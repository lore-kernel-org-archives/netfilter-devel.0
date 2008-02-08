From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/04]: Netfilter fixes
Date: Thu, 07 Feb 2008 17:57:26 -0800 (PST)
Message-ID: <20080207.175726.75445070.davem@davemloft.net>
References: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58059
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbYBHB4z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:56:55 -0500
In-Reply-To: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed,  6 Feb 2008 14:33:59 +0100 (MET)

> These patches fix a couple of bugs in netfilter: a bug in ct_extend,
> causing invalid memory accesses when DNATing a connection to a port
> using a connection tracking helper, the TCP connection reopening bug,
> causing slowdowns by dropping connection reopening attempts, and
> a typo and missing #include in xt_iprange.
> 
> Please apply, thanks.

All applied, thanks Patrick.
