From: Patrick McHardy <kaber@trash.net>
Subject: Re: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 05:43:04 +0200
Message-ID: <49014448.4090405@trash.net>
References: <20081023231611.GA19245@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYJXDnI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:43:08 -0400
In-Reply-To: <20081023231611.GA19245@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> xt_recent wants netns inside ->match hook (and xt_hashlimit probably,
> haven't looked closely):
> 
> 	recent_mt
> 	recent_table_lookup
> 	[use per-netns tables list]
> 
> Now, I can drag netns through struct xt_match_param, or use
> dev_net(skb->dev ? skb->dev : skb->dst->dev) trick.
> 
> And the latter should be better, because only xt_recent module will be
> affected.
> 
> Comments?

I prefer the later. Using the supplied device parameters would
be better though to keep the device handling centralized.
