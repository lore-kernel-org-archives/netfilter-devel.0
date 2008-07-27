From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 04/06: arptables in netns for real
Date: Sat, 26 Jul 2008 17:49:11 -0700 (PDT)
Message-ID: <20080726.174911.261078172.davem@davemloft.net>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
	<20080726233711.15283.14873.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56282
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756571AbYG0AtL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 20:49:11 -0400
In-Reply-To: <20080726233711.15283.14873.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 27 Jul 2008 01:37:12 +0200 (MEST)

> netfilter: arptables in netns for real
> 
> IN, FORWARD -- grab netns from in device, OUT -- from out device.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
