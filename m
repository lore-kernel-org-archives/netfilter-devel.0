From: Kevin Cernekee <cernekee@chromium.org>
Subject: [RFC/PATCH 2/3] netfilter: ctnetlink: Fix regression in CTA_STATUS processing
Date: Mon, 16 Jan 2017 21:14:07 -0800
Message-ID: <1484630048-25416-3-git-send-email-cernekee@chromium.org>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The libnetfilter_conntrack userland library always sets IPS_CONFIRMED
when building a CTA_STATUS attribute.  If this toggles the bit from
0->1, Linux 4.4+ will reject it and this will cause any NFQA_EXP
attribute in the packet to be ignored.  This breaks conntrackd's
userland helpers because they operate on unconfirmed connections.

Instead of returning -EBUSY if the user program asks to modify an
unchangeable bit, simply ignore the change.

Also, fix the logic so that user programs are allowed to clear
the bits that they are allowed to change.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h |  4 ++++
 net/netfilter/nf_conntrack_netlink.c               | 10 ++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 319f47128db8..846722d8e2a4 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -76,6 +76,10 @@ enum ip_conntrack_status {
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
index 43beb950df16..cc59f388928e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1422,10 +1422,6 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
 	d = ct->status ^ status;
 
-	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
-		/* unchangeable */
-		return -EBUSY;
-
 	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
 		/* SEEN_REPLY bit can only be set */
 		return -EBUSY;
@@ -1436,8 +1432,10 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 
 	/* Be careful here, modifying NAT bits can screw up things,
 	 * so don't let users modify them directly if they don't pass
-	 * nf_nat_range. */
-	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+	 * nf_nat_range.  Also, disallow changing bits that indicate
+	 * which hash table owns the connection. */
+	ct->status = (status & ~IPS_UNCHANGEABLE_MASK) |
+		     (ct->status & IPS_UNCHANGEABLE_MASK);
 	return 0;
 }
 
-- 
2.7.4
