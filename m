From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] iptables: fix undersized deletion mask creation
Date: Thu, 29 Oct 2009 19:11:17 +0100
Message-ID: <1256839878-24358-4-git-send-email-jengelh@medozas.de>
References: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56285 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZJ2SLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 14:11:19 -0400
In-Reply-To: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The mask created for the -D rulespec is simply too small.
xtables_targets points to whatever target has last been loaded, so
xtables_targets->size is quite almost wrong, as we need to use the
size of the target for the specific rule that is about to be deleted.

This bug existed ever since iptables history is tracked, and requires
certain circumstances to be visible, where the deletion operation is
one. Furthermore, multiple userspace target extensions must have been
loaded, and a target B whose .size is smaller than the target A of
the rule we are about to delete must have been loaded more recently
than target A. The minimal testcase is (rule 60007 gets wrongly
removed)

	*nat
	-F
	-X
	-A POSTROUTING -p udp -j SNAT --to 192.168.1.1:60007
	-A POSTROUTING -p udp -j SNAT --to 192.168.1.1:60008
	-A POSTROUTING -p udp -j CONNMARK --set-mark 0
	-D POSTROUTING -p udp -j SNAT --to 192.168.1.1:60008
	COMMIT

References: http://bugzilla.netfilter.org/show_bug.cgi?id=606
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   14 ++++++++------
 iptables.c  |   14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 8f653e8..53a1a5d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -803,7 +803,8 @@ insert_entry(const ip6t_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct xtables_rule_match *matches)
+make_delete_mask(struct xtables_rule_match *matches,
+		 const struct xtables_target *target)
 {
 	/* Establish mask for comparison */
 	unsigned int size;
@@ -816,7 +817,7 @@ make_delete_mask(struct xtables_rule_match *matches)
 
 	mask = xtables_calloc(1, size
 			 + IP6T_ALIGN(sizeof(struct ip6t_entry_target))
-			 + xtables_targets->size);
+			 + target->size);
 
 	memset(mask, 0xFF, sizeof(struct ip6t_entry));
 	mptr = mask + sizeof(struct ip6t_entry);
@@ -830,7 +831,7 @@ make_delete_mask(struct xtables_rule_match *matches)
 
 	memset(mptr, 0xFF,
 	       IP6T_ALIGN(sizeof(struct ip6t_entry_target))
-	       + xtables_targets->userspacesize);
+	       + target->userspacesize);
 
 	return mask;
 }
@@ -846,13 +847,14 @@ delete_entry(const ip6t_chainlabel chain,
 	     const struct in6_addr dmasks[],
 	     int verbose,
 	     struct ip6tc_handle *handle,
-	     struct xtables_rule_match *matches)
+	     struct xtables_rule_match *matches,
+	     const struct xtables_target *target)
 {
 	unsigned int i, j;
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches);
+	mask = make_delete_mask(matches, target);
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ipv6.src = saddrs[i];
 		fw->ipv6.smsk = smasks[i];
@@ -1938,7 +1940,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
 				   options&OPT_VERBOSE,
-				   *handle, matches);
+				   *handle, matches, target);
 		break;
 	case CMD_DELETE_NUM:
 		ret = ip6tc_delete_num_entry(chain, rulenum - 1, *handle);
diff --git a/iptables.c b/iptables.c
index 7228721..1160171 100644
--- a/iptables.c
+++ b/iptables.c
@@ -805,7 +805,8 @@ insert_entry(const ipt_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct xtables_rule_match *matches)
+make_delete_mask(struct xtables_rule_match *matches,
+		 const struct xtables_target *target)
 {
 	/* Establish mask for comparison */
 	unsigned int size;
@@ -818,7 +819,7 @@ make_delete_mask(struct xtables_rule_match *matches)
 
 	mask = xtables_calloc(1, size
 			 + IPT_ALIGN(sizeof(struct ipt_entry_target))
-			 + xtables_targets->size);
+			 + target->size);
 
 	memset(mask, 0xFF, sizeof(struct ipt_entry));
 	mptr = mask + sizeof(struct ipt_entry);
@@ -832,7 +833,7 @@ make_delete_mask(struct xtables_rule_match *matches)
 
 	memset(mptr, 0xFF,
 	       IPT_ALIGN(sizeof(struct ipt_entry_target))
-	       + xtables_targets->userspacesize);
+	       + target->userspacesize);
 
 	return mask;
 }
@@ -848,13 +849,14 @@ delete_entry(const ipt_chainlabel chain,
 	     const struct in_addr dmasks[],
 	     int verbose,
 	     struct iptc_handle *handle,
-	     struct xtables_rule_match *matches)
+	     struct xtables_rule_match *matches,
+	     const struct xtables_target *target)
 {
 	unsigned int i, j;
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches);
+	mask = make_delete_mask(matches, target);
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ip.src.s_addr = saddrs[i].s_addr;
 		fw->ip.smsk.s_addr = smasks[i].s_addr;
@@ -1979,7 +1981,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
 				   options&OPT_VERBOSE,
-				   *handle, matches);
+				   *handle, matches, target);
 		break;
 	case CMD_DELETE_NUM:
 		ret = iptc_delete_num_entry(chain, rulenum - 1, *handle);
-- 
1.6.5.1

