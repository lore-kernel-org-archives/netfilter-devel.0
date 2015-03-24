From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/2] xt_cgroups fix
Date: Tue, 24 Mar 2015 16:42:16 +0100
Message-ID: <20150324154216.GD1685@breakpoint.cc>
References: <cover.1427209409.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, daniel@zonque.org, fw@strlen.de,
	a.perevalov@samsung.com, netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47805 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950AbbCXPmZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 11:42:25 -0400
Content-Disposition: inline
In-Reply-To: <cover.1427209409.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Borkmann <daniel@iogearbox.net> wrote:
> here's a possible fix for xt_cgroups that was previously reported
> by Daniel Mack.
> 
> The first patch refactors common helpers, which is later on being
> used by the actual fix. Please see individual patches for more
> details.
> 
> I have based the changes on nf-next as they're rather big, they
> are, however, on top of Eric's a94070000388 ("netfilter: xt_socket:
> prepare for TCP_NEW_SYN_RECV support") from net-next to avoid ugly
> merge conflicts in xt_socket.
> 
> If you nevertheless think it's more suited for nf, or I should
> ignore the above conflicting commit, I'd be happy to rebase.

My main problem with these patches is that we're now paving the way
for skb->sk testing in input, i.e. doing protocol demuxing steps
in iptables modules.

E.g. why not accept similar patch for xt_owner?
What about sctp (or any other protocol) support?

I don't see anything wrong with the implementation per se but I'm afraid
we're starting down a slippery slope here.

