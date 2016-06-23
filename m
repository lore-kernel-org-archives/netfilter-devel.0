From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PACTH nf-next] netfilter: nf_reject_ipv4: don't send tcp RST if
 the packet is non-TCP
Date: Thu, 23 Jun 2016 13:53:02 +0200
Message-ID: <20160623115302.GA23847@salvia>
References: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
 <20160620154829.GD18341@localhost.localdomain>
 <CAML_gOf0ofzsnsxP=8xW7tYfv+H91yMthLykUbOphBL0JEgJqQ@mail.gmail.com>
 <20160621190301.GI18341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@gmail.com>,
	Liping Zhang <zlpnobody@163.com>,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40702 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbcFWLxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:53:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 11BFF1C4388
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:53:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 030C8FF134
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:53:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D7588FAB57
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:53:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160621190301.GI18341@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 21, 2016 at 04:03:01PM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Jun 21, 2016 at 09:35:55AM +0800, Liping Zhang wrote:
> > For example, when tcp->rst is set, reject_ip6 will call
> > pr_debug("RST is set\n"), while there's nothing in reject_ip4.
> > 
> > IMO, these debug informations are almost useless, so there's
> > no need to add this debug info only for consistent with nf_reject_ip6.
> 
> Fair enough. Although I did the comment, I don't have a strong opinion
> on this.

I'd take a patch to get rid of those pr_debug() in nf_reject_ip6.

Thanks.
