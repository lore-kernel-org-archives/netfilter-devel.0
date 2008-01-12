From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: bridge: fix double POST_ROUTING invocation
Date: Fri, 11 Jan 2008 18:02:45 -0800 (PST)
Message-ID: <20080111.180245.179448656.davem@davemloft.net>
References: <4787ADE8.2010902@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57112
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbYALCCp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 21:02:45 -0500
In-Reply-To: <4787ADE8.2010902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 11 Jan 2008 18:56:56 +0100

> [NETFILTER]: bridge: fix double POST_ROUTING invocation
> 
> The bridge code incorrectly causes two POST_ROUTING hook invocations
> for DNATed packets that end up on the same bridge device. This
> happens because packets with a changed destination address are passed
> to dst_output() to make them go through the neighbour output function
> again to build a new destination MAC address, before they will continue
> through the IP hooks simulated by bridge netfilter.
> 
> The resulting hook order is:
>  PREROUTING	(bridge netfilter)
>  POSTROUTING	(dst_output -> ip_output)
>  FORWARD	(bridge netfilter)
>  POSTROUTING	(bridge netfilter)
> 
> The deferred hooks used to abort the first POST_ROUTING invocation,
> but since the only thing bridge netfilter actually really wants is
> a new MAC address, we can avoid going through the IP stack completely
> by simply calling the neighbour output function directly.
> 
> Tested, reported and lots of data provided by: Damien Thebault <damien.thebault@gmail.com>
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick.
