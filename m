From: Andreas Herz <andi@geekosphere.org>
Subject: Re: function for getting the source ip defined in the routing table
Date: Thu, 22 May 2014 12:31:48 +0200
Message-ID: <20140522103148.GA10939@kvmbude>
References: <20140520124634.GM10939@kvmbude>
 <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
 <20140520141828.GO10939@kvmbude>
 <CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
 <20140521083643.GU10939@kvmbude>
 <CAHo-Oozp=_ss7NG=yBQwD2qxjpvKRUwcMa4fJ+gbkMyYuJM6Jw@mail.gmail.com>
 <20140522091129.GZ10939@kvmbude>
 <CAJ26g5T1Ugfy-tfeFUBWABLrwuNkG26V7u=SvF6cr9pFwkGobA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:43191 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaEVKbv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 06:31:51 -0400
Content-Disposition: inline
In-Reply-To: <CAJ26g5T1Ugfy-tfeFUBWABLrwuNkG26V7u=SvF6cr9pFwkGobA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22/05/14 at 11:41, Patrick Schaaf wrote:
> Am 22.05.2014 11:15 schrieb "Andreas Herz" <andi@geekosphere.org>:
> >
> > I will try your hint to use ip_route_output_key twice.
> 
> A second call with input src set to 0 will match a _different_ set of
> rules, so that will probably not work.

That's correct, the wrong rule will match again and the same issue with
calling it without src ip in the first place.

> > Although i still wonder why my requirement is so special :)
> 
> Combining MASQUERADE with policy routing is probably a bit rare :)

Is it? We have several scenarios in that we have more IPs on one
interface and different routes and want to specify the source IP.
Especially in cluster scenarios.

> You could work around with a set of rules using SNAT while matching
> outgoing interface and source/destination IPs - basically duplicating your
> extra routing table in the nat POSTROUTING chains. But that is certainly a
> pain to maintain...

That's the reason why we ported MASQUERADE from 2.6.9 to the newer
kernels to keep it to less rules.

Since rt->src got removed i wanted to find a way to update the module,
but for now it looks like i have to patch the kernel itself :/

Thanks so far.

-- 
Andreas Herz
