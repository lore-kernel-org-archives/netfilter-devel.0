From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/33] netns ct: pass netns pointer to nf_conntrack_in()
Date: Tue, 09 Sep 2008 07:52:15 +0200
Message-ID: <48C60F0F.6000104@trash.net>
References: <48C01046.2070704@trash.net> <1220842990-30500-7-git-send-email-adobriyan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62308 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYIIFwS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:52:18 -0400
In-Reply-To: <1220842990-30500-7-git-send-email-adobriyan@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> It's deducible from skb->dev or skb->dst->dev, but we know netns at
> the moment of call, so pass it down and use for finding and creating
> conntracks.

Applied, thanks.
