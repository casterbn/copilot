-- | Help to display.
module Language.Copilot.Help (helpStr)

where

helpStr :: String
helpStr =
  unlines
  [ ""
  , "USAGE:"
  , "There are 4 essential Copilot commands.  Each command may take a variety"
  , "of options. We describe the commands then list the possible options."
  , ""
  , " interpret :: Streams -> Int -> (Options -> Options) -> IO ()"
  , " > interpret STREAMS RNDS (noOpts | [$ OPTS])"
  , "   Executes the interpreter for the Copilot specification STREAMS of type"
  , "   'Streams', where the specification is interpreted as a set of mutually-"
  , "   recursive Haskell infinite lists.  The output from the lists is given"
  , "   for RNDS indexes.  RNDS must be greater than 0."
  , ""
  , " compile :: Streams -> String -> (Options -> Options) -> IO ()"
  , " > compile STREAMS FILENAME (noOpts | [$ OPTS])"
  , "   Compiles the Copilot specification STREAMS to constant-time & constant-"
  , "   constant-space C program named FILENAME.c with header FILENAME.h"
  , "   and executable FILENAME."
  , ""
  , " > test RNDS (noOpts | [$ OPTS])"
  , "   Generates a random set of streams & inputs for external variables, and"
  , "   tests the equivalence between the output of the compiled C program and"
  , "   the interpreter over RNDS rounds.  RNDS must be greater than 0.  This"
  , "   command is equivalent to executing the interpret command and the"
  , "   compile command for a randomly-generated stream and comparing the"
  , "   results by-hand.  Throws an error if the outputs differ.  Testing"
  , "   external arrays is currently not supported."
  , ""
  , " > Prelude.putStr $ Prelude.show STREAMS     -- or simply"
  , " > STREAMS                                   -- in ghci"
  , "   Pretty-prints the parsed Copilot specification of type 'Streams'."
  , ""
  , " verify :: FilePath -> Int -> IO () (FilePath is a synonym for String)"
  , " > verify PATH/FILE.c n"
  , "   Calls cbmc, developed by Daniel Kroening \& Edmund Clarke"
  , "   <http://www.cprover.org/cbmc/> on a C file generated by Copilot."
  , "   cbmc is a bounded model-checker that verifies C programs.  While there"
  , "   should be no incorrect C programs generated by the Copilot compiler,"
  , "   cbmc provides independent evidence of this claim.  Specifically, it"
  , "   checks that there are no buffer overflows (both lower and upper), that"
  , "   there are no pointer deferences of NULL, that there is no division by"
  , "   zero, that floating point computations do not result in not-a-number"
  , "   (NaN), and that no uninitialized local variables are used.  The entry"
  , "   point of main() is assumed, and it is also assumed that main() can be"
  , "   unrolled at least n times, where n is an Int.  This command is thus"
  , "   best used when generating a simulation program (i.e., the setPP flag"
  , "   is not used when compiling).  For more information on the properties"  
  , "   checked, see <http://www.cprover.org/cprover-manual/properties.shtml>."
  , ""
  , " > help "
  , "   Displays this help message."
  , ""
  , ""
  , "OPTIONS:"
  , "In the following, we designate the interpreter by (i), the compiler by (c),"
  , "and the test function by (t).  Options are marked by which tool they are"
  , "relevant to; e.g., (i, t) means that an option is relevant to the"
  , "interpreter and test functions."
  , ""
  , "For each option, there is a default described below."
  , ""
  , "  setE :: Vars -> Options -> Options                                    (i)"
  , "    default: Nothing (no assignments)" 
  , "    Set the environment for program variables.  E.g., for the spec"
  , ""
  , "    t :: Streams"
  , "    t =  \"a\" .= [0,1] ++ extW32 \"ext0\" 7 + extW32 \"ext1\" 8 "
  , "      .| end"
  , ""
  , "    setE (emptySM {w32Map = fromList "
  , "                     [ (\"ext0\", [0,1..])"
  , "                     , (\"ext1\", [3,3..])]})"
  , "    assigns external variable \"ext0\" the values 0,1,2... and "
  , "    external variable \"ext1\" the values 3,3,3... over Word32 in the"
  , "    sequential rounds.  "
  , ""
  , "  setV :: Verbose -> Options -> Options                           (i, c, t)"
  , "    default: DefaultVerbose"
  , "    Set the verbosity level.  One of OnlyErrors | DefaultVerbose | Verbose."
  , ""
  , "  setGCC :: String -> Options -> Options                             (c, t)"
  , "    default: \"gcc\""
  , "    Sets the compiler to use, given as a path (String) to the executable."
  , ""
  , "  setDir :: String -> Options -> Options                             (c, t)"
  , "    default: \"./\""
  , "    The location for the generated .c, .h, and binary files.  The"
  , "    path can be either absolute or relative, but MUST containing the"
  , "    trailing '/'."
  , ""
  , "  setC :: String -> Options -> Options                               (c, t)"
  , "    default: Nothing"
  , "    Set the additional options to pass to the compiler.  E.g.,"
  , "    setC \"-O2\"."
  , ""
  , "  setP :: Period -> Options -> Options                               (c, t)"
  , "    default: automatically computed minimal period."
  , "    Manually set the number of ticks per period for execution.  An error"
  , "    is returned if the number is too small.  For any program, the number"
  , "    of ticks must be at least 2."
  , ""
  , "  setPP :: (String, String) -> Options -> Options                       (c)"
  , "    default: Nothing.  The default generates a main() function that calls"
  , "    Copilot code to run simulations."
  , ""
  , "    Sets C code to pretty-print before and after the generated Copilot"
  , "    code: the before code is the first element of the tuple and the after"
  , "    code is the second element.  For writing ad-hoc C, please see"
  , "    Language.Copilot.AdHocC (and please add to it and send patches!)."
  , "    For exmple, pre-code might include 'includes'.  Post-code might include"
  , "    a custom main() function.  ('PP' stands for 'pretty-print'.)"  
  , ""
  , "    NOTE: when the pre-/post-code is anything but Nothing, the C compiler"
  , "    is NOT called---we assume you're doing a custom build.  We do NOT"
  , "    instrument your code with a 'main()' function simulator.  Use this"
  , "    function to generate embedded programs."
  , "" 
  , "  setArrs :: [(String,Int)] -> Options -> Options                       (c)"
  , "    default: Nothing" 
  , "    When generating C programs to test, we don't know how large external"
  , "    arrays are, so we cannot declare them.  Passing in pairs containing the"
  , "    name of the array and it's size allows them to be declared."  
  , ""
  , "  setO :: Name -> Options -> Options                                    (t)"
  , "    default: \"copilotProgram\""
  , "    Sets the name of the executable (e.g., -o) generated by the C"
  , "    compiler."
  , ""
  , ""
  , "EXAMPLES:"
  , "The following examples reference Copilot specs defined in"
  , "Language.Copilot.Examples.Examples."
  , ""
  , " > interpret t0 50 noOpts"
  , "   Interprets t0 for 50 iterations."
  , ""
  , " > interpret t3 40"
  , "     $ setE (emptySM {w32Map = fromList "
  , "                     [ (\"ext0\", [0,1..])"
  , "                     , (\"ext1\", [3,3..])]})"
  , "       $ setV Verbose baseOpts"
  , "   Interpret t3 for 40 iterations, seeding the external variable \"ext\""
  , "   to [0,1,..], with 'Verbose' verbosity."
  , ""
  , " > compile t1 \"t1\" noOpts"
  , "   Compile Copilot spec t1 to t1.c, t1.h, and executable t1 in the default"
  , "   directory, /tmp/copilot/ .  This is compiled with a simulation main()"
  , ""
  , " > compile t2 \"t2\" $ setC \"-O2\" $ setP 100"
  , "   Compile Copilot spec t2 to t2.c, t2.h, and executable t2 in the default"
  , "   directory, /tmp/copilot/ , with optimization level -02 and period 100."
  , "   This is compiled with a simulation main()."
  , ""
  , " > test 1000"
  , "   Compare the compiler and interpreter for a randomly-generated Copilot"
  , "   spec for 1000 iterations."
  , ""
  , " > Prelude.sequence_ [test 100 $ setR x | x <- [0..100]]"
  , "   Compare the compiler and interpreter on 100 randomly-generated Copilot"
  , "   specs, for 100 iterations each."
  , ""
  , " > verify \"foo.c\""
  , "   Calls cbmc on foo.c (where foo.c is in the current directory)."
  ]
