From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER try 2]: ip6t_eui64: Fixes calculation of
 Universal/Local bit
Date: Thu, 10 Jan 2008 22:40:58 -0800 (PST)
Message-ID: <20080110.224058.77440376.davem@davemloft.net>
References: <47863DA1.8090907@trash.net>
	<4786490F.5090001@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47996
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbYAKGk6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:40:58 -0500
In-Reply-To: <4786490F.5090001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 10 Jan 2008 17:34:23 +0100

> [NETFILTER]: ip6t_eui64: Fixes calculation of Universal/Local bit
> 
> RFC2464 says that the next to lowerst order bit of the first octet
> of the Interface Identifier is formed by complementing
> the Universal/Local bit of the EUI-64. But ip6t_eui64 uses OR not XOR.
> 
> Thanks Peter Ivancik for reporing this bug and posting a patch
> for it.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
