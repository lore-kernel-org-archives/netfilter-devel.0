From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxt_NFQUEUE: add new v1 version with queue-balance
 option
Date: Thu, 20 Aug 2009 16:40:22 +0200
Message-ID: <4A8D6056.4090206@trash.net>
References: <4A8D46AA.8020303@trash.net> <1250778482-9959-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47938 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZHTOkZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:40:25 -0400
In-Reply-To: <1250778482-9959-1-git-send-email-fw@strlen.de>
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
> 
> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
> ---
>  changes since v1:
>   - bail out on --queue-num 1<something> (i.e. do not change behaviour, v1
>     did treat "--queue-num 1<something>" as "--queue-num 1")
> 
>  extensions/libxt_NFQUEUE.c           |  116 ++++++++++++++++++++++++++++++++-
>  extensions/libxt_NFQUEUE.man         |   18 ++++--
>  include/linux/netfilter/xt_NFQUEUE.h |    5 ++
>  3 files changed, 129 insertions(+), 10 deletions(-)

Applied and pushed out, thanks Florian.

