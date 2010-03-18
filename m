From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] netfilter: update documentation fields of x_tables.h
Date: Thu, 18 Mar 2010 15:09:44 +0100
Message-ID: <1268921390-30296-3-git-send-email-jengelh@medozas.de>
References: <1268921390-30296-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37316 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0CROJ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:09:56 -0400
In-Reply-To: <1268921390-30296-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 84c7c92..c68ff82 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -197,6 +197,7 @@ struct xt_counters_info {
  * @family:	Actual NFPROTO_* through which the function is invoked
  * 		(helpful when match->family == NFPROTO_UNSPEC)
  * @hotdrop:	drop packet if we had inspection problems
+ * Network namespace obtainable using dev_net(in/out)
  */
 struct xt_match_param {
 	const struct net_device *in, *out;
@@ -213,12 +214,14 @@ struct xt_match_param {
  * struct xt_mtchk_param - parameters for match extensions'
  * checkentry functions
  *
+ * @net:	network namespace through which the check was invoked
  * @table:	table the rule is tried to be inserted into
  * @entryinfo:	the family-specific rule data
- * 		(struct ipt_ip, ip6t_ip, ebt_entry)
+ * 		(struct ipt_ip, ip6t_ip, arpt_arp or (note) ebt_entry)
  * @match:	struct xt_match through which this function was invoked
  * @matchinfo:	per-match data
  * @hook_mask:	via which hooks the new rule is reachable
+ * Other fields as above.
  */
 struct xt_mtchk_param {
 	struct net *net;
@@ -230,7 +233,10 @@ struct xt_mtchk_param {
 	u_int8_t family;
 };
 
-/* Match destructor parameters */
+/**
+ * struct xt_mdtor_param - match destructor parameters
+ * Fields as above.
+ */
 struct xt_mtdtor_param {
 	struct net *net;
 	const struct xt_match *match;
-- 
1.7.0.2

