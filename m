From: Florian Westphal <fw@strlen.de>
Subject: Re: Needs to fix in userspace
Date: Sun, 21 Jun 2009 01:11:44 +0200
Message-ID: <20090620231144.GD31266@Chamillionaire.breakpoint.cc>
References: <alpine.DEB.2.00.0906210018560.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52009 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbZFTXLm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:11:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906210018560.11764@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> While working on netfilter/iptables in parallel, I discovered a couple of 
> elements which are missing from userspace, compared to the recent kernel:
> 
> - libxt_LED and libxt_osf are missing: the kernel supports the LED
>   target and the osf match, but the userspace doesn't
> - libxt_NFQUEUE and libxt_socket: the kernel parts support revision 0
>   and 1 while the userspace support only revision 0

Yes, right, I haven't re-sent the userspace changes for nfqueue v1 yet.
Apologies, I will resend them in a few minutes.
