From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v5] netfilter: introduce l2tp match extension
Date: Fri, 3 Jan 2014 15:26:15 +0100
Message-ID: <20140103142615.GC28854@breakpoint.cc>
References: <1388757711-13712-1-git-send-email-jchapman@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43435 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbaACO0S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:26:18 -0500
Content-Disposition: inline
In-Reply-To: <1388757711-13712-1-git-send-email-jchapman@katalix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James Chapman <jchapman@katalix.com> wrote:
> Is there a way in checkentry() to check that a UDP match has also been
> specified, for the case when L2TP UDP encap is being used? This would
> ensure that specific UDP ports are matched.

xt_TCPMSS uses xt_ematch_foreach() in checkentry to verify that -p tcp
--syn was specified.
