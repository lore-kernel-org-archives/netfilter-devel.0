From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nft_ct: keep counters away from
 CONFIG_NF_CONNTRACK_LABELS
Date: Thu, 14 Jan 2016 00:38:14 +0100
Message-ID: <20160113233814.GB10507@breakpoint.cc>
References: <1452703673-4046-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33569 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbcAMXiQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 18:38:16 -0500
Content-Disposition: inline
In-Reply-To: <1452703673-4046-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This is accidental, they don't depend on the label infrastructure.

Thats exactly right, sorry :-|

Acked-by: Florian Westphal <fw@strlen.de>
