From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 04/34] netfilter: ipset: Introduce RCU locking in hash:*
 types
Date: Fri, 8 May 2015 22:13:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1505082201460.16001@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu> <1430587703-3387-5-git-send-email-kadlec@blackhole.kfki.hu> <20150507235202.GB3971@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:43488 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbEHUMw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2015 16:12:52 -0400
In-Reply-To: <20150507235202.GB3971@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 8 May 2015, Pablo Neira Ayuso wrote:

> On Sat, May 02, 2015 at 07:27:53PM +0200, Jozsef Kadlecsik wrote:
> > Three types of data need to be protected in the case of the hash types:
> > 
> > a. The hash buckets: standard rcu pointer operations are used.
> > b. The allocated elements in the hash buckets: a bitmap is used
> >    for book-keeping to tell which elements in the hash bucket are
> >    used or free.
> > c. Networks per cidr values and the cidr values themselves: the fix
> >    sized arrays need no protection. The values are modified in such
> >    an order that in the worst case an element testing is repeated
> >    again with the same cidr value.
> 
> Did you consider using the rhashtable implementation under
> lib/rhashtable.c? Do you think there is any chance to accommodate that
> into ipset? If possible, it would avoid from dealing with this
> complexity.

The cidr book-keeping (c) must be kept in the rhashtable implementation 
too. If the speed optimization (arrays as hash elements) is ported over, 
then (b) must be preserved too. What remains is actually simpler than 
rhashtable itself. I must look into rhashtable deeper in order to check 
other required features like enforced hard limit on the number of 
elements/hash size (instead of memory limit).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
