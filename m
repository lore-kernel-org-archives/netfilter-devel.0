Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AF2C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Dec 2022 12:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiL3Mei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Dec 2022 07:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiL3Meh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2022 07:34:37 -0500
X-Greylist: delayed 593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Dec 2022 04:34:34 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CB23885
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2022 04:34:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 4C8A4CC00FC;
        Fri, 30 Dec 2022 13:24:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1672403078; x=1674217479; bh=xJEA9QLebw
        IwL+Xs0LZoQwZiR+R0SjHQ0oQLGVqStJA=; b=HPtZg8mh7yLnFr1Pd7wnWrkGIK
        i4zP7mI6JxYq8+SItHoBRmT8eAOKCIoCA+pce3MaQX6EtZb4Ja2FIU2vqlT8HBL7
        CmENiIVYdFttKa1T02rRxlBUvqDZlvVXL+il/PPDRrWVteQTTLXTOAxSkgvk3z+h
        9EdPnkM8M9oK1xy4I=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 30 Dec 2022 13:24:38 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 5769ECC00F3;
        Fri, 30 Dec 2022 13:24:38 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 4D38F340D74; Fri, 30 Dec 2022 13:24:38 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: ipset: fix hash:net,port,net hang with /0 subnet
Date:   Fri, 30 Dec 2022 13:24:37 +0100
Message-Id: <20221230122438.1618153-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221230122438.1618153-1-kadlec@netfilter.org>
References: <20221230122438.1618153-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The hash:net,port,net set type supports /0 subnets. However, the patch
commit 5f7b51bf09baca8e titled "netfilter: ipset: Limit the maximal range
of consecutive elements to add/delete" did not take into account it and
resulted in an endless loop. The bug is actually older but the patch
5f7b51bf09baca8e brings it out earlier.

Handle /0 subnets properly in hash:net,port,net set types.

Reported-by: =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=
=D0=B5=D1=80=D0=B3 <socketpair@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 40 ++++++++++----------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index 19bcdb3141f6..005a7ce87217 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -173,17 +173,26 @@ hash_netportnet4_kadt(struct ip_set *set, const str=
uct sk_buff *skb,
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
=20
+static u32
+hash_netportnet4_range_to_cidr(u32 from, u32 to, u8 *cidr)
+{
+	if (from =3D=3D 0 && to =3D=3D UINT_MAX) {
+		*cidr =3D 0;
+		return to;
+	}
+	return ip_set_range_to_cidr(from, to, cidr);
+}
+
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netportnet4 *h =3D set->data;
+	struct hash_netportnet4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netportnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
 	u32 ip =3D 0, ip_to =3D 0, p =3D 0, port, port_to;
-	u32 ip2_from =3D 0, ip2_to =3D 0, ip2, ipn;
-	u64 n =3D 0, m =3D 0;
+	u32 ip2_from =3D 0, ip2_to =3D 0, ip2, i =3D 0;
 	bool with_ports =3D false;
 	int ret;
=20
@@ -285,19 +294,6 @@ hash_netportnet4_uadt(struct ip_set *set, struct nla=
ttr *tb[],
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
-	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
=20
 	if (retried) {
 		ip =3D ntohl(h->next.ip[0]);
@@ -310,13 +306,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nl=
attr *tb[],
=20
 	do {
 		e.ip[0] =3D htonl(ip);
-		ip =3D ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
+		ip =3D hash_netportnet4_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		for (; p <=3D port_to; p++) {
 			e.port =3D htons(p);
 			do {
+				i++;
 				e.ip[1] =3D htonl(ip2);
-				ip2 =3D ip_set_range_to_cidr(ip2, ip2_to,
-							   &e.cidr[1]);
+				if (i > IPSET_MAX_RANGE) {
+					hash_netportnet4_data_next(&h->next,
+								   &e);
+					return -ERANGE;
+				}
+				ip2 =3D hash_netportnet4_range_to_cidr(ip2,
+							ip2_to, &e.cidr[1]);
 				ret =3D adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
--=20
2.30.2

