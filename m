From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 04/34] netfilter: ipset: Introduce RCU locking in hash:*
 types
Date: Fri, 8 May 2015 01:52:02 +0200
Message-ID: <20150507235202.GB3971@salvia>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1430587703-3387-5-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbbEGXr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 19:47:28 -0400
Content-Disposition: inline
In-Reply-To: <1430587703-3387-5-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 02, 2015 at 07:27:53PM +0200, Jozsef Kadlecsik wrote:
> Three types of data need to be protected in the case of the hash types:
> 
> a. The hash buckets: standard rcu pointer operations are used.
> b. The allocated elements in the hash buckets: a bitmap is used
>    for book-keeping to tell which elements in the hash bucket are
>    used or free.
> c. Networks per cidr values and the cidr values themselves: the fix
>    sized arrays need no protection. The values are modified in such
>    an order that in the worst case an element testing is repeated
>    again with the same cidr value.

Did you consider using the rhashtable implementation under
lib/rhashtable.c? Do you think there is any chance to accommodate that
into ipset? If possible, it would avoid from dealing with this
complexity.
