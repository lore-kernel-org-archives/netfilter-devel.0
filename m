From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: extend payload to support writing
 data
Date: Wed, 19 Feb 2014 17:12:13 +0100
Message-ID: <5304D7DD.6040004@redhat.com>
References: <1392660737-10149-1-git-send-email-nikolay@redhat.com> <20140217183751.GB10701@macbook.localnet> <5302585A.9070309@redhat.com> <20140217184651.GA11041@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbaBSQQs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:16:48 -0500
In-Reply-To: <20140217184651.GA11041@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/17/2014 07:46 PM, Patrick McHardy wrote:
> On Mon, Feb 17, 2014 at 07:43:38PM +0100, Nikolay Aleksandrov wrote:
>> On 02/17/2014 07:37 PM, Patrick McHardy wrote:
>>>>  
>>>> -static void nft_payload_eval(const struct nft_expr *expr,
>>>> -			     struct nft_data data[NFT_REG_MAX + 1],
>>>> -			     const struct nft_pktinfo *pkt)
>>>> +static int nft_payload_make_offset(const struct nft_pktinfo *pkt,
>>>> +				   const struct nft_payload *payload)
>>>
>>> We're using priv everywhere. Please keep this consistent. Also please
>>> make sure (in the entire patch) that arguments are aligned with the
>>> opening (.
>>>
>> Okay, I'll use the priv.
>> They're adjusted, apply the patch and see for yourself, or do you mean some
>> other adjustment ?
>> Both arguments are aligned from what I can see.
> 
> I see. Probably misrepresented by mutt.
> 
>>>> +static void nft_payload_set_eval(const struct nft_expr *expr,
>>>> +				 struct nft_data data[NFT_REG_MAX + 1],
>>>> +				 const struct nft_pktinfo *pkt)
>>>> +{
>>>> +	const struct nft_payload *priv = nft_expr_priv(expr);
>>>> +	struct nft_data *source = &data[priv->sreg];
>>>> +	int offset = nft_payload_make_offset(pkt, priv);
>>>> +
>>>> +	if (offset == -1)
>>>> +		goto err;
>>>> +	if (!skb_make_writable(pkt->skb, offset + priv->len))
>>>> +		goto err;
>>>> +	memcpy(pkt->skb->data + offset, source, priv->len);
>>>
>>> We need to take care of checksumming. Shouldn't be too hard to get *most*
>>> cases right using the existing checksum helpers.
>>>
>> Yes, but would you like to do that in here or have a separate op which
>> is configurable i.e. you can set what to calculate and where to put it,
>> or would you prefer to make it automatic based on what we're changing here ?
> 
> Something here is a lot cheaper since we can use incremental checksumming.
> That won't be possible somewhere else, additionally we'd have to check
> the checksum before recalculating it to make sure we don't fix up bad
> packets. So yes, I think it should be done here.
> 
Okay, I've been working on this today and have gotten to a point where it works :)
But I have a few questions, currently I've made it so the header that you modify
is the only one that gets its checksum updated (with the exception of pseudo
header if the address gets written to), I recompute the changed bytes one at a
time because of the freedom of offset and length. Now this works fine and I can
mangle the ip/ip6 headers or the transport headers (tcp/udp, I'll look into
adding sctp as well), but there's a problem with the cross-header writing i.e.
if a write spills from the network header to the transport header, currently I
only update the network header part (correctly, only up to the bytes that were
changed inside) and leave the transport header broken.
This also applies to the LL header, if a write spills into the network header
then we'll have a broken packet.

Would you like me to add additional logic to support the cross-header writes or
leave it as it is ?

Nik
