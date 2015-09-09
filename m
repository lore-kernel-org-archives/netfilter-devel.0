From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnf-queue] examples: attaching a conntrack information
Date: Wed, 9 Sep 2015 22:29:32 +0200
Message-ID: <20150909202932.GC24810@breakpoint.cc>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150909095851.GD11843@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53338 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbbIIU3f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 16:29:35 -0400
Content-Disposition: inline
In-Reply-To: <20150909095851.GD11843@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> This patch enables nf-queue in examples directory to show conntrack
> information if --enable-nfct configure option is specified.

Thanks for doing this!

> +#ifdef BUILD_NFCT
> +static int print_ctinfo(const struct nlattr *const attr)
> +{
> +	char *s = NULL;
> +
> +	if (attr == NULL)
> +		return MNL_CB_OK;
> +	attr->nla_len = 12;

What this?
