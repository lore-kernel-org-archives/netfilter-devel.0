From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
Date: Tue, 29 Jan 2008 16:31:21 +0100
Message-ID: <479F46C9.2010102@trash.net>
References: <Pine.LNX.4.64.0801241946190.12676@fbirervta.pbzchgretzou.qr> <479F245A.2030509@trash.net> <Pine.LNX.4.64.0801291621000.1185@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57529 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764425AbYA2PbX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:31:23 -0500
In-Reply-To: <Pine.LNX.4.64.0801291621000.1185@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 29 2008 14:04, Patrick McHardy wrote:
>> Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
>>
>> Jan Engelhardt wrote:
>>> Hi,
>>>
>>> this patch was previously unmerged because it conflicted with Eric Dumazet's
>>> changes. I now rediffed it; please apply.
>> This adds a huge number of sparse warnings, please fix those up.
>> I already fixed those in your other recent patches, but please
>> make sure all patches you submit are sparse warning free.
> 
> Interestingly enough, I do not get these warnings.

You're probably not using make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__".

> Anyway, please have this patch on top:
> 
> The last u_int32_t should be ok as it stands.

That fixes it, thanks.
