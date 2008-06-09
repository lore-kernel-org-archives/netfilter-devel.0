From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 00/11: netfilter -next update
Date: Mon, 09 Jun 2008 16:09:00 -0700 (PDT)
Message-ID: <20080609.160900.72824722.davem@davemloft.net>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53952
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbYFIXJA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:09:00 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Fri,  6 Jun 2008 17:17:40 +0200 (MEST)

> Hi Dave,
> 
> following is a first netfilter update for net-next-2.6.git, including:
> 
> - conntrack accounting fixes
> - a new IPv4/IPv6 security table for SELinux
> - IPv6 support for ebtables
> - ctnetlink cleanups and SCTP support
> - removal of ksize "abuse" in ct_extend
> - minor queuing cleanups
> 
> Please apply, thanks.

All applied and pushed out to net-next-2.6, thanks!
