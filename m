From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: replace built-in tables by chain
 types
Date: Mon, 5 Nov 2012 15:32:16 +0100
Message-ID: <20121105143216.GA7280@1984>
References: <1352054018-4648-1-git-send-email-pablo@netfilter.org>
 <5097B7AC.3010206@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48887 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab2KEOcV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:32:21 -0500
Content-Disposition: inline
In-Reply-To: <5097B7AC.3010206@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 05, 2012 at 02:57:16PM +0200, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> Don't know why, but git cannot apply properly the patch at once.
> Though, nothing seems to prevent such thing.
> Anyway:
> 
> >@@ -1807,6 +1793,10 @@ static int __init nf_tables_module_init(void)
> >  	if (err<  0)
> >  		goto err2;
> >
> >+	nft_register_chain_type(&filter_ipv4);
> >+	nft_register_chain_type(&filter_ipv6);
> >+	nft_register_chain_type(&filter_bridge);
> >+
> >  	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy<kaber@trash.net>\n");
> >  	return 0;
> >
> >@@ -1818,6 +1808,9 @@ err1:
> >
> >  static void __exit nf_tables_module_exit(void)
> >  {
> >+	nft_unregister_chain_type(&filter_ipv4);
> >+	nft_unregister_chain_type(&filter_ipv6);
> >+	nft_unregister_chain_type(&filter_bridge);
> >  	nfnetlink_subsys_unregister(&nf_tables_subsys);
> >  	nf_tables_core_module_exit();
> >  }
> >-- 
> 
> filter_bridge declaration is missing.

It's a leftover, remove it. It's already fixed here. Sorry for the
inconvenience.
