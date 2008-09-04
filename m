From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/38] netns ct: per-netns unconfirmed hash
Date: Thu, 04 Sep 2008 18:46:00 +0200
Message-ID: <48C010C8.9060808@trash.net>
References: <20080821220059.GK31136@x200.localdomain> <20080821224030.GB31601@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: containers@lists.linux-foundation.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33427 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYIDQqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:46:02 -0400
In-Reply-To: <20080821224030.GB31601@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

adobriyan@gmail.com wrote:
> What is unconfirmed connection in one netns can very well be confirmed
> in another.
> 

> @@ -10,5 +11,6 @@ struct netns_ct {
>  	unsigned int		expect_count;
>  	struct hlist_head	*expect_hash;
>  	int			expect_vmalloc;
> +	struct hlist_head	unconfirmed;
>  };

You could lay this out a bit better to avoid holes and move
the members only used rarely (like *_vmalloc) to the end.
