Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEB3CA9ED2
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4597B21734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="LzJo5CZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfKAQgA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:36:00 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:50471 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfKAQf7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 12:35:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 7559C3C80124;
        Fri,  1 Nov 2019 17:35:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1572626155; x=1574440556; bh=4OcL6iBygn
        afG+hjMiiICi8aWVG0bE35EzYkoWrwFoQ=; b=LzJo5CZjoFUwEg+hG6ywoHu/g5
        NMyvzNQTfLUqPt9HsT4O7Qa0CZoeap3m/GrpUILEzZ8CTwngGG6U5ToDEQLZO5s4
        G53SNfWS55OyHyWFahp4ygQg42ED+6H2QaLZPqna0WyMeqQKhmyblwrBl5xTOcYE
        wdNbflI5wpvm3vcbU=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 558B23C8011F;
        Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3625C220A4; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT
Date:   Fri,  1 Nov 2019 17:35:54 +0100
Message-Id: <20191101163554.10561-4-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
References: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since v5.2 (commit "netlink: re-add parse/validate functions in strict
mode") NL_VALIDATE_STRICT is enabled. Fix the ipset nla_policies which di=
d
not support strict mode and convert from deprecated parsings to verified =
ones.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c        | 41 ++++++++++++++++--------
 net/netfilter/ipset/ip_set_hash_net.c    |  1 +
 net/netfilter/ipset/ip_set_hash_netnet.c |  1 +
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index e7288eab7512..d73d1828216a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -296,7 +296,8 @@ ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipadd=
r)
=20
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_=
policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
+			     ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV4)))
 		return -IPSET_ERR_PROTOCOL;
@@ -314,7 +315,8 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_=
addr *ipaddr)
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
=20
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_=
policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
+			     ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV6)))
 		return -IPSET_ERR_PROTOCOL;
@@ -934,7 +936,8 @@ static int ip_set_create(struct net *net, struct sock=
 *ctnl,
=20
 	/* Without holding any locks, create private part. */
 	if (attr[IPSET_ATTR_DATA] &&
-	    nla_parse_nested_deprecated(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_A=
TTR_DATA], set->type->create_policy, NULL)) {
+	    nla_parse_nested(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA],
+			     set->type->create_policy, NULL)) {
 		ret =3D -IPSET_ERR_PROTOCOL;
 		goto put_out;
 	}
@@ -1281,6 +1284,14 @@ dump_attrs(struct nlmsghdr *nlh)
 	}
 }
=20
+static const struct nla_policy
+ip_set_dump_policy[IPSET_ATTR_CMD_MAX + 1] =3D {
+	[IPSET_ATTR_PROTOCOL]	=3D { .type =3D NLA_U8 },
+	[IPSET_ATTR_SETNAME]	=3D { .type =3D NLA_NUL_STRING,
+				    .len =3D IPSET_MAXNAMELEN - 1 },
+	[IPSET_ATTR_FLAGS]	=3D { .type =3D NLA_U32 },
+};
+
 static int
 dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 {
@@ -1292,9 +1303,9 @@ dump_init(struct netlink_callback *cb, struct ip_se=
t_net *inst)
 	ip_set_id_t index;
 	int ret;
=20
-	ret =3D nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
-				   nlh->nlmsg_len - min_len,
-				   ip_set_setname_policy, NULL);
+	ret =3D nla_parse(cda, IPSET_ATTR_CMD_MAX, attr,
+			nlh->nlmsg_len - min_len,
+			ip_set_dump_policy, NULL);
 	if (ret)
 		return ret;
=20
@@ -1543,9 +1554,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, str=
uct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr =3D (void *)&errmsg->msg + min_len;
=20
-		ret =3D nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-					   nlh->nlmsg_len - min_len,
-					   ip_set_adt_policy, NULL);
+		ret =3D nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+				nlh->nlmsg_len - min_len, ip_set_adt_policy,
+				NULL);
=20
 		if (ret) {
 			nlmsg_free(skb2);
@@ -1596,7 +1607,9 @@ static int ip_set_ad(struct net *net, struct sock *=
ctnl,
=20
 	use_lineno =3D !!attr[IPSET_ATTR_LINENO];
 	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATT=
R_DATA], set->type->adt_policy, NULL))
+		if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX,
+				     attr[IPSET_ATTR_DATA],
+				     set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
 		ret =3D call_ad(ctnl, skb, set, tb, adt, flags,
 			      use_lineno);
@@ -1606,7 +1619,8 @@ static int ip_set_ad(struct net *net, struct sock *=
ctnl,
 		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
 			if (nla_type(nla) !=3D IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
-			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->typ=
e->adt_policy, NULL))
+			    nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, nla,
+					     set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
 			ret =3D call_ad(ctnl, skb, set, tb, adt,
 				      flags, use_lineno);
@@ -1655,7 +1669,8 @@ static int ip_set_utest(struct net *net, struct soc=
k *ctnl, struct sk_buff *skb,
 	if (!set)
 		return -ENOENT;
=20
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR=
_DATA], set->type->adt_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA],
+			     set->type->adt_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
=20
 	rcu_read_lock_bh();
@@ -1961,7 +1976,7 @@ static const struct nfnl_callback ip_set_netlink_su=
bsys_cb[IPSET_MSG_MAX] =3D {
 	[IPSET_CMD_LIST]	=3D {
 		.call		=3D ip_set_dump,
 		.attr_count	=3D IPSET_ATTR_CMD_MAX,
-		.policy		=3D ip_set_setname_policy,
+		.policy		=3D ip_set_dump_policy,
 	},
 	[IPSET_CMD_SAVE]	=3D {
 		.call		=3D ip_set_dump,
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index c259cbc3ef45..3d932de0ad29 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -368,6 +368,7 @@ static struct ip_set_type hash_net_type __read_mostly=
 =3D {
 		[IPSET_ATTR_IP_TO]	=3D { .type =3D NLA_NESTED },
 		[IPSET_ATTR_CIDR]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_LINENO]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BYTES]	=3D { .type =3D NLA_U64 },
 		[IPSET_ATTR_PACKETS]	=3D { .type =3D NLA_U64 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index a3ae69bfee66..4398322fad59 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -476,6 +476,7 @@ static struct ip_set_type hash_netnet_type __read_mos=
tly =3D {
 		[IPSET_ATTR_CIDR]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_CIDR2]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_LINENO]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BYTES]	=3D { .type =3D NLA_U64 },
 		[IPSET_ATTR_PACKETS]	=3D { .type =3D NLA_U64 },
--=20
2.20.1

