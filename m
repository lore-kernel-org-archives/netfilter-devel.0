From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Thu, 11 Jul 2013 02:48:27 +0200
Message-ID: <20130711004827.GA5500@localhost>
References: <20130705020312.25783ccd.billfink@mindspring.com>
 <20130706132333.GA3279@localhost>
 <20130707030458.fbf22472.billfink@mindspring.com>
 <20130709013023.2fb1fef1.billfink@mindspring.com>
 <20130709182223.GA6266@localhost>
 <20130710055815.a1bd2c1d.billfink@mindspring.com>
 <20130710220820.GA20666@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bill Fink <billfink@mindspring.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130710220820.GA20666@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 11, 2013 at 12:08:20AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 10, 2013 at 05:58:15AM -0400, Bill Fink wrote:
> > Almost there.  With the above patch, I now successfully get
> > IPv6 expectations on the backup firewall.  Unfortunately they're
> > not quite right.  On the backup firewall, the expectation src-IP
> > is the same as the dst-IP (either IPv4 or IPv6).
> > 
> > Primary firewall:
> > 
> > [root@sen-fw1 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> > 251 proto=6 src=192.168.218.199 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> > conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> > 
> > Backup firewall:
> > 
> > [root@sen-fw2 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> > 245 proto=6 src=192.168.28.198 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> > conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> > 
> > This was an unfortunate side affect of the patch to fix the
> > conntrackd segfault problem.  If I use Florian's version
> > of the fix segfault patch rather than Pablo's then all is
> > good.
> 
> Thanks for the information, however, we still need to get working back
> the filtering support.
> 
> Could you give a try to the following patch, please?
> 
> It applies on top of conntrack-tools master branch, thanks.

There are still some downsides in the previous solution, please, give
a try to this patch instead.

Thanks.

--tThc/1wpZn/ma/RB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-conntrackd-simplify-expectation-filtering.patch"

>From 586382d9a8389ee553db019fd9be14a8a7c0b8ec Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 11 Jul 2013 00:43:20 +0200
Subject: [PATCH] conntrackd: simplify expectation filtering

This patch simplifies the expectation filtering by looking up for the
master conntrack. If it does not exists, then we assume that we don't
want this expectation either.

This simplification also fixes the current broken expectation filtering,
since the master conntrack from expectations has neither reply tuple
nor state, however, the filtering code assumes the opposite.

This partially reverts (479a37a conntrackd: fix crash with IPv6 expectation
in the filtering code) since it was incorrectly setting the reply tuple
of the master conntrack.

Thanks to Bill Fink for providing feedback to resolve this issue.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/filter.h      |    1 +
 include/internal.h    |    1 +
 src/cache-ct.c        |   11 +++++++++--
 src/ctnl.c            |   37 +++++++++----------------------------
 src/filter.c          |   45 +++++++++++++++++++++++++++++++++++++++++++++
 src/internal_bypass.c |    6 ++++++
 src/internal_cache.c  |   11 +++++++++++
 7 files changed, 82 insertions(+), 30 deletions(-)

diff --git a/include/filter.h b/include/filter.h
index 3c7c8cc..d0acd96 100644
--- a/include/filter.h
+++ b/include/filter.h
@@ -51,6 +51,7 @@ void ct_filter_set_logic(struct ct_filter *f,
 			 enum ct_filter_type type,
 			 enum ct_filter_logic logic);
 int ct_filter_conntrack(const struct nf_conntrack *ct, int userspace);
+int ct_filter_master(const struct nf_conntrack *master);
 
 struct exp_filter;
 struct nf_expect;
diff --git a/include/internal.h b/include/internal.h
index 2ba9714..1a796a7 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -40,6 +40,7 @@ struct internal_handler {
 		void	(*new)(struct nf_expect *exp, int origin_type);
 		void	(*upd)(struct nf_expect *exp, int origin_type);
 		int	(*del)(struct nf_expect *exp, int origin_type);
+		int	(*find)(const struct nf_conntrack *master);
 
 		void	(*dump)(int fd, int type);
 		void	(*populate)(struct nf_expect *exp);
diff --git a/src/cache-ct.c b/src/cache-ct.c
index a538215..f86d143 100644
--- a/src/cache-ct.c
+++ b/src/cache-ct.c
@@ -88,14 +88,21 @@ cache_ct_hash(const void *data, const struct hashtable *table)
 	return ret;
 }
 
+/* master conntrack of expectations have no ID */
+static inline int
+cache_ct_cmp_id(const struct nf_conntrack *ct1, const struct nf_conntrack *ct2)
+{
+	return nfct_attr_is_set(ct2, ATTR_ID) ?
+	       nfct_get_attr_u32(ct1, ATTR_ID) == nfct_get_attr_u32(ct2, ATTR_ID) : 1;
+}
+
 static int cache_ct_cmp(const void *data1, const void *data2)
 {
 	const struct cache_object *obj = data1;
 	const struct nf_conntrack *ct = data2;
 
 	return nfct_cmp(obj->ptr, ct, NFCT_CMP_ORIG) &&
-	       nfct_get_attr_u32(obj->ptr, ATTR_ID) ==
-	       nfct_get_attr_u32(ct, ATTR_ID);
+	       cache_ct_cmp_id(obj->ptr, ct);
 }
 
 static void *cache_ct_alloc(void)
diff --git a/src/ctnl.c b/src/ctnl.c
index 9e1cfa1..10b5f4c 100644
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
+	if (ct_filter_master(master))
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
+	if (ct_filter_master(master))
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
+	if (ct_filter_master(master))
 		return NFCT_CB_CONTINUE;
 
 	STATE(get_retval) = 1;
diff --git a/src/filter.c b/src/filter.c
index e21cfde..8fac71b 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -407,6 +407,51 @@ int ct_filter_conntrack(const struct nf_conntrack *ct, int userspace)
 	return 0;
 }
 
+static inline int
+ct_filter_master_sanity_check(const struct nf_conntrack *master)
+{
+	if (master == NULL) {
+		dlog(LOG_ERR, "no master tuple in expectation");
+		return 0;
+	}
+
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
+			     "You forgot to load nf_conntrack_ipv4?");
+			return 0;
+		}
+		break;
+	case AF_INET6:
+		if (!nfct_attr_is_set(master, ATTR_IPV6_SRC) ||
+		    !nfct_attr_is_set(master, ATTR_IPV6_DST)) {
+		    	dlog(LOG_ERR, "missing IPv6 address. "
+			     "You forgot to load nf_conntrack_ipv6?");
+			return 0;
+		}
+		break;
+	}
+	return 1;
+}
+
+int ct_filter_master(const struct nf_conntrack *master)
+{
+	if (!ct_filter_master_sanity_check(master))
+		return 1;
+
+	/* Check if we've got a master conntrack for this expectation in our
+	 * caches. If there is not, we don't want this expectation either.
+	 */
+	return STATE(mode)->internal->exp.find(master) ? 0 : 1;
+}
+
 struct exp_filter {
 	struct list_head 	list;
 };
diff --git a/src/internal_bypass.c b/src/internal_bypass.c
index 1194339..ce2ae46 100644
--- a/src/internal_bypass.c
+++ b/src/internal_bypass.c
@@ -283,6 +283,11 @@ static int internal_bypass_exp_event_del(struct nf_expect *exp, int origin)
 	return 1;
 }
 
+static int internal_bypass_exp_master_find(const struct nf_conntrack *master)
+{
+	return nl_get_conntrack(STATE(get), master) == 0;
+}
+
 struct internal_handler internal_bypass = {
 	.init			= internal_bypass_init,
 	.close			= internal_bypass_close,
@@ -309,5 +314,6 @@ struct internal_handler internal_bypass = {
 		.new			= internal_bypass_exp_event_new,
 		.upd			= internal_bypass_exp_event_upd,
 		.del			= internal_bypass_exp_event_del,
+		.find			= internal_bypass_exp_master_find,
 	},
 };
diff --git a/src/internal_cache.c b/src/internal_cache.c
index ba2d74b..bad31f3 100644
--- a/src/internal_cache.c
+++ b/src/internal_cache.c
@@ -364,6 +364,16 @@ static int internal_cache_exp_event_del(struct nf_expect *exp, int origin)
 	return 1;
 }
 
+static int internal_cache_exp_master_find(const struct nf_conntrack *master)
+{
+	struct cache_object *obj;
+	int id;
+
+	obj = cache_find(STATE(mode)->internal->ct.data,
+			 (struct nf_conntrack *)master, &id);
+	return obj ? 1 : 0;
+}
+
 struct internal_handler internal_cache = {
 	.flags			= INTERNAL_F_POPULATE | INTERNAL_F_RESYNC,
 	.init			= internal_cache_init,
@@ -391,5 +401,6 @@ struct internal_handler internal_cache = {
 		.new			= internal_cache_exp_event_new,
 		.upd			= internal_cache_exp_event_upd,
 		.del			= internal_cache_exp_event_del,
+		.find			= internal_cache_exp_master_find,
 	},
 };
-- 
1.7.10.4


--tThc/1wpZn/ma/RB--
