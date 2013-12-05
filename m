From: Florian Westphal <fw@strlen.de>
Subject: Re: libmnl [PATCH 1/5] examples: set attr table
Date: Thu, 5 Dec 2013 15:15:32 +0100
Message-ID: <20131205141532.GG2767@breakpoint.cc>
References: <CAGCkEt1_mew78vbG88Jk79eFAuZcADMTzt0mr=t_us7fe1EUyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36540 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab3LEOPf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:15:35 -0500
Content-Disposition: inline
In-Reply-To: <CAGCkEt1_mew78vbG88Jk79eFAuZcADMTzt0mr=t_us7fe1EUyQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> Date: Thu, 7 Nov 2013 16:45:41 +0900
> Subject: [PATCH 1/5] examples: set attr table
> 
> ---
>  examples/rtnl/rtnl-route-dump.c |    4 ++++
>  1 file changed, 4 insertions(+)

Looks correct, thanks!
Would you mind reviewing the other examples as well?

examples/rtnl/rtnl-route-event.c seems to have similar problem.
