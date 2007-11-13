From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/03]: bridge: fix double POSTROUTING hook
 invocation
Date: Tue, 13 Nov 2007 02:59:03 -0800 (PST)
Message-ID: <20071113.025903.07136326.davem@davemloft.net>
References: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
	<20071113105504.25336.42744.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32967
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXKMK7E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:59:04 -0500
In-Reply-To: <20071113105504.25336.42744.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 13 Nov 2007 11:55:44 +0100 (MET)

> [NETFILTER]: bridge: fix double POSTROUTING hook invocation
> 
> Packets routed between bridges have the POST_ROUTING hook invoked
> twice since bridging mistakes them for bridged packets because
> they have skb->nf_bridge set.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks Patrick.
