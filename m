Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4DBC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Dec 2022 12:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiL3Mej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Dec 2022 07:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiL3Meh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2022 07:34:37 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C28E0CC
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2022 04:34:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8A114CC010E;
        Fri, 30 Dec 2022 13:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1672403080; x=1674217481; bh=ZFqKEtwPY2
        tc+rwKEkk7ZMmAi++n+3Erh7dGitUlHos=; b=JcWksUDHoaSuMnzuctk+1Ffp0p
        ELfoVfhd+7f8xhxX5WAdoeOZu7sOKGhnWDk/nIEosUwTAquqeHZ5tOVjSM9nFWpx
        lCfyrmFChdNcu1Oi14CNZt23+bhlJ29B9/YX81gFGKKaDxvPciq7fHiCtMzNV+K0
        dkem+1ICH/wpN7Hyw=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 30 Dec 2022 13:24:40 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 5A238CC00F4;
        Fri, 30 Dec 2022 13:24:38 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 507C2343158; Fri, 30 Dec 2022 13:24:38 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: ipset: Rework long task execution when adding/deleting entries
Date:   Fri, 30 Dec 2022 13:24:38 +0100
Message-Id: <20221230122438.1618153-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221230122438.1618153-1-kadlec@netfilter.org>
References: <20221230122438.1618153-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding/deleting large number of elements in one step in ipset, it ca=
n
take a reasonable amount of time and can result in soft lockup errors. Th=
e
patch 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of
consecutive elements to add/delete") tried to fix it by limiting the max
elements to process at all. However it was not enough, it is still possib=
le
that we get hung tasks. Lowering the limit is not reasonable, so the
approach in this patch is as follows: rely on the method used at resizing
sets and save the state when we reach a smaller internal batch limit,
unlock/lock and proceed from the saved state. Thus we can avoid long
continuous tasks and at the same time removed the limit to add/delete lar=
ge
number of elements in one step.

The nfnl mutex is held during the whole operation which prevents one to
issue other ipset commands in parallel.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Reported-by: syzbot+9204e7399656300bf271@syzkaller.appspotmail.com
Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consec=
utive elements to add/delete")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h      |  2 +-
 net/netfilter/ipset/ip_set_core.c           |  7 ++++---
 net/netfilter/ipset/ip_set_hash_ip.c        | 14 ++++++-------
 net/netfilter/ipset/ip_set_hash_ipmark.c    | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipport.c    | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportip.c  | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 13 +++++++-----
 net/netfilter/ipset/ip_set_hash_net.c       | 17 +++++++--------
 net/netfilter/ipset/ip_set_hash_netiface.c  | 15 ++++++--------
 net/netfilter/ipset/ip_set_hash_netnet.c    | 23 +++++++--------------
 net/netfilter/ipset/ip_set_hash_netport.c   | 19 +++++++----------
 11 files changed, 68 insertions(+), 81 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index ab934ad951a8..e8c350a3ade1 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -197,7 +197,7 @@ struct ip_set_region {
 };
=20
 /* Max range where every element is added/deleted in one step */
-#define IPSET_MAX_RANGE		(1<<20)
+#define IPSET_MAX_RANGE		(1<<14)
=20
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index e7ba5b6dd2b7..46ebee9400da 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1698,9 +1698,10 @@ call_ad(struct net *net, struct sock *ctnl, struct=
 sk_buff *skb,
 		ret =3D set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		ip_set_unlock(set);
 		retried =3D true;
-	} while (ret =3D=3D -EAGAIN &&
-		 set->variant->resize &&
-		 (ret =3D set->variant->resize(set, retried)) =3D=3D 0);
+	} while (ret =3D=3D -ERANGE ||
+		 (ret =3D=3D -EAGAIN &&
+		  set->variant->resize &&
+		  (ret =3D set->variant->resize(set, retried)) =3D=3D 0));
=20
 	if (!ret || (ret =3D=3D -IPSET_ERR_EXIST && eexist))
 		return 0;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/i=
p_set_hash_ip.c
index e30513cefd90..c9f4e3859663 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -100,11 +100,11 @@ static int
 hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ip4 *h =3D set->data;
+	struct hash_ip4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ip4_elem e =3D { 0 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip =3D 0, ip_to =3D 0, hosts;
+	u32 ip =3D 0, ip_to =3D 0, hosts, i =3D 0;
 	int ret =3D 0;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -149,14 +149,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb=
[],
=20
 	hosts =3D h->netmask =3D=3D 32 ? 1 : 2 << (32 - h->netmask - 1);
=20
-	/* 64bit division is not allowed on 32bit */
-	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip =3D ntohl(h->next.ip);
-	for (; ip <=3D ip_to;) {
+	for (; ip <=3D ip_to; i++) {
 		e.ip =3D htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ip4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret =3D adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ips=
et/ip_set_hash_ipmark.c
index 153de3457423..a22ec1a6f6ec 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -97,11 +97,11 @@ static int
 hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipmark4 *h =3D set->data;
+	struct hash_ipmark4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipmark4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to =3D 0;
+	u32 ip, ip_to =3D 0, i =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -148,13 +148,14 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
=20
-	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip =3D ntohl(h->next.ip);
-	for (; ip <=3D ip_to; ip++) {
+	for (; ip <=3D ip_to; ip++, i++) {
 		e.ip =3D htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ipmark4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret =3D adtfn(set, &e, &ext, &ext, flags);
=20
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ips=
et/ip_set_hash_ipport.c
index 2ffbd0b78a8c..e977b5a9c48d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -112,11 +112,11 @@ static int
 hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipport4 *h =3D set->data;
+	struct hash_ipport4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipport4_elem e =3D { .ip =3D 0 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to =3D 0, p =3D 0, port, port_to;
+	u32 ip, ip_to =3D 0, p =3D 0, port, port_to, i =3D 0;
 	bool with_ports =3D false;
 	int ret;
=20
@@ -184,17 +184,18 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 			swap(port, port_to);
 	}
=20
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	for (; ip <=3D ip_to; ip++) {
 		p =3D retried && ip =3D=3D ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <=3D port_to; p++) {
+		for (; p <=3D port_to; p++, i++) {
 			e.ip =3D htonl(ip);
 			e.port =3D htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret =3D adtfn(set, &e, &ext, &ext, flags);
=20
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/i=
pset/ip_set_hash_ipportip.c
index 334fb1ad0e86..39a01934b153 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -108,11 +108,11 @@ static int
 hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportip4 *h =3D set->data;
+	struct hash_ipportip4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipportip4_elem e =3D { .ip =3D 0 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to =3D 0, p =3D 0, port, port_to;
+	u32 ip, ip_to =3D 0, p =3D 0, port, port_to, i =3D 0;
 	bool with_ports =3D false;
 	int ret;
=20
@@ -180,17 +180,18 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlat=
tr *tb[],
 			swap(port, port_to);
 	}
=20
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	for (; ip <=3D ip_to; ip++) {
 		p =3D retried && ip =3D=3D ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <=3D port_to; p++) {
+		for (; p <=3D port_to; p++, i++) {
 			e.ip =3D htonl(ip);
 			e.port =3D htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipportip4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret =3D adtfn(set, &e, &ext, &ext, flags);
=20
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index 7df94f437f60..5c6de605a9fb 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -160,12 +160,12 @@ static int
 hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportnet4 *h =3D set->data;
+	struct hash_ipportnet4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipportnet4_elem e =3D { .cidr =3D HOST_MASK - 1 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
 	u32 ip =3D 0, ip_to =3D 0, p =3D 0, port, port_to;
-	u32 ip2_from =3D 0, ip2_to =3D 0, ip2;
+	u32 ip2_from =3D 0, ip2_to =3D 0, ip2, i =3D 0;
 	bool with_ports =3D false;
 	u8 cidr;
 	int ret;
@@ -253,9 +253,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlatt=
r *tb[],
 			swap(port, port_to);
 	}
=20
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	ip2_to =3D ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret =3D ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
@@ -282,9 +279,15 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlat=
tr *tb[],
 		for (; p <=3D port_to; p++) {
 			e.port =3D htons(p);
 			do {
+				i++;
 				e.ip2 =3D htonl(ip2);
 				ip2 =3D ip_set_range_to_cidr(ip2, ip2_to, &cidr);
 				e.cidr =3D cidr - 1;
+				if (i > IPSET_MAX_RANGE) {
+					hash_ipportnet4_data_next(&h->next,
+								  &e);
+					return -ERANGE;
+				}
 				ret =3D adtfn(set, &e, &ext, &ext, flags);
=20
 				if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index 1422739d9aa2..ce0a9ce5a91f 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -136,11 +136,11 @@ static int
 hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_net4 *h =3D set->data;
+	struct hash_net4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_net4_elem e =3D { .cidr =3D HOST_MASK };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip =3D 0, ip_to =3D 0, ipn, n =3D 0;
+	u32 ip =3D 0, ip_to =3D 0, i =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,19 +188,16 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *t=
b[],
 		if (ip + UINT_MAX =3D=3D ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
-	ipn =3D ip;
-	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
=20
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip =3D htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_net4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip =3D ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret =3D adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index 9810f5bf63f5..031073286236 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netiface4_elem e =3D { .cidr =3D HOST_MASK, .elem =3D 1 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip =3D 0, ip_to =3D 0, ipn, n =3D 0;
+	u32 ip =3D 0, ip_to =3D 0, i =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,19 +256,16 @@ hash_netiface4_uadt(struct ip_set *set, struct nlat=
tr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
-	ipn =3D ip;
-	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
=20
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip =3D htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_netiface4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip =3D ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret =3D adtfn(set, &e, &ext, &ext, flags);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index cdfb78c6e0d3..8fbe649c9dd3 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -166,13 +166,12 @@ static int
 hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netnet4 *h =3D set->data;
+	struct hash_netnet4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
 	u32 ip =3D 0, ip_to =3D 0;
-	u32 ip2 =3D 0, ip2_from =3D 0, ip2_to =3D 0, ipn;
-	u64 n =3D 0, m =3D 0;
+	u32 ip2 =3D 0, ip2_from =3D 0, ip2_to =3D 0, i =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -248,19 +247,6 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr =
*tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn =3D ip;
-	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn =3D ip2_from;
-	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m > IPSET_MAX_RANGE)
-		return -ERANGE;
=20
 	if (retried) {
 		ip =3D ntohl(h->next.ip[0]);
@@ -273,7 +259,12 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr =
*tb[],
 		e.ip[0] =3D htonl(ip);
 		ip =3D ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		do {
+			i++;
 			e.ip[1] =3D htonl(ip2);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netnet4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ip2 =3D ip_set_range_to_cidr(ip2, ip2_to, &e.cidr[1]);
 			ret =3D adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index 09cf72eb37f8..d1a0628df4ef 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -154,12 +154,11 @@ static int
 hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netport4 *h =3D set->data;
+	struct hash_netport4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netport4_elem e =3D { .cidr =3D HOST_MASK - 1 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p =3D 0, ip =3D 0, ip_to =3D 0, ipn;
-	u64 n =3D 0;
+	u32 port, port_to, p =3D 0, ip =3D 0, ip_to =3D 0, i =3D 0;
 	bool with_ports =3D false;
 	u8 cidr;
 	int ret;
@@ -236,14 +235,6 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
-	ipn =3D ip;
-	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
=20
 	if (retried) {
 		ip =3D ntohl(h->next.ip);
@@ -255,8 +246,12 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 		e.ip =3D htonl(ip);
 		ip =3D ip_set_range_to_cidr(ip, ip_to, &cidr);
 		e.cidr =3D cidr - 1;
-		for (; p <=3D port_to; p++) {
+		for (; p <=3D port_to; p++, i++) {
 			e.port =3D htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret =3D adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
--=20
2.30.2

