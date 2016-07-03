From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] xtables: Add an interval option for xtables lock wait
Date: Sun, 3 Jul 2016 11:16:53 +0200
Message-ID: <20160703091653.GA12350@salvia>
References: <1466729046-3070-1-git-send-email-subashab@codeaurora.org>
 <20160701132216.GA3252@salvia>
 <384253a17bf0b4e253fc47a93588c51c@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: subashab@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54807 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbcGCJQ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 05:16:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 95468E5A5C
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 11:16:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 858739EBA8
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 11:16:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7AC6FAD6F
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 11:16:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <384253a17bf0b4e253fc47a93588c51c@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 01, 2016 at 11:14:58AM -0600, subashab@codeaurora.org wrote:
> >I'm attaching a patch that applies on top of this.
> >
> >That I can remember, you only needed to reduce the wait interval, not
> >to make it ever larger, so I'm simplifying this so -W only takes
> >microseconds.
> >
> >I have only included some missing error check in case -W is specified
> >but -w is not.
> >
> >I can collapse this patch to yours, unless you have any concern.
> 
> Thanks Pablo. Sure, that is fine.

OK, I have applied this. Please give it another review and follow up
in case there's some fallout.

Thanks.
