From: ratheesh kannoth <ratheesh.ksz@gmail.com>
Subject: Re: track dns udp packet
Date: Thu, 27 Oct 2011 21:51:09 +0530
Message-ID: <CAGZFCEHb9o1kFozHuEz6aJftcBtfzpOpdZ5CNec5R8-7ysxNVQ@mail.gmail.com>
References: <CAGZFCEH4eexuN36PDaacGPkAxZ2KW90g86Jh1dvmMubes-ntFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36468 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1J0QVL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:21:11 -0400
Received: by faan17 with SMTP id n17so2801430faa.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2011 09:21:09 -0700 (PDT)
In-Reply-To: <CAGZFCEH4eexuN36PDaacGPkAxZ2KW90g86Jh1dvmMubes-ntFA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 25, 2011 at 10:57 PM, ratheesh kannoth
<ratheesh.ksz@gmail.com> wrote:
> I wrote a =A0module to track the udp dns query. It is not working, wh=
at
> could be the problem ?
>
> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <net/netfilter/nf_conntrack.h>
> #include <net/netfilter/nf_conntrack_helper.h>
> #include <linux/ip.h>
> #include <net/netfilter/nf_conntrack_expect.h>
>
> MODULE_LICENSE("GPL");
>
>
> static const struct nf_conntrack_expect_policy my_expect_policy =3D {
> =A0 =A0 =A0 =A0.max_expected =A0 =A0 =A0 =A0 =A0 =3D 1,
> };
>
> static int foo_help(struct sk_buff *skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int protoff,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nf_conn *ct,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum ip_conntrack_info conntra=
ckinfo)
> {
>
> =A0 =A0 =A0 =A0printk (KERN_ALERT "A dns query is sent out \n");
> =A0 =A0 =A0 =A0return NF_ACCEPT;
> }
>
> static struct nf_conntrack_helper foo;
>
>
>
> int init_conntrack_module(void)
> {
> =A0 =A0 =A0 =A0int ret =3D -1;
> =A0 =A0 =A0 =A0memset(&foo, 0, sizeof(struct nf_conntrack_helper));
> =A0 =A0 =A0 =A0foo.name =3D "foo";
> =A0 =A0 =A0 =A0foo.me =3D THIS_MODULE;
> =A0 =A0 =A0 =A0foo.tuple.dst.protonum =3D IPPROTO_UDP;
> =A0 =A0 =A0 =A0foo.tuple.dst.u.udp.port =3D htons(53);
> =A0 =A0 =A0 =A0foo.help =3D foo_help;
> =A0 =A0 =A0 =A0foo.expect_policy =3D &my_expect_policy;
> =A0 =A0 =A0 =A0ret =3D nf_conntrack_helper_register(&foo);
> =A0 =A0 =A0 =A0printk ("Registration ret =3D %d\n", ret);
> =A0 =A0 =A0 =A0return ret;
> }
>
> void =A0fini_conntrack_module(void)
> {
> =A0 =A0 =A0 =A0nf_conntrack_helper_unregister(&foo);
> }
>
> module_init(init_conntrack_module);
> module_exit(fini_conntrack_module);
>

I looked into ftp connection tracking and made similar changes.
removed  below line
       foo.tuple.dst.u.udp.port =3D htons(53);
 added below lines
      foo.tuple.src.l3num =3D PF_INET;
      foo.tuple.src.u.udp.port =3D htons(53);

I could see  printks whenever  dns udp packets gets forwarded through
the machine.

1. I copied it blindly. I dont know why it works. Could anybody
explain why it started working please ?
2. This works only for packets gets forwarded through the linux
machine (where module is loaded ) ;
      it doesn't work for packets originating from the linux   machine =
=2E Why?

-Ratheesh
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
