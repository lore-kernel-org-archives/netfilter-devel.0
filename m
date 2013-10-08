From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables 1/2] xtables: fix missing ipt_entry for
 MASQUERADE target
Date: Tue, 8 Oct 2013 11:44:52 +0200
Message-ID: <20131008094452.GB7186@localhost>
References: <1381223479-1157-1-git-send-email-pablo@netfilter.org>
 <5253CD59.9060508@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab3JHJo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:44:58 -0400
Content-Disposition: inline
In-Reply-To: <5253CD59.9060508@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 08, 2013 at 12:16:09PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> >+	/* Default on AF_INET */
> >+	h->ops = nft_family_ops_lookup(AF_INET);
> >+	if (h->ops == NULL)
> >+		xtables_error(PARAMETER_PROBLEM, "Unknown family");
> >+
> 
> Since you use AF_INET by default...

If neither -4 and -6 is passed, we assume AF_INET.

> >  	opts = xt_params->orig_opts;
> >  	while ((cs.c = getopt_long(argc, argv,
> >  	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
> >@@ -894,6 +899,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
> >  			if (args.proto == 0 && (args.invflags & XT_INV_PROTO))
> >  				xtables_error(PARAMETER_PROBLEM,
> >  					   "rule would never match protocol");
> >+
> >+			/* This needs to happen here to parse extensions */
> >+			h->ops->proto_parse(&cs, &args);
> >  			break;
> >  		case 's':
> >@@ -1033,11 +1041,21 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
> >  		case '4':
> >  			if (args.family != AF_INET)
> >  				exit_tryhelp(2);
> >+
> >+			h->ops = nft_family_ops_lookup(args.family);
> >+			if (h->ops == NULL)
> >+				xtables_error(PARAMETER_PROBLEM,
> >+					      "Unknown family");
> 
> ... this is useless I guess, then.

Yes, copied and pasted from the original code, will remove it.
