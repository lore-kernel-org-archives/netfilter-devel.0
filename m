From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: ebtables: only call xt_compat_add_offset
 once per rule
Date: Thu, 21 Apr 2011 10:59:16 +0200
Message-ID: <4DAFF1E4.6010703@trash.net>
References: <1302121610-18057-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1DUI7T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:59:19 -0400
In-Reply-To: <1302121610-18057-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.04.2011 22:26, Florian Westphal wrote:
> The optimizations in commit 255d0dc34068a976
> (netfilter: x_table: speedup compat operations) assume that
> xt_compat_add_offset is called once per rule.
> 
> ebtables however called it for each match/target found in a rule.
> 
> The match/watcher/target parser already returns the needed delta, so it
> is sufficient to move the xt_compat_add_offset call to a more reasonable
> location.
> 
> While at it, also get rid of the unused COMPAT iterator macros.

Applied, thanks Florian.
