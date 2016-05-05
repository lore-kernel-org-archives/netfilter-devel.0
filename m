From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -nf v7] netfilter: nftables: add connlabel set support
Date: Thu, 5 May 2016 16:35:43 +0200
Message-ID: <20160505143543.GB12977@breakpoint.cc>
References: <1461664793-22342-1-git-send-email-fw@strlen.de>
 <20160505115432.GA10879@salvia>
 <20160505135122.GA12977@breakpoint.cc>
 <20160505142830.GA16173@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54728 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbcEEOfr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 10:35:47 -0400
Content-Disposition: inline
In-Reply-To: <20160505142830.GA16173@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> OK, then I'm going to simplify this to make it look like:
> 
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +       case NFT_CT_LABELS:
> +               nf_connlabels_replace(ct,
> +                                     &regs->data[priv->sreg],
> +                                     &regs->data[priv->sreg],
> +                                     NF_CT_LABELS_MAX_SIZE / sizeof(u32));
> +               break;
> +#endif

I'm OK with this.
