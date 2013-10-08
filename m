From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables 1/2] xtables: fix missing ipt_entry for MASQUERADE
 target
Date: Tue, 08 Oct 2013 12:16:09 +0300
Message-ID: <5253CD59.9060508@linux.intel.com>
References: <1381223479-1157-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51880 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3JHJQL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:16:11 -0400
In-Reply-To: <1381223479-1157-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
> +	/* Default on AF_INET */
> +	h->ops = nft_family_ops_lookup(AF_INET);
> +	if (h->ops == NULL)
> +		xtables_error(PARAMETER_PROBLEM, "Unknown family");
> +

Since you use AF_INET by default...

>   	opts = xt_params->orig_opts;
>   	while ((cs.c = getopt_long(argc, argv,
>   	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
> @@ -894,6 +899,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
>   			if (args.proto == 0 && (args.invflags & XT_INV_PROTO))
>   				xtables_error(PARAMETER_PROBLEM,
>   					   "rule would never match protocol");
> +
> +			/* This needs to happen here to parse extensions */
> +			h->ops->proto_parse(&cs, &args);
>   			break;
>   
>   		case 's':
> @@ -1033,11 +1041,21 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
>   		case '4':
>   			if (args.family != AF_INET)
>   				exit_tryhelp(2);
> +
> +			h->ops = nft_family_ops_lookup(args.family);
> +			if (h->ops == NULL)
> +				xtables_error(PARAMETER_PROBLEM,
> +					      "Unknown family");

... this is useless I guess, then.

Tomasz
