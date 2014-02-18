From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 -next] netfilter: nft_ct: labels get support
Date: Tue, 18 Feb 2014 14:49:44 +0000
Message-ID: <20140218144940.GB29101@macbook.localnet>
References: <1392733532-18469-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60623 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaBROuF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:50:05 -0500
Content-Disposition: inline
In-Reply-To: <1392733532-18469-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 03:25:32PM +0100, Florian Westphal wrote:
> This also adds NF_CT_LABELS_MAX_SIZE so it can be re-used
> as BUILD_BUG_ON in nft_ct.
> 
> At this time, nft doesn't yet support writing to the label area;
> when this changes the label->words handling needs to be moved
> out of xt_connlabel.c into nf_conntrack_labels.c.
> 
> Also removes a useless run-time check: words cannot grow beyond
> 4 (32 bit) or 2 (64bit) since xt_connlabel enforces a maximum of
> 128 labels.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Looks very good to me.

Acked-by: Patrick McHardy <kaber@trash.net>
