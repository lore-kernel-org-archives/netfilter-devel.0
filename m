From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER -stable 01/03]: nfnetlink_queue: fix SKB_LINEAR_ASSERT
 when mangling packet data
Date: Mon, 25 Feb 2008 15:06:43 +0100
Message-ID: <47C2CB73.3090107@trash.net>
References: <20080225140058.20602.52127.sendpatchset@localhost.localdomain> <20080225140059.20602.57007.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:57926 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYBYOGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:06:54 -0500
In-Reply-To: <20080225140059.20602.57007.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> [NETFILTER]: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data
> 
> Upstream commit e2b58a67:
> 
> As reported by Tomas Simonaitis <tomas.simonaitis@gmail.com>, inserting new
> data in skbs queued over {ip,ip6,nfnetlink}_queue triggers a SKB_LINEAR_ASSERT
> in skb_put().
> 
> Going back through the git history, it seems this bug is present since at
> least 2.6.12-rc2, probably even since the removal of skb_linearize() for
> netfilter.


Just to avoid confusion: this part of the changelog is wrong, I initialy
didn't realize this was just introduced recently and forgot to edit it
out for -stable.
