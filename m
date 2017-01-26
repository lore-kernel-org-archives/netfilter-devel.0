From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH V2 1/2] netfilter: ctnetlink: Fix regression in CTA_STATUS processing
Date: Thu, 26 Jan 2017 14:49:43 -0800
Message-ID: <20170126224944.29047-1-cernekee@chromium.org>
Cc: dianders@chromium.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The libnetfilter_conntrack userland library always sets IPS_CONFIRMED
when building a CTA_STATUS attribute.  If this toggles the bit from
0->1, the parser will return an error.  On Linux 4.4+ this will cause any
NFQA_EXP attribute in the packet to be ignored.  This breaks conntrackd's
userland helpers because they operate on unconfirmed connections.

Instead of returning -EBUSY if the user program asks to modify an
unchangeable bit, simply ignore the change.

Also, fix the logic so that user programs are allowed to clear
the bits that they are allowed to change.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---


V1->V2:

 - Create a new ctnetlink_update_status() function, per code review feedback
 - Add comment and update changelog, per code review feedback
 - Rebase + retest on net-next

(Note that the original patch 1/3, which fixed a related problem on
CTA_TIMEOUT, is only needed on old kernels like 4.4.)


 include/uapi/linux/netfilter/nf_conntrack_common.h |  4 ++++
 net/netfilter/nf_conntrack_netlink.c               | 27 +++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 6d074d1..6a8e33d 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -82,6 +82,10 @@ enum ip_conntrack_status {
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
 
+	/* Bits that cannot be altered from userland. */
+	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
+				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING),
+
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2754045..e8f704a6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1446,6 +1446,31 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 }
 
 static int
+ctnetlink_update_status(struct nf_conn *ct, const struct nlattr * const cda[])
+{
+	unsigned long d;
+	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
+	d = ct->status ^ status;
+
+	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
+		/* SEEN_REPLY bit can only be set */
+		return -EBUSY;
+
+	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
+		/* ASSURED bit can only be set */
+		return -EBUSY;
+
+	/* This check is less strict than ctnetlink_change_status()
+	 * because callers often flip IPS_EXPECTED bits when sending
+	 * an NFQA_CT attribute to the kernel.  So ignore the
+	 * unchangeable bits but do not error out.
+	 */
+	ct->status = (status & ~IPS_UNCHANGEABLE_MASK) |
+		     (ct->status & IPS_UNCHANGEABLE_MASK);
+	return 0;
+}
+
+static int
 ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
 {
 #ifdef CONFIG_NF_NAT_NEEDED
@@ -2280,7 +2305,7 @@ ctnetlink_glue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 			return err;
 	}
 	if (cda[CTA_STATUS]) {
-		err = ctnetlink_change_status(ct, cda);
+		err = ctnetlink_update_status(ct, cda);
 		if (err < 0)
 			return err;
 	}
-- 
2.7.4
