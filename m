From: Florian Westphal <fw@strlen.de>
Subject: Re: OOPS NULL pointer dereference in nf_nat_setup_info+0x471
 (reproductible, 3.14.4)
Date: Thu, 29 May 2014 20:32:53 +0200
Message-ID: <20140529183253.GA16912@breakpoint.cc>
References: <4667198.VVkvcgzEe7@luna>
 <9874911.sZTeTrmm52@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50388 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbaE2Scz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 14:32:55 -0400
Content-Disposition: inline
In-Reply-To: <9874911.sZTeTrmm52@quad>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr> wrote:
> sysctl -w net.ipv4.ip_forward=1
> sysctl -w net.netfilter.nf_conntrack_helper=0
> sysctl -w net.netfilter.nf_conntrack_acct=1
> 
> And try to connect the pptp client. Instant oops.

Q: does it not oops with _acct=0?

If that fixes it, and you have lockdep enabled in kernel
config -- can you check if

commit 223b02d923ecd7c84cf9780bb3686f455d279279
netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

helps?
