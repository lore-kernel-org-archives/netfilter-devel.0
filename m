From: Mohit Mehta <mohit.mehta@vyatta.com>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte
 counters for a specific rule using iptables/ip6tables
Date: Thu, 19 Feb 2009 11:41:33 -0800 (PST)
Message-ID: <2025662.36471235072493203.JavaMail.root@tahiti.vyatta.com>
References: <499D32AB.1050309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:46943 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbZBSTlb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:41:31 -0500
In-Reply-To: <499D32AB.1050309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hopefully, this works -

diff --git a/ip6tables.c b/ip6tables.c
index 06c0a60..d524f6a 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -80,9 +80,10 @@
 #define CMD_SET_POLICY         0x0400U
 #define CMD_RENAME_CHAIN       0x0800U
 #define CMD_LIST_RULES         0x1000U
-#define NUMBER_OF_CMD  14
+#define CMD_ZERO_NUM           0x2000U
+#define NUMBER_OF_CMD  15
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-                                'N', 'X', 'P', 'E', 'S' };
+                                'Z', 'N', 'X', 'P', 'E', 'S' };

 #define OPT_NONE       0x00000U
 #define OPT_NUMERIC    0x00001U
@@ -172,6 +173,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
@@ -268,7 +270,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --list-rules -S [chain [rulenum]]\n"
 "                              Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --zero    -Z [chain[rulenum]]\n"
+"                              Zero counters in chain or all chains\n"
 "  --new     -N chain          Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]                Delete a user-defined chain\n"
@@ -1377,7 +1380,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                        break;

                case 'L':
-                       add_command(&command, CMD_LIST, CMD_ZERO,
+                       add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
                                    invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
@@ -1389,8 +1392,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                        break;

                case 'S':
-                       add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-                                   invert);
+                       add_command(&command, CMD_LIST_RULES,
+                               CMD_ZERO|CMD_ZERO_NUM, invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
                                 && argv[optind][0] != '!')
@@ -1416,6 +1419,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                        else if (optind < argc && argv[optind][0] != '-'
                                && argv[optind][0] != '!')
                                chain = argv[optind++];
+                       if (optind < argc && argv[optind][0] != '-'
+                               && argv[optind][0] != '!') {
+                               rulenum = parse_rulenumber(argv[optind++]);
+                               command = CMD_ZERO_NUM;
+                       }
                        break;

                case 'N':
@@ -1950,8 +1958,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
        case CMD_ZERO:
                ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
                break;
+       case CMD_ZERO_NUM:
+               ret = ip6tc_zero_counter(chain, rulenum, handle);
+               break;
        case CMD_LIST:
        case CMD_LIST|CMD_ZERO:
+       case CMD_LIST|CMD_ZERO_NUM:
                ret = list_entries(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -1962,9 +1974,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = ip6tc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_LIST_RULES:
        case CMD_LIST_RULES|CMD_ZERO:
+       case CMD_LIST_RULES|CMD_ZERO_NUM:
                ret = list_rules(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -1972,6 +1987,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = ip6tc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_NEW_CHAIN:
                ret = ip6tc_create_chain(chain, *handle);
diff --git a/iptables.c b/iptables.c
index a8e97c7..61ddbde 100644
--- a/iptables.c
+++ b/iptables.c
@@ -77,9 +77,10 @@
 #define CMD_SET_POLICY         0x0400U
 #define CMD_RENAME_CHAIN       0x0800U
 #define CMD_LIST_RULES         0x1000U
-#define NUMBER_OF_CMD  14
+#define CMD_ZERO_NUM           0x2000U
+#define NUMBER_OF_CMD  15
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-                                'N', 'X', 'P', 'E', 'S' };
+                                'Z', 'N', 'X', 'P', 'E', 'S' };

 #define OPT_NONE       0x00000U
 #define OPT_NUMERIC    0x00001U
@@ -173,6 +174,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
@@ -282,7 +284,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --list-rules -S [chain [rulenum]]\n"
 "                              Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --zero    -Z [chain[rulenum]]\n"
+"                              Zero counters in chain or all chains\n"
 "  --new     -N chain          Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]                Delete a user-defined chain\n"
@@ -1400,7 +1403,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                        break;

                case 'L':
-                       add_command(&command, CMD_LIST, CMD_ZERO,
+                       add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
                                    invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
@@ -1412,8 +1415,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                        break;

                case 'S':
-                       add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-                                   invert);
+                       add_command(&command, CMD_LIST_RULES,
+                               CMD_ZERO|CMD_ZERO_NUM, invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
                                 && argv[optind][0] != '!')
@@ -1439,6 +1442,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                        else if (optind < argc && argv[optind][0] != '-'
                                && argv[optind][0] != '!')
                                chain = argv[optind++];
+                       if (optind < argc && argv[optind][0] != '-'
+                               && argv[optind][0] != '!') {
+                               rulenum = parse_rulenumber(argv[optind++]);
+                               command = CMD_ZERO_NUM;
+                       }
                        break;

                case 'N':
@@ -1992,8 +2000,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
        case CMD_ZERO:
                ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
                break;
+       case CMD_ZERO_NUM:
+               ret = iptc_zero_counter(chain, rulenum, handle);
+               break;
        case CMD_LIST:
        case CMD_LIST|CMD_ZERO:
+       case CMD_LIST|CMD_ZERO_NUM:
                ret = list_entries(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -2004,9 +2016,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = iptc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_LIST_RULES:
        case CMD_LIST_RULES|CMD_ZERO:
+       case CMD_LIST_RULES|CMD_ZERO_NUM:
                ret = list_rules(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -2014,6 +2029,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = iptc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_NEW_CHAIN:
                ret = iptc_create_chain(chain, *handle);

----- Original Message -----
From: "Patrick McHardy" <kaber@trash.net>
To: "Mohit Mehta" <mohit.mehta@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
Sent: Thursday, February 19, 2009 2:21:31 AM (GMT-0800) Auto-Detected
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters for a specific rule using iptables/ip6tables

Mohit Mehta wrote:
>> Please rediff your patch against the current tree.
> 
> diff for iptables.c -
> 
> --- iptables.c.orig     2009-02-18 11:26:31.000000000 -0800
> +++ iptables.c  2009-02-18 11:38:30.000000000 -0800

That patch is whitespace-mangled and also doesn't apply.
