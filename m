From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] ipset patches for nf-next
Date: Mon, 25 Aug 2014 10:28:16 +0200
Message-ID: <20140825082816.GA8262@salvia>
References: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52454 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbaHYI1p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:27:45 -0400
Content-Disposition: inline
In-Reply-To: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 24, 2014 at 07:49:39PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to apply the next series of patches:
> 
> - Dan Carpenter reported that the static checker emits a warning
>   about integer overflows in ip_set_list_set.c, fixed by me
> - missing-field-initializer warnings resolved, from Mark Rustad
> - In netnet and netportnet hash types the range support for IPv4
>   was broken, fixed by Sergey Popovich
> - A smatch warning about IPSET_ATTR_MARKMASK validation is fixed
>   by Vytas Dauksa.
> 
> You can pull the changes from
> 
>         git://blackhole.kfki.hu/nf-next master

Pulled. Thanks, Jozsef.

