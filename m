From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: physdev: physdev-is-out should not work with
 OUTPUT chain
Date: Wed, 6 Jul 2016 11:34:29 +0200
Message-ID: <20160706093429.GA1086@salvia>
References: <1467723336-27953-1-git-send-email-liuhangbin@gmail.com>
 <20160705210012.GA9599@localhost.localdomain>
 <20160706092232.GA1019@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41283 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbcGFJei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 05:34:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0DAA91B694B
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 11:34:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EF7619EBC3
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 11:34:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 002749EBC2
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 11:34:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160706092232.GA1019@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 06, 2016 at 11:22:32AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 05, 2016 at 06:00:12PM -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, Jul 05, 2016 at 08:55:36PM +0800, Hangbin Liu wrote:
> > > physdev_mt() will check skb->nf_bridge first, which was alloced in
> > > br_nf_pre_routing. So if we want to use --physdev-out and physdev-is-out,
> > > we need to match it in FORWARD or POSTROUTING chain. physdev_mt_check()
> > > only checked physdev-out and missed physdev-is-out. Fix it and update the
> > > debug message to make it clearer.
> > > 
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > 
> > Reviewed-by: Marcelo R Leitner <marcelo.leitner@gmail.com>
> 
> Applied, thanks.

I have a batch ready for David now, so will be placing this in the
next batch actually.

Don't worry if you don't see this in the next pull request I'm going
to send.
