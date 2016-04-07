From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfct parameters
Date: Thu, 7 Apr 2016 19:02:27 +0200
Message-ID: <20160407170227.GA5825@salvia>
References: <5706290C.7080000@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55875 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbcDGRCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:02:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C9891EAA8B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:02:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B9486DA391
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:02:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AB458DA38C
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:02:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5706290C.7080000@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 11:31:56AM +0200, Mart Frauenlob wrote:
> Good day,
> 
> while I'm writing bash completion code for conntrack-tools, I browsed
> through the source and found some things, that raised this questions for me
> (I'm no C developer, so limited here).
> 
> 1: Are there three undocumented parameters?
> namely: disable, default-get, default-set
> At least there are functions that do something... not sure what exactly w/
> the default-* cmds.

They set the default timeouts. They provide a replacement for the
/proc/ interface to set default conntrack protocol timeouts.

'disable' is for userspace helpers. You can disable enqueueing packets
to userspace for helper inspection.

> 2: in src/nfct-extensions/timeout.c there is:
> 
> static void
> nfct_cmd_timeout_usage(char *argv[])
> {
>     fprintf(stderr, "nfct v%s: Missing command\n"
>             "%s <list|add|delete|get|flush|set> timeout "
>             "[<parameters>, ...]\n", VERSION, argv[0]);
> }
> 
> Where a 'set' command is printed. Which is another discrepancy?
> 
> If my reading is correct, please take this mail as a bug report.

Right, we seem not to have any 'set' there.
