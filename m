From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables with ipset combined types
Date: Mon, 03 Feb 2014 20:28:49 +0000
Message-ID: <27f7b03e-5dd5-4e6b-a0fe-099f07fbea6f@email.android.com>
References: <52E8AD76.5050808@aim.com> <20140129093010.GA4332@localhost> <24843182.8UhhjTCEZr@rofl> <20140202235734.GA6793@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38904 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaBCU3G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:29:06 -0500
In-Reply-To: <20140202235734.GA6793@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2. Februar 2014 23:57:34 GMT+00:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>On Wed, Jan 29, 2014 at 12:34:12PM +0100, Patrick Schaaf wrote:
>> Hi Pablo,
>> 
>> another useful feature of ipset is that the same set is usable in the
>> filter, nat, and mangle tables.
>> 
>> If I'm not mistaken, sets in nftables are right now scoped within a
>table,
>> so I could not reuse them in that fashion.
>
>The table <-> set link is currently needed to check for loops if
>verdict maps are used. But AFAICS, for sets with no verdict maps using
>jump to chain, this limitation could be removed. I'll add this to my
>TODO list.

While this might be useful, I don't think it justifies more than minor code changes since the user can just as well only use a single table.

Regarding TODO lists, I think it would be good to put the bigger items in the nftables TODO list. I'll start by cleaning it up and adding my current items.


