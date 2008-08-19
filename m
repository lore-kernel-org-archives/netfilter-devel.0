From: David Miller <davem@davemloft.net>
Subject: Re: nf_nat 06/06: use secure_ipv4_port_ephemeral() for NAT port
 randomization
Date: Mon, 18 Aug 2008 21:32:42 -0700 (PDT)
Message-ID: <20080818.213242.123302569.davem@davemloft.net>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
	<20080818165155.18978.32057.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39653
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbYHSEcm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:32:42 -0400
In-Reply-To: <20080818165155.18978.32057.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Aug 2008 18:51:56 +0200 (MEST)

> nf_nat: use secure_ipv4_port_ephemeral() for NAT port randomization
> 
> Use incoming network tuple as seed for NAT port randomization.
> This avoids concerns of leaking net_random() bits, and also gives better
> port distribution. Don't have NAT server, compile tested only.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> [ added missing EXPORT_SYMBOL_GPL ]
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
