From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf V2] netfilter: ctnetlink: make it safer when updating ct->status
Date: Thu, 13 Apr 2017 20:53:47 +0800
Message-ID: <1492088027-10389-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, cernekee@chromium.org,
        fgao@ikuai8.com, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:43450 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdDMMyk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 08:54:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

User can update the ct->status via nfnetlink, but using a non-atomic
operation "ct->status |= status;". This is unsafe, and may clear
IPS_DYING_BIT bit set by another CPU unexpectedly. For example:
         CPU0                            CPU1
  ctnetlink_change_status        __nf_conntrack_find_get
      old = ct->status              nf_ct_gc_expired
          -                         nf_ct_kill
          -                      test_and_set_bit(IPS_DYING_BIT
      new = old | status;                 -
  ct->status = new; <-- oops, _DYING_ is cleared!

So using a series of atomic bit operation to solve the above issue.

Also note, user shouldn't set IPS_TEMPLATE, IPS_SEQ_ADJUST directly.

If we set the IPS_TEMPLATE_BIT, ct will be freed by nf_ct_tmpl_free,
but actually it is alloced by nf_conntrack_alloc.

If we set the IPS_SEQ_ADJUST_BIT, this may cause the NULL pointer
deference, as the nfct_seqadj(ct) maybe NULL.

So make these two bits be unchangable too.

Last, add some comments to describe the logic change due to the
commit a963d710f367 ("netfilter: ctnetlink: Fix regression in CTA_STATUS
processing"), which makes me feel a little confusing.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: make __ctnetlink_change_status more clean, per Gao Feng

 include/uapi/linux/netfilter/nf_conntrack_common.h | 13 ++++++---
 net/netfilter/nf_conntrack_netlink.c               | 33 ++++++++++++++++------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 6a8e33d..38fc383 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -82,10 +82,6 @@ enum ip_conntrack_status {
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
 
-	/* Bits that cannot be altered from userland. */
-	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
-				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING),
-
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
@@ -101,6 +97,15 @@ enum ip_conntrack_status {
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Be careful here, modifying these bits can make things messy,
+	 * so don't let users modify them directly.
+	 */
+	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
+				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
+				 IPS_SEQ_ADJUST | IPS_TEMPLATE),
+
+	__IPS_MAX_BIT = 14,
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 908d858..c16641e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1419,6 +1419,24 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 }
 #endif
 
+static void
+__ctnetlink_change_status(struct nf_conn *ct, unsigned long on,
+			  unsigned long off)
+{
+	unsigned int bit;
+
+	/* Ignore these unchangable bits */
+	on &= ~IPS_UNCHANGEABLE_MASK;
+	off &= ~IPS_UNCHANGEABLE_MASK;
+
+	for (bit = 0; bit < __IPS_MAX_BIT; bit++) {
+		if (on & (1 << bit))
+			set_bit(bit, &ct->status);
+		else if (off & (1 << bit))
+			clear_bit(bit, &ct->status);
+	}
+}
+
 static int
 ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 {
@@ -1438,10 +1456,7 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 		/* ASSURED bit can only be set */
 		return -EBUSY;
 
-	/* Be careful here, modifying NAT bits can screw up things,
-	 * so don't let users modify them directly if they don't pass
-	 * nf_nat_range. */
-	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+	__ctnetlink_change_status(ct, status, 0);
 	return 0;
 }
 
@@ -1632,7 +1647,7 @@ ctnetlink_change_seq_adj(struct nf_conn *ct,
 		if (ret < 0)
 			return ret;
 
-		ct->status |= IPS_SEQ_ADJUST;
+		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 	}
 
 	if (cda[CTA_SEQ_ADJ_REPLY]) {
@@ -1641,7 +1656,7 @@ ctnetlink_change_seq_adj(struct nf_conn *ct,
 		if (ret < 0)
 			return ret;
 
-		ct->status |= IPS_SEQ_ADJUST;
+		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 	}
 
 	return 0;
@@ -2295,10 +2310,10 @@ ctnetlink_update_status(struct nf_conn *ct, const struct nlattr * const cda[])
 	/* This check is less strict than ctnetlink_change_status()
 	 * because callers often flip IPS_EXPECTED bits when sending
 	 * an NFQA_CT attribute to the kernel.  So ignore the
-	 * unchangeable bits but do not error out.
+	 * unchangeable bits but do not error out. Also user programs
+	 * are allowed to clear the bits that they are allowed to change.
 	 */
-	ct->status = (status & ~IPS_UNCHANGEABLE_MASK) |
-		     (ct->status & IPS_UNCHANGEABLE_MASK);
+	__ctnetlink_change_status(ct, status, ~status);
 	return 0;
 }
 
-- 
2.5.5


