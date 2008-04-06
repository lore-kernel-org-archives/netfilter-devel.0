From: Patrick McHardy <kaber@trash.net>
Subject: Re: DCCP conntrack/NAT
Date: Sun, 06 Apr 2008 02:28:35 +0200
Message-ID: <47F81933.4050102@trash.net>
References: <47F64C0D.5080700@trash.net> <alpine.LNX.1.10.0804042152090.26881@fbirervta.pbzchgretzou.qr> <47F74FE7.2040809@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51119 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYDFAbP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 20:31:15 -0400
In-Reply-To: <47F74FE7.2040809@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>   
>>> +static int dccp_pkt_to_tuple(const struct sk_buff *skb, unsigned int
>>> dataoff,
>>> +                 struct nf_conntrack_tuple *tuple)
>>> +{
>>> +    struct dccp_hdr _hdr, *dh;
>>> +
>>> +    dh = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
>>> +    if (dh == NULL)
>>> +        return 0;
>>> +
>> skb_header_pointer() is used for the case of a non-linear skb (has to
>> do with IP fragments?).
>>     
>
> Indeed.
>
>   
>> In ipv4_pkt_to_tuple in nf_conntrack_l3proto_ipv4.c,
>> skb_header_pointer() is used to get the [source address of the] IP
>> header. Since I figured the layer-3 header must always be
>> unfragmented, would not it be simpler to use ip_hdr(), or is there
>> something that mandates use of skb_header_pointer?
>>     
>
> Right. I think that we can assume that the IP header is always linear (I
> remember this from a conversation with Davem or Rusty), Patrick?
>   

Right, the IP header is linearized by ip_rcv() (or bridge netfilter).
The pkt_to_tuple functions may be called for the inner packet of an
ICMP message however, which might be in the non-linear area.


