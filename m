From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] statement: avoid huge rodata array
Date: Tue, 22 Oct 2013 15:12:41 +0200
Message-ID: <20131022131241.GE12157@breakpoint.cc>
References: <1382445302-8050-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35086 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab3JVNMm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:12:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1VYblJ-0000LQ-Kd
	for netfilter-devel@vger.kernel.org; Tue, 22 Oct 2013 15:12:41 +0200
Content-Disposition: inline
In-Reply-To: <1382445302-8050-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> commit b259d1a ('src: operational limit match') creates huge
> array, increasing nft binary size from ~240k to ~5m on x86_64.
> 
> Use switch statement instead.

Applied,

> +static const char *get_unit(uint64_t u)
> +{
> +	switch (u) {
> +	case 1: return "seconds";

... after changing this to 'second', spotted by Phil Oester.
