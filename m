From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-nftables nft: Removes if_nametoindex
 ,NFT_META_OIF for outiface
Date: Fri, 11 Oct 2013 13:03:44 +0200
Message-ID: <20131011110344.GB18505@localhost>
References: <CAEyr1FRKpudN76NbA-o0MAsMy8XpPFjBwviSy4xtWB46LcCekw@mail.gmail.com>
 <20131011081525.GA4127@localhost>
 <CAEyr1FSUeGcw_DXBCP7xm0D9D9eFzM98Dv-Mwv0jfyTwaYo--w@mail.gmail.com>
 <20131011095012.GA4787@localhost>
 <CAEyr1FQ51A71gtx6Gb_nf4mLCOftRZCYUoVGtR_ft6cmWzKVRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35360 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab3JKLDt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:03:49 -0400
Content-Disposition: inline
In-Reply-To: <CAEyr1FQ51A71gtx6Gb_nf4mLCOftRZCYUoVGtR_ft6cmWzKVRg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 11, 2013 at 03:37:34PM +0530, Anand Raj Manickam wrote:
> On Fri, Oct 11, 2013 at 3:20 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Oct 11, 2013 at 03:05:05PM +0530, Anand Raj Manickam wrote:
> >> On Fri, Oct 11, 2013 at 1:45 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> > On Fri, Oct 11, 2013 at 11:34:04AM +0530, Anand Raj Manickam wrote:
> >> >> This patch fixes the issue where , the Rules are added for non
> >> >> existent interface and unable to delete.
> >> >> eg xtables -t nat -I POSTROUTING -o eth10.10 -j MASQUERADE , allows
> >> >> you to add the rule , where eth10.10 interface is not created.
> >> >> But will not allow to delete as the label maps to * by  if_nametoindex().
> >> >
> >> > This patch doesn't apply:
> >> >
> >> > patch -p1 < /tmp/anand.patch
> >> > patching file iptables/nft-shared.c
> >> > patch: **** malformed patch at line 6: *iface, int invflags)
> >> >
> >> > Please, no need to split things in that many chunks per file. One
> >> > single patch file to address one thing is just fine, the repository
> >> > has to remain in consistent state between patches.
> >> >
> >> > Thanks.
> >>
> >> Merged all into a single patch.
> >
> > I still think this still breaks -i eth+ matching, as there was special
> > handling for that case.
> 
> Can you share me the exact case ? It does NOT work on rules added before patch.
> 
> The patch looks good on my setup..
> xtables -I INPUT -i eth+ -j ACCEPT
> 
> xtables -L INPUT -nv
> Chain INPUT (policy ACCEPT 142K packets, 19M bytes)
>  pkts bytes target     prot opt in     out     source
> destination
>     0     0 ACCEPT     all  --  eth+   *       0.0.0.0/0
> 0.0.0.0/0
> 
> # xtables -D INPUT -i eth+ -j ACCEPT
> comparing with... -A INPUT -c        0        0 -i eth+ -j ACCEPT
> DEBUG: rule: ip filter INPUT 29 0
>   [ meta load iifname => reg 1 ]
>   [ cmp eq reg 1 0x2b687465 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 1 ]

I guess that seems to work by adding/removing rules, but packet
matching won't work since from the kernel side it will strictly
compare the string, eg. eth0 == eth+.

Note that eth+ means we want to match all interfaces starting by 'eth'
