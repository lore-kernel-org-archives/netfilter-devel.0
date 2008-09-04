From: Patrick McHardy <kaber@trash.net>
Subject: Re: 4/7 [NETFILTER]: xt_length match, revision 1
Date: Thu, 04 Sep 2008 17:58:22 +0200
Message-ID: <48C0059E.1080602@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131927360.13154@fbirervta.pbzchgretzou.qr> <48BFF712.3020301@trash.net> <alpine.LNX.1.10.0809041154090.7250@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65139 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYIDP6Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:58:24 -0400
In-Reply-To: <alpine.LNX.1.10.0809041154090.7250@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-09-04 10:56, Patrick McHardy wrote:
>>> [NETFILTER]: xt_length match, revision 1
>>>
>>> Introduce xt_length match revision 1. It adds support for layer-4,
>>> layer-5 and layer-7 length matching. It is much easier than writing
>>> up the according xt_u32 magic.
>> I still think this is too ugly to live
> 
> Do you have a better suggestion?

Not currently, too busy catching up. Lets revisit this later.

> 
>>> +static bool
>>> +xtlength_layer7_sctp(unsigned int *length, const struct sk_buff *skb,
>>> +		     unsigned int offset)
>>> +{
>>> +	const struct sctp_chunkhdr *ch;
>>> +	struct sctp_chunkhdr chbuf;
>>> +	unsigned int pos;
>>> +
>>> +	*length = 0;
>>> +	for (pos = sizeof(struct sctphdr); pos < skb->len;
>>> +	     pos += ntohs(ch->length)) {
>> Endless loop
> 
> It should have been
> 	pos = offset + sizeof(struct sctphdr)
> right? If not, where is the endless loop?

ch->length may be zero. It should round up to multiples of four.
