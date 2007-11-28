From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] iptables/libiptc perf issue: Sorting chain during
 pull-out
Date: Wed, 28 Nov 2007 09:32:04 +0100
Message-ID: <474D2784.3060303@trash.net>
References: <1196085397.3866.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>,
	"Paul C. Diem" <PCDiem@FoxValley.net>,
	Martin Josefsson <gandalf@netfilter.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39843 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXK1IcK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:32:10 -0500
In-Reply-To: <1196085397.3866.58.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
> Performance optimize scalability issue:
>   Sorting chain during pull-out give worst-case runtime O(Chains^2).
> 
> When pulling out the blob, every chain name is inserted alphabetically
> into a linked list (by function iptc_insert_chain()).  The problem
> with this approach is that the chain names delivered in the blob is
> already sorted (as we push it back to the kernel sorted).
> 
> This cause chain parsing to always process every element in the chain
> list and finish with a tail add.  Causing worst-case runtime O(C^2/2)
> for alphabetically sorting of chains.
> 
> The patch solves this by only calling iptc_insert_chain() when
> creating new chains.


Applied, thanks a lot.
