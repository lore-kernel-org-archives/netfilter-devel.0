From: =?iso-8859-1?q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Subject: Re: nft: segfault after adding to { type ipv4_addr; flags interval;
 } set
Date: Wed, 20 Jan 2016 20:55:22 +0000
Message-ID: <1453323322.11716.3@x201s.roaming.asbjorn.biz>
References: <20160119184648.GA24758@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-oKxVwg2XGKu1S2tuNSzD"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:50489 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbcATWbT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 17:31:19 -0500
In-Reply-To: <20160119184648.GA24758@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=-oKxVwg2XGKu1S2tuNSzD
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

On Tue, 19 Jan 2016 19:46:48 +0100, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Just posted several patches on the mailing list, it would be good if
> you can intensively test them. They apply on top of the current git
> tree.

Thanks, I will have a look at them, and test em.

> BTW, deletion is not implemented in nft, but I think it should be easy
> to follow up with a patch to make it.

I will need this, so I take a stab at it.

I am currently heading to a ski resort in France, but I expect to
get it tested next week, before I am heading to FOSDEM.
If my colleagues get too boring, I might test them before then.

> > It would be great if the ipset article on the wiki, could have some info
> > on how to migrate separate ipset types to nftables set types.
> 
> Would you like to start such article? I can create an account in the
> wiki page too, it would be a nice contribution.

Sure.

-- 
Best regards
Asbjørn Sloth Tønnesen
Network Engineer
Fiberby ApS - AS42541

--=-oKxVwg2XGKu1S2tuNSzD--
