From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [CTNETLINK] Remove debugging messages
Date: Wed, 11 Oct 2006 00:58:41 +0200
Message-ID: <452C25A1.1060302@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090702040506020204060007"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------090702040506020204060007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Remove debugging messages introduced at early development stage

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090702040506020204060007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[CTNETLINK] Remove debugging messages

Remove debugging messages introduces at early development stage

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-10-10 03:00:00.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-10-11 00:32:15.000000000 +0200
@@ -44,13 +44,6 @@ MODULE_LICENSE("GPL");
 
 static char __initdata version[] = "0.90";
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
 			    const struct ip_conntrack_tuple *tuple,
@@ -398,7 +391,6 @@ nfattr_failure:
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
-	DEBUGP("entered %s\n", __FUNCTION__);
 	if (cb->args[1])
 		ip_conntrack_put((struct ip_conntrack *)cb->args[1]);
 	return 0;
@@ -411,9 +403,6 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct ip_conntrack_tuple_hash *h;
 	struct list_head *i;
 
-	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
-			cb->args[0], *id);
-
 	read_lock_bh(&ip_conntrack_lock);
 	last = (struct ip_conntrack *)cb->args[1];
 	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++) {
@@ -452,7 +441,6 @@ out:
 	if (last)
 		ip_conntrack_put(last);
 
-	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
 	return skb->len;
 }
 
@@ -466,8 +454,6 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 {
 	struct nfattr *tb[CTA_IP_MAX];
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_IP_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
@@ -481,8 +467,6 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 		return -EINVAL;
 	tuple->dst.ip = *(__be32 *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
 
-	DEBUGP("leaving\n");
-
 	return 0;
 }
 
@@ -503,8 +487,6 @@ ctnetlink_parse_tuple_proto(struct nfatt
 	struct ip_conntrack_protocol *proto;
 	int ret = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_PROTO_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
@@ -531,8 +513,6 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	struct nfattr *tb[CTA_TUPLE_MAX];
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	memset(tuple, 0, sizeof(*tuple));
 
 	nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]);
@@ -557,10 +537,6 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	else
 		tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
-	DUMP_TUPLE(tuple);
-
-	DEBUGP("leaving\n");
-
 	return 0;
 }
 
@@ -577,8 +553,6 @@ static int ctnetlink_parse_nat_proto(str
 	struct nfattr *tb[CTA_PROTONAT_MAX];
 	struct ip_nat_protocol *npt;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
@@ -597,7 +571,6 @@ static int ctnetlink_parse_nat_proto(str
 
 	ip_nat_proto_put(npt);
 
-	DEBUGP("leaving\n");
 	return 0;
 }
 
@@ -613,8 +586,6 @@ ctnetlink_parse_nat(struct nfattr *nat,
 	struct nfattr *tb[CTA_NAT_MAX];
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	memset(range, 0, sizeof(*range));
 	
 	nfattr_parse_nested(tb, CTA_NAT_MAX, nat);
@@ -640,7 +611,6 @@ ctnetlink_parse_nat(struct nfattr *nat,
 	if (err < 0)
 		return err;
 
-	DEBUGP("leaving\n");
 	return 0;
 }
 #endif
@@ -650,8 +620,6 @@ ctnetlink_parse_help(struct nfattr *attr
 {
 	struct nfattr *tb[CTA_HELP_MAX];
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_HELP_MAX, attr);
 
 	if (!tb[CTA_HELP_NAME-1])
@@ -679,8 +647,6 @@ ctnetlink_del_conntrack(struct sock *ctn
 	struct ip_conntrack *ct;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
@@ -698,10 +664,8 @@ ctnetlink_del_conntrack(struct sock *ctn
 		return err;
 
 	h = ip_conntrack_find_get(&tuple, NULL);
-	if (!h) {
-		DEBUGP("tuple not found in conntrack hash\n");
+	if (!h)
 		return -ENOENT;
-	}
 
 	ct = tuplehash_to_ctrack(h);
 	
@@ -716,7 +680,6 @@ ctnetlink_del_conntrack(struct sock *ctn
 		ct->timeout.function((unsigned long)ct);
 
 	ip_conntrack_put(ct);
-	DEBUGP("leaving\n");
 
 	return 0;
 }
@@ -731,8 +694,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 	struct sk_buff *skb2 = NULL;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct nfgenmsg *msg = NLMSG_DATA(nlh);
 		u32 rlen;
@@ -770,11 +731,9 @@ ctnetlink_get_conntrack(struct sock *ctn
 		return err;
 
 	h = ip_conntrack_find_get(&tuple, NULL);
-	if (!h) {
-		DEBUGP("tuple not found in conntrack hash");
+	if (!h)
 		return -ENOENT;
-	}
-	DEBUGP("tuple found\n");
+
 	ct = tuplehash_to_ctrack(h);
 
 	err = -ENOMEM;
@@ -795,7 +754,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 	if (err < 0)
 		goto out;
 
-	DEBUGP("leaving\n");
 	return 0;
 
 free:
@@ -866,8 +824,6 @@ ctnetlink_change_helper(struct ip_conntr
 	char *helpname;
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	/* don't change helper of sibling connections */
 	if (ct->master)
 		return -EINVAL;
@@ -938,8 +894,6 @@ ctnetlink_change_conntrack(struct ip_con
 {
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (cda[CTA_HELP-1]) {
 		err = ctnetlink_change_helper(ct, cda);
 		if (err < 0)
@@ -969,7 +923,6 @@ ctnetlink_change_conntrack(struct ip_con
 		ct->mark = ntohl(*(__be32 *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	DEBUGP("all done\n");
 	return 0;
 }
 
@@ -981,8 +934,6 @@ ctnetlink_create_conntrack(struct nfattr
 	struct ip_conntrack *ct;
 	int err = -EINVAL;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	ct = ip_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;	
@@ -1017,7 +968,6 @@ ctnetlink_create_conntrack(struct nfattr
 	if (ct->helper)
 		ip_conntrack_helper_put(ct->helper);
 
-	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
 
 err:	
@@ -1033,8 +983,6 @@ ctnetlink_new_conntrack(struct sock *ctn
 	struct ip_conntrack_tuple_hash *h = NULL;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
@@ -1058,7 +1006,6 @@ ctnetlink_new_conntrack(struct sock *ctn
 
 	if (h == NULL) {
 		write_unlock_bh(&ip_conntrack_lock);
-		DEBUGP("no such conntrack, create new\n");
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
@@ -1074,7 +1021,6 @@ ctnetlink_new_conntrack(struct sock *ctn
 
 	/* We manipulate the conntrack inside the global conntrack table lock,
 	 * so there's no need to increase the refcount */
-	DEBUGP("conntrack found\n");
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
 		err = ctnetlink_change_conntrack(tuplehash_to_ctrack(h), cda);
@@ -1249,8 +1195,6 @@ ctnetlink_exp_dump_table(struct sk_buff 
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[0];
 
-	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
-
 	read_lock_bh(&ip_conntrack_lock);
 	list_for_each_prev(i, &ip_conntrack_expect_list) {
 		exp = (struct ip_conntrack_expect *) i;
@@ -1266,8 +1210,6 @@ ctnetlink_exp_dump_table(struct sk_buff 
 out:	
 	read_unlock_bh(&ip_conntrack_lock);
 
-	DEBUGP("leaving, last id=%llu\n", *id);
-
 	return skb->len;
 }
 
@@ -1285,8 +1227,6 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	struct sk_buff *skb2;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
@@ -1437,8 +1377,6 @@ ctnetlink_create_expect(struct nfattr *c
 	struct ip_conntrack *ct;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	/* caller guarantees that those three CTA_EXPECT_* exist */
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
 	if (err < 0)
@@ -1490,8 +1428,6 @@ ctnetlink_new_expect(struct sock *ctnl, 
 	struct ip_conntrack_expect *exp;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);	
-
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
@@ -1520,8 +1456,6 @@ ctnetlink_new_expect(struct sock *ctnl, 
 		err = ctnetlink_change_expect(exp, cda);
 	write_unlock_bh(&ip_conntrack_lock);
 
-	DEBUGP("leaving\n");
-	
 	return err;
 }
 
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-10-10 03:02:35.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-10-11 00:12:53.000000000 +0200
@@ -47,13 +47,6 @@ MODULE_LICENSE("GPL");
 
 static char __initdata version[] = "0.93";
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
 			    const struct nf_conntrack_tuple *tuple,
@@ -410,7 +403,6 @@ static int ctnetlink_done(struct netlink
 {
 	if (cb->args[1])
 		nf_ct_put((struct nf_conn *)cb->args[1]);
-	DEBUGP("entered %s\n", __FUNCTION__);
 	return 0;
 }
 
@@ -425,9 +417,6 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
-			cb->args[0], *id);
-
 	read_lock_bh(&nf_conntrack_lock);
 	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
@@ -471,7 +460,6 @@ out:
 	if (last)
 		nf_ct_put(last);
 
-	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
 	return skb->len;
 }
 
@@ -482,8 +470,6 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 	struct nf_conntrack_l3proto *l3proto;
 	int ret = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_IP_MAX, attr);
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
@@ -493,8 +479,6 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 
 	nf_ct_l3proto_put(l3proto);
 
-	DEBUGP("leaving\n");
-
 	return ret;
 }
 
@@ -510,8 +494,6 @@ ctnetlink_parse_tuple_proto(struct nfatt
 	struct nf_conntrack_protocol *proto;
 	int ret = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_PROTO_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
@@ -538,8 +520,6 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	struct nfattr *tb[CTA_TUPLE_MAX];
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	memset(tuple, 0, sizeof(*tuple));
 
 	nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]);
@@ -566,10 +546,6 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	else
 		tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
-	NF_CT_DUMP_TUPLE(tuple);
-
-	DEBUGP("leaving\n");
-
 	return 0;
 }
 
@@ -586,8 +562,6 @@ static int ctnetlink_parse_nat_proto(str
 	struct nfattr *tb[CTA_PROTONAT_MAX];
 	struct ip_nat_protocol *npt;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
@@ -606,7 +580,6 @@ static int ctnetlink_parse_nat_proto(str
 
 	ip_nat_proto_put(npt);
 
-	DEBUGP("leaving\n");
 	return 0;
 }
 
@@ -622,8 +595,6 @@ ctnetlink_parse_nat(struct nfattr *nat,
 	struct nfattr *tb[CTA_NAT_MAX];
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	memset(range, 0, sizeof(*range));
 	
 	nfattr_parse_nested(tb, CTA_NAT_MAX, nat);
@@ -649,7 +620,6 @@ ctnetlink_parse_nat(struct nfattr *nat,
 	if (err < 0)
 		return err;
 
-	DEBUGP("leaving\n");
 	return 0;
 }
 #endif
@@ -659,8 +629,6 @@ ctnetlink_parse_help(struct nfattr *attr
 {
 	struct nfattr *tb[CTA_HELP_MAX];
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	nfattr_parse_nested(tb, CTA_HELP_MAX, attr);
 
 	if (!tb[CTA_HELP_NAME-1])
@@ -690,8 +658,6 @@ ctnetlink_del_conntrack(struct sock *ctn
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
@@ -709,10 +675,8 @@ ctnetlink_del_conntrack(struct sock *ctn
 		return err;
 
 	h = nf_conntrack_find_get(&tuple, NULL);
-	if (!h) {
-		DEBUGP("tuple not found in conntrack hash\n");
+	if (!h)
 		return -ENOENT;
-	}
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 	
@@ -727,7 +691,6 @@ ctnetlink_del_conntrack(struct sock *ctn
 		ct->timeout.function((unsigned long)ct);
 
 	nf_ct_put(ct);
-	DEBUGP("leaving\n");
 
 	return 0;
 }
@@ -744,8 +707,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		u32 rlen;
 
@@ -779,11 +740,9 @@ ctnetlink_get_conntrack(struct sock *ctn
 		return err;
 
 	h = nf_conntrack_find_get(&tuple, NULL);
-	if (!h) {
-		DEBUGP("tuple not found in conntrack hash");
+	if (!h)
 		return -ENOENT;
-	}
-	DEBUGP("tuple found\n");
+	
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	err = -ENOMEM;
@@ -804,7 +763,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 	if (err < 0)
 		goto out;
 
-	DEBUGP("leaving\n");
 	return 0;
 
 free:
@@ -876,8 +834,6 @@ ctnetlink_change_helper(struct nf_conn *
 	char *helpname;
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (!help) {
 		/* FIXME: we need to reallocate and rehash */
 		return -EBUSY;
@@ -954,8 +910,6 @@ ctnetlink_change_conntrack(struct nf_con
 {
 	int err;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (cda[CTA_HELP-1]) {
 		err = ctnetlink_change_helper(ct, cda);
 		if (err < 0)
@@ -985,7 +939,6 @@ ctnetlink_change_conntrack(struct nf_con
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	DEBUGP("all done\n");
 	return 0;
 }
 
@@ -997,8 +950,6 @@ ctnetlink_create_conntrack(struct nfattr
 	struct nf_conn *ct;
 	int err = -EINVAL;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;	
@@ -1028,7 +979,6 @@ ctnetlink_create_conntrack(struct nfattr
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 
-	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
 
 err:	
@@ -1046,8 +996,6 @@ ctnetlink_new_conntrack(struct sock *ctn
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
@@ -1071,7 +1019,6 @@ ctnetlink_new_conntrack(struct sock *ctn
 
 	if (h == NULL) {
 		write_unlock_bh(&nf_conntrack_lock);
-		DEBUGP("no such conntrack, create new\n");
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
@@ -1087,7 +1034,6 @@ ctnetlink_new_conntrack(struct sock *ctn
 
 	/* We manipulate the conntrack inside the global conntrack table lock,
 	 * so there's no need to increase the refcount */
-	DEBUGP("conntrack found\n");
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
 		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h), cda);
@@ -1268,8 +1214,6 @@ ctnetlink_exp_dump_table(struct sk_buff 
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
-
 	read_lock_bh(&nf_conntrack_lock);
 	list_for_each_prev(i, &nf_conntrack_expect_list) {
 		exp = (struct nf_conntrack_expect *) i;
@@ -1287,8 +1231,6 @@ ctnetlink_exp_dump_table(struct sk_buff 
 out:	
 	read_unlock_bh(&nf_conntrack_lock);
 
-	DEBUGP("leaving, last id=%llu\n", *id);
-
 	return skb->len;
 }
 
@@ -1308,8 +1250,6 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
@@ -1460,8 +1400,6 @@ ctnetlink_create_expect(struct nfattr *c
 	struct nf_conn_help *help;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);
-
 	/* caller guarantees that those three CTA_EXPECT_* exist */
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
 	if (err < 0)
@@ -1516,8 +1454,6 @@ ctnetlink_new_expect(struct sock *ctnl, 
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);	
-
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
@@ -1546,8 +1482,6 @@ ctnetlink_new_expect(struct sock *ctnl, 
 		err = ctnetlink_change_expect(exp, cda);
 	write_unlock_bh(&nf_conntrack_lock);
 
-	DEBUGP("leaving\n");
-	
 	return err;
 }
 

--------------090702040506020204060007--
