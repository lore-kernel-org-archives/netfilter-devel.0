From: Patrick McHardy <kaber@trash.net>
Subject: Re: 4/7 [NETFILTER]: xt_length match, revision 1
Date: Thu, 04 Sep 2008 16:56:18 +0200
Message-ID: <48BFF712.3020301@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131927360.13154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63575 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYIDO4U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:56:20 -0400
In-Reply-To: <alpine.LNX.1.10.0808131927360.13154@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 60425bec17c83f58e5ef1e833898a65af292cf64
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sun Aug 10 17:46:28 2008 -0400
> 
> [NETFILTER]: xt_length match, revision 1
> 
> Introduce xt_length match revision 1. It adds support for layer-4,
> layer-5 and layer-7 length matching. It is much easier than writing
> up the according xt_u32 magic.
> 
> This can be used for packet scheduling; specific example are online
> games where all data is transferred over the same port, but the
> regular gameplay has a characteristically lower packet size than bulk
> downloads of game maps. (Tested with Unreal Tournament 99.)

I still think this is too ugly to live, additionally:

> +static bool
> +xtlength_layer7_sctp(unsigned int *length, const struct sk_buff *skb,
> +		     unsigned int offset)
> +{
> +	const struct sctp_chunkhdr *ch;
> +	struct sctp_chunkhdr chbuf;
> +	unsigned int pos;
> +
> +	*length = 0;
> +	for (pos = sizeof(struct sctphdr); pos < skb->len;
> +	     pos += ntohs(ch->length)) {

Endless loop

> +		ch = skb_header_pointer(skb, offset + pos,
> +		     sizeof(chbuf), &chbuf);
> +		if (ch == NULL)
> +			return false;
> +		if (ch->type != SCTP_CID_DATA)
> +			continue;
> +		*length += ntohs(ch->length);
> +	}
> +	return true;
> +}
