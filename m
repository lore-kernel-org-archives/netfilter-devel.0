From: Mohit Mehta <mohit.mehta@vyatta.com>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte
 counters for a specific rule using iptables/ip6tables
Date: Wed, 18 Feb 2009 12:17:54 -0800 (PST)
Message-ID: <4700595.31361234988274007.JavaMail.root@tahiti.vyatta.com>
References: <499C5623.7060902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:44344 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZBRURw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:17:52 -0500
In-Reply-To: <499C5623.7060902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Please rediff your patch against the current tree.

diff for iptables.c -

--- iptables.c.orig     2009-02-18 11:26:31.000000000 -0800
+++ iptables.c  2009-02-18 11:38:30.000000000 -0800
@@ -76,9 +76,10 @@
 #define CMD_SET_POLICY         0x0400U
 #define CMD_RENAME_CHAIN       0x0800U
 #define CMD_LIST_RULES         0x1000U
-#define NUMBER_OF_CMD  14
+#define CMD_ZERO_NUM           0x2000U
+#define NUMBER_OF_CMD  15
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-                                'N', 'X', 'P', 'E', 'S' };
+                                'Z', 'N', 'X', 'P', 'E', 'S' };

 #define OPTION_OFFSET 256

@@ -165,6 +166,7 @@ static char commands_v_options[NUMBER_OF
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
@@ -311,7 +313,8 @@ exit_printhelp(struct iptables_rule_matc
 "  --list-rules -S [chain [rulenum]]\n"
 "                              Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --zero    -Z [chain[rulenum]]\n"
+"                              Zero counters in chain or all chains\n"
 "  --new     -N chain          Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]                Delete a user-defined chain\n"
@@ -1521,7 +1524,7 @@ int do_command(int argc, char *argv[], c
                        break;

                case 'L':
-                       add_command(&command, CMD_LIST, CMD_ZERO,
+                       add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
                                    invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
@@ -1533,8 +1536,8 @@ int do_command(int argc, char *argv[], c
                        break;

                case 'S':
-                       add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-                                   invert);
+                       add_command(&command, CMD_LIST_RULES,
+                                   CMD_ZERO|CMD_ZERO_NUM, invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
                                 && argv[optind][0] != '!')
@@ -1560,6 +1563,11 @@ int do_command(int argc, char *argv[], c
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
@@ -2094,8 +2102,12 @@ int do_command(int argc, char *argv[], c
        case CMD_ZERO:
                ret = zero_entries(chain, options&OPT_VERBOSE, handle);
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
@@ -2106,9 +2118,12 @@ int do_command(int argc, char *argv[], c
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = iptc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_LIST_RULES:
        case CMD_LIST_RULES|CMD_ZERO:
+       case CMD_LIST_RULES|CMD_ZERO_NUM:
                ret = list_rules(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -2116,6 +2131,8 @@ int do_command(int argc, char *argv[], c
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = iptc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_NEW_CHAIN:
                ret = iptc_create_chain(chain, handle);






diff for ip6tables.c -

--- ip6tables.c.orig    2009-02-18 11:44:04.000000000 -0800
+++ ip6tables.c 2009-02-18 11:50:51.000000000 -0800
@@ -79,9 +79,10 @@
 #define CMD_SET_POLICY         0x0400U
 #define CMD_RENAME_CHAIN       0x0800U
 #define CMD_LIST_RULES         0x1000U
-#define NUMBER_OF_CMD  14
+#define CMD_ZERO_NUM           0x2000U
+#define NUMBER_OF_CMD  15
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-                                'N', 'X', 'P', 'E', 'S' };
+                                'Z', 'N', 'X', 'P', 'E', 'S' };

 #define OPTION_OFFSET 256

@@ -166,6 +167,7 @@ static char commands_v_options[NUMBER_OF
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
@@ -309,7 +311,8 @@ exit_printhelp(struct ip6tables_rule_mat
 "  --list-rules -S [chain [rulenum]]\n"
 "                              Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --zero    -Z [chain[rulenum]]\n"
+"                              Zero counters in chain or all chains\n"
 "  --new     -N chain          Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]                Delete a user-defined chain\n"
@@ -1508,7 +1511,7 @@ int do_command6(int argc, char *argv[],
                        break;

                case 'L':
-                       add_command(&command, CMD_LIST, CMD_ZERO,
+                       add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
                                    invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
@@ -1520,8 +1523,8 @@ int do_command6(int argc, char *argv[],
                        break;

                case 'S':
-                       add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-                                   invert);
+                       add_command(&command, CMD_LIST_RULES,
+                                   CMD_ZERO|CMD_ZERO_NUM, invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
                                 && argv[optind][0] != '!')
@@ -1547,6 +1550,11 @@ int do_command6(int argc, char *argv[],
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
@@ -2062,8 +2070,12 @@ int do_command6(int argc, char *argv[],
        case CMD_ZERO:
                ret = zero_entries(chain, options&OPT_VERBOSE, handle);
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
@@ -2074,9 +2086,12 @@ int do_command6(int argc, char *argv[],
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = ip6tc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_LIST_RULES:
        case CMD_LIST_RULES|CMD_ZERO:
+       case CMD_LIST_RULES|CMD_ZERO_NUM:
                ret = list_rules(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -2084,6 +2099,8 @@ int do_command6(int argc, char *argv[],
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = ip6tc_zero_counter(chain, rulenum, handle);
                break;
        case CMD_NEW_CHAIN:
                ret = ip6tc_create_chain(chain, handle);



----- Original Message -----
From: "Patrick McHardy" <kaber@trash.net>
To: "Mohit Mehta" <mohit.mehta@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
Sent: Wednesday, February 18, 2009 10:40:35 AM (GMT-0800) Auto-Detected
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters for a specific rule using iptables/ip6tables

Mohit Mehta wrote:
> iptc_zero_counter/ip6tc_zero_counter are functions available in libiptc to zero counters for a rule in a given chain. However, this is not exposed in iptables/ip6tables. The patch below exposes the underlying function to the user to zero out packet and byte counters for a specific rule.

Exposing this seems useful, the patch doesn't apply to the
current git version though:

8 out of 9 hunks FAILED -- saving rejects to file ip6tables.c.rej
8 out of 9 hunks FAILED -- saving rejects to file iptables.c.rej

Please rediff your patch against the current tree.
