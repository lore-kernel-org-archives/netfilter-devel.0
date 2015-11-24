From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 12:11:45 +0100
Message-ID: <20151124111145.GI1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124101705.GB2683@salvia>
 <20151124102707.GC1740@breakpoint.cc>
 <20151124103045.GA2947@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58607 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbbKXLLr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:11:47 -0500
Content-Disposition: inline
In-Reply-To: <20151124103045.GA2947@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If you place this in this core, we should need to export any symbol.
> 
> nf_tables-objs += nf_tables_core.o nf_tables_api.o nf_tables_trace.o

Argh, I'm a moron, I misunderstood what you meant.  Sure, that makes
sense.  Will do it this way.
