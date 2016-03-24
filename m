From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: x_tables: add and use
 xt_check_entry_target
Date: Thu, 24 Mar 2016 21:18:23 +0100
Message-ID: <20160324201823.GC1937@salvia>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57578 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcCXUSc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:18:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 76BB080B13
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2301128D227
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 30EEB28D227
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458666173-24318-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 06:02:51PM +0100, Florian Westphal wrote:
> We have targets and standard targets -- the latter carries a verdict, so we
> must check the standard size as well here -- later functions access t->verdict
> which otherwise can point after the blob end.

Applied to nf, thanks.
