From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] netfilter: conntrack: remove timer from ecache
 extension
Date: Wed, 25 Jun 2014 19:13:27 +0200
Message-ID: <20140625171327.GE6328@breakpoint.cc>
References: <1402434776-23461-1-git-send-email-fw@strlen.de>
 <20140611085547.GA4131@localhost>
 <20140611092015.GA12405@breakpoint.cc>
 <20140625170636.GA16571@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57443 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964834AbaFYRN2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:13:28 -0400
Content-Disposition: inline
In-Reply-To: <20140625170636.GA16571@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch looks good to me. I made some experiments again in my
> testbed. I see no packet drops and the result of 'conntrack -L dying |
> wc -l' per second shows small peaks of entries waiting in the dying
> list to be delivered which is followed by empty lists by conntrackd at
> some point.

Thanks a lot for all the testing Pablo.

> However, perhaps the per-second watch is not enough to get
> a real evolution on how the dying list population evolves along time.

Yes, you might be right.
IFF you think its useful, we could add a counter to keep track of the
maximum length of entries that the ecache worker has seen and
export that via ctnetlink (like we do for number of conntracks, search
list restarts, etc etc).

> Anyway, I think this is good enough to get rid of the extra timer. We
> can enqueue this patch to 3.17, unless you have any objection.

No objections from me, thanks Pablo!
