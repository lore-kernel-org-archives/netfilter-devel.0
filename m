From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/38]: Netfilter update
Date: Mon, 14 Jan 2008 23:50:24 -0800 (PST)
Message-ID: <20080114.235024.221728105.davem@davemloft.net>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36908
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYAOHuZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:50:25 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 15 Jan 2008 07:19:12 +0100 (MET)

> following is another netfilter update. The diffstat contains mostly
> noise from a MODULE_DESCRIPTION update, the main changes are:
> 
> - removal of EXPERIMENTAL dependencies for all but a few selected modules
> 
> - Updates from Jan for multiple matches and targets to use fixed types,
>   scheduling of the old version for removal in 2009
> 
> - IPv6 support for a few more matches and targets
> 
> - SCTP conntrack cleanup
> 
> - REJECT target conversion to construct TCP RSTs from scratch to properly
>   deal with IP options
> 
> - Minor cleanups and optimizations
> 
> Please apply, thanks.

All applied, thanks Patrick.
