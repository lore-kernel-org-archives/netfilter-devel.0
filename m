From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxt_NFQUEUE: add new v1 version with queue-balance
 option
Date: Thu, 20 Aug 2009 14:50:50 +0200
Message-ID: <4A8D46AA.8020303@trash.net>
References: <1245541351-18513-1-git-send-email-fw@strlen.de> <1245541351-18513-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45860 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZHTMuw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:50:52 -0400
In-Reply-To: <1245541351-18513-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> New version that adds support for specifying a queue range instead
> of a single queue id.
> The kernel will distribute flows across the given queue range.
> 
> This is useful for multicore systems, simply start multiple instances
> of the userspace program on queues x, x+1, .. x+n and use
> "--queue-balance x:x+n".
> Packets belonging to the same connection are put into the same queue.
> 
> With fixes from Jan Engelhardt.

This patch does not apply anymore, could you rediff against -git
please? Thanks!
