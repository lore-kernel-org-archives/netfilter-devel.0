Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7B7C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 15:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C8A60F9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 15:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhG1PCE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 11:02:04 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:52197 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236736AbhG1PBW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 11:01:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id B443DCC00F3;
        Wed, 28 Jul 2021 17:01:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1627484475; x=1629298876; bh=ddYs5i4Y+a
        crYVHm+tFt0yex6KS7wzd32H/qLsPFgGs=; b=CT6hTueDqPn/sa2i600Gyes+LI
        lycjN+pq4GvuU3QWji1FrdMejhPtznQXnvlHAmyR3fusHAtlO8GzxoA2rXR/iA7q
        83sLcdPW3TYGEIVKGV+OuxJXK6k3YNgGhseoM7DHqaGaiUhDymYLSk4oBVzuREp6
        JSgtvxQj4ktlCLQ5U=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 28 Jul 2021 17:01:15 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 23A3ACC00F6;
        Wed, 28 Jul 2021 17:01:15 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 1BB3E3412ED; Wed, 28 Jul 2021 17:01:15 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: Limit the maximal range of consecutive elements to add/delete
Date:   Wed, 28 Jul 2021 17:01:15 +0200
Message-Id: <20210728150115.5107-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210728150115.5107-1-kadlec@netfilter.org>
References: <20210728150115.5107-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The range size of consecutive elements were not limited. Thus one could
define a huge range which may result soft lockup errors due to the long
execution time. Now the range size is limited to 2^20 entries.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h       |  3 +++
 net/netfilter/ipset/ip_set_hash_ip.c         |  9 ++++++++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 +++
 net/netfilter/ipset/ip_set_hash_net.c        | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c     | 16 +++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netport.c    | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 16 +++++++++++++++-
 11 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index 10279c4830ac..ada1296c87d5 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -196,6 +196,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
=20
+/* Max range where every element is added/deleted in one step */
+#define IPSET_MAX_RANGE		(1<<20)
+
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
=20
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/i=
p_set_hash_ip.c
index d1bef23fd4f5..dd30c03d5a23 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -132,8 +132,11 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[=
],
 		ret =3D ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (ip_to =3D=3D 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr =3D nla_get_u8(tb[IPSET_ATTR_CIDR]);
=20
@@ -144,6 +147,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[=
],
=20
 	hosts =3D h->netmask =3D=3D 32 ? 1 : 2 << (32 - h->netmask - 1);
=20
+	/* 64bit division is not allowed on 32bit */
+	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried) {
 		ip =3D ntohl(h->next.ip);
 		e.ip =3D htonl(ip);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ips=
et/ip_set_hash_ipmark.c
index 18346d18aa16..153de3457423 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -121,6 +121,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *=
tb[],
=20
 	e.mark =3D ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &=3D h->markmask;
+	if (e.mark =3D=3D 0 && e.ip =3D=3D 0)
+		return -IPSET_ERR_HASH_ELEM;
=20
 	if (adt =3D=3D IPSET_TEST ||
 	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
@@ -133,8 +135,11 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr =
*tb[],
 		ret =3D ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (e.mark =3D=3D 0 && ip_to =3D=3D 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr =3D nla_get_u8(tb[IPSET_ATTR_CIDR]);
=20
@@ -143,6 +148,9 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *=
tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
=20
+	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	for (; ip <=3D ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ips=
et/ip_set_hash_ipport.c
index e1ca11196515..7303138e46be 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -173,6 +173,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *=
tb[],
 			swap(port, port_to);
 	}
=20
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	for (; ip <=3D ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/i=
pset/ip_set_hash_ipportip.c
index ab179e064597..334fb1ad0e86 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -180,6 +180,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 			swap(port, port_to);
 	}
=20
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	for (; ip <=3D ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index 8f075b44cf64..b293aa1ff258 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -246,6 +246,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlatt=
r *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
=20
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	port_to =3D port =3D ntohs(e.port);
 	if (tb[IPSET_ATTR_PORT_TO]) {
 		port_to =3D ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index c1a11f041ac6..1422739d9aa2 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -140,7 +140,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[=
],
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_net4_elem e =3D { .cidr =3D HOST_MASK };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip =3D 0, ip_to =3D 0;
+	u32 ip =3D 0, ip_to =3D 0, ipn, n =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,6 +188,15 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb=
[],
 		if (ip + UINT_MAX =3D=3D ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
+	ipn =3D ip;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip =3D ntohl(h->next.ip);
 	do {
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index ddd51c2e1cb3..9810f5bf63f5 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netiface4_elem e =3D { .cidr =3D HOST_MASK, .elem =3D 1 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 ip =3D 0, ip_to =3D 0;
+	u32 ip =3D 0, ip_to =3D 0, ipn, n =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,6 +256,14 @@ hash_netiface4_uadt(struct ip_set *set, struct nlatt=
r *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
+	ipn =3D ip;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
=20
 	if (retried)
 		ip =3D ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index 6532f0505e66..3d09eefe998a 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -168,7 +168,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *=
tb[],
 	struct hash_netnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
 	u32 ip =3D 0, ip_to =3D 0;
-	u32 ip2 =3D 0, ip2_from =3D 0, ip2_to =3D 0;
+	u32 ip2 =3D 0, ip2_from =3D 0, ip2_to =3D 0, ipn;
+	u64 n =3D 0, m =3D 0;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -244,6 +245,19 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr =
*tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn =3D ip;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn =3D ip2_from;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m > IPSET_MAX_RANGE)
+		return -ERANGE;
=20
 	if (retried) {
 		ip =3D ntohl(h->next.ip[0]);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index ec1564a1cb5a..09cf72eb37f8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -158,7 +158,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr =
*tb[],
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netport4_elem e =3D { .cidr =3D HOST_MASK - 1 };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p =3D 0, ip =3D 0, ip_to =3D 0;
+	u32 port, port_to, p =3D 0, ip =3D 0, ip_to =3D 0, ipn;
+	u64 n =3D 0;
 	bool with_ports =3D false;
 	u8 cidr;
 	int ret;
@@ -235,6 +236,14 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
+	ipn =3D ip;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
=20
 	if (retried) {
 		ip =3D ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index 0e91d1e82f1c..19bcdb3141f6 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -182,7 +182,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlat=
tr *tb[],
 	struct hash_netportnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
 	u32 ip =3D 0, ip_to =3D 0, p =3D 0, port, port_to;
-	u32 ip2_from =3D 0, ip2_to =3D 0, ip2;
+	u32 ip2_from =3D 0, ip2_to =3D 0, ip2, ipn;
+	u64 n =3D 0, m =3D 0;
 	bool with_ports =3D false;
 	int ret;
=20
@@ -284,6 +285,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nla=
ttr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn =3D ip;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn =3D ip2_from;
+	do {
+		ipn =3D ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
=20
 	if (retried) {
 		ip =3D ntohl(h->next.ip[0]);
--=20
2.20.1

