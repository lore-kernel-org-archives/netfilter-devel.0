From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: do not omit re-route check on NF_QUEUE
 verdict
Date: Thu, 20 Jan 2011 10:24:25 +0100
Message-ID: <4D37FF49.4020509@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-7-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1ATJY3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:24:29 -0500
In-Reply-To: <1295183947-12786-7-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 16.01.2011 14:19, schrieb Florian Westphal:
> ret != NF_QUEUE only works in the "--queue-num 0" case; for
> queues > 0 the test should be '(ret & NF_VERDICT_MASK) != NF_QUEUE'.
> 
> However, NF_QUEUE no longer DROPs the skb unconditionally if queueing
> fails (due to NF_VERDICT_FLAG_QUEUE_BYPASS verdict flag), so the
> re-route test should also be performed if this flag is set in the
> verdict.
> 
> The full test would then look something like
> 
> && ((ret & NF_VERDICT_MASK) == NF_QUEUE && (ret & NF_VERDICT_FLAG_QUEUE_BYPASS))
> 
> This is rather ugly, so just remove the NF_QUEUE test altogether.
> 
> The only effect is that we might perform an unnecessary route lookup
> in the NF_QUEUE case.
> 
> ip6table_mangle did not have such a check.

Applied, thanks Florian.
