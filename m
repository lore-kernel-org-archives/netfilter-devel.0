From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 15/27] xt_length match, revision 1
Date: Fri, 4 Jan 2008 16:43:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041634340.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022129270.14900@fbirervta.pbzchgretzou.qr>
 <477E4F49.3000405@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYADPnR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:43:17 -0500
In-Reply-To: <477E4F49.3000405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 16:22, Patrick McHardy wrote:
>> +#ifndef NEXTHDR_IPV4
>> +#	define NEXTHDR_IPV4 4
>
> This should be IPPROTO_IPIP I guess.

Or actually define NEXTHDR_IPV4 in include/net/ipv6.h I suppose.

>> +	case IPPROTO_AH:
>> +		*length = skb->len - offset - sizeof(struct ip_auth_hdr);
>> +		return true;
>> +	case IPPROTO_ESP:
>> +		*length = skb->len - offset - sizeof(struct ip_esp_hdr);
>> +		return true;
>> +	}
>
> I'm missing SCTP and DCCP. We try to consistently support at least all
> protocols implemented in Linux itself.
>
I did not quite get yet how to parse SCTP or what could be classified as
'data', since SCTP has multiple streams (ouch). Should reread RFC.


> I'm also wondering what this is actually useful for? The only
> useful thing I can imagine is TCP since its useful for matching on
> ACKs without data,
>
What was the original xt_length v0 good for, I wonder? :)


> all others have fixed sizes and can easily be implemented in userspace.
>
You cannot reliably use xt_length v0 to match any frame combination
where there is IPv4, IPv6 or TCP, because they all have dynamic sizes.
