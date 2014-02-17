From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: extend payload to support writing
 data
Date: Mon, 17 Feb 2014 19:43:38 +0100
Message-ID: <5302585A.9070309@redhat.com>
References: <1392660737-10149-1-git-send-email-nikolay@redhat.com> <20140217183751.GB10701@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaBQSnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:43:45 -0500
In-Reply-To: <20140217183751.GB10701@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/17/2014 07:37 PM, Patrick McHardy wrote:
> On Mon, Feb 17, 2014 at 07:12:17PM +0100, Nikolay Aleksandrov wrote:
>> This patch extends the payload expression to support packet writing.
>> The new payload attribute - SREG specifies the source register to use
>> when changing packet data, the rest of the attributes are the same:
>> base - where to start from
>> offset - offset in the packet
>> len - length to write
>>
>> The DREG attribute should not be set if writing is intended, if both
>> attributes are set the SREG (packet writing) will take precedence.
>> When the expression is dumped both registers will get dumped and the
>> user can differentiate the type of the payload (reading/writing) by
>> checking if the sreg attribute is different from zero.
> 
> I'd suggest to return an error if both are set. We should only accept
> clearly defined input and reject everything else.
> 
Okay, will do.

>> I'm sending this patch early thus the RFC (I'm still testing),
>> just to see if you have any comments on the structure and changes. Now to
>> justify a few of the changes:
>> I added the sreg as a separate variable to struct nft_payload in order for
>> the user to be able to recognize which payload type is the expression when
>> dumping since both SREG and DREG get dumped.
> 
> Adding another register seems fine. I'd suggest to only dump the one
> actually used though.
> 
Given the previous comment, yep :)

>> I also factored the offset code in nft_payload_make_offset since it's used
>> by both evaluation functions, returns -1 on error.
>> The two init functions check only the registers as that's what is different
>> the rest of the attributes are still checked by the select_ops. I've also
>> allowed to have both SREG and DREG set but in such case SREG takes
>> precedence.
> 
> See above.
> 
>> I left the old payload names as they were, but they can get _get or
>> something else if you'd like.
> 
> Actually I dislike the _get and _set suffixes, so I'm happy to use them
> as little as possible :)
> 
>> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
>> index a2aeb31..1b42668 100644
>> --- a/net/netfilter/nft_payload.c
>> +++ b/net/netfilter/nft_payload.c
>> @@ -17,23 +17,19 @@
>>  #include <net/netfilter/nf_tables_core.h>
>>  #include <net/netfilter/nf_tables.h>
>>  
>> -static void nft_payload_eval(const struct nft_expr *expr,
>> -			     struct nft_data data[NFT_REG_MAX + 1],
>> -			     const struct nft_pktinfo *pkt)
>> +static int nft_payload_make_offset(const struct nft_pktinfo *pkt,
>> +				   const struct nft_payload *payload)
> 
> We're using priv everywhere. Please keep this consistent. Also please
> make sure (in the entire patch) that arguments are aligned with the
> opening (.
> 
Okay, I'll use the priv.
They're adjusted, apply the patch and see for yourself, or do you mean some
other adjustment ?
Both arguments are aligned from what I can see.

>>  {
>> -	const struct nft_payload *priv = nft_expr_priv(expr);
>> -	const struct sk_buff *skb = pkt->skb;
>> -	struct nft_data *dest = &data[priv->dreg];
>> -	int offset;
>> +	int offset = -1;
>>  
>> -	switch (priv->base) {
>> +	switch (payload->base) {
>>  	case NFT_PAYLOAD_LL_HEADER:
>> -		if (!skb_mac_header_was_set(skb))
>> -			goto err;
>> -		offset = skb_mac_header(skb) - skb->data;
>> +		if (!skb_mac_header_was_set(pkt->skb))
> 
> Why don't you keep the local skb pointer?
> 
Anyway is fine by me, I'll leave it.

>> +			return offset;
>> +		offset = skb_mac_header(pkt->skb) - pkt->skb->data;
>>  		break;
>>  	case NFT_PAYLOAD_NETWORK_HEADER:
>> -		offset = skb_network_offset(skb);
>> +		offset = skb_network_offset(pkt->skb);
>>  		break;
>>  	case NFT_PAYLOAD_TRANSPORT_HEADER:
>>  		offset = pkt->xt.thoff;
> 
>> +static void nft_payload_set_eval(const struct nft_expr *expr,
>> +				 struct nft_data data[NFT_REG_MAX + 1],
>> +				 const struct nft_pktinfo *pkt)
>> +{
>> +	const struct nft_payload *priv = nft_expr_priv(expr);
>> +	struct nft_data *source = &data[priv->sreg];
>> +	int offset = nft_payload_make_offset(pkt, priv);
>> +
>> +	if (offset == -1)
>> +		goto err;
>> +	if (!skb_make_writable(pkt->skb, offset + priv->len))
>> +		goto err;
>> +	memcpy(pkt->skb->data + offset, source, priv->len);
> 
> We need to take care of checksumming. Shouldn't be too hard to get *most*
> cases right using the existing checksum helpers.
> 
Yes, but would you like to do that in here or have a separate op which
is configurable i.e. you can set what to calculate and where to put it,
or would you prefer to make it automatic based on what we're changing here ?

>> +
>> +	return;
>> +err:
>> +	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
>> +}
>> +
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

