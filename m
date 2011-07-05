From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH next] netfilter: nfqueue: batch verdict support
Date: Tue, 05 Jul 2011 15:26:04 +0200
Message-ID: <4E1310EC.1030401@trash.net>
References: <1307657659-30266-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39528 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab1GEN0F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:26:05 -0400
In-Reply-To: <1307657659-30266-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.06.2011 00:14, Florian Westphal wrote:
> Introduces a new nfnetlink type that applies a given
> verdict to all queued packets with an id <= the id in the verdict
> message.
> 
> If a mark is provided it is applied to all matched packets.
> 
> This reduces the number of verdicts that have to be sent.
> Applications that make use of this feature need to maintain
> a timeout to send a batchverdict periodically to avoid starvation.

Thanks Florian. Do you have any throughput numbers with this patch?
