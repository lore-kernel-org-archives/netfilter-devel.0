From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_dup4: remove redundant checksum
 recalculation
Date: Sat, 30 Jul 2016 15:17:06 +0200
Message-ID: <20160730131706.GB29291@breakpoint.cc>
References: <1469879052-15378-1-git-send-email-zlpnobody@163.com>
 <20160730131317.GA29291@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41716 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbcG3NRK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2016 09:17:10 -0400
Content-Disposition: inline
In-Reply-To: <20160730131317.GA29291@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Liping Zhang <zlpnobody@163.com> wrote:
> > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > 
> > IP header checksum will be recalculated at ip_local_out, so
> 
> Thats only called for local packets.

Nevermind, nft_dup indeed uses ip_local_out, patch looks correct.
