From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/8] ipset patches for nf-next
Date: Tue, 16 Sep 2014 18:50:48 +0200
Message-ID: <20140916165048.GA18526@salvia>
References: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49045 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbaIPQtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:49:53 -0400
Content-Disposition: inline
In-Reply-To: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 15, 2014 at 11:02:46PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to apply the next series of patches:
> 
> - the new hash:mac type by which it's easy to store
>   just the MAC addresses in a set
> - an optimization to the skbinfo expression, which
>   suppresses sending zero valued extensions
> - the skbinfo extension support to the SET
>   target from Anton Danilov
> - the skbinfo extension support for the list,
>   hash and bitmap types separatedly
>   from Anton Danilov
> - the skbinfo extension support in the ipset
>   core from Anton Danilov
> - a fix for a static checker warning in
>   ip_set_core.c, reported by Dan Carpenter
> 
> The skbinfo extension makes possible to store
> fw mark, tc class and/or hardware queue parameters
> together with the set elements and then attach
> them to the matchig packets by the SET target.
> 
> You can pull the changes from
> 
>         git://blackhole.kfki.hu/nf-next master

Pulled, thanks Jozsef.
