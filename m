From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reject verdict request
 from different portid
Date: Mon, 8 Aug 2016 16:12:34 +0200
Message-ID: <20160808141234.GE20192@breakpoint.cc>
References: <1470665247-20570-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40332 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbcHHOMp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:12:45 -0400
Content-Disposition: inline
In-Reply-To: <1470665247-20570-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Like NFQNL_MSG_VERDICT_BATCH do, we should also reject the verdict
> request when the portid is not same with the initial portid(maybe
> from another process).
> 
> Fixes: 97d32cf9440d ("netfilter: nfnetlink_queue: batch verdict support")
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>

Good catch, thanks!

Reviewed-by: Florian Westphal <fw@strlen.de>
