From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: physdev: physdev-is-out should not work with
 OUTPUT chain
Date: Wed, 6 Jul 2016 11:22:32 +0200
Message-ID: <20160706092232.GA1019@salvia>
References: <1467723336-27953-1-git-send-email-liuhangbin@gmail.com>
 <20160705210012.GA9599@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbcGFJWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 05:22:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1D8671B694B
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 11:22:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01B109EBAA
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 11:22:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 03013FAB53
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 11:22:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160705210012.GA9599@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 06:00:12PM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Jul 05, 2016 at 08:55:36PM +0800, Hangbin Liu wrote:
> > physdev_mt() will check skb->nf_bridge first, which was alloced in
> > br_nf_pre_routing. So if we want to use --physdev-out and physdev-is-out,
> > we need to match it in FORWARD or POSTROUTING chain. physdev_mt_check()
> > only checked physdev-out and missed physdev-is-out. Fix it and update the
> > debug message to make it clearer.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Reviewed-by: Marcelo R Leitner <marcelo.leitner@gmail.com>

Applied, thanks.
