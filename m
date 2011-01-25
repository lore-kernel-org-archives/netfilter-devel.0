From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 13/13] "set" match and "SET" target support
Date: Tue, 25 Jan 2011 22:40:16 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252234440.19648@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1295618527-9583-5-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-6-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-7-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1295618527-9583-9-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-10-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-11-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-12-git-send-email-kadlec@blackhole.kfki.hu>
 <1295618527-9583-13-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-14-git-send-email-kadlec@blackhole.kfki.hu> <4D3EE9C4.3020804@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47430 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab1AYVkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:40:17 -0500
In-Reply-To: <4D3EE9C4.3020804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Jan 2011, Patrick McHardy wrote:

> > +/* Backward compatibility constrains (incomplete):
> > + *  2.6.24: [NETLINK]: Introduce nested and byteorder flag to netlink attribute
> > + *  2.6.25: is_vmalloc_addr(): Check if an address is within the vmalloc
> > + *	    boundaries
> > + *  2.6.27: rcu: split list.h and move rcu-protected lists into rculist.h
> > + *  2.6.28: netfilter: ctnetlink: remove bogus module dependency between
> > + *	    ctnetlink and nf_nat (nfnl_lock/nfnl_unlock)
> > + *  2.6.29: generic swap(): introduce global macro swap(a, b)
> > + *  2.6.31: netfilter: passive OS fingerprint xtables match
> > + *  2.6.34: rcu: Add lockdep-enabled variants of rcu_dereference()
> 
> These are just implementation details about what changed in previous
> versions and don't really matter for the current kernel version.
> I think this comment can be removed.

Yes.
 
> > + */
> > +
> > +#define	CHECK_OK	0
> > +#define CHECK_FAIL	(-EINVAL)
> 
> This is not making the code easier to read, its a common convention
> to return 0 for no error and errno codes otherwise.

It's there because actually, in the git tree that's a full macro 
condition:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 35)
#define CHECK_OK        1
#define CHECK_FAIL      0
#else /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35) */
#define CHECK_OK        0
#define CHECK_FAIL      (-EINVAL)
#endif

I can search/replace it, of course.
 
> > +	if (info->add_set.u.flags[IPSET_DIM_MAX-1] != 0 ||
> > +	    info->del_set.u.flags[IPSET_DIM_MAX-1] != 0) {
> > +		pr_warning("That's nasty!\n");
> 
> This message doesn't seem very helpful. Assuming a structure
> mismatch and no mischief, it would be better to print something
> the user can understand.

Cryptic messages from the old age, inherited through many version, 
survived many changes. I'll mourn it :-)).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
