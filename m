From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] netfilter:ipset: References are protected by rwlock
 instead of mutex
Date: Mon, 28 Mar 2011 15:33:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1103281438120.2069@blackhole.kfki.hu>
References: <1301049733-32160-1-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-2-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-3-git-send-email-kadlec@blackhole.kfki.hu> <4D908075.1010008@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:46729 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab1C1NdM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:33:12 -0400
In-Reply-To: <4D908075.1010008@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 28 Mar 2011, Patrick McHardy wrote:

> Am 25.03.2011 11:42, schrieb Jozsef Kadlecsik:
> > The timeout variant of the list:set type must reference the member sets.
> > However, its garbage collector runs at timer interrupt so the mutex protection
> > of the references is a no go. Therefore the reference protection
> > is converted to rwlock.
> > 
> 
> >  __ip_set_get(ip_set_id_t index)
> >  {
> > -	atomic_inc(&ip_set_list[index]->ref);
> > +	write_lock_bh(&ip_set_ref_lock);
> > +	ip_set_list[index]->ref++;
> > +	write_unlock_bh(&ip_set_ref_lock);
> >  }
> >  
> 
> I'm not sure I get this, why aren't regular atomic ops working
> here?

A set can only be destroyed if it's not referenced. The reference counter 
is incremented/decremented by the checkentry/destroy functions of the set 
match and target, and when the set is added/deleted to/from a list:set 
type of set. These operations are serialized by the nfnl mutex.

However sets get deleted from the timeout variant of a list:set types by 
the garbage collector, too, which runs at timer interrupt. The set 
destroying happens by first checking the reference counter, then 
destroying the set without holding any lock. Because the garbage collector 
only decrements the refcount, we could go without using any rwlock and 
having atomic refcounts: if the counter is zero, we are safe and can 
destroy the set.

But when swapping two sets, the operation swaps the names, reference 
counters and the pointers of the sets. The values of two atomic counters 
cannot safely be swapped without holding some kind of lock. So I could not 
avoid introducing a rwlock to protect the refcounts, but then those are
not needed to be atomic.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
