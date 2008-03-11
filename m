From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: nf_nat_core just using l3proto_find_get
Date: Tue, 11 Mar 2008 20:42:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803112041330.18745@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr>
 <47BACA14.8000006@trash.net> <Pine.LNX.4.64.0803102259100.21961@fbirervta.pbzchgretzou.qr>
 <47D691C5.7010907@trash.net> <Pine.LNX.4.64.0803111507320.19018@fbirervta.pbzchgretzou.qr>
 <47D69519.9070404@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37623 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYCKTmp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:42:45 -0400
In-Reply-To: <47D69519.9070404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 11 2008 15:20, Patrick McHardy wrote:
>
>> So what happens when nf_nat is loaded before nf_conntrack_ipv4?
>> (Even if there are dependencies, this question is valid)
>>=20
>> l3proto will be NULL, and is this ok?
[well, not NULL, but it will point to the l3Proto_generic]
>
> No, it will break when translating ICMP errors.
>
I see=C2=A0=E2=80=94 so this patch is needed, seems like it?

=3D=3D=3D
commit 0d3f177a94aadedf9fd26f230d473e636eb0553c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Mar 11 20:40:05 2008 +0100

    [NETFILTER]: nf_nat: autoload IPv4 connection tracking
   =20
    Without this patch, the generic L3 tracker would kick in
    if nf_conntrack_ipv4 was not loaded before nf_nat, which
    would lead to translation problems with ICMP errors.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_n=
at_core.c
index 9c8aa8d..a9de065 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -657,7 +657,12 @@ static int __init nf_nat_init(void)
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_conntrack_untracked.status |=3D IPS_NAT_DONE_MASK;
=20
-	l3proto =3D nf_ct_l3proto_find_get((u_int16_t)AF_INET);
+	if (nf_ct_l3proto_try_module_get(AF_INET) < 0)
+		printk(KERN_INFO KBUILD_MODNAME ": Could not load connection "
+		       "tracking for l3proto %u, using generic L3 tracking "
+		       "only.\n", AF_INET);
+
+	l3proto =3D __nf_ct_l3proto_find(AF_INET);
 	return 0;
=20
  cleanup_extend:
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
