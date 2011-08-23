From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: better wording for table-full message
Date: Tue, 23 Aug 2011 15:25:03 +0200
Message-ID: <20110823132503.GE25003@Chamillionaire.breakpoint.cc>
References: <alpine.LNX.2.01.1108231507040.24849@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, hawk@diku.dk,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43746 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898Ab1HWNZK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:25:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1108231507040.24849@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> parent ad146381889371c2d1b89b27d9dc70ae257fc1c8 (v3.1-rc2-2-gad14638)
> commit 51b33b93d4c2e6c63afb177158f660fd17daf47c
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Aug 23 15:07:00 2011 +0200
> 
> netfilter: better wording for table-full message
> -				       "nf_conntrack: table full, dropping"
> -				       " packet.\n");
> +				       "nf_conntrack: table full, no new "
> +				       "CT created, packet will have "
> +				       "classification INVALID.\n");

packets seem to be dropped after all; call chain is:

nf_conntrack_in -> resolve_normal_ct -> init_conntrack -> __nf_conntrack_alloc.

AFAICS, the -ENOMEM is propagated back to nf_conntrack_in, where ret
will be set to NF_DROP.

The important point is resolve_normal_ct() return value;
on NULL the packet would be untracked.
