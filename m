Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4593C38D41C;
	Thu,  2 Jul 2026 10:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989453; cv=none; b=DMTrMMWLWKxqrl7R6gpCJLYEJDucbElV5MvTNCeme2QD0jBsAdqOrhsFtm/eyMbyI+Wkm0KEc3vEaYu8P8i1KM+1D7md8RF6Qq4jGYcBKBO+6q31I5fBgL2simCZ12itzwruyjDk42+kUhUClAA9GaLieHCGGqvvyUpFEKB8njQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989453; c=relaxed/simple;
	bh=/LvDRZ8rUEbdqsVowQ4wXgIL/WqhA91DxCvkZHEVguw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0gRvbDo/LdwAl6VSsQVaHhakkdvK536sjXL+vzOBjAo43STgCXTVON6j83/QCHpy4+CjDyZDqCSKOR7ztUKhJfQxBVZsGn7or2j9QY11VVsNPXnz7p+qw1PtVmh4zRhIqJw+U4etrRrcl3Gm/T5rHOtkzESoFCPys19/nH/PT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0BC216032C; Thu, 02 Jul 2026 12:50:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 09/12] netfilter: conntrack: get rid of tuple in helper definitions
Date: Thu,  2 Jul 2026 12:50:00 +0200
Message-ID: <20260702105003.13550-10-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Leftover from the days when the kernel did automatic assignment of helpers
based on a pre-registered / well-known-port.

This helper autoassign was removed from the kernel, so all we really
need are the l3 and l4 protocol numbers.

In the broadcast helper, the only remaining consumer of the port number is
removed.  AFAICS its not needed: The expectation is populated from the
control connection reply tuple, so the src port is the original directions
destination (snmp/161 for example).

LLM complained about silent l3num (u16) -> nfproto (u8) truncation, so
add a netlink policy validation to reject large NFPROTO values upfront.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_helper.h |  9 ++++-----
 net/netfilter/nf_conntrack_broadcast.c      |  2 --
 net/netfilter/nf_conntrack_helper.c         | 22 +++++++++------------
 net/netfilter/nf_conntrack_ovs.c            |  6 +++---
 net/netfilter/nfnetlink_cthelper.c          | 21 ++++++++++----------
 net/sched/act_ct.c                          |  4 ++--
 6 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index c761cd8158b2..f3f0c1392e88 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -43,11 +43,10 @@ struct nf_conntrack_helper {
 
 	refcount_t ct_refcnt;
 
-	/* Tuple of things we will help (compared against server response) */
-	struct nf_conntrack_tuple tuple;
+	u8 nfproto;	/* NFPROTO_*, can be NFPROTO_UNSPEC */
+	u8 l4proto;	/* IPPROTO_UDP/TCP */
 
-	/* Function to call when data passes; return verdict, or -1 to
-           invalidate. */
+	/* Function to call when data passes; return verdict */
 	int __rcu (*help)(struct sk_buff *skb, unsigned int protoff,
 			  struct nf_conn *ct,
 			  enum ip_conntrack_info conntrackinfo);
@@ -94,7 +93,7 @@ struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
-		       u16 l3num, u16 protonum, const char *name,
+		       u8 l3num, u16 protonum, const char *name,
 		       u16 default_port, u16 spec_port, u32 id,
 		       const struct nf_conntrack_expect_policy *exp_pol,
 		       u32 expect_class_max,
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index bf78828c7549..6ff954f1bfb8 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -66,8 +66,6 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
 	helper = rcu_dereference(help->helper);
-	if (helper)
-		exp->tuple.src.u.udp.port = helper->tuple.src.u.udp.port;
 
 	exp->mask.src.u3.ip       = mask;
 	exp->mask.src.u.udp.port  = htons(0xFFFF);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 5ad5429352a7..b28986100db0 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -66,12 +66,9 @@ __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 	hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
 		if (strcmp(h->name, name))
 			continue;
-
-		if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
-		    h->tuple.src.l3num != l3num)
+		if (h->nfproto != NFPROTO_UNSPEC && h->nfproto != l3num)
 			continue;
-
-		if (h->tuple.dst.protonum == protonum)
+		if (h->l4proto == protonum)
 			return h;
 	}
 	return NULL;
@@ -388,13 +385,13 @@ int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			return -EINVAL;
 	}
 
-	h = helper_hash(me->name, me->tuple.dst.protonum);
+	h = helper_hash(me->name, me->l4proto);
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
 		if (!strcmp(cur->name, me->name) &&
-		    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
-		     cur->tuple.src.l3num == me->tuple.src.l3num) &&
-		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
+		    (cur->nfproto == NFPROTO_UNSPEC ||
+		     cur->nfproto == me->nfproto) &&
+		    cur->l4proto == me->l4proto) {
 			ret = -EBUSY;
 			goto out;
 		}
@@ -474,7 +471,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
-		       u16 l3num, u16 protonum, const char *name,
+		       u8 l3num, u16 protonum, const char *name,
 		       u16 default_port, u16 spec_port, u32 id,
 		       const struct nf_conntrack_expect_policy *exp_pol,
 		       u32 expect_class_max,
@@ -487,9 +484,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 {
 	memset(helper, 0, sizeof(*helper));
 
-	helper->tuple.src.l3num = l3num;
-	helper->tuple.dst.protonum = protonum;
-	helper->tuple.src.u.all = htons(spec_port);
+	helper->nfproto = l3num;
+	helper->l4proto = protonum;
 
 	rcu_assign_pointer(helper->help, help);
 	helper->from_nlattr = from_nlattr;
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index 49d1511e9921..b4085af3ad1c 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -31,8 +31,8 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 	if (!helper)
 		return NF_ACCEPT;
 
-	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
-	    helper->tuple.src.l3num != proto)
+	if (helper->nfproto != NFPROTO_UNSPEC &&
+	    helper->nfproto != proto)
 		return NF_ACCEPT;
 
 	switch (proto) {
@@ -60,7 +60,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		return NF_DROP;
 	}
 
-	if (helper->tuple.dst.protonum != proto)
+	if (helper->l4proto != proto)
 		return NF_ACCEPT;
 
 	helper_cb = rcu_dereference(helper->help);
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index f1460b683d7a..56655cb7fe2a 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -67,7 +67,7 @@ nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 }
 
 static const struct nla_policy nfnl_cthelper_tuple_pol[NFCTH_TUPLE_MAX+1] = {
-	[NFCTH_TUPLE_L3PROTONUM] = { .type = NLA_U16, },
+	[NFCTH_TUPLE_L3PROTONUM] = NLA_POLICY_MAX(NLA_BE16, NFPROTO_IPV6),
 	[NFCTH_TUPLE_L4PROTONUM] = { .type = NLA_U8, },
 };
 
@@ -254,7 +254,8 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	helper->data_len = size;
 
 	helper->flags |= NF_CT_HELPER_F_USERSPACE;
-	memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));
+	helper->nfproto = tuple->src.l3num;
+	helper->l4proto = tuple->dst.protonum;
 
 	helper->me = THIS_MODULE;
 	helper->help = nfnl_userspace_cthelper;
@@ -449,8 +450,8 @@ static int nfnl_cthelper_new(struct sk_buff *skb, const struct nfnl_info *info,
 		if (strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
 			continue;
 
-		if ((tuple.src.l3num != cur->tuple.src.l3num ||
-		     tuple.dst.protonum != cur->tuple.dst.protonum))
+		if ((tuple.src.l3num != cur->nfproto ||
+		     tuple.dst.protonum != cur->l4proto))
 			continue;
 
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL)
@@ -479,10 +480,10 @@ nfnl_cthelper_dump_tuple(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nla_put_be16(skb, NFCTH_TUPLE_L3PROTONUM,
-			 htons(helper->tuple.src.l3num)))
+			 htons(helper->nfproto)))
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, NFCTH_TUPLE_L4PROTONUM, helper->tuple.dst.protonum))
+	if (nla_put_u8(skb, NFCTH_TUPLE_L4PROTONUM, helper->l4proto))
 		goto nla_put_failure;
 
 	nla_nest_end(skb, nest_parms);
@@ -661,8 +662,8 @@ static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
 			continue;
 
 		if (tuple_set &&
-		    (tuple.src.l3num != cur->tuple.src.l3num ||
-		     tuple.dst.protonum != cur->tuple.dst.protonum))
+		    (tuple.src.l3num != cur->nfproto ||
+		     tuple.dst.protonum != cur->l4proto))
 			continue;
 
 		skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -721,8 +722,8 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 			continue;
 
 		if (tuple_set &&
-		    (tuple.src.l3num != cur->tuple.src.l3num ||
-		     tuple.dst.protonum != cur->tuple.dst.protonum))
+		    (tuple.src.l3num != cur->nfproto ||
+		     tuple.dst.protonum != cur->l4proto))
 			continue;
 
 		found = true;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index be535a261fa0..4ca7964e83c8 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1527,8 +1527,8 @@ static int tcf_ct_dump_helper(struct sk_buff *skb,
 		return 0;
 
 	if (nla_put_string(skb, TCA_CT_HELPER_NAME, helper->name) ||
-	    nla_put_u8(skb, TCA_CT_HELPER_FAMILY, helper->tuple.src.l3num) ||
-	    nla_put_u8(skb, TCA_CT_HELPER_PROTO, helper->tuple.dst.protonum))
+	    nla_put_u8(skb, TCA_CT_HELPER_FAMILY, helper->nfproto) ||
+	    nla_put_u8(skb, TCA_CT_HELPER_PROTO, helper->l4proto))
 		return -1;
 
 	return 0;
-- 
2.54.0

