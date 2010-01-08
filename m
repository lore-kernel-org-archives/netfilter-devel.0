From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 00/04: netfilter fixes
Date: Fri, 08 Jan 2010 13:17:27 -0800 (PST)
Message-ID: <20100108.131727.39365817.davem@davemloft.net>
References: <20100108164204.28066.44430.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53882
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab0AHVRV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:17:21 -0500
In-Reply-To: <20100108164204.28066.44430.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Fri,  8 Jan 2010 17:42:07 +0100 (MET)

> the following patches fix a couple of bugs in netfilter and IPVS:
> 
> - use lib/gcd in IPVS
> 
> - add missing boundary checks for IPVS ioctl arguments, from Arjan
> 
> - fix an out-of-bounds read in FTP conntrack, from myself
> 
> - add missing CAP_NET_ADMIN check to ebtables, from Florian Westphal.
>   ebtables userspace uses IP RAW sockets to address ebtables, which
>   enforce CAP_NET_RAW. Any other IP socket type allows unpriviledged
>   access to the ebtables ruleset.
> 
> Please apply or pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Pulled, thanks Patrick.
