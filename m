From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] NFQUEUE: add new v1 version with queue-balance
	option
Date: Fri, 5 Jun 2009 15:33:27 +0200
Message-ID: <20090605133327.GH29745@Chamillionaire.breakpoint.cc>
References: <1244164679-11032-1-git-send-email-fw@strlen.de> <1244164679-11032-3-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0906051457160.17010@fbirervta.pbzchgretzou.qr> <20090605132707.GG29745@Chamillionaire.breakpoint.cc> <alpine.LSU.2.00.0906051528200.7950@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42400 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbZFENd0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:33:26 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0906051528200.7950@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> >Hm, v1 is tied to ipv4/6 on the kernel side, thats why I wanted to make
> >this explicit here, too.
> 
> It is not needed. iptables's .family and the kernel's .family fields
> are not linked in any way. That is why libxt_length.c can have
> NFPROTO_UNSPEC even if the kernel's xt_length.c happens not to
> (because it inspects L3proto-dependent headers).

I didn't know this was common practice. Thanks for explaining, I will use
_UNSPEC as you suggested.
