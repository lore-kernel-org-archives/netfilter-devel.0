From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add xt_tos
Date: Tue, 23 Oct 2007 17:26:05 +0200
Message-ID: <471E128D.3010707@trash.net>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr> <471A2338.6060501@trash.net> <Pine.LNX.4.64.0710201809380.1997@fbirervta.pbzchgretzou.qr> <471E0162.7060702@trash.net> <Pine.LNX.4.64.0710231724030.16684@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48517 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXJWP1D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:27:03 -0400
In-Reply-To: <Pine.LNX.4.64.0710231724030.16684@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 23 2007 16:12, Patrick McHardy wrote:
>>>>> +struct xt_tos_info {
>>>>> +	u_int8_t tos;
>>>>> +	u_int8_t invert;
>>>>> +};
>> XT_ALIGN - it pads to multiples of the highest alignment
>> requirement of u{8,16,32,64} - which is 1 one CRIS.
> 
> Even then I do not see where the problem is.
> If CRIS kernelspace has 1-alignment, then its userspace
> will have the same.
> 
>>> Note that ipt_tos(_match)_info also had these two fields.
>> Right, I mixed something up. So the patch I queued (attached
>> again for reference) seems to be fine.
>>
> Please drop it, I resend it (with new functionality).


OK. Since this is getting confusing and I get clashes with
your other patches, I'm going to drop both xt_tos and
xt_TOS. Please resend both once you've finished them.
Thanks.



