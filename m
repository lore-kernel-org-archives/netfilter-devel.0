From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/6] netfilter: nfnetlink_queue: return error number to
 caller
Date: Tue, 18 Jan 2011 15:27:50 +0100
Message-ID: <4D35A366.4060507@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56650 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1ARO1w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:27:52 -0500
In-Reply-To: <1295183947-12786-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.01.2011 14:19, Florian Westphal wrote:
> instead of returning -1 on error, return an error number to allow the
> caller to handle some errors differently.
> 
> ECANCELED is used to indicate that the hook is going away and should be
> ignored.
> 
> A followup patch will introduce more 'ignore this hook' conditions,
> (depending on queue settings) and will move kfree_skb responsibility
> to the caller.

Applied, thanks.
