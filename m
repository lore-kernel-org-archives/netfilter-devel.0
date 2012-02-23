From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Thu, 23 Feb 2012 13:43:06 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu> <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu> <20120221145234.GB25826@1984> <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu> <20120223101250.GA3547@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:35514 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2BWMnJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:43:09 -0500
In-Reply-To: <20120223101250.GA3547@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Thu, 23 Feb 2012, Pablo Neira Ayuso wrote:

> On Tue, Feb 21, 2012 at 04:06:59PM +0100, Jozsef Kadlecsik wrote:
> > Or do I miss something else here?
> 
> I just noticed one problem.
> 
> With your approach, we may lose race if one packet inserts same conntrack
> entry while we're adding one conntrack. Thus resulting in two conntracks
> with the same tuples in the table.

Yes, you're right, that race condition is possible.
 
> One possible solution would be to check if it already exists before
> adding it to the list, but this will add too many extra cycles for
> each conntrack that is added via ctnetlink.

Actually, netfilter for normal conntrack entries does the same in 
__nf_conntrack_confirm. So entries added via ctnetlink would not be 
penalized if the same checking were added to ctnetlink_create_conntrack
in the locked region. Shall I send a patch over the previous one?
 
> I'm also considering disabling early_drop from ctnetlink and to return
> -ENOMEM instead. Not sure if it makes sense the early drop mechanism
> via ctnetlink. If we hit ENOMEM from user-space while adding one new
> conntrack, we can iterate over the table and delete conntrack based on
> some criteria, then retry.

There are advantages in early drop too: it's a good dice playing, which 
can be sufficient in many cases.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
