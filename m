From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: do not dump other netns's
 conntrack entries via proc
Date: Mon, 15 Aug 2016 16:02:14 +0200
Message-ID: <20160815140214.GB22054@breakpoint.cc>
References: <1471269035-4436-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39074 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbcHOOCZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 10:02:25 -0400
Content-Disposition: inline
In-Reply-To: <1471269035-4436-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We should skip the conntracks that belong to a different namespace,
> otherwise other unrelated netns's conntrack entries will be dumped via
> /proc/net/nf_conntrack.
> 
> Fixes: 56d52d4892d0 ("netfilter: conntrack: use a single hashtable for all namespaces")
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>

Thanks for the fix.

Reviewed-by: Florian Westphal <fw@strlen.de>
