From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] examples: selective rule dumping
Date: Wed, 20 Jul 2016 20:05:23 +0200
Message-ID: <20160720180523.GA30217@salvia>
References: <578F7E7A.5080901@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: jalvarez <jalvarez@toulouse.viveris.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32946 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbcGTSFe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 14:05:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B949C392E13
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 20:05:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6C5FA8E8
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 20:05:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E1423FC619
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 20:05:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <578F7E7A.5080901@toulouse.viveris.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 20, 2016 at 03:36:58PM +0200, jalvarez wrote:
> Add example (based on nft-get-rule.c) to demonstrate selective rule dumping
> when table and / or chain attributes are set in a rule dump request.
> Used to test the changes made in "[PATCH nf-next] netfilter: nf_tables:
> allow to filter out rules by table and chain"
> (http://marc.info/?t=146237901200004&r=1&w=2).
> 
> Signed-off-by: Josue Alvarez <jalvarez@toulouse.viveris.com>
> --
> diff --git a/examples/Makefile.am b/examples/Makefile.am
> index e002d36..73450c2 100644
> --- a/examples/Makefile.am
> +++ b/examples/Makefile.am
> @@ -13,6 +13,7 @@ check_PROGRAMS = nft-table-add        \
>           nft-rule-parse-add    \
>           nft-rule-del        \
>           nft-rule-get        \
> +         nft-rule-selective-get    \

Would you rework this to integrate these changes into nft-rule-get?
I'd suggest you make the invocation look like this below.

        Usage: nft-rule-get <family> [<table> <chain>] [<xml|json>]

So table and chain must be specified at the same time to keep it
simple, it is less flexible than what we actually support but I think
this is fine for an example.

Thanks.
