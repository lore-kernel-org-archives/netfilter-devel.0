From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: Re: about ROUTE target
Date: 19 Sep 2002 14:43:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032439408.2314.18.camel@descartes>
References: <002f01c25e5e$46745100$ecf8a8c0@monday>
	<1032346636.2377.4.camel@descartes>  <031b01c25f2e$35ddd520$fb01a8c0@monday>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Toshihiro Sonoda <toshihiro@jp.fujitsu.com>
In-Reply-To: <031b01c25f2e$35ddd520$fb01a8c0@monday>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> In the following case, while ipt_ROUTE action, which is
> the ipt_route_target(), is processing, another netfiter action is called.
> Is it able to call one netfiter action during processing another one?
>=20
> ROUTE action is called when PRE_ROUTING rule is matched, after
> that, in the PRE_ROUTING action, OUTPUT and POST_ROUTING
> is called. so, nf_hook_slow() is nested.
>=20
> Is that ok??

I could not reproduce the bug. I'm using here a kernel 2.4.19.
I also tested your configuration in a User-Mode Linux, running
a kernel 2.4.18, but I didn't get any problem.

However, I traced the journey of a packet matching the ROUTE
target. Function nf_hook_slow() is effectively nested as you
said (see the backtrace below). But this behaviour is the same as the
one of the ipt_MIRROR target (ROUTE target was based on its code),=20
which works well.
I don't know if this behaviour is desirable. Anyway, I don't know
about a method to avoid it.

Maybe someone on the mailing list can help us ?

Here is the backtrace of the packet :

#0  dev_queue_xmit (skb=3D0xa1050980) at dev.c:1011
#1  0xa00bdd6d in ip_finish_output2 (skb=3D0xa1050980) at ip_output.c:173
#2  0xa00b2a66 in nf_hook_slow (pf=3D2, hook=3D4, skb=3D0xa1050980, indev=
=3D0x0,
outdev=3D0xa08be000,=20
    okfn=3D0xa00bdcf0 <ip_finish_output2>) at netfilter.c:493
#3  0xa00bdcc4 in ip_finish_output (skb=3D0x0) at
/usr/src/uml/linux/include/linux/list.h:112
#4  0xa00e8680 in do_ip_send (skb=3D0x0) at ip_gre.c:672
#5  0xa00b2a66 in nf_hook_slow (pf=3D2, hook=3D3, skb=3D0xa1050980, indev=
=3D0x0,
outdev=3D0xa08be000,=20
    okfn=3D0xa00e8650 <do_ip_send>) at netfilter.c:493
#6  0xa00e7ac4 in ipgre_tunnel_xmit (skb=3D0xa1050980, dev=3D0xa08e8800) at
ip_gre.c:886
#7  0xa00abf96 in dev_queue_xmit (skb=3D0xa104d5e0) at dev.c:1044
#8  0xa28cf494 in ip_direct_send (skb=3D0xa104d5e0) at ipt_ROUTE.c:99
#9  0xa28cf26e in ipt_route_target (pskb=3D0xa1050980, hooknum=3D0,
in=3D0xa08be000, out=3D0x0, targinfo=3D0xa28d10d0,=20
    userinfo=3D0x0) at ipt_ROUTE.c:193
#10 0xa28b62dd in ipt_do_table (pskb=3D0xa018baf4, hook=3D0, in=3D0xa08be00=
0,
out=3D0x0, table=3D0xa1050980, userdata=3D0x0)
    at ip_tables.c:363
#11 0xa28c67cd in ip_nat_rule_find (pskb=3D0xa018baf4, hooknum=3D0,
in=3D0xa08be000, out=3D0x0, ct=3D0xa074e1c0,=20
    info=3D0xa074e290) at ip_nat_rule.c:279
#12 0xa28c615b in ip_nat_fn (hooknum=3D0, pskb=3D0xa018baf4, in=3D0xa08be00=
0,
out=3D0x0, okfn=3D0xa00ba280 <ip_rcv_finish>)
    at ip_nat_standalone.c:106
#13 0xa00b2769 in nf_iterate (head=3D0xa01d22e0, skb=3D0xa018baf4, hook=3D0=
,
indev=3D0xa08be000, outdev=3D0x0,=20
    i=3D0xa018bad4, okfn=3D0xa00ba280 <ip_rcv_finish>) at netfilter.c:350
#14 0xa00b2a22 in nf_hook_slow (pf=3D2, hook=3D0, skb=3D0xa104d5e0,
indev=3D0xa08be000, outdev=3D0x0,=20
    okfn=3D0xa00ba280 <ip_rcv_finish>) at netfilter.c:484
#15 0xa00ba024 in ip_rcv (skb=3D0xa104d5e0, dev=3D0xa08be000, pt=3D0xa01933=
98)
    at /usr/src/uml/linux/include/linux/list.h:112
#16 0xa00ac66f in net_rx_action (h=3D0xa01ab610) at dev.c:1509

C=E9dric
