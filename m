From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: bridge: fix missing link layer headers on
 outgoing routed packets
Date: Thu, 13 Dec 2007 09:32:46 -0800 (PST)
Message-ID: <20071213.093246.83297959.davem@davemloft.net>
References: <47616BC6.9010208@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36233
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755010AbXLMRcq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:32:46 -0500
In-Reply-To: <47616BC6.9010208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 13 Dec 2007 18:28:38 +0100

> [NETFILTER]: bridge: fix missing link layer headers on outgoing routed packets
> 
> As reported by Damien Thebault, the double POSTROUTING hook invocation
> fix caused outgoing packets routed between two bridges to appear without
> a link-layer header. The reason for this is that we're skipping the
> br_nf_post_routing hook for routed packets now and don't save the
> original link layer header, but nevertheless tries to restore it on
> output, causing corruption.
> 
> The root cause for this is that skb->nf_bridge has no clearly defined
> lifetime and is used to indicate all kind of things, but that is
> quite complicated to fix. For now simply don't touch these packets
> and handle them like packets from any other device.
> 
> Tested-by: Damien Thebault <damien.thebault@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied to net-2.6, thanks Patrick.
