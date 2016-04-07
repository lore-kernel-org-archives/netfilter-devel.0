From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: Add missing tables dying and unconfirmed to
 usage output.
Date: Thu, 7 Apr 2016 19:47:48 +0200
Message-ID: <20160407174748.GA7271@salvia>
References: <1459763037-10400-1-git-send-email-mart.frauenlob@chello.at>
 <20160407094518.GA2309@salvia>
 <57069951.8080706@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34974 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbcDGRrx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:47:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 528F310078D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:47:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3BDDDDA388
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:47:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3A214DA38A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:47:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <57069951.8080706@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 07:30:57PM +0200, Mart Frauenlob wrote:
> On 07.04.2016 11:45, Pablo Neira Ayuso wrote:
> >also applied.
> >
> 
> I'd update the man page also, but I'm unsure about the wording.
> Is there a description of the tables dying and unconfirmed
> somewhere in the source? Or maybe someone can help me out with a
> brief description?

Let me give it a try:

'dying' shows the conntrack entries that have expired and that have been
destroyed by the connection tracking itself or via the conntrack
utility.

'unconfirmed' shows new entries that are not yet inserted into the
conntrack table, these entries are attached to packets that are
traversing the stack, but that did not reach the confirmation point at
the postrouting hook.

These two new tables are basically only useful for debugging purposes.
Under normal operation, it is hard to see entries in any of these two
tables.

Well, to be preciuse, there are still two "normal cases" where you
could see entries there: 1) when packets that are enqueued via
nfqueue, or 2) when conntrackd runs in event reliable mode. But these
are kind of corner cases where it is valid to see entries in the
unconfirmed table.

Feel free to reword/improve/adapt it for the manpage.
