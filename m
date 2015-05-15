From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 10/34] netfilter: ipset: Missing rcu protection in
 mtype_list() fixed
Date: Fri, 15 May 2015 22:04:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1505152202360.29442@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu> <1430587703-3387-11-git-send-email-kadlec@blackhole.kfki.hu> <20150507181918.GA3654@salvia> <20150508000343.GA18705@salvia> <alpine.DEB.2.10.1505082213350.16001@blackhole.kfki.hu>
 <20150513163219.GA27541@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:48666 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934313AbbEOUDp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 16:03:45 -0400
In-Reply-To: <20150513163219.GA27541@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 13 May 2015, Pablo Neira Ayuso wrote:

> On Fri, May 08, 2015 at 10:15:14PM +0200, Jozsef Kadlecsik wrote:
> > On Fri, 8 May 2015, Pablo Neira Ayuso wrote:
> > 
> > > On Thu, May 07, 2015 at 08:19:18PM +0200, Pablo Neira Ayuso wrote:
> > > [...]
> > > > I will come back to review the rcu patches, I still have concerns
> > > > there.
> > > > 
> > > > If you're OK, I'll take as much as I can that is independent your RCU
> > > > changes, so you don't need to resend this large patchset, but you will
> > > > need to rebase though.
> > > 
> > > Unless you have any concern, I'm going to start by applying this batch
> > > of 15 patches:
> > > 
> > > netfilter: ipset: Use better include files in xt_set.c
> > > netfilter: ipset: Improve preprocessor macros checks
> > > netfilter: ipset: Fix hashing for ipv6 sets
> > > netfilter: ipset: Fix ext_*() macros
> > > netfilter: ipset: Check for comment netlink attribute length
> > > netfilter: ipset: Return bool values instead of int
> > > netfilter: ipset: Use HOST_MASK literal to represent host address CIDR len
> > > netfilter: ipset: Check IPSET_ATTR_PORT only once
> > > netfilter: ipset: Return ipset error instead of bool
> > > netfilter: ipset: Preprocessor directices cleanup
> > > netfilter: ipset: No need to make nomatch bitfield
> > > netfilter: ipset: Properly calculate extensions offsets and total length
> > > netfilter: ipset: make ip_set_get_ip*_port to use skb_network_offset
> > > netfilter: ipset: Give a better name to a macro in ip_set_core.c
> > > netfilter: ipset: Fix sparse warning
> > > 
> > > It would be good if other small patches come in first place if
> > > possible. Otherwise, I'd suggest you focus on a next batch with the
> > > rcu conversion, that will be already quite large.
> > 
> > OK. I'll work on the rebasing after the patches above are applied.
> 
> I just pushed out this, you can start preparing a new batch.
> 
> Please, do the following changes in the next batch:
> 
> 1) Collapse the RCU fix to the master patch, where it belongs.
> 2) Add the rcu_barrier() to the patch that starts requiring this.
> 3) Remove the synchronize_rcu() after list_add_rcu() since it's not
>    needed.

I'm going to create the new batch, based on your comments!

> Regarding rhashtable, I understand your implementation is simpler, but
> it would be good if you can give it a further look as you said, I
> guess other fellows will probably ask the same as I did.
>
> Let me know if I can help, thanks for your patience Jozsef!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
