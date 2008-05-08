From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2/2]: Kconfig: default DCCP/SCTP conntrack support
 to the protocol config values
Date: Thu, 08 May 2008 01:16:15 -0700 (PDT)
Message-ID: <20080508.011615.107529780.davem@davemloft.net>
References: <48215E9A.9070501@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46443
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbYEHIQV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 May 2008 04:16:21 -0400
In-Reply-To: <48215E9A.9070501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 07 May 2008 09:47:38 +0200

> [NETFILTER]: Kconfig: default DCCP/SCTP conntrack support to the protocol config values
> 
> When conntrack and DCCP/SCTP protocols are enabled, chances are good that
> people also want DCCP/SCTP conntrack and NAT support.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks Patrick.
