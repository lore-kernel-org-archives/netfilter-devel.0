From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/6] netfilter: nfnetlink_queue: do not free skb on error
Date: Tue, 18 Jan 2011 15:29:02 +0100
Message-ID: <4D35A3AE.2090403@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56676 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1ARO3C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:29:02 -0500
In-Reply-To: <1295183947-12786-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.01.2011 14:19, Florian Westphal wrote:
> Move free responsibility from nf_queue to caller.
> This enables more flexible error handling; we can now accept the skb
> instead of freeing it.
> 

Applied, thanks.
