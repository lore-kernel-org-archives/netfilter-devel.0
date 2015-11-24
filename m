From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 11:30:45 +0100
Message-ID: <20151124103045.GA2947@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124101705.GB2683@salvia>
 <20151124102707.GC1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbbKXKat (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:30:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C6DDFB6BAF
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:30:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADCAEDA804
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:30:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 89E0ADA867
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:30:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151124102707.GC1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:27:07AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Do you think we can place all this new netlink code in
> > net/netfilter/nf_tables_trace.c ? So we leave in the core file only
> > our classifier engine.
> > 
> > I like the attribute definition rename in nf_tables.h, but this code
> > we can probably place it away from here.
> 
> Ok, I'll see if this is doable without exporting half a dozen of
> symbols.

If you place this in this core, we should need to export any symbol.

nf_tables-objs += nf_tables_core.o nf_tables_api.o nf_tables_trace.o

And I would expect probably only functions to enable/disabling tracing
and to notify the trace via netlink.

Let me know, thanks.
