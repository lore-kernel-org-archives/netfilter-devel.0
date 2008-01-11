From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER try 2]: xt_helper: Do not bypass RCU
Date: Thu, 10 Jan 2008 22:41:42 -0800 (PST)
Message-ID: <20080110.224142.196704791.davem@davemloft.net>
References: <47863DA5.6020003@trash.net>
	<47864918.9080001@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYAKGlm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:41:42 -0500
In-Reply-To: <47864918.9080001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 10 Jan 2008 17:34:32 +0100

> [NETFILTER]: xt_helper: Do not bypass RCU
> 
> Use the @helper variable that was just obtained.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
