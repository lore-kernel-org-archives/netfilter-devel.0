From: "Toshihiro Sonoda" <toshihiro@jp.fujitsu.com>
Subject: Re: about ROUTE target
Date: Thu, 19 Sep 2002 23:35:09 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <05f001c25fe9$c1939ad0$fb01a8c0@monday>
References: <002f01c25e5e$46745100$ecf8a8c0@monday> <1032346636.2377.4.camel@descartes> <031b01c25f2e$35ddd520$fb01a8c0@monday> <1032439408.2314.18.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-15?Q?C=E9dric_de_Launois?= <delaunoi@info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Hi, Launois. Thanks for your comments and trial.
but, I feel sad, because I can not use ROUTE . (T_T;

I tried linux 2.4.19, too, but the result was same.
I cannot trace in kernel, because linux is freezed.

If you can, let me know how to config your environment on
linux 2.4.18 or 19. I want to try ROUTE on the just your
same environmet.

And, at one more time, I explain my detail environment.

[local pc] <-LAN-> [ router ] <-WAN->[ target pc]

LAN: 192.168.7.0/24
WAN: 192.168.1.0/24
[local-pc]
  eth0: 192.168.7.2
[router]
  eth1: 192.168.7.1(LAN interface)
  eth0: 192.168.1.2(WAN interface)
[target pc]
 eth0: 192.168.1.3

on the router, I did following command.

# modprobe ip_gre
# iptunnel add tundev mode gre remote 192.168.1.3
# ifconfig tundev 192.168.1.2
# iptables -t nat -A POSTROUTING -o eth0 \
                   -s 192.168.7.0/24 -j MASQUERADE
# iptables -t nat -A PREROUTING -p icmp -j ROUTE --iface tundev

and I executed the "ping " command from the [local pc] to another pc

# ping 192.168.1.10

mmm.. I don't know why you can, but i cannot.



> > In the following case, while ipt_ROUTE action, which is
> > the ipt_route_target(), is processing, another netfiter action is called.
> > Is it able to call one netfiter action during processing another one?
> >
> > ROUTE action is called when PRE_ROUTING rule is matched, after
> > that, in the PRE_ROUTING action, OUTPUT and POST_ROUTING
> > is called. so, nf_hook_slow() is nested.
> >
> > Is that ok??
>
> I could not reproduce the bug. I'm using here a kernel 2.4.19.
> I also tested your configuration in a User-Mode Linux, running
> a kernel 2.4.18, but I didn't get any problem.
>
> However, I traced the journey of a packet matching the ROUTE
> target. Function nf_hook_slow() is effectively nested as you
> said (see the backtrace below). But this behaviour is the same as the
> one of the ipt_MIRROR target (ROUTE target was based on its code),
> which works well.
> I don't know if this behaviour is desirable. Anyway, I don't know
> about a method to avoid it.
>
> Maybe someone on the mailing list can help us ?
>
> Here is the backtrace of the packet :
>
> #0  dev_queue_xmit (skb=0xa1050980) at dev.c:1011
> #1  0xa00bdd6d in ip_finish_output2 (skb=0xa1050980) at ip_output.c:173
> #2  0xa00b2a66 in nf_hook_slow (pf=2, hook=4, skb=0xa1050980, indev=0x0,
> outdev=0xa08be000,
>     okfn=0xa00bdcf0 <ip_finish_output2>) at netfilter.c:493
> #3  0xa00bdcc4 in ip_finish_output (skb=0x0) at
> /usr/src/uml/linux/include/linux/list.h:112
> #4  0xa00e8680 in do_ip_send (skb=0x0) at ip_gre.c:672
> #5  0xa00b2a66 in nf_hook_slow (pf=2, hook=3, skb=0xa1050980, indev=0x0,
> outdev=0xa08be000,
>     okfn=0xa00e8650 <do_ip_send>) at netfilter.c:493
> #6  0xa00e7ac4 in ipgre_tunnel_xmit (skb=0xa1050980, dev=0xa08e8800) at
> ip_gre.c:886
> #7  0xa00abf96 in dev_queue_xmit (skb=0xa104d5e0) at dev.c:1044
> #8  0xa28cf494 in ip_direct_send (skb=0xa104d5e0) at ipt_ROUTE.c:99
> #9  0xa28cf26e in ipt_route_target (pskb=0xa1050980, hooknum=0,
> in=0xa08be000, out=0x0, targinfo=0xa28d10d0,
>     userinfo=0x0) at ipt_ROUTE.c:193
> #10 0xa28b62dd in ipt_do_table (pskb=0xa018baf4, hook=0, in=0xa08be000,
> out=0x0, table=0xa1050980, userdata=0x0)
>     at ip_tables.c:363
> #11 0xa28c67cd in ip_nat_rule_find (pskb=0xa018baf4, hooknum=0,
> in=0xa08be000, out=0x0, ct=0xa074e1c0,
>     info=0xa074e290) at ip_nat_rule.c:279
> #12 0xa28c615b in ip_nat_fn (hooknum=0, pskb=0xa018baf4, in=0xa08be000,
> out=0x0, okfn=0xa00ba280 <ip_rcv_finish>)
>     at ip_nat_standalone.c:106
> #13 0xa00b2769 in nf_iterate (head=0xa01d22e0, skb=0xa018baf4, hook=0,
> indev=0xa08be000, outdev=0x0,
>     i=0xa018bad4, okfn=0xa00ba280 <ip_rcv_finish>) at netfilter.c:350
> #14 0xa00b2a22 in nf_hook_slow (pf=2, hook=0, skb=0xa104d5e0,
> indev=0xa08be000, outdev=0x0,
>     okfn=0xa00ba280 <ip_rcv_finish>) at netfilter.c:484
> #15 0xa00ba024 in ip_rcv (skb=0xa104d5e0, dev=0xa08be000, pt=0xa0193398)
>     at /usr/src/uml/linux/include/linux/list.h:112
> #16 0xa00ac66f in net_rx_action (h=0xa01ab610) at dev.c:1509
>
> Cédric
>
>
>
>
