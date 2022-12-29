Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5868DC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Dec 2022 13:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiL2NOU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Dec 2022 08:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiL2NOT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Dec 2022 08:14:19 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1585CBE27
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2022 05:14:15 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id E3F8C67400F8;
        Thu, 29 Dec 2022 14:14:09 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 29 Dec 2022 14:14:07 +0100 (CET)
Received: from mentat.rmki.kfki.hu (host-94-248-211-167.kabelnet.hu [94.248.211.167])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 8C78067400F4;
        Thu, 29 Dec 2022 14:14:07 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id 1F02769E; Thu, 29 Dec 2022 14:14:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mentat.rmki.kfki.hu (Postfix) with ESMTP id 1571C45A;
        Thu, 29 Dec 2022 14:14:07 +0100 (CET)
Date:   Thu, 29 Dec 2022 14:14:07 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: ipset bug (kernel hang)
In-Reply-To: <CAEmTpZFTQVDYw4w2LgTmABZ8ygJtwtLj+Kj9CsZmNARpuB2oHQ@mail.gmail.com>
Message-ID: <ce3bf2f0-526f-b2c7-77c2-24ed28cede8e@netfilter.org>
References: <CAEmTpZFTQVDYw4w2LgTmABZ8ygJtwtLj+Kj9CsZmNARpuB2oHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1393428146-1304804731-1672319647=:1214071"
X-deepspam: maybeham 8%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1393428146-1304804731-1672319647=:1214071
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, 23 Dec 2022, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=
=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:

> ipset create acl_cdc_cert hash:net,port,net
> ipset add acl_cdc_cert 0.0.0.0/0,tcp:1-2,192.168.230.128/25
>=20
> and kernel 6.0.12 hangs (!)
>=20
> Seems the problem happens only if both 0.0.0.0/0 and port range
> specified at the same time.

Thanks for the bugreport, I'm going to submit then next patch to fix it:

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index 19bcdb3141f6..b3616f5e1f6a 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -173,6 +173,16 @@ hash_netportnet4_kadt(struct ip_set *set, const stru=
ct sk_buff *skb,
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
@@ -287,12 +297,12 @@ hash_netportnet4_uadt(struct ip_set *set, struct nl=
attr *tb[],
 	}
 	ipn =3D ip;
 	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		ipn =3D hash_netportnet4_range_to_cidr(ipn, ip_to, &e.cidr[0]);
 		n++;
 	} while (ipn++ < ip_to);
 	ipn =3D ip2_from;
 	do {
-		ipn =3D ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		ipn =3D hash_netportnet4_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
 		m++;
 	} while (ipn++ < ip2_to);
=20
@@ -310,13 +320,13 @@ hash_netportnet4_uadt(struct ip_set *set, struct nl=
attr *tb[],
=20
 	do {
 		e.ip[0] =3D htonl(ip);
-		ip =3D ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
+		ip =3D hash_netportnet4_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		for (; p <=3D port_to; p++) {
 			e.port =3D htons(p);
 			do {
 				e.ip[1] =3D htonl(ip2);
-				ip2 =3D ip_set_range_to_cidr(ip2, ip2_to,
-							   &e.cidr[1]);
+				ip2 =3D hash_netportnet4_range_to_cidr(ip2,
+							ip2_to, &e.cidr[1]);
 				ret =3D adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--1393428146-1304804731-1672319647=:1214071--
