From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3 nft] ct: connlabel matching support
Date: Tue, 18 Feb 2014 10:09:09 +0000
Message-ID: <20140218100909.GB12496@macbook.localnet>
References: <1392715644-4458-1-git-send-email-fw@strlen.de>
 <1392715644-4458-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58346 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaBRKJN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:09:13 -0500
Content-Disposition: inline
In-Reply-To: <1392715644-4458-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:27:24AM +0100, Florian Westphal wrote:
> Takes advantage of the fact that the current maximum label storage area
> is 128 bits, i.e. the dynamically allocated extension area in the
> kernel will always fit into a nft register.
> 
> Currently this re-uses rt_symbol_table_init() to read connlabel.conf.
> This works since the format is pretty much the same.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Changes since RFC:
>   - print function should only output one single label
>   - use singular ('label', not 'labels')
>   - use extra __init function to init label symtable

Looks very good to me.
