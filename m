From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] [PATCH] fix sleepable allocation with spin lock bh
Date: Wed, 13 Aug 2008 15:29:24 +0200
Message-ID: <48A2E1B4.9050607@trash.net>
References: <20080807100803.8036.8684.stgit@Decadence> <20080807100846.8036.73172.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42444 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYHMN30 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:29:26 -0400
In-Reply-To: <20080807100846.8036.73172.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch removes a GFP_KERNEL allocation while holding a spin lock with
> bottom halves disabled in ctnetlink_change_helper().
> 
> This problem was introduced in 2.6.23 with the netfilter extension
> infrastructure.

Also applied, thanks. I'll push all three to -stable once they
are upstream.
