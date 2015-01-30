From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH 2/2] ebtables-compat: add mark target
 extension
Date: Fri, 30 Jan 2015 19:51:55 +0100
Message-ID: <20150130185155.GB23146@salvia>
References: <20150129164433.21224.14657.stgit@nfdev.cica.es>
 <20150129164439.21224.8860.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45635 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbbA3Ssv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 13:48:51 -0500
Content-Disposition: inline
In-Reply-To: <20150129164439.21224.8860.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 29, 2015 at 05:44:39PM +0100, Arturo Borrero Gonzalez wrote:
> +static void brmark_final_check(unsigned int flags)
> +{
> +	if (!flags)
> +		xtables_error(PARAMETER_PROBLEM,
> +			      "You must specify some option");

You can provide better error reporting by checking this flags:

        if (!(flags & OPTION1 | OPTION2 | OPTION3))
                xtables_error(..., "you have to specify at least one of these: --option1, --option2, --option3");
        if (!(flags & OPTION4))
                xtables_error(..., "--option4 is mandatory");

Please, revisit this.
