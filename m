From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Thu, 11 Jul 2013 00:08:20 +0200
Message-ID: <20130710220820.GA20666@localhost>
References: <20130705020312.25783ccd.billfink@mindspring.com>
 <20130706132333.GA3279@localhost>
 <20130707030458.fbf22472.billfink@mindspring.com>
 <20130709013023.2fb1fef1.billfink@mindspring.com>
 <20130709182223.GA6266@localhost>
 <20130710055815.a1bd2c1d.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bill Fink <billfink@mindspring.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54019 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab3GJWJU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:09:20 -0400
Content-Disposition: inline
In-Reply-To: <20130710055815.a1bd2c1d.billfink@mindspring.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2013 at 05:58:15AM -0400, Bill Fink wrote:
> Almost there.  With the above patch, I now successfully get
> IPv6 expectations on the backup firewall.  Unfortunately they're
> not quite right.  On the backup firewall, the expectation src-IP
> is the same as the dst-IP (either IPv4 or IPv6).
> 
> Primary firewall:
> 
> [root@sen-fw1 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> 251 proto=6 src=192.168.218.199 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> 
> Backup firewall:
> 
> [root@sen-fw2 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> 245 proto=6 src=192.168.28.198 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> 
> This was an unfortunate side affect of the patch to fix the
> conntrackd segfault problem.  If I use Florian's version
> of the fix segfault patch rather than Pablo's then all is
> good.

Thanks for the information, however, we still need to get working back
the filtering support.

Could you give a try to the following patch, please?

It applies on top of conntrack-tools master branch, thanks.

--bg08WKrSYDhXBjb5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-conntrackd-add-specific-filtering-for-expectations.patch"

>From 964b9a11a15f27dc4393d07dd9971f65c9fe998c Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 10 Jul 2013 23:35:22 +0200
Subject: [PATCH] conntrackd: add specific filtering for expectations

This patch adds exp_filter_conntrack, that allows us to filter expectations
based on its master conntrack. Previously, the daemon was relying on the
existing ct_filter_conntrack, however, we cannot use it since the master
tuple of the expectation has neither reply tuple nor state.

This partially reverts (479a37a conntrackd: fix crash with IPv6 expectation
in the filtering code) as it was incorrectly setting the reply tuple of the
master conntrack.

Reported-by: Bill Fink <billfink@mindspring.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/filter.h |    1 +
 src/ctnl.c       |   37 ++++---------
 src/filter.c     |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 158 insertions(+), 34 deletions(-)

diff --git a/include/filter.h b/include/filter.h
index 3c7c8cc..e1cf671 100644
--- a/include/filter.h
+++ b/include/filter.h
@@ -51,6 +51,7 @@ void ct_filter_set_logic(struct ct_filter *f,
 			 enum ct_filter_type type,
 			 enum ct_filter_logic logic);
 int ct_filter_conntrack(const struct nf_conntrack *ct, int userspace);
+int exp_filter_conntrack(const struct nf_conntrack *master);
 
 struct exp_filter;
 struct nf_expect;
diff --git a/src/ctnl.c b/src/ctnl.c
index 9e1cfa1..c37c38a 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -211,35 +211,14 @@ out:
 		return NFCT_CB_CONTINUE;
 }
 
-static const struct nf_conntrack *exp_get_master_ct(struct nf_expect *exp)
-{
-	struct nf_conntrack *master =
-		(struct nf_conntrack *)nfexp_get_attr(exp, ATTR_EXP_MASTER);
-
-	/* The function ct_filter_conntrack needs the source address of the
-	 * reply tuple, emulate it.
-	 */
-	switch (nfct_get_attr_u8(master, ATTR_L3PROTO)) {
-	case AF_INET:
-		nfct_set_attr_u32(master, ATTR_REPL_IPV4_SRC,
-				  nfct_get_attr_u32(master, ATTR_IPV4_DST));
-		break;
-	case AF_INET6:
-		nfct_set_attr(master, ATTR_REPL_IPV6_SRC,
-			      nfct_get_attr(master, ATTR_IPV6_DST));
-		break;
-	}
-
-	return master;
-}
-
 static int exp_event_handler(const struct nlmsghdr *nlh,
 			     enum nf_conntrack_msg_type type,
 			     struct nf_expect *exp,
 			     void *data)
 {
 	int origin_type;
-	const struct nf_conntrack *master = exp_get_master_ct(exp);
+	const struct nf_conntrack *master =
+		nfexp_get_attr(exp, ATTR_EXP_MASTER);
 
 	STATE(stats).nl_events_received++;
 
@@ -247,7 +226,7 @@ static int exp_event_handler(const struct nlmsghdr *nlh,
 		STATE(stats).nl_events_filtered++;
 		goto out;
 	}
-	if (ct_filter_conntrack(master, 1))
+	if (exp_filter_conntrack(master))
 		return NFCT_CB_CONTINUE;
 
 	origin_type = origin_find(nlh);
@@ -296,12 +275,13 @@ static int dump_handler(enum nf_conntrack_msg_type type,
 static int exp_dump_handler(enum nf_conntrack_msg_type type,
 			    struct nf_expect *exp, void *data)
 {
-	const struct nf_conntrack *master = exp_get_master_ct(exp);
+	const struct nf_conntrack *master =
+		nfexp_get_attr(exp, ATTR_EXP_MASTER);
 
 	if (!exp_filter_find(STATE(exp_filter), exp))
 		return NFCT_CB_CONTINUE;
 
-	if (ct_filter_conntrack(master, 1))
+	if (exp_filter_conntrack(master))
 		return NFCT_CB_CONTINUE;
 
 	switch(type) {
@@ -329,12 +309,13 @@ static int get_handler(enum nf_conntrack_msg_type type,
 static int exp_get_handler(enum nf_conntrack_msg_type type,
 			   struct nf_expect *exp, void *data)
 {
-	const struct nf_conntrack *master = exp_get_master_ct(exp);
+	const struct nf_conntrack *master =
+		nfexp_get_attr(exp, ATTR_EXP_MASTER);
 
 	if (!exp_filter_find(STATE(exp_filter), exp))
 		return NFCT_CB_CONTINUE;
 
-	if (ct_filter_conntrack(master, 1))
+	if (exp_filter_conntrack(master))
 		return NFCT_CB_CONTINUE;
 
 	STATE(get_retval) = 1;
diff --git a/src/filter.c b/src/filter.c
index e21cfde..c160c1a 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -279,13 +279,10 @@ __ct_filter_test_mask4(const void *ptr, const void *ct)
 		(elem->ip & elem->mask) == (dst & elem->mask));
 }
 
-static int
-__ct_filter_test_mask6(const void *ptr, const void *ct)
+static inline int
+vector_elem_cmp_ipv6(const struct ct_filter_netmask_ipv6 *elem,
+		     const uint32_t *src, const uint32_t *dst)
 {
-	const struct ct_filter_netmask_ipv6 *elem = ptr;
-	const uint32_t *src = nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
-	const uint32_t *dst = nfct_get_attr(ct, ATTR_REPL_IPV6_SRC);
-
 	return (((elem->ip[0] & elem->mask[0]) == (src[0] & elem->mask[0]) &&
 		 (elem->ip[1] & elem->mask[1]) == (src[1] & elem->mask[1]) &&
 		 (elem->ip[2] & elem->mask[2]) == (src[2] & elem->mask[2]) &&
@@ -297,6 +294,16 @@ __ct_filter_test_mask6(const void *ptr, const void *ct)
 }
 
 static int
+__ct_filter_test_mask6(const void *ptr, const void *ct)
+{
+	const struct ct_filter_netmask_ipv6 *elem = ptr;
+	const uint32_t *src = nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
+	const uint32_t *dst = nfct_get_attr(ct, ATTR_REPL_IPV6_SRC);
+
+	return vector_elem_cmp_ipv6(elem, src, dst);
+}
+
+static int
 __ct_filter_test_state(struct ct_filter *f, const struct nf_conntrack *ct)
 {
 	uint16_t val = 0;
@@ -407,6 +414,141 @@ int ct_filter_conntrack(const struct nf_conntrack *ct, int userspace)
 	return 0;
 }
 
+static int exp_filter_ipv4(const void *ptr, const void *master)
+{
+	const struct ct_filter_netmask_ipv4 *elem = ptr;
+	const uint32_t src = nfct_get_attr_u32(master, ATTR_IPV4_SRC);
+	const uint32_t dst = nfct_get_attr_u32(master, ATTR_IPV4_DST);
+
+	return ((elem->ip & elem->mask) == (src & elem->mask) ||
+		(elem->ip & elem->mask) == (dst & elem->mask));
+}
+
+static int exp_filter_ipv6(const void *ptr, const void *master)
+{
+	const struct ct_filter_netmask_ipv6 *elem = ptr;
+	const uint32_t *src = nfct_get_attr(master, ATTR_IPV6_SRC);
+	const uint32_t *dst = nfct_get_attr(master, ATTR_IPV6_DST);
+
+	return vector_elem_cmp_ipv6(elem, src, dst);
+}
+
+static inline int
+exp_filter_test_ipv4(struct ct_filter *f, const struct nf_conntrack *ct)
+{
+	int id_src, id_dst;
+	uint32_t src, dst;
+
+	src = nfct_get_attr_u32(ct, ATTR_IPV4_SRC);
+	dst = nfct_get_attr_u32(ct, ATTR_IPV4_DST);
+
+	id_src = hashtable_hash(f->h, &src);
+	id_dst = hashtable_hash(f->h, &dst);
+
+	return hashtable_find(f->h, &src, id_src) ||
+	       hashtable_find(f->h, &dst, id_dst);
+}
+
+static inline int
+exp_filter_test_ipv6(struct ct_filter *f, const struct nf_conntrack *ct)
+{
+	int id_src, id_dst;
+	const uint32_t *src, *dst;
+
+	src = nfct_get_attr(ct, ATTR_IPV6_SRC);
+	dst = nfct_get_attr(ct, ATTR_IPV6_DST);
+
+	id_src = hashtable_hash(f->h6, src);
+	id_dst = hashtable_hash(f->h6, dst);
+
+	return hashtable_find(f->h6, src, id_src) ||
+	       hashtable_find(f->h6, dst, id_dst);
+}
+
+static int exp_filter_check(struct ct_filter *f, const struct nf_conntrack *ct)
+{
+	int ret, protonum = nfct_get_attr_u8(ct, ATTR_L4PROTO);
+
+	/* no event filtering at all */
+	if (f == NULL)
+		return 1;
+
+	if (f->logic[CT_FILTER_L4PROTO] != -1) {
+		ret = test_bit_u32(protonum, f->l4protomap);
+		if (ret ^ f->logic[CT_FILTER_L4PROTO])
+			return 0;
+	}
+
+	if (f->logic[CT_FILTER_ADDRESS] != -1) {
+		switch (nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
+		case AF_INET:
+			ret = vector_iterate(f->v, ct, exp_filter_ipv4);
+			if (ret ^ f->logic[CT_FILTER_ADDRESS])
+				return 0;
+			ret = exp_filter_test_ipv4(f, ct);
+			if (ret ^ f->logic[CT_FILTER_ADDRESS])
+				return 0;
+			break;
+		case AF_INET6:
+			ret = vector_iterate(f->v6, ct, exp_filter_ipv6);
+			if (ret ^ f->logic[CT_FILTER_ADDRESS])
+				return 0;
+			ret = exp_filter_test_ipv6(f, ct);
+			if (ret ^ f->logic[CT_FILTER_ADDRESS])
+				return 0;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 1;
+}
+
+static inline int exp_filter_sanity_check(const struct nf_conntrack *master)
+{
+	if (!nfct_attr_is_set(master, ATTR_L3PROTO)) {
+		dlog(LOG_ERR, "missing layer 3 protocol");
+		return 0;
+	}
+
+	switch (nfct_get_attr_u8(master, ATTR_L3PROTO)) {
+	case AF_INET:
+		if (!nfct_attr_is_set(master, ATTR_IPV4_SRC) ||
+		    !nfct_attr_is_set(master, ATTR_IPV4_DST)) {
+		    	dlog(LOG_ERR, "missing IPv4 address. "
+				      "You forgot to load "
+				      "nf_conntrack_ipv4?");
+			return 0;
+		}
+		break;
+	case AF_INET6:
+		if (!nfct_attr_is_set(master, ATTR_IPV6_SRC) ||
+		    !nfct_attr_is_set(master, ATTR_IPV6_DST)) {
+		    	dlog(LOG_ERR, "missing IPv6 address. "
+				      "You forgot to load "
+				      "nf_conntrack_ipv6?");
+			return 0;
+		}
+		break;
+	}
+	return 1;
+}
+
+int exp_filter_conntrack(const struct nf_conntrack *master)
+{
+	if (!exp_filter_sanity_check(master))
+		return 1;
+
+	/* The master tuple of the expectation has neither reply tuple nor
+	 * state, use specific filtering function for this case.
+	 */
+	if (!exp_filter_check(STATE(us_filter), master))
+		return 1;
+
+	return 0;
+}
+
 struct exp_filter {
 	struct list_head 	list;
 };
-- 
1.7.10.4


--bg08WKrSYDhXBjb5--
