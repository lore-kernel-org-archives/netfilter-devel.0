From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nf_nat_snmp_basic: use asn1 decoder library
Date: Mon, 13 Nov 2017 14:50:20 +0100
Message-ID: <20171113135020.GA21079@salvia>
References: <20171107145836.29917-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbdKMNuZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 08:50:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE7AD6EAE9
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:50:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E79ADA87D
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:50:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171107145836.29917-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Taehee,

On Tue, Nov 07, 2017 at 11:58:36PM +0900, Taehee Yoo wrote:
> The basic SNMP ALG parse snmp ASN.1 payload
> however, since 2012 linux kernel provide ASN.1 decoder library.
> If we use ASN.1 decoder in the /lib/asn1_decoder.c, we can remove
> about 1000 line of ASN.1 parsing routine.
> 
> To use asn1_decoder.c, we should write mib file(nf_nat_snmp_basic.asn1)
> then /script/asn1_compiler.c makes *-asn1.c and *-asn1.h file
> at the compiletime.(nf_nat_snmp_basic-asn1.c, nf_nat_snmp_basic-asn1.h)
> The nf_nat_snmp_basic.asn1 is made by RFC1155, RFC1157, RFC1902, RFC1905,
> RFC2578, RFC3416. of course that mib file supports only the basic SNMP ALG.
> 
> Previous SNMP ALG mangles only first octet of IPv4 address.
> but after this patch, the SNMP ALG mangles whole IPv4 Address.
> And SNMPv3 is not supported.

Was SNMPv3 supported before this patch?

> I tested with snmp commands such ans snmpd, snmpwalk, snmptrap.

If you can develop a bit more how you have tested this, I'd really
appreciate.

This is removing quite a lot of code, which as I said is great since
it's way less code to maintain.

My concern is that this patch is doing way many things in one go, and
the lack of tests also make me feel concerned about regressions. If
you could provide a more comprehensive description of what you have
tested, I'd really appreciate.

Just to mention a few things that got introduced here in one go, that
probably can be done incrementally:

> @@ -1232,14 +185,17 @@ static int help(struct sk_buff *skb, unsigned int protoff,
>  	if (ntohs(udph->len) != skb->len - (iph->ihl << 2)) {
>  		net_warn_ratelimited("SNMP: dropping malformed packet src=%pI4 dst=%pI4\n",
>  				     &iph->saddr, &iph->daddr);
> -		 return NF_DROP;
> +		nf_ct_helper_log(skb, ct, "too short packet");
> +		return NF_DROP;
>  	}
>  
> -	if (!skb_make_writable(skb, skb->len))
> +	if (!skb_make_writable(skb, skb->len)) {
> +		nf_ct_helper_log(skb, ct, "cannot mangle packet");

This log line is new, probably good to add this in a separated initial patch.

>  		return NF_DROP;
> +	}
>  
>  	spin_lock_bh(&snmp_lock);
> -	ret = snmp_translate(ct, ctinfo, skb);
> +	ret = snmp_translate(ct, dir, skb);

Conversion to use 'dir' could be done in a initial patch too I think.

>  	spin_unlock_bh(&snmp_lock);
>  	return ret;
>  }
> @@ -1259,12 +215,6 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
>  	.tuple.dst.protonum	= IPPROTO_UDP,
>  };
>  
> -/*****************************************************************************
> - *
> - * Module stuff.
> - *
> - *****************************************************************************/
> -

This useless comment can also go away in an initial patch.

>  static int __init nf_nat_snmp_basic_init(void)
>  {
>  	BUG_ON(nf_nat_snmp_hook != NULL);
> @@ -1282,5 +232,3 @@ static void __exit nf_nat_snmp_basic_fini(void)
>  
>  module_init(nf_nat_snmp_basic_init);
>  module_exit(nf_nat_snmp_basic_fini);
> -
> -module_param(debug, int, 0600);

I'm fine with killing this old debug parameter, but better in an
initial patch.

Thanks for your work!
