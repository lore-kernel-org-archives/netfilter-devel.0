From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: remove redundant skb check in
 nf_conntrack_put_reasm
Date: Thu, 20 Jun 2013 11:22:59 +0200
Message-ID: <20130620092259.GD2124@breakpoint.cc>
References: <20130619142735.GA2758@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35770 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439Ab3FTJXA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:23:00 -0400
Content-Disposition: inline
In-Reply-To: <20130619142735.GA2758@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> kfree_skb already checks for skb existence - remove redundant check from
> nf_conntrack_put_reasm.

This is called for every free'd skb, in almost all cases
the condition will be false.

So I think its ok to keep this check.
