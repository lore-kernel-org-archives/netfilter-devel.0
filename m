From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Fri, 1 Jul 2016 21:19:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1607012119110.6106@blackhole.kfki.hu>
References: <20160623102211.GA31272@hydrogen> <20160623103744.GA10764@salvia> <CAMQP0smTrOCvq6nXH3u5VLfLdj1nf7_D6760RCmCUx6DfrynNA@mail.gmail.com> <20160623180454.GA15678@salvia> <CAMQP0skT_L_pKrjYA+FfEj0Etz_DfY0wEPxv=Qsq+PyHOg1kyA@mail.gmail.com>
 <20160701143444.GA20402@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Neutron Soutmun <neo.neutron@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54330 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcGATSJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 15:18:09 -0400
In-Reply-To: <20160701143444.GA20402@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 1 Jul 2016, Pablo Neira Ayuso wrote:

> On Fri, Jun 24, 2016 at 05:55:09AM +0700, Neutron Soutmun wrote:
> > On Fri, Jun 24, 2016 at 1:04 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > What is exactly the compilation error you get?
> > 
> > === 8< ===
> > /usr/src/linux-headers-4.7.0-rc4-common/include/net/netlink.h:883:59:
> > note: declared here
> >  static inline int nla_put_net64(struct sk_buff *skb, int attrtype,
> > __be64 value,
> >                                                            ^
> > In file included from
> > /home/neutron/works/debian/mypkg/ipset/git/ipset/kernel/include/linux/netfilter/ipset/ip_set.h:458:0,
> >                  from
> > /home/neutron/works/debian/mypkg/ipset/git/ipset/kernel/net/netfilter/xt_set.c:19:
> > /home/neutron/works/debian/mypkg/ipset/git/ipset/kernel/include/linux/netfilter/ipset/ip_set_counter.h:58:9:
> > error: too few arguments to function ?nla_put_net64?
> >          nla_put_net64(skb, IPSET_ATTR_PACKETS,
> >          ^
> > === 8< ===
> 
> Thanks for explaining, I let Jozsef handle this.

I have already applied the patch in the ipset git tree where it belongs 
to.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
