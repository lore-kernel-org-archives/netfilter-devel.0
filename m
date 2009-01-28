From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Wed, 28 Jan 2009 17:11:37 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901281707460.20921@fbirervta.pbzchgretzou.qr>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36441 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZA1QLi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:11:38 -0500
In-Reply-To: <20090128145826.7501.34671.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-28 15:58, Pablo Neira Ayuso wrote:

>This patch adds the PKTTYPE target which can be used to mangle the
>skbuff packet type field. This target is useful in conjunction with
>the arptables mcmangle target to TCP working again when a
>multicast hardware address is used. An example of its use:
>
>iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
>	-j PKTTYPE --to-pkt-type unicast

Are not packets not destined for 224/4 - assuming standard route setups=
 -
unicast anyway?

>@@ -489,6 +489,24 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
> 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
> 	  TCP options from TCP packets.
>=20
>+config NETFILTER_XT_TARGET_PKTTYPE

Please adhere to alphabetical ordering. (Andrew Morton mentioned it
time and again that it causes the least merge conflicts where
conflicts would happen if multiple people always add to the last
item.) Also, searching for "PKTTYPE"/("cluster") in `make menuconfig`
in the otherwise-sorted Kconfig/Makefile list could provide confusing
if it was out-of-order.

>+	  If you want to compile it as a module, say M here and read
>+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.

A lovely paragraph, but I think it has lost its purpose given that
NETFILTER_ADVANCED can now be general-tagged "if unsure, pick=C2=A0N" a=
nd
the rest will be automagic.

>+++ b/net/netfilter/Makefile
>@@ -55,6 +55,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) +=3D xt_TPR=
OXY.o
> obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
> obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
> obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
>+obj-$(CONFIG_NETFILTER_XT_TARGET_PKTTYPE) +=3D xt_PKTTYPE.o
>=20
>+static struct xt_target xt_pkttype_target[] __read_mostly =3D {
>+	{
>+		.family		=3D AF_INET,
>+		.name		=3D "PKTTYPE",
>+		.table		=3D "mangle",
>+		.target		=3D xt_pkttype_tg,
>+		.targetsize	=3D sizeof(struct xt_pkttype_target_info),
>+		.me		=3D THIS_MODULE,
>+	},
>+	{
>+		.family		=3D AF_INET6,
>+		.name		=3D "PKTTYPE",
>+		.table		=3D "mangle",
>+		.target		=3D xt_pkttype_tg,
>+		.targetsize	=3D sizeof(struct xt_pkttype_target_info),
>+		.me		=3D THIS_MODULE,
>+	},
>+};

Combine to NFPROTO_UNSPEC.

>+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>+MODULE_LICENSE("GPL");
>+MODULE_DESCRIPTION("Xtables: xt_PKTTYPE target");

I propose
MODULE_DESCRIPTION("Xtables: set skbuff packet type");
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
