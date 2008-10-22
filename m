From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: snmp nat leaks memory in case of failure
Date: Wed, 22 Oct 2008 19:41:29 +0200 (MEST)
Message-ID: <20081022174129.21341.93881.sendpatchset@x2.localnet>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58290 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993AbYJVRlb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:41:31 -0400
In-Reply-To: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 6339355779208471ab254e13f31aa0d3217ee6fd
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Oct 22 19:34:40 2008 +0200

    netfilter: snmp nat leaks memory in case of failure
   =20
    Upstream commit 311670f3e:
   =20
    Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilte=
r/nf_nat_snmp_basic.c
index ffeaffc..8303e4b 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -742,6 +742,7 @@ static unsigned char snmp_object_decode(struct asn1=
_ctx *ctx,
 			*obj =3D kmalloc(sizeof(struct snmp_object) + len,
 				       GFP_ATOMIC);
 			if (*obj =3D=3D NULL) {
+				kfree(p);
 				kfree(id);
 				if (net_ratelimit())
 					printk("OOM in bsalg (%d)\n", __LINE__);
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
