Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39715C28CC7
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 128E120820
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="nUnTSEDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389853AbfFJMYV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 08:24:21 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:44195 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbfFJMYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 08:24:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 5166E67400E5;
        Mon, 10 Jun 2019 14:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1560169457; x=1561983858; bh=UVfKbobsE5
        y0Zi2kx9hqw6JohIEoE/VNYFPUlxYdVDs=; b=nUnTSEDOO7kmdTaRTOGzrf504x
        nIEB8Y80KYRqMuMnlmBr+tDcoRXcrDX2Cx7LKa3q6md3dpx/19YKDDatX3nglqBu
        wRaCXgpE+1kE3rtH/p+060qu0JptaBEIU2Fz3EvQQZFjjgu95PZmHxVz1TR5VeWy
        TJV5tcADt7p3AAlDc=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id EE6E867400D9;
        Mon, 10 Jun 2019 14:24:16 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D420022FDF; Mon, 10 Jun 2019 14:24:16 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] netfilter: ipset: merge uadd and udel functions
Date:   Mon, 10 Jun 2019 14:24:11 +0200
Message-Id: <20190610122416.22708-3-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
References: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

Both functions are using exactly the same code, except the command value
passed to call_ad function.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 71 +++++++++----------------------
 1 file changed, 20 insertions(+), 51 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index faddcf398b73..2ad609900b22 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1561,10 +1561,12 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, s=
truct ip_set *set,
 	return ret;
 }
=20
-static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buf=
f *skb,
-		       const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_ad(struct net *net, struct sock *ctnl,
+		     struct sk_buff *skb,
+		     enum ipset_adt adt,
+		     const struct nlmsghdr *nlh,
+		     const struct nlattr * const attr[],
+		     struct netlink_ext_ack *extack)
 {
 	struct ip_set_net *inst =3D ip_set_pernet(net);
 	struct ip_set *set;
@@ -1593,7 +1595,7 @@ static int ip_set_uadd(struct net *net, struct sock=
 *ctnl, struct sk_buff *skb,
 	if (attr[IPSET_ATTR_DATA]) {
 		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATT=
R_DATA], set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
-		ret =3D call_ad(ctnl, skb, set, tb, IPSET_ADD, flags,
+		ret =3D call_ad(ctnl, skb, set, tb, adt, flags,
 			      use_lineno);
 	} else {
 		int nla_rem;
@@ -1603,7 +1605,7 @@ static int ip_set_uadd(struct net *net, struct sock=
 *ctnl, struct sk_buff *skb,
 			    !flag_nested(nla) ||
 			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->typ=
e->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
-			ret =3D call_ad(ctnl, skb, set, tb, IPSET_ADD,
+			ret =3D call_ad(ctnl, skb, set, tb, adt,
 				      flags, use_lineno);
 			if (ret < 0)
 				return ret;
@@ -1612,55 +1614,22 @@ static int ip_set_uadd(struct net *net, struct so=
ck *ctnl, struct sk_buff *skb,
 	return ret;
 }
=20
-static int ip_set_udel(struct net *net, struct sock *ctnl, struct sk_buf=
f *skb,
-		       const struct nlmsghdr *nlh,
+static int ip_set_uadd(struct net *net, struct sock *ctnl,
+		       struct sk_buff *skb, const struct nlmsghdr *nlh,
 		       const struct nlattr * const attr[],
 		       struct netlink_ext_ack *extack)
 {
-	struct ip_set_net *inst =3D ip_set_pernet(net);
-	struct ip_set *set;
-	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] =3D {};
-	const struct nlattr *nla;
-	u32 flags =3D flag_exist(nlh);
-	bool use_lineno;
-	int ret =3D 0;
-
-	if (unlikely(protocol_min_failed(attr) ||
-		     !attr[IPSET_ATTR_SETNAME] ||
-		     !((attr[IPSET_ATTR_DATA] !=3D NULL) ^
-		       (attr[IPSET_ATTR_ADT] !=3D NULL)) ||
-		     (attr[IPSET_ATTR_DATA] &&
-		      !flag_nested(attr[IPSET_ATTR_DATA])) ||
-		     (attr[IPSET_ATTR_ADT] &&
-		      (!flag_nested(attr[IPSET_ATTR_ADT]) ||
-		       !attr[IPSET_ATTR_LINENO]))))
-		return -IPSET_ERR_PROTOCOL;
-
-	set =3D find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (!set)
-		return -ENOENT;
-
-	use_lineno =3D !!attr[IPSET_ATTR_LINENO];
-	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATT=
R_DATA], set->type->adt_policy, NULL))
-			return -IPSET_ERR_PROTOCOL;
-		ret =3D call_ad(ctnl, skb, set, tb, IPSET_DEL, flags,
-			      use_lineno);
-	} else {
-		int nla_rem;
+	return ip_set_ad(net, ctnl, skb,
+			 IPSET_ADD, nlh, attr, extack);
+}
=20
-		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
-			if (nla_type(nla) !=3D IPSET_ATTR_DATA ||
-			    !flag_nested(nla) ||
-			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->typ=
e->adt_policy, NULL))
-				return -IPSET_ERR_PROTOCOL;
-			ret =3D call_ad(ctnl, skb, set, tb, IPSET_DEL,
-				      flags, use_lineno);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	return ret;
+static int ip_set_udel(struct net *net, struct sock *ctnl,
+		       struct sk_buff *skb, const struct nlmsghdr *nlh,
+		       const struct nlattr * const attr[],
+		       struct netlink_ext_ack *extack)
+{
+	return ip_set_ad(net, ctnl, skb,
+			 IPSET_DEL, nlh, attr, extack);
 }
=20
 static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_bu=
ff *skb,
--=20
2.20.1

