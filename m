From: Patrick McHardy <kaber@trash.net>
Subject: RFC: NAT configuration over ctnetlink
Date: Fri, 28 Apr 2006 08:46:24 +0200
Message-ID: <4451BA40.4050207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090201070109060508010903"
Cc: Harald Welte <laforge@netfilter.org>, Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------090201070109060508010903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I added ctnetlink support to a SIP proxy (siproxd) yesterday and
stumbled over some problems with NAT. The CTA_NAT attribute only
allows to set up a single manip, since NAT mappings can't be
changed for existing conntracks there is no way to add both a
src- and a dst-manip. This patch removes the overloading of the
status bits with netlink-relevant semantic and changes the CTA_NAT
attribute to CTA_NAT_SRC and CTA_NAT_DST. It breaks compatiblity,
but I don't think its worth trying to keep it for this stupid
behaviour. Any comments?


--------------090201070109060508010903
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix ctnetlink NAT configuration

---
commit 420869deee91a3bb78701885c3fd616015e38024
tree 211d2fcc33a6f129e3eda854362d342f9d8c8109
parent 22748548e0e83899fddf877f556e5220569ed8fd
author Patrick McHardy <kaber@trash.net> Thu, 27 Apr 2006 19:22:18 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Apr 2006 19:22:18 +0200

 include/linux/netfilter/nfnetlink_conntrack.h |    3 +
 net/ipv4/netfilter/ip_conntrack_netlink.c     |   53 ++++++++++---------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 668ec94..850526b 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -27,13 +27,14 @@ enum ctattr_type {
 	CTA_STATUS,
 	CTA_PROTOINFO,
 	CTA_HELP,
-	CTA_NAT,
+	CTA_NAT_SRC,
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

--------------090201070109060508010903--
