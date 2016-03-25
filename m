From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: x_tables: add and use
 xt_check_entry_target
Date: Fri, 25 Mar 2016 15:27:49 +0100
Message-ID: <20160325142749.GA1306@salvia>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-4-git-send-email-fw@strlen.de>
 <20160325114553.GA9738@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59699 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbcCYO16 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2016 10:27:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 26B55C124B
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2016 15:27:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BC93EDA8F8
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2016 15:27:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E46D1DA8FA
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2016 15:27:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160325114553.GA9738@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 25, 2016 at 12:45:53PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > +	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
> > +	    target_offset + sizeof(struct xt_standard_target) > next_offset)
> > +		return -EINVAL;
> 
> The last hunk broke CONFIG_COMPAT, it calls into check_entry() and
> casts compat_Xt_entry to Xt_entry, but for compat case
> xt_standard_target is larger than what a 32bit userspace sends us.
> 
> For now I'd suggest to not pass this to stable, I'll  rework
> the compat handlers next week to fix this properly.

OK, I'll pull this out from the nf tree and rebase.
