From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] netfilter: ipset: refactor hash types to use address/cidr
 arrays.
Date: Tue, 10 Sep 2013 10:01:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309100852510.24076@blackhole.kfki.hu>
References: <1378232143-27406-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1894701.xWd9IXYenT@gentoovm> <alpine.DEB.2.00.1309061950350.14814@blackhole.kfki.hu> <2217859.YSQ2Hmiv8L@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:48710 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3IJIB1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:01:27 -0400
In-Reply-To: <2217859.YSQ2Hmiv8L@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 6 Sep 2013, Oliver wrote:

> On Friday 06 September 2013 20:00:19 Jozsef Kadlecsik wrote:
> > Hi Oliver,
> > 
> > On Fri, 6 Sep 2013, Oliver wrote:
> > > Alright, I took a look at the changes - I'll wait for the extension
> > > cleanup then send out a rebased version of hash:net,net since that's
> > > presumably going to be the difference between having to declare struct
> > > combinations for the various extensions versus not having to do it. I'm
> > > very intrigued to see what you can come up with that's shorter than my
> > > rework :P
> > 
> > There's a technical problem with your refactoring patchset (it doesn't
> > prevent unaligned access to extension members), and a design issue: the
> > data about the extensions (offsets) should belong to the core. There's
> > still code duplication between the bitmap and hash types in it when even
> > the list type is missing. The solution means an overall rearrangig and
> > that's what I'm working on.
> 
> Sounds good. I was working under the expectation that explicitly setting the 
> alignment of extension structs wasn't that big of a deal, but I agree that 
> it's better if it doesn't need to be manually taken care of and moving more 
> stuff into the core would definitely improve things.

I pushed out the patches to the ipset git tree: the support of extensions 
which need per-data cleanup is there.

I think first you should adapt and submit the comment extension (at the 
places where you check the comment length and reject oversized ones, 
indicate the allowed length in the error message). Add tests at least for 
one of bitmap, hash and list types: add/delete/test elements with 
comments, list and verify the list output, flush, destroy, save and 
restore. Then the hash:net,net type may follow.
 
> > > On a related note - I was thinking about the impact of recursively
> > > walking the CIDRs and it did occur to me that this operation is very
> > > parallelisable - however, I found that when I ran ipset -T on the set,
> > > the in-kernel code is running in an interrupt context (somehow, I
> > > couldn't see what made it like that), which means it's not possible to
> > > spin up kthreads (unless there's something that I don't know about) -
> > > when testing of an ipset is called via xt_set, is that also running in
> > > an interrupt context? if not, it could be parallelised quite nicely,
> > > which I anticipate would give some gains on multicore systems, and
> > > especially for IPv6, one would think.
> > 
> > How could the walking of the CIDRs be parallellized, when the lookup must
> > follow the priority of the networks? (With the exception of checking
> > multiple same sized networks.)
> 
> Well, pretty easily... as the most basic (albeit not necessarily most 
> resource efficient) example: you spin up a kthread for every CIDR size 
> and then check the return value of each kthread you spun up in order 
> that you started them - the first result you get to that has a non-zero 
> return value is obviously the one you require and you're done. Naturally 
> the time saving here is coming from the hash table searches for every 
> given CIDR size being done in parallel; the thread controller code is 
> still going to iterate, but it's just checking a return code.

It might be a good idea or a bad one: the management of the kthreads may 
cost more in performance than iterating through the CIDR sizes. A thorough 
testing could tell the difference.
 
> I already took a stab at this, but it's currently impossible because the 
> moment kthread_create_on_node() is called and goes into 
> sched_setscheduler_nocheck(), it triggers BUG_ON(in_interrupt()) - I poked 
> through all the base code but I don't see exactly how or why we're inside an 
> interrupt context when responding to ipset userspace commands.

It's a socket-based communication, I believe that's the reason.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
