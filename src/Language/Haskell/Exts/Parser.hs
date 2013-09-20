{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Language.Haskell.Exts.Parser
-- Copyright   :  (c) The GHC Team, 1997-2000
--                (c) Niklas Broberg, 2004-2012
--                (c) Michael Sloan, 2013
-- License     :  BSD-style (see the file LICENSE.txt)
--
-- Maintainer  :  Niklas Broberg, niklas.broberg@chalmers.se
-- Stability   :  stable
-- Portability :  portable
--
-- Parser for Haskell with extensions.
--
-----------------------------------------------------------------------------
module Language.Haskell.Exts.Parser
            (
                -- * General parsing
                Parseable(parse, parseWithMode, parseWithComments),
                Parse, ParseWithMode, ParseWithComments,
                ParseMode(..), defaultParseMode, ParseResult(..), fromParseResult,
                -- * Parsing of specific AST elements
                -- ** Modules
                parseModule, parseModuleWithMode, parseModuleWithComments,
                parseModules, parseModulesWithMode, parseModulesWithComments,
                -- ** Expressions
                parseExp, parseExpWithMode, parseExpWithComments,
                -- ** Statements
                parseStmt, parseStmtWithMode, parseStmtWithComments,
                -- ** Patterns
                parsePat, parsePatWithMode, parsePatWithComments,
                -- ** Declarations
                parseDecl, parseDeclWithMode, parseDeclWithComments,
                -- ** Types
                parseType, parseTypeWithMode, parseTypeWithComments,
                -- ** Module pragmas
                getTopPragmas, parseExtensions, readExtensions
            ) where

import Language.Haskell.Exts.Annotated.Parser (parseExtensions, readExtensions)
import Language.Haskell.Exts.Annotated.Simplify
import Language.Haskell.Exts.ParseMonad
import Language.Haskell.Exts.Annotated.Fixity

import qualified Language.Haskell.Exts.Annotated.Parser as P
import qualified Language.Haskell.Exts.Syntax as S

simpleParser :: (Parseable a, Simplify a a') => Maybe [Fixity] -> P a'
simpleParser mfixs = parser mfixs >>= return . simplify

instance Parseable (S.ModuleName, Maybe S.WarningText, Maybe [S.ExportSpec]) where
    parser = simpleParser

instance Parseable S.Activation             where parser = simpleParser
instance Parseable S.Alt                    where parser = simpleParser
instance Parseable S.Annotation             where parser = simpleParser
instance Parseable S.BangType               where parser = simpleParser
instance Parseable S.Binds                  where parser = simpleParser
instance Parseable S.CallConv               where parser = simpleParser
instance Parseable S.ClassDecl              where parser = simpleParser
instance Parseable S.CName                  where parser = simpleParser
instance Parseable S.ConDecl                where parser = simpleParser
instance Parseable S.Decl                   where parser = simpleParser
instance Parseable S.Exp                    where parser = simpleParser
instance Parseable S.ExportSpec             where parser = simpleParser
instance Parseable S.FunDep                 where parser = simpleParser
instance Parseable S.GadtDecl               where parser = simpleParser
instance Parseable S.GuardedAlt             where parser = simpleParser
instance Parseable S.GuardedAlts            where parser = simpleParser
instance Parseable S.GuardedRhs             where parser = simpleParser
instance Parseable S.ImportDecl             where parser = simpleParser
instance Parseable S.ImportSpec             where parser = simpleParser
instance Parseable S.InstDecl               where parser = simpleParser
instance Parseable S.IPBind                 where parser = simpleParser
instance Parseable S.IPName                 where parser = simpleParser
instance Parseable S.Kind                   where parser = simpleParser
instance Parseable S.Literal                where parser = simpleParser
instance Parseable S.Module                 where parser = simpleParser
instance Parseable S.ModuleName             where parser = simpleParser
instance Parseable S.ModulePragma           where parser = simpleParser
instance Parseable S.Name                   where parser = simpleParser
instance Parseable S.Op                     where parser = simpleParser
instance Parseable S.Pat                    where parser = simpleParser
instance Parseable S.QName                  where parser = simpleParser
instance Parseable S.QOp                    where parser = simpleParser
instance Parseable S.QualConDecl            where parser = simpleParser
instance Parseable S.QualStmt               where parser = simpleParser
instance Parseable S.Rhs                    where parser = simpleParser
instance Parseable S.Rule                   where parser = simpleParser
instance Parseable S.RuleVar                where parser = simpleParser
instance Parseable S.Safety                 where parser = simpleParser
instance Parseable S.Stmt                   where parser = simpleParser
instance Parseable S.Type                   where parser = simpleParser
instance Parseable S.TyVarBind              where parser = simpleParser
instance Parseable S.XName                  where parser = simpleParser

instance Parseable ([S.Name], S.BangType)   where parser = simpleParser
instance Parseable (Bool, [S.ImportSpec])   where parser = simpleParser

instance Parseable [S.Module]               where parser = simpleParser
instance Parseable [S.Rule]                 where parser = simpleParser
instance Parseable [S.RuleVar]              where parser = simpleParser

instance Parseable [([S.Name], S.BangType)] where parser = simpleParser
instance Parseable [S.ClassDecl]            where parser = simpleParser
instance Parseable [S.CName]                where parser = simpleParser
instance Parseable [S.Decl]                 where parser = simpleParser
instance Parseable [S.ExportSpec]           where parser = simpleParser
instance Parseable [S.FunDep]               where parser = simpleParser
instance Parseable [S.GadtDecl]             where parser = simpleParser
instance Parseable [S.GuardedAlt]           where parser = simpleParser
instance Parseable [S.GuardedRhs]           where parser = simpleParser
instance Parseable [S.ImportDecl]           where parser = simpleParser
instance Parseable [S.InstDecl]             where parser = simpleParser
instance Parseable [S.IPBind]               where parser = simpleParser
instance Parseable [S.ModulePragma]         where parser = simpleParser
instance Parseable [S.Name]                 where parser = simpleParser
instance Parseable [S.Op]                   where parser = simpleParser
instance Parseable [S.QName]                where parser = simpleParser
instance Parseable [S.QualConDecl]          where parser = simpleParser
instance Parseable [S.QualStmt]             where parser = simpleParser
instance Parseable [S.Stmt]                 where parser = simpleParser
instance Parseable [S.TyVarBind]            where parser = simpleParser
instance Parseable [S.Exp]                  where parser = simpleParser
instance Parseable [S.Pat]                  where parser = simpleParser

instance Parseable [[S.QualStmt]]           where parser = simpleParser

{-
instance Parseable (S.Name, [S.TyVarBind])  where parser = simpleParser
instance Parseable (S.QName, [S.Type])      where parser = simpleParser
instance Parseable [(S.QName, [S.Type])]    where parser = simpleParser
instance Parseable S.Assoc                  where parser = simpleParser
instance Parseable S.Asst                   where parser = simpleParser
instance Parseable S.Bracket                where parser = simpleParser
instance Parseable S.Context                where parser = simpleParser
instance Parseable S.FieldUpdate            where parser = simpleParser
instance Parseable S.Match                  where parser = simpleParser
instance Parseable S.PatField               where parser = simpleParser
instance Parseable S.PXAttr                 where parser = simpleParser
instance Parseable S.RPat                   where parser = simpleParser
instance Parseable S.RPatOp                 where parser = simpleParser
instance Parseable S.SpecialCon             where parser = simpleParser
instance Parseable S.Splice                 where parser = simpleParser
instance Parseable S.WarningText            where parser = simpleParser
instance Parseable S.XAttr                  where parser = simpleParser
-}

-- Type-specific instances

-- | Parse of a string, which should contain a complete Haskell module.
parseModule :: Parse S.Module
parseModule = parse

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode'.
parseModuleWithMode :: ParseWithMode S.Module
parseModuleWithMode = parseWithMode

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode', retaining comments.
parseModuleWithComments :: ParseWithComments S.Module
parseModuleWithComments = parseWithComments

-- | Parse of a string, which should contain complete Haskell modules.
parseModules :: Parse [S.Module]
parseModules = parse

-- | Parse of a string containing complete Haskell modules, using an explicit 'ParseMode'.
parseModulesWithMode :: ParseWithMode [S.Module]
parseModulesWithMode = parseWithMode

-- | Parse of a string containing complete Haskell modules, using an explicit 'ParseMode', retaining comments.
parseModulesWithComments :: ParseWithComments [S.Module]
parseModulesWithComments = parseWithComments

-- | Parse of a string containing a Haskell expression.
parseExp :: Parse S.Exp
parseExp = parse

-- | Parse of a string containing a Haskell expression, using an explicit 'ParseMode'.
parseExpWithMode :: ParseWithMode S.Exp
parseExpWithMode = parseWithMode

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode', retaining comments.
parseExpWithComments :: ParseWithComments S.Exp
parseExpWithComments = parseWithComments

-- | Parse of a string containing a Haskell pattern.
parsePat :: Parse S.Pat
parsePat = parse

-- | Parse of a string containing a Haskell pattern, using an explicit 'ParseMode'.
parsePatWithMode :: ParseWithMode S.Pat
parsePatWithMode = parseWithMode

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode', retaining comments.
parsePatWithComments :: ParseWithComments S.Pat
parsePatWithComments = parseWithComments

-- | Parse of a string containing a Haskell top-level declaration.
parseDecl :: Parse S.Decl
parseDecl = parse

-- | Parse of a string containing a Haskell top-level declaration, using an explicit 'ParseMode'.
parseDeclWithMode :: ParseWithMode S.Decl
parseDeclWithMode = parseWithMode

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode', retaining comments.
parseDeclWithComments :: ParseWithComments S.Decl
parseDeclWithComments = parseWithComments

-- | Parse of a string containing a Haskell type.
parseType :: Parse S.Type
parseType = parse

-- | Parse of a string containing a Haskell type, using an explicit 'ParseMode'.
parseTypeWithMode :: ParseWithMode S.Type
parseTypeWithMode = parseWithMode

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode', retaining comments.
parseTypeWithComments :: ParseWithComments S.Type
parseTypeWithComments = parseWithComments

-- | Parse of a string containing a Haskell type.
parseStmt :: Parse S.Stmt
parseStmt = parse

-- | Parse of a string containing a Haskell type, using an explicit 'ParseMode'.
parseStmtWithMode :: ParseWithMode S.Stmt
parseStmtWithMode = parseWithMode

-- | Parse of a string containing a complete Haskell module, using an explicit 'ParseMode', retaining comments.
parseStmtWithComments :: ParseWithComments S.Stmt
parseStmtWithComments = parseWithComments

getTopPragmas :: Parse [S.ModulePragma]
getTopPragmas = fmap (map sModulePragma) . P.getTopPragmas
