From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] option: fix ignored negation before implicit extension loading
Date: Tue,  7 Jun 2011 22:36:03 +0200
Message-ID: <1307478964-2034-6-git-send-email-jengelh@medozas.de>
References: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39450 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab1FGUgN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:36:13 -0400
In-Reply-To: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

`iptables -A INPUT -p tcp ! --syn` forgot the negation, i.e. it
was not present in a subsequent `iptables -S`.

Commit v1.4.11~77^2~9 missed the fact that after autoloading a proto
extension, cs.invert must not be touched until the next getopt call.
This is now fixed by having command_default return a value to indicate
whether to jump or not.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables.c     |    8 +++++++-
 iptables/iptables.c      |    4 +++-
 iptables/xshared.c       |   12 +++++++-----
 iptables/xshared.h       |    2 +-
 tests/options-most.rules |    2 ++
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4df73b8..4037acf 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1716,7 +1716,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit_tryhelp(2);
 
 		default:
-			command_default(&cs, &ip6tables_globals);
+			if (command_default(&cs, &ip6tables_globals) == 1)
+				/*
+				 * If new options were loaded, we must retry
+				 * getopt immediately and not allow
+				 * cs.invert=FALSE to be executed.
+				 */
+				continue;
 			break;
 		}
 		cs.invert = FALSE;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index d9c6436..4ae7541 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1743,7 +1743,9 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 			exit_tryhelp(2);
 
 		default:
-			command_default(&cs, &iptables_globals);
+			if (command_default(&cs, &iptables_globals) == 1)
+				/* cf. ip6tables.c */
+				continue;
 			break;
 		}
 		cs.invert = FALSE;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 4651888..0e3857b 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -104,8 +104,8 @@ struct xtables_match *load_proto(struct iptables_command_state *cs)
 			  cs->options & OPT_NUMERIC, &cs->matches);
 }
 
-void command_default(struct iptables_command_state *cs,
-		     struct xtables_globals *gl)
+int command_default(struct iptables_command_state *cs,
+		    struct xtables_globals *gl)
 {
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
@@ -116,7 +116,7 @@ void command_default(struct iptables_command_state *cs,
 	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
 		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
 				      cs->target, &cs->fw);
-		return;
+		return 0;
 	}
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
@@ -129,7 +129,7 @@ void command_default(struct iptables_command_state *cs,
 		    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
 			continue;
 		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
-		return;
+		return 0;
 	}
 
 	/* Try loading protocol */
@@ -161,7 +161,8 @@ void command_default(struct iptables_command_state *cs,
 		if (gl->opts == NULL)
 			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 		optind--;
-		return;
+		/* Indicate to rerun getopt *immediately* */
+ 		return 1;
 	}
 
 	if (cs->c == ':')
@@ -171,6 +172,7 @@ void command_default(struct iptables_command_state *cs,
 		xtables_error(PARAMETER_PROBLEM, "unknown option "
 			      "\"%s\"", cs->argv[optind-1]);
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
+	return 0;
 }
 
 static mainfunc_t subcmd_get(const char *cmd, const struct subcommand *cb)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index d868c06..b44a3a3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -77,7 +77,7 @@ enum {
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 extern const char *proto_to_name(uint8_t, int);
-extern void command_default(struct iptables_command_state *,
+extern int command_default(struct iptables_command_state *,
 	struct xtables_globals *);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 4cd3a87..6c4a831 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -38,6 +38,8 @@
 -A INPUT -p tcp -m recent --rcheck --name DEFAULT --rsource
 -A INPUT -p tcp -m socket --transparent
 -A INPUT -p tcp -m string --string "foobar" --algo kmp --from 1 --to 2 --icase
+-A INPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN
+-A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN
 -A INPUT -p tcp -m tos --tos 0xff/0x01
 -A INPUT -p tcp -m u32 --u32 "0x0=0x0" -m u32 --u32 "0x0=0x0"
 -A INPUT -p tcp -m hbh -m hbh -m hl --hl-eq 1 -m ipv6header --header hop-by-hop --soft
-- 
1.7.3.4

