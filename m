From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pass netns to ->match or to not pass
Date: Thu, 23 Oct 2008 19:17:29 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr>
References: <20081023231611.GA19245@x200.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43111 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYJWXRb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:17:31 -0400
In-Reply-To: <20081023231611.GA19245@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-23 19:16, Alexey Dobriyan wrote:

>xt_recent wants netns inside ->match hook (and xt_hashlimit probably,
>haven't looked closely):
>
>	recent_mt
>	recent_table_lookup
>	[use per-netns tables list]
>
>Now, I can drag netns through struct xt_match_param, or use
>dev_net(skb->dev ? skb->dev : skb->dst->dev) trick.
>
>And the latter should be better, because only xt_recent module will be
>affected.
>
>Comments?

What exactly needs netns? This?

	if (par->out != NULL && skb->sk == NULL)
		ttl++;
