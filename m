From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -nf] Revert "netfilter: bridge: query conntrack about skb
 dnat"
Date: Wed, 20 May 2015 13:44:21 +0200
Message-ID: <20150520114421.GB7622@breakpoint.cc>
References: <1432122145-20527-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59418 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbbETLoW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 May 2015 07:44:22 -0400
Content-Disposition: inline
In-Reply-To: <1432122145-20527-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> This reverts commit c055d5b03bb4cb69d349d787c9787c0383abd8b2.
> 
> There are two issues:
> 'dnat_took_place' made me think that this is related to
> -j DNAT/MASQUERADE.

I meant to write DNAT/REDIRECT :-(
