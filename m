From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 -next] netfilter: nft_ct: labels get support
Date: Wed, 19 Feb 2014 11:14:51 +0100
Message-ID: <20140219101451.GA9180@localhost>
References: <1392733532-18469-1-git-send-email-fw@strlen.de>
 <20140218144940.GB29101@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43125 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaBSKO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:14:56 -0500
Content-Disposition: inline
In-Reply-To: <20140218144940.GB29101@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 02:49:44PM +0000, Patrick McHardy wrote:
> On Tue, Feb 18, 2014 at 03:25:32PM +0100, Florian Westphal wrote:
> > This also adds NF_CT_LABELS_MAX_SIZE so it can be re-used
> > as BUILD_BUG_ON in nft_ct.
> > 
> > At this time, nft doesn't yet support writing to the label area;
> > when this changes the label->words handling needs to be moved
> > out of xt_connlabel.c into nf_conntrack_labels.c.
> > 
> > Also removes a useless run-time check: words cannot grow beyond
> > 4 (32 bit) or 2 (64bit) since xt_connlabel enforces a maximum of
> > 128 labels.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Looks very good to me.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

Applied, thanks!
