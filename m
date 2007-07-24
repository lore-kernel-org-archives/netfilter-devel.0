From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 06/13] Unifies libip[6]t_state into libxt_state
Date: Tue, 24 Jul 2007 15:58:31 +0900 (JST)
Message-ID: <200707240658.l6O6wWxL019734@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


 extensions/Makefile                          |    6 +-
 extensions/{libipt_state.c => libxt_state.c} |   65 ++++++++++++++++---------
 include/linux/netfilter/xt_state.h           |   13 +++++
 3 files changed, 57 insertions(+), 27 deletions(-)
 rename extensions/{libipt_state.c => libxt_state.c} (63%)
 create mode 100644 include/linux/netfilter/xt_state.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 6b70bd5..4bf40c7 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy state HL LOG TRACE
-PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy HL LOG TRACE
+PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libipt_state.c b/extensions/libxt_state.c
similarity index 63%
rename from extensions/libipt_state.c
rename to extensions/libxt_state.c
index fcfee46..68c7484 100644
--- a/extensions/libipt_state.c
+++ b/extensions/libxt_state.c
@@ -4,12 +4,12 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter/nf_conntrack_common.h>
-#include <linux/netfilter_ipv4/ipt_state.h>
+#include <linux/netfilter/xt_state.h>
 
-#ifndef IPT_STATE_UNTRACKED
-#define IPT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+#ifndef XT_STATE_UNTRACKED
+#define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
 #endif
 
 /* Function which prints out usage message. */
@@ -29,25 +29,25 @@ static struct option opts[] = {
 };
 
 static int
-parse_state(const char *state, size_t strlen, struct ipt_state_info *sinfo)
+parse_state(const char *state, size_t strlen, struct xt_state_info *sinfo)
 {
 	if (strncasecmp(state, "INVALID", strlen) == 0)
-		sinfo->statemask |= IPT_STATE_INVALID;
+		sinfo->statemask |= XT_STATE_INVALID;
 	else if (strncasecmp(state, "NEW", strlen) == 0)
-		sinfo->statemask |= IPT_STATE_BIT(IP_CT_NEW);
+		sinfo->statemask |= XT_STATE_BIT(IP_CT_NEW);
 	else if (strncasecmp(state, "ESTABLISHED", strlen) == 0)
-		sinfo->statemask |= IPT_STATE_BIT(IP_CT_ESTABLISHED);
+		sinfo->statemask |= XT_STATE_BIT(IP_CT_ESTABLISHED);
 	else if (strncasecmp(state, "RELATED", strlen) == 0)
-		sinfo->statemask |= IPT_STATE_BIT(IP_CT_RELATED);
+		sinfo->statemask |= XT_STATE_BIT(IP_CT_RELATED);
 	else if (strncasecmp(state, "UNTRACKED", strlen) == 0)
-		sinfo->statemask |= IPT_STATE_UNTRACKED;
+		sinfo->statemask |= XT_STATE_UNTRACKED;
 	else
 		return 0;
 	return 1;
 }
 
 static void
-parse_states(const char *arg, struct ipt_state_info *sinfo)
+parse_states(const char *arg, struct xt_state_info *sinfo)
 {
 	const char *comma;
 
@@ -69,7 +69,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-	struct ipt_state_info *sinfo = (struct ipt_state_info *)(*match)->data;
+	struct xt_state_info *sinfo = (struct xt_state_info *)(*match)->data;
 
 	switch (c) {
 	case '1':
@@ -99,23 +99,23 @@ static void print_state(unsigned int statemask)
 {
 	const char *sep = "";
 
-	if (statemask & IPT_STATE_INVALID) {
+	if (statemask & XT_STATE_INVALID) {
 		printf("%sINVALID", sep);
 		sep = ",";
 	}
-	if (statemask & IPT_STATE_BIT(IP_CT_NEW)) {
+	if (statemask & XT_STATE_BIT(IP_CT_NEW)) {
 		printf("%sNEW", sep);
 		sep = ",";
 	}
-	if (statemask & IPT_STATE_BIT(IP_CT_RELATED)) {
+	if (statemask & XT_STATE_BIT(IP_CT_RELATED)) {
 		printf("%sRELATED", sep);
 		sep = ",";
 	}
-	if (statemask & IPT_STATE_BIT(IP_CT_ESTABLISHED)) {
+	if (statemask & XT_STATE_BIT(IP_CT_ESTABLISHED)) {
 		printf("%sESTABLISHED", sep);
 		sep = ",";
 	}
-	if (statemask & IPT_STATE_UNTRACKED) {
+	if (statemask & XT_STATE_UNTRACKED) {
 		printf("%sUNTRACKED", sep);
 		sep = ",";
 	}
@@ -128,7 +128,7 @@ print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
+	struct xt_state_info *sinfo = (struct xt_state_info *)match->data;
 
 	printf("state ");
 	print_state(sinfo->statemask);
@@ -137,27 +137,44 @@ print(const void *ip,
 /* Saves the matchinfo in parsable form to stdout. */
 static void save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
+	struct xt_state_info *sinfo = (struct xt_state_info *)match->data;
 
 	printf("--state ");
 	print_state(sinfo->statemask);
 }
 
-static struct iptables_match state = { 
+static struct xtables_match state = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "state",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_state_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_state_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
 	.help		= &help,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
-	.extra_opts	= opts
+	.extra_opts	= opts,
+};
+
+static struct xtables_match state6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "state",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
 };
 
 void _init(void)
 {
-	register_match(&state);
+	xtables_register_match(&state);
+	xtables_register_match(&state6);
 }
diff --git a/include/linux/netfilter/xt_state.h b/include/linux/netfilter/xt_state.h
new file mode 100644
index 0000000..c06f32e
--- /dev/null
+++ b/include/linux/netfilter/xt_state.h
@@ -0,0 +1,13 @@
+#ifndef _XT_STATE_H
+#define _XT_STATE_H
+
+#define XT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
+#define XT_STATE_INVALID (1 << 0)
+
+#define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+
+struct xt_state_info
+{
+	unsigned int statemask;
+};
+#endif /*_XT_STATE_H*/
-- 
1.5.2.2
