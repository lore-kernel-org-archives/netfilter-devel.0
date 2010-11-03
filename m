From: David Miller <davem@davemloft.net>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 14:55:03 -0700 (PDT)
Message-ID: <20101103.145503.104044664.davem@davemloft.net>
References: <4CD12B8B.9090506@plouf.fr.eu.org>
	<20101103.051925.193703726.davem@davemloft.net>
	<alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org,
	hpa@zytor.com
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42726
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab0KCVyj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:54:39 -0400
In-Reply-To: <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Wed, 3 Nov 2010 13:32:42 +0100 (CET)

> On Wednesday 2010-11-03 13:19, David Miller wrote:
>>
>>> What would be a use case ?
>>
>>I thought it was painfully obvious but...  the use case is setting up
>>a rule that matches the prefix addresses and having such rules still
>>work properly when the link flaps onto a link with a different prefix
> 
> A link moving to another link.. you lost me there.
> Links usually don't move, packets do. Can you provide `ip addr`-style 
> output of Before and After, to better see what's being meant?

This issue was expressed to me by H. Peter Anvin, let's CC: him
to get some specific examples.

HPA?
