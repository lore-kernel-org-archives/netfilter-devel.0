From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: add HMARK target
Date: Thu, 12 Jul 2012 17:29:47 +0200
Message-ID: <20120712152947.GA18341@1984>
References: <tqndgm6.047f943bd7060a4c2b179885c2c22c50@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39789 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677Ab2GLP3z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:29:55 -0400
Content-Disposition: inline
In-Reply-To: <tqndgm6.047f943bd7060a4c2b179885c2c22c50@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 12, 2012 at 09:34:45AM +0200, Hans Schillstrom wrote:
> Hi Pablo
> [snip]
> +static void HMARK_check(struct xt_fcheck_call *cb)
> >+{
> >+	if (!(cb->xflags & (1 << O_HMARK_MODULUS)))
> >+		xtables_error(PARAMETER_PROBLEM, "--hmark-mod is mandatory");
> >+	if (!(cb->xflags & (1 << O_HMARK_RND)))
> >+		xtables_error(PARAMETER_PROBLEM, "--hmark-rnd is mandatory");
> 
> I don't think rnd should be mandatory, a default value is enough.
> offset however should be mandatory.

As I said, parameters that are not set will likely not be set by
users. If default value for random, the easier it will be for an
attacker to direct all flows to the same target.

I'll be OK to make --hmark-offset mandatory, BTW.
