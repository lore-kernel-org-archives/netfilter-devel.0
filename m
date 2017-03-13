From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: Force fake conntrack entry to be at least 8
 bytes aligned
Date: Mon, 13 Mar 2017 13:41:43 +0100
Message-ID: <20170313124143.GA26782@breakpoint.cc>
References: <20170311002526.1d21e750@gandalf.local.home>
 <20170311091222.GA24201@breakpoint.cc>
 <20170313123332.GA6790@salvia>
 <20170313123606.GA14606@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60620 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753048AbdCMMmB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:42:01 -0400
Content-Disposition: inline
In-Reply-To: <20170313123606.GA14606@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> @Florian: This is clashing with your nf-next patches to kill the fake
> conntrack. Would you mind if you resubmit these once this fix shows up
> in the nf-next.git tree.

no problem, I'll respin once its there.
