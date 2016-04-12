From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 00/17] netfilter: xtables: stricter ruleset validation
Date: Tue, 12 Apr 2016 23:54:44 +0200
Message-ID: <20160412215444.GA20837@salvia>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
 <20160408115818.GA6954@salvia>
 <20160408115905.GA7001@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59630 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272AbcDLVyu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:54:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 750AEE8391
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:54:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 663681B309B
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:54:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C107DFAB46
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:54:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160408115905.GA7001@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 01:59:05PM +0200, Florian Westphal wrote:
> > I'm starting to consider that, given that this has been broken since
> > day 1, we pass this through nf-next and then later on we request
> > inclusion for -stable.
> 
> Fine with me.

Florian, I'm going to send a pull request to David, then resync and
place this into nf-next. But first I'm going to send a pull request
with the little stuff I have in that tree.
