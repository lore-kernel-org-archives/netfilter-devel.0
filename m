From: Mohit Mehta <mohit.mehta@vyatta.com>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte
 counters for a specific rule using iptables/ip6tables
Date: Wed, 19 Aug 2009 10:56:33 -0700 (PDT)
Message-ID: <23915168.171071250704593343.JavaMail.root@tahiti.vyatta.com>
References: <499DBCE8.2070503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5404_21233729.1250704593341"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:51118 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZHSR4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:56:32 -0400
In-Reply-To: <499DBCE8.2070503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_5404_21233729.1250704593341
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

I was able to cleanly apply the attached modified patches to the latest iptables code. Also, below is the code in text if attachment doesn't reach.

build-vm:/# cat iptables.c.patch
>From 4dbfcfeb9fc65df7fac1f16230871c02a85b4ea1 Mon Sep 17 00:00:00 2001
From: root <root@build-vm.(none)>
Date: Tue, 7 Jul 2009 14:03:50 -0700
Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using iptables

---
 iptables.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/iptables.c b/iptables.c
index a229c35..53c2d56 100644
--- a/iptables.c
+++ b/iptables.c
@@ -78,9 +78,10 @@
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
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
@@ -280,7 +282,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --list-rules -S [chain [rulenum]]\n"
 "                              Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --zero    -Z [chain [rulenum]]\n"
+"                              Zero counters in chain or all chains\n"
 "  --new     -N chain          Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]                Delete a user-defined chain\n"
@@ -1399,7 +1402,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                        break;

                case 'L':
-                       add_command(&command, CMD_LIST, CMD_ZERO,
+                       add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
                                    invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
@@ -1411,8 +1414,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                        break;

                case 'S':
-                       add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-                                   invert);
+                       add_command(&command, CMD_LIST_RULES,
+                                   CMD_ZERO|CMD_ZERO_NUM, invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
                                 && argv[optind][0] != '!')
@@ -1438,6 +1441,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
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
@@ -1994,8 +2002,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
        case CMD_ZERO:
                ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
                break;
+       case CMD_ZERO_NUM:
+               ret = iptc_zero_counter(chain, rulenum, *handle);
+               break;
        case CMD_LIST:
        case CMD_LIST|CMD_ZERO:
+       case CMD_LIST|CMD_ZERO_NUM:
                ret = list_entries(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -2006,9 +2018,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = iptc_zero_counter(chain, rulenum, *handle);
                break;
        case CMD_LIST_RULES:
        case CMD_LIST_RULES|CMD_ZERO:
+       case CMD_LIST_RULES|CMD_ZERO_NUM:
                ret = list_rules(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -2016,6 +2031,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = iptc_zero_counter(chain, rulenum, *handle);
                break;
        case CMD_NEW_CHAIN:
                ret = iptc_create_chain(chain, *handle);
--
1.5.6.5





build-vm:/# cat ip6tables.c.patch
>From 8f98a64ad2a2b312a3b9c94a0f79145bf04c6391 Mon Sep 17 00:00:00 2001
From: root <root@build-vm.(none)>
Date: Tue, 7 Jul 2009 14:17:40 -0700
Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using ip6tables

---
 ip6tables.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index f974fb1..849e94d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -81,9 +81,10 @@
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
@@ -267,7 +269,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --list-rules -S [chain [rulenum]]\n"
 "                              Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --zero    -Z [chain [rulenum]]\n"
+"                              Zero counters in chain or all chains\n"
 "  --new     -N chain          Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]                Delete a user-defined chain\n"
@@ -1376,7 +1379,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                        break;

                case 'L':
-                       add_command(&command, CMD_LIST, CMD_ZERO,
+                       add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
                                    invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
@@ -1388,8 +1391,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                        break;

                case 'S':
-                       add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-                                   invert);
+                       add_command(&command, CMD_LIST_RULES,
+                                   CMD_ZERO|CMD_ZERO_NUM, invert);
                        if (optarg) chain = optarg;
                        else if (optind < argc && argv[optind][0] != '-'
                                 && argv[optind][0] != '!')
@@ -1415,6 +1418,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
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
@@ -1953,8 +1961,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
        case CMD_ZERO:
                ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
                break;
+       case CMD_ZERO_NUM:
+               ret = ip6tc_zero_counter(chain, rulenum, *handle);
+               break;
        case CMD_LIST:
        case CMD_LIST|CMD_ZERO:
+       case CMD_LIST|CMD_ZERO_NUM:
                ret = list_entries(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -1965,9 +1977,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = ip6tc_zero_counter(chain, rulenum, *handle);
                break;
        case CMD_LIST_RULES:
        case CMD_LIST_RULES|CMD_ZERO:
+       case CMD_LIST_RULES|CMD_ZERO_NUM:
                ret = list_rules(chain,
                                   rulenum,
                                   options&OPT_VERBOSE,
@@ -1975,6 +1990,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
                if (ret && (command & CMD_ZERO))
                        ret = zero_entries(chain,
                                           options&OPT_VERBOSE, *handle);
+               if (ret && (command & CMD_ZERO_NUM))
+                       ret = ip6tc_zero_counter(chain, rulenum, *handle);
                break;
        case CMD_NEW_CHAIN:
                ret = ip6tc_create_chain(chain, *handle);
--
1.5.6.5


----- Patrick McHardy <kaber@trash.net> wrote:
> Mohit Mehta wrote:
> > Hopefully, this works -
> 
> It does not. Try sending to yourself first and applying it yourself.
> And I'd suggest not to use a web based client:
> 
> X-Mailer: Zimbra 5.0.11_GA_2696.RHEL4 (ZimbraWebClient - FF3.0 
> (Win)/5.0.11_GA_2696.RHEL4)


------=_Part_5404_21233729.1250704593341
Content-Type: application/octet-stream; charset=utf-8; name=ip6tables.c.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ip6tables.c.patch

>From 8f98a64ad2a2b312a3b9c94a0f79145bf04c6391 Mon Sep 17 00:00:00 2001
From: root <root@build-vm.(none)>
Date: Tue, 7 Jul 2009 14:17:40 -0700
Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using ip6tables

---
 ip6tables.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index f974fb1..849e94d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -81,9 +81,10 @@
 #define CMD_SET_POLICY		0x0400U
 #define CMD_RENAME_CHAIN	0x0800U
 #define CMD_LIST_RULES		0x1000U
-#define NUMBER_OF_CMD	14
+#define CMD_ZERO_NUM		0x2000U
+#define NUMBER_OF_CMD	15
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E', 'S' };
+				 'Z', 'N', 'X', 'P', 'E', 'S' };
 
 #define OPT_NONE	0x00000U
 #define OPT_NUMERIC	0x00001U
@@ -172,6 +173,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
@@ -267,7 +269,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --list-rules -S [chain [rulenum]]\n"
 "				Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]		Zero counters in chain or all chains\n"
+"  --zero    -Z [chain [rulenum]]\n"
+"				Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]		Delete a user-defined chain\n"
@@ -1376,7 +1379,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'L':
-			add_command(&command, CMD_LIST, CMD_ZERO,
+			add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
 				    invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
@@ -1388,8 +1391,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'S':
-			add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-				    invert);
+			add_command(&command, CMD_LIST_RULES, 
+				    CMD_ZERO|CMD_ZERO_NUM, invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1415,6 +1418,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			else if (optind < argc && argv[optind][0] != '-'
 				&& argv[optind][0] != '!')
 				chain = argv[optind++];
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!') {
+				rulenum = parse_rulenumber(argv[optind++]);
+				command = CMD_ZERO_NUM;
+			}	
 			break;
 
 		case 'N':
@@ -1953,8 +1961,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	case CMD_ZERO:
 		ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
 		break;
+	case CMD_ZERO_NUM:
+		ret = ip6tc_zero_counter(chain, rulenum, *handle);
+		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
+	case CMD_LIST|CMD_ZERO_NUM:
 		ret = list_entries(chain,
 				   rulenum,
 				   options&OPT_VERBOSE,
@@ -1965,9 +1977,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
 					   options&OPT_VERBOSE, *handle);
+		if (ret && (command & CMD_ZERO_NUM))
+			ret = ip6tc_zero_counter(chain, rulenum, *handle);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
+	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		ret = list_rules(chain,
 				   rulenum,
 				   options&OPT_VERBOSE,
@@ -1975,6 +1990,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
 					   options&OPT_VERBOSE, *handle);
+		if (ret && (command & CMD_ZERO_NUM))
+			ret = ip6tc_zero_counter(chain, rulenum, *handle);
 		break;
 	case CMD_NEW_CHAIN:
 		ret = ip6tc_create_chain(chain, *handle);
-- 
1.5.6.5


------=_Part_5404_21233729.1250704593341
Content-Type: application/octet-stream; charset=utf-8; name=iptables.c.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=iptables.c.patch

>From 4dbfcfeb9fc65df7fac1f16230871c02a85b4ea1 Mon Sep 17 00:00:00 2001
From: root <root@build-vm.(none)>
Date: Tue, 7 Jul 2009 14:03:50 -0700
Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using iptables

---
 iptables.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/iptables.c b/iptables.c
index a229c35..53c2d56 100644
--- a/iptables.c
+++ b/iptables.c
@@ -78,9 +78,10 @@
 #define CMD_SET_POLICY		0x0400U
 #define CMD_RENAME_CHAIN	0x0800U
 #define CMD_LIST_RULES		0x1000U
-#define NUMBER_OF_CMD	14
+#define CMD_ZERO_NUM		0x2000U
+#define NUMBER_OF_CMD	15
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E', 'S' };
+				 'Z', 'N', 'X', 'P', 'E', 'S' };
 
 #define OPT_NONE	0x00000U
 #define OPT_NUMERIC	0x00001U
@@ -172,6 +173,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
@@ -280,7 +282,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --list-rules -S [chain [rulenum]]\n"
 "				Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]		Zero counters in chain or all chains\n"
+"  --zero    -Z [chain [rulenum]]\n"
+"				Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]		Delete a user-defined chain\n"
@@ -1399,7 +1402,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'L':
-			add_command(&command, CMD_LIST, CMD_ZERO,
+			add_command(&command, CMD_LIST, CMD_ZERO|CMD_ZERO_NUM,
 				    invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
@@ -1411,8 +1414,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'S':
-			add_command(&command, CMD_LIST_RULES, CMD_ZERO,
-				    invert);
+			add_command(&command, CMD_LIST_RULES,
+				    CMD_ZERO|CMD_ZERO_NUM, invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1438,6 +1441,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			else if (optind < argc && argv[optind][0] != '-'
 				&& argv[optind][0] != '!')
 				chain = argv[optind++];
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!') {
+				rulenum = parse_rulenumber(argv[optind++]);
+				command = CMD_ZERO_NUM;
+			}
 			break;
 
 		case 'N':
@@ -1994,8 +2002,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	case CMD_ZERO:
 		ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
 		break;
+	case CMD_ZERO_NUM:
+		ret = iptc_zero_counter(chain, rulenum, *handle);
+		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
+	case CMD_LIST|CMD_ZERO_NUM:
 		ret = list_entries(chain,
 				   rulenum,
 				   options&OPT_VERBOSE,
@@ -2006,9 +2018,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
 					   options&OPT_VERBOSE, *handle);
+		if (ret && (command & CMD_ZERO_NUM))
+			ret = iptc_zero_counter(chain, rulenum, *handle);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
+	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		ret = list_rules(chain,
 				   rulenum,
 				   options&OPT_VERBOSE,
@@ -2016,6 +2031,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
 					   options&OPT_VERBOSE, *handle);
+		if (ret && (command & CMD_ZERO_NUM))
+			ret = iptc_zero_counter(chain, rulenum, *handle);
 		break;
 	case CMD_NEW_CHAIN:
 		ret = iptc_create_chain(chain, *handle);
-- 
1.5.6.5


------=_Part_5404_21233729.1250704593341--
