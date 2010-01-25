From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 06/09]: netfilter: xtables: add CT target
Date: Mon, 25 Jan 2010 17:46:43 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001251745350.20906@obet.zrqbmnf.qr>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <20100125153740.15305.76374.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36632 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab0AYQqp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:46:45 -0500
In-Reply-To: <20100125153740.15305.76374.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-01-25 16:37, Patrick McHardy wrote:

>    netfilter: xtables: add CT target
>    
>    Add a new target for the raw table, which can be used to specify conntrack
>    parameters for specific connections, f.i. the conntrack helper.
>    
>    The target attaches a "template" connection tracking entry to the skb, which
>    is used by the conntrack core when initializing the new conntrack.

> include/linux/netfilter/xt_CT.h             |   13 ++
> include/net/netfilter/nf_conntrack_helper.h |    3 
> net/netfilter/Kconfig                       |    6 +
> net/netfilter/Makefile                      |    1 
> net/netfilter/nf_conntrack_helper.c         |   19 +++
> net/netfilter/xt_CT.c                       |  142 ++++++++++++++++++++++++++++
> 6 files changed, 184 insertions(+)

Is it perhaps feasible to put the xt_CT code into an already existing
.c file (e.g. xt_conntrack.c) to cut on module overhead?
