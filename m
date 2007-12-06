From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_inet_address
Date: Thu, 06 Dec 2007 10:54:17 +0100
Message-ID: <4757C6C9.20002@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr> <474A749B.8000303@trash.net> <Pine.LNX.4.64.0711262105080.22369@fbirervta.pbzchgretzou.qr> <474B60E1.6060002@trash.net> <Pine.LNX.4.64.0712051822360.10753@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712051828450.10753@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58839 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXLFJyo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:54:44 -0500
In-Reply-To: <Pine.LNX.4.64.0712051828450.10753@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 5 2007 18:24, Jan Engelhardt wrote:
>>> And the name doesn't really match. I'd prefer to type for all of
>>> netfilter and then have conntrack use that one.
>>>
>> About nf_inet_addr; does any userspace program depend on 
>> nf_conntrack_address? If so, I would have to add some #defines to remain 
>> compat.
> 
> Oh and also, if we can actually do that. Because if xt_FOOBAR
> starts using
> 
> 	struct xt_foobar_target_info {
> 		union nf_inet_addr blubb;
> 	};
> 
> we may not change nf_inet_addr beyond its current size...
> I hope that is ok for this century, given it is already 128 bits.


Thats seems OK.
