From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_hash: bug fixes and resizing
Date: Fri, 28 Feb 2014 06:24:14 -0800
Message-ID: <1393597454.26794.62.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1393595283-7036-1-git-send-email-kaber@trash.net>
	 <1393595283-7036-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	josh@joshtriplett.org, paulmck@linux.vnet.ibm.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53377 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaB1OYQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:24:16 -0500
Received: by mail-pb0-f43.google.com with SMTP id um1so819928pbc.2
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2014 06:24:15 -0800 (PST)
In-Reply-To: <1393595283-7036-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2014-02-28 at 13:48 +0000, Patrick McHardy wrote:

> +
> +static struct nft_hash_table *nft_hash_tbl_alloc(unsigned int nbuckets)
> +{
> +	struct nft_hash_table *tbl;
> +	size_t size;
> +
> +	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
> +	tbl = kzalloc(size, GFP_KERNEL);
> +	if (tbl == NULL)
> +		tbl = vzalloc(size);

There is no limit on nbuckets ?

You might consider using __GFP_REPEAT | __GFP_NOWARN



