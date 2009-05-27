From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: add support for DCCP handshake
 sequence to ctnetlink
Date: Wed, 27 May 2009 16:13:36 +0200
Message-ID: <4A1D4A90.6030605@trash.net>
References: <20090527125242.11366.70215.stgit@Decadence> <20090527125423.11366.64989.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50882 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbZE0ONj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 10:13:39 -0400
In-Reply-To: <20090527125423.11366.64989.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -639,6 +639,8 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
>  	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state);
>  	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_ROLE,
>  		   ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]);
> +	NLA_PUT_U64(skb, CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
> +		    ct->proto.dccp.handshake_seq);

This should use big endian byteorder.
