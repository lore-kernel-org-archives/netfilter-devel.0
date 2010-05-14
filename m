From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_core.c: fix for dead connection after flushing
 conntrack cache
Date: Fri, 14 May 2010 13:05:55 +0200
Message-ID: <4BED2E93.1030004@trash.net>
References: <4BE3D31F.6000607@secunet.com> <4BE73DE3.6080304@netfilter.org> <4BE824EA.6000303@trash.net> <4BE83D93.8080909@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Mail List - Netfilter <netfilter@vger.kernel.org>
To: Joerg Marx <joerg.marx@secunet.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0ENLF4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 07:05:56 -0400
In-Reply-To: <4BE83D93.8080909@secunet.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joerg Marx wrote:
> On 05/10/2010 05:23 PM, Patrick McHardy wrote:
> 
> ...
>> I think this should be fine since the race you describe only affects
>> unconfirmed conntracks, but it took me a while to realize that all
>> the other spots where the DYING bit is set are fine without holding
>> the conntrack lock.
>>
>> Could you please add a comment to the check in __nf_conntrack_confirm()
>> stating that the dying check is supposed to prevent races against
>> nf_ct_get_next_corpse()? The semantic of the DYING bit is unfortunately
>> a bit overloaded.
>>
>> Also, since the condition unconfirmed + dying in nf_conntrack_confirm()
>> is highly unlikely, I'd suggest to remove the dying check there and only
>> perform it in __nf_conntrack_confirm().
>>
> 
> I hope the comment is clearly pointing to the (solved) problem now. I
> also removed the obsolete check in nf_conntrack_confirm.

Thanks, this looks fine. But I need a formal submission, including
a changelog and Signed-off-by: line. Thanks!
