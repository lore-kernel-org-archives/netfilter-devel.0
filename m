From: Patrick McHardy <kaber@trash.net>
Subject: Re: [conntrack-tools] XML output is invalid
Date: Fri, 20 Jun 2008 15:30:56 +0200
Message-ID: <485BB110.60307@trash.net>
References: <F7825499-A8F5-4F41-B3DD-2E13807954E2@rotsen.be> <485BAF8B.1050502@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sen Haerens <sen@rotsen.be>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYFTNa7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:30:59 -0400
In-Reply-To: <485BAF8B.1050502@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Does this patch help?
> 
> 
> +	if (output_mask & _O_XML) {
>  		op_type = NFCT_O_XML;
> +		if (dump_xml_header_done) {
> +			dump_xml_header_done = 0;
> +			len = snprintf(buf, 1024, "<?xml version=\"1.0\"?>\n"
> +						  "<conntrack>\n");
> +		}
> +	}
>  	if (output_mask & _O_EXT)
>  		op_flags = NFCT_OF_SHOW_LAYER3;
>  	if (output_mask & _O_ID)
>  		op_flags |= NFCT_OF_ID;
>  
> -	nfct_snprintf(buf, 1024, ct, NFCT_T_UNKNOWN, op_type, op_flags);
> +	nfct_snprintf(buf+len, 1024-len, ct, NFCT_T_UNKNOWN, op_type, op_flags);


It doesn't seem to matter here, but that looks buggy (combined
with the snprintf above). When the buffer size is exceed, snprintf
returns the amount of characters it *would have written* if
enough space was available. So when this really happens above,
you have a buffer overflow in the second snprintf.


