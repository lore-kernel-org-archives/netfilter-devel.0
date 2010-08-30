From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 15:25:06 +0200
Message-ID: <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51047 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0H3NZI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:25:08 -0400
Received: by wyb35 with SMTP id 35so6597580wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 06:25:07 -0700 (PDT)
In-Reply-To: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

i make an error the iptables line is:
 iptables -A INPUT -s 127.0.0.1 -p icmp -j TAR

On Mon, Aug 30, 2010 at 3:22 PM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
> Hi all!
> I've write the following =A0(and dummy) module that drops all packet.=
=2E.
> but...now? after i write the module i can use it?
> for example: i want digit:
> iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP
> but i don't know how create this new target...
> I've modified the netfilter makefile e Kbuild file (in net/netfilter)=
,
> and then i've do 'make' 'make modules' 'make modules_install' but
> after i digit iptables i have this message
>
> "iptables v1.4.2: Couldn't load target `TAR':/lib/xtables/libipt_TAR.
> so: cannot open shared object file: No such file or directory"
>
> what's my problem?
>
>
> code:
> #include <linux/module.h>
> #include <linux/skbuff.h>
> #include <linux/netfilter_ipv4/ip_tables.h>
> #include <linux/kernel.h>
> #include <linux/netfilter.h>
> #include <linux/netfilter_ipv4.h>
> #include <linux/netfilter/x_tables.h>
>
> static unsigned int xt_tar_target(unsigned int hook,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct sk_buff **skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 const struct net_device *in,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 const struct net_device *out,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 int (*okfn)(struct sk_buff*))
> {
> =A0 =A0printk(KERN_INFO "ciaociao");
> =A0 =A0return NF_DROP;
> }
>
> static struct xt_target xt_tar_reg =3D {
> =A0 =A0.name =A0 =A0 =A0 =3D "TAR",
> =A0 =A0.family =A0 =A0 =3D AF_INET,
> =A0 =A0.proto =A0 =A0 =A0=3D IPPROTO_TCP,
> =A0 =A0.target =A0 =A0 =3D xt_tar_target,
> =A0 =A0.me =A0 =A0 =A0 =A0 =3D THIS_MODULE,
> };
>
> static int __init xt_tar_init(void)
> {
> =A0 =A0return xt_register_target(&xt_tar_reg);
> }
>
> static void __exit xt_tar_exit(void)
> {
> =A0 =A0xt_unregister_target(&xt_tar_reg);
> }
>
> module_init(xt_tar_init);
> module_exit(xt_tar_exit);
>
> MODULE_DESCRIPTION("np des");
> MODULE_LICENSE("GPL");
> MODULE_ALIAS("xt_TAR");
>



--=20
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
