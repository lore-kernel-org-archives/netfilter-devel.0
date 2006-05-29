From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/17]: ctnetlink: fix NAT configuration
Date: Tue, 30 May 2006 00:34:22 +0200 (MEST)
Message-ID: <20060529223422.24834.72481.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: fix NAT configuration

The current configuration only allows to configure one manip and overloads
conntrack status flags with netlink semantic.

Signed-off-by: Patrick Mchardy <kaber@trash.net>

---
commit 614914402a6a25f37b4cc0840e29aa1808d3426e
tree 9f1263181e20728bda8ac1fb2f8a6185c8c4aaa7
parent fc38099c5c54d23c8cee06ba1b1450f58b5ca1c2
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:15 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:15 +0200

 include/linux/netfilter/nfnetlink_conntrack.h |    4 +-
 net/ipv4/netfilter/ip_conntrack_netlink.c     |   53 ++++++++++---------------
 net/netfilter/nf_conntrack_netlink.c          |   53 ++++++++++---------------
 3 files changed, 47 insertions(+), 63 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 668ec94..b5883cc 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -27,13 +27,15 @@ enum ctattr_type {
 	CTA_STATUS,
 	CTA_PROTOINFO,
 	CTA_HELP,
-	CTA_NAT,
+	CTA_NAT_SRC,
+#define CTA_NAT	CTA_NAT_SRC	/* backwards compatibility */
 	CTA_TIMEOUT,
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
 	CTA_USE,
 	CTA_ID,
+	CTA_NAT_DST,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 01bd7ca..af152e3 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -629,7 +629,7 @@ static const size_t cta_min_nat[CTA_NAT_
 };
 
 static inline int
-ctnetlink_parse_nat(struct nfattr *cda[],
+ctnetlink_parse_nat(struct nfattr *nat,
 		    const struct ip_conntrack *ct, struct ip_nat_range *range)
 {
 	struct nfattr *tb[CTA_NAT_MAX];
@@ -639,7 +639,7 @@ ctnetlink_parse_nat(struct nfattr *cda[]
 
 	memset(range, 0, sizeof(*range));
 	
-	nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]);
+	nfattr_parse_nested(tb, CTA_NAT_MAX, nat);
 
 	if (nfattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
 		return -EINVAL;
@@ -854,39 +854,30 @@ ctnetlink_change_status(struct ip_conntr
 		/* ASSURED bit can only be set */
 		return -EINVAL;
 
-	if (cda[CTA_NAT-1]) {
+	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
 #ifndef CONFIG_IP_NF_NAT_NEEDED
 		return -EINVAL;
 #else
-		unsigned int hooknum;
 		struct ip_nat_range range;
 
-		if (ctnetlink_parse_nat(cda, ct, &range) < 0)
-			return -EINVAL;
-
-		DEBUGP("NAT: %u.%u.%u.%u-%u.%u.%u.%u:%u-%u\n", 
-		       NIPQUAD(range.min_ip), NIPQUAD(range.max_ip),
-		       htons(range.min.all), htons(range.max.all));
-		
-		/* This is tricky but it works. ip_nat_setup_info needs the
-		 * hook number as parameter, so let's do the correct 
-		 * conversion and run away */
-		if (status & IPS_SRC_NAT_DONE)
-			hooknum = NF_IP_POST_ROUTING; /* IP_NAT_MANIP_SRC */
-		else if (status & IPS_DST_NAT_DONE)
-			hooknum = NF_IP_PRE_ROUTING;  /* IP_NAT_MANIP_DST */
-		else 
-			return -EINVAL; /* Missing NAT flags */
-
-		DEBUGP("NAT status: %lu\n", 
-		       status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
-		
-		if (ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
-			return -EEXIST;
-		ip_nat_setup_info(ct, &range, hooknum);
-
-                DEBUGP("NAT status after setup_info: %lu\n",
-                       ct->status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
+		if (cda[CTA_NAT_DST-1]) {
+			if (ctnetlink_parse_nat(cda[CTA_NAT_DST-1], ct,
+						&range) < 0)
+				return -EINVAL;
+			if (ip_nat_initialized(ct,
+					       HOOK2MANIP(NF_IP_PRE_ROUTING)))
+				return -EEXIST;
+			ip_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
+		}
+		if (cda[CTA_NAT_SRC-1]) {
+			if (ctnetlink_parse_nat(cda[CTA_NAT_SRC-1], ct,
+						&range) < 0)
+				return -EINVAL;
+			if (ip_nat_initialized(ct,
+					       HOOK2MANIP(NF_IP_POST_ROUTING)))
+				return -EEXIST;
+			ip_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
+		}
 #endif
 	}
 
@@ -1106,7 +1097,7 @@ ctnetlink_new_conntrack(struct sock *ctn
 	/* implicit 'else' */
 
 	/* we only allow nat config for new conntracks */
-	if (cda[CTA_NAT-1]) {
+	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bd10eb9..8f27fe9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -641,7 +641,7 @@ static const size_t cta_min_nat[CTA_NAT_
 };
 
 static inline int
-ctnetlink_parse_nat(struct nfattr *cda[],
+ctnetlink_parse_nat(struct nfattr *nat,
 		    const struct nf_conn *ct, struct ip_nat_range *range)
 {
 	struct nfattr *tb[CTA_NAT_MAX];
@@ -651,7 +651,7 @@ ctnetlink_parse_nat(struct nfattr *cda[]
 
 	memset(range, 0, sizeof(*range));
 	
-	nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]);
+	nfattr_parse_nested(tb, CTA_NAT_MAX, nat);
 
 	if (nfattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
 		return -EINVAL;
@@ -866,39 +866,30 @@ ctnetlink_change_status(struct nf_conn *
 		/* ASSURED bit can only be set */
 		return -EINVAL;
 
-	if (cda[CTA_NAT-1]) {
+	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
 #ifndef CONFIG_IP_NF_NAT_NEEDED
 		return -EINVAL;
 #else
-		unsigned int hooknum;
 		struct ip_nat_range range;
 
-		if (ctnetlink_parse_nat(cda, ct, &range) < 0)
-			return -EINVAL;
-
-		DEBUGP("NAT: %u.%u.%u.%u-%u.%u.%u.%u:%u-%u\n", 
-		       NIPQUAD(range.min_ip), NIPQUAD(range.max_ip),
-		       htons(range.min.all), htons(range.max.all));
-		
-		/* This is tricky but it works. ip_nat_setup_info needs the
-		 * hook number as parameter, so let's do the correct 
-		 * conversion and run away */
-		if (status & IPS_SRC_NAT_DONE)
-			hooknum = NF_IP_POST_ROUTING; /* IP_NAT_MANIP_SRC */
-		else if (status & IPS_DST_NAT_DONE)
-			hooknum = NF_IP_PRE_ROUTING;  /* IP_NAT_MANIP_DST */
-		else 
-			return -EINVAL; /* Missing NAT flags */
-
-		DEBUGP("NAT status: %lu\n", 
-		       status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
-		
-		if (ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
-			return -EEXIST;
-		ip_nat_setup_info(ct, &range, hooknum);
-
-                DEBUGP("NAT status after setup_info: %lu\n",
-                       ct->status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
+		if (cda[CTA_NAT_DST-1]) {
+			if (ctnetlink_parse_nat(cda[CTA_NAT_DST-1], ct,
+						&range) < 0)
+				return -EINVAL;
+			if (ip_nat_initialized(ct,
+					       HOOK2MANIP(NF_IP_PRE_ROUTING)))
+				return -EEXIST;
+			ip_nat_setup_info(ct, &range, hooknum);
+		}
+		if (cda[CTA_NAT_SRC-1]) {
+			if (ctnetlink_parse_nat(cda[CTA_NAT_SRC-1], ct,
+						&range) < 0)
+				return -EINVAL;
+			if (ip_nat_initialized(ct,
+					       HOOK2MANIP(NF_IP_POST_ROUTING)))
+				return -EEXIST;
+			ip_nat_setup_info(ct, &range, hooknum);
+		}
 #endif
 	}
 
@@ -1122,7 +1113,7 @@ ctnetlink_new_conntrack(struct sock *ctn
 	/* implicit 'else' */
 
 	/* we only allow nat config for new conntracks */
-	if (cda[CTA_NAT-1]) {
+	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
