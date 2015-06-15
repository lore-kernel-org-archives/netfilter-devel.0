From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/15] ipset patches for nf-next
Date: Mon, 15 Jun 2015 20:21:29 +0200
Message-ID: <20150615182129.GA26662@salvia>
References: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37527 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbbFOSQM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 14:16:12 -0400
Content-Disposition: inline
In-Reply-To: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 14, 2015 at 10:56:17AM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to apply the next bunch of patches for ipset. First
> comes the small changes, then the bugfixes and at the end the RCU
> related patches.
> 
> * Use MSEC_PER_SEC consistently instead of the number.
> * Use SET_WITH_*() helpers to test set extensions from Sergey Popovich.
> * Check extensions attributes before getting extensions from Sergey Popovich.
> * Permit CIDR equal to the host address CIDR in IPv6 from Sergey Popovich.
> * Make sure we always return line number on batch in the case of error
>   from Sergey Popovich.
> * Check CIDR value only when attribute is given from Sergey Popovich.
> * Fix cidr handling for hash:*net* types, reported by Jonathan Johnson.
> * Fix parallel resizing and listing of the same set so that the original
>   set is kept for the whole dumping.
> * Make sure listing doesn't grab a set which is just being destroyed.
> * Remove rbtree from ip_set_hash_netiface.c in order to introduce RCU.
> * Replace rwlock_t with spinlock_t in "struct ip_set", change the locking
>   in the core and simplifications in the timeout routines.
> * Introduce RCU locking in bitmap:* types with a slight modification in the
>   logic on how an element is added.
> * Introduce RCU locking in hash:* types. This is the most complex part of
>   the changes.
> * Introduce RCU locking in list type where standard rculist is used.
> * Fix coding styles reported by checkpatch.pl.
> 
> Best regards,
> Jozsef
> 
> The following changes since commit 482cfc318559e2527dfd8513582d2fdb276e47c2:
> 
>   netfilter: xtables: avoid percpu ruleset duplication (2015-06-12 14:27:10 +0200)
> 
> are available in the git repository at:
> 
>   git://blackhole.kfki.hu/nf-next master

Pulled, thanks Jozsef.
