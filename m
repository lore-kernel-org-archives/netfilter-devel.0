From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 17:23:42 +0100
Message-ID: <20151125162342.GA4051@salvia>
References: <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58987 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbbKYQXz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 11:23:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 14D161324CE
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 17:23:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 06229DA809
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 17:23:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 110A8DA85D
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 17:23:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151125150640.GE18449@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 25, 2015 at 03:06:40PM +0000, Patrick McHardy wrote:
> @@ -698,6 +703,10 @@ const struct proto_desc proto_arp = {
>  		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
>  		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
>  		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
> +		[ARPHDR_SHA]		= PROTO_HDR_TEMPLATE("sha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 8 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
> +		[ARPHDR_SPA]		= PROTO_HDR_TEMPLATE("sip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 14 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
> +		[ARPHDR_THA]		= PROTO_HDR_TEMPLATE("tha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 18 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
> +		[ARPHDR_TPA]		= PROTO_HDR_TEMPLATE("tip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
>  	},
>  };
>  

Could you also push this chunk into the repository?

I have a similar patch here for this. Given that we only support ARP
for IPv4, we don't have to worry about the variable length offset in
this case.

Thanks.
