From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_connmark: Add translation to nft
Date: Fri, 25 Dec 2015 13:13:52 +0100
Message-ID: <20151225121352.GA4822@salvia>
References: <20151223143333.GA16694@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46732 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbbLYMN6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:13:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7C3EC7B543
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:13:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6EC50DA801
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:13:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 95D10DA801
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:13:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223143333.GA16694@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 08:03:33PM +0530, Shivani Bhardwaj wrote:
>  static struct xtables_match connmark_mt_reg[] = {
>  	{
>  		.family        = NFPROTO_UNSPEC,
> @@ -135,6 +178,7 @@ static struct xtables_match connmark_mt_reg[] = {
>  		.save          = connmark_save,
>  		.x6_parse      = connmark_parse,
>  		.x6_options    = connmark_mt_opts,
> +		.xlate	       = connmark_xlate,
>  	},
>  	{
>  		.version       = XTABLES_VERSION,
> @@ -148,6 +192,7 @@ static struct xtables_match connmark_mt_reg[] = {
>  		.save          = connmark_mt_save,
>  		.x6_parse      = connmark_mt_parse,
>  		.x6_options    = connmark_mt_opts,
> +		.xlate	       = connmark_mt_xlate,

Careful.

The different revisions use different structure definitions, ie. the
structure binary layout is different, therefore you cannot reuse the
same connmark_mt_xlate() for the two different revision.

Let me make sure I clarify this, this is revision 0:

struct xt_connmark_info {
        unsigned long mark, mask;
        uint8_t invert;
};

This is revision 1:

struct xt_connmark_mtinfo1 {
        __u32 mark, mask;
        __u8 invert;
};

The size of unsigned long depends on the architecture, so this code
will not work correctly.

You have to add a connmark_mt_xlate_v0() and connmark_mt_xlate_v1(),
in each of these functions you have to cast data to the right
structure layout.

Thanks.
