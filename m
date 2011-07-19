From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] netfilter: nfqueue: batch verdict support
Date: Tue, 19 Jul 2011 11:47:13 +0200
Message-ID: <4E2552A1.3020501@trash.net>
References: <1311023924-12806-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35603 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GSJrP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:47:15 -0400
In-Reply-To: <1311023924-12806-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.07.2011 23:18, Florian Westphal wrote:
> Introduces a new nfnetlink type that applies a given
> verdict to all queued packets with an id <= the id in the verdict
> message.
> 
> If a mark is provided it is applied to all matched packets.
> 
> This reduces the number of verdicts that have to be sent.
> Applications that make use of this feature need to maintain
> a timeout to send a batchverdict periodically to avoid starvation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
