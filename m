From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: 4/7 [NETFILTER]: xt_length match, revision 1
Date: Thu, 4 Sep 2008 11:56:41 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809041154090.7250@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131927360.13154@fbirervta.pbzchgretzou.qr> <48BFF712.3020301@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48019 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYIDP4m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:56:42 -0400
In-Reply-To: <48BFF712.3020301@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-09-04 10:56, Patrick McHardy wrote:
>> [NETFILTER]: xt_length match, revision 1
>> 
>> Introduce xt_length match revision 1. It adds support for layer-4,
>> layer-5 and layer-7 length matching. It is much easier than writing
>> up the according xt_u32 magic.
>
> I still think this is too ugly to live

Do you have a better suggestion?

>> +static bool
>> +xtlength_layer7_sctp(unsigned int *length, const struct sk_buff *skb,
>> +		     unsigned int offset)
>> +{
>> +	const struct sctp_chunkhdr *ch;
>> +	struct sctp_chunkhdr chbuf;
>> +	unsigned int pos;
>> +
>> +	*length = 0;
>> +	for (pos = sizeof(struct sctphdr); pos < skb->len;
>> +	     pos += ntohs(ch->length)) {
>
> Endless loop

It should have been
	pos = offset + sizeof(struct sctphdr)
right? If not, where is the endless loop? The intention here is that
pos is the index to the first byte of whatever chunk is currently
in iteration. So @ch points to the chunk header, and ch->length
says how long this chunk is, so that after increasing pos by
ch->length, we are at the next CH. Or we are past the skb's length,
in which case the loop terminates.

>> +		ch = skb_header_pointer(skb, offset + pos,
>> +		     sizeof(chbuf), &chbuf);
>> +		if (ch == NULL)
>> +			return false;
>> +		if (ch->type != SCTP_CID_DATA)
>> +			continue;
>> +		*length += ntohs(ch->length);
>> +	}
>> +	return true;
>> +}

thanks,
Jan
