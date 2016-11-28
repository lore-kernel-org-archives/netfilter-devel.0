From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: add chain to pktinfo
 structure
Date: Mon, 28 Nov 2016 01:56:49 +0100
Message-ID: <20161128005649.GA17749@breakpoint.cc>
References: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33622 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753066AbcK1A7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:59:44 -0500
Content-Disposition: inline
In-Reply-To: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch adds the chain object to the pktinfo structure. This
> potentially allow us to know what basechain this packet is walking over
> from the expression evaluation path.

... for what?  Why...?

Its not clear to me why these changes are made.  Same for patch #2.
