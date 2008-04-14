From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/41]: Netfilter Update
Date: Mon, 14 Apr 2008 04:03:19 -0700 (PDT)
Message-ID: <20080414.040319.117242548.davem@davemloft.net>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33381
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYDNLDR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:03:17 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 14 Apr 2008 12:16:18 +0200 (MEST)

> following is part 2 of my netfilter patches for 2.6.26. The highlights
> are:
> 
> - ip_tables network namespace support from Alexey Dobriyan
> - some cleanups, const annotatations and boolean conversion by Jan Engelhardt
> - SCTP/UDP-Lite NAT support, DCCP conntrack/NAT support
> - nfnetlink_log support for bridge netfilter
> - some assorted cleanups
> 
> I've also uploaded a git tree to:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.26.git
> 
> Please apply or pull, thanks.

Pulled and pushed back out to net-2.6.26, thanks Patrick!
