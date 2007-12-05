From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: nf_inet_address (was: NF [PATCH 2/4] xt_TEE)
Date: Wed, 5 Dec 2007 18:35:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712051828450.10753@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
 <474A749B.8000303@trash.net> <Pine.LNX.4.64.0711262105080.22369@fbirervta.pbzchgretzou.qr>
 <474B60E1.6060002@trash.net> <Pine.LNX.4.64.0712051822360.10753@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37747 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLERfI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:35:08 -0500
In-Reply-To: <Pine.LNX.4.64.0712051822360.10753@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 5 2007 18:24, Jan Engelhardt wrote:
>> And the name doesn't really match. I'd prefer to type for all of
>> netfilter and then have conntrack use that one.
>>
>About nf_inet_addr; does any userspace program depend on 
>nf_conntrack_address? If so, I would have to add some #defines to remain 
>compat.

Oh and also, if we can actually do that. Because if xt_FOOBAR
starts using

	struct xt_foobar_target_info {
		union nf_inet_addr blubb;
	};

we may not change nf_inet_addr beyond its current size...
I hope that is ok for this century, given it is already 128 bits.
