From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nfnl_cthelper: Replace kzalloc with kcalloc
Date: Fri, 13 Oct 2017 01:42:15 +0200
Message-ID: <20171012234215.GB25032@breakpoint.cc>
References: <20171012222218.1220-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51236 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753283AbdJLXmZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 19:42:25 -0400
Content-Disposition: inline
In-Reply-To: <20171012222218.1220-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Harsha Sharma <harshasharmaiitr@gmail.com> wrote:
> kcalloc is preferred to allocate an array instead of kzalloc.
> This patch fixes checkpatch isssue.
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  net/netfilter/nfnetlink_cthelper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
> index 41628b393673..f1ce335b9158 100644
> --- a/net/netfilter/nfnetlink_cthelper.c
> +++ b/net/netfilter/nfnetlink_cthelper.c
> @@ -189,7 +189,7 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
>  	if (class_max > NF_CT_MAX_EXPECT_CLASSES)
>  		return -EOVERFLOW;
>  
> -	expect_policy = kzalloc(sizeof(struct nf_conntrack_expect_policy) *
> +	expect_policy = kcalloc(sizeof(struct nf_conntrack_expect_policy) *
>  				class_max, GFP_KERNEL);

Please at least compile test patches.
