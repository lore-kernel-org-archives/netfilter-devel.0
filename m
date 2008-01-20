From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2.6.24]: bridge-netfilter: fix net_device refcnt
 leaks
Date: Sun, 20 Jan 2008 06:26:04 -0800 (PST)
Message-ID: <20080120.062604.202415434.davem@davemloft.net>
References: <4793586F.10709@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42095
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753333AbYATO0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:26:00 -0500
In-Reply-To: <4793586F.10709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 20 Jan 2008 15:19:27 +0100

> This patch fixes the bridge netfilter device refcounting
> problems reported by Jan Christoph Nordholz. I'll also push
> it to -stable once it hits upstream.

Applied, thanks Patrick.
