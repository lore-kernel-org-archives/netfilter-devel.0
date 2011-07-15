From: Rick Jones <rick.jones2@hp.com>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 08:43:11 -0700
Message-ID: <4E20600F.1000907@hp.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>	<4E1F1902.9020605@student.ulg.ac.be>	<alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>	<20110714.161717.1387261665409519132.davem@davemloft.net> <4E1F7DC3.5000407@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, T.Moes@student.ulg.ac.be,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38681 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1GOPnN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:43:13 -0400
In-Reply-To: <4E1F7DC3.5000407@hp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/14/2011 04:37 PM, Rick Jones wrote:
> On 07/14/2011 04:17 PM, David Miller wrote:
>> Everyone needs to stop being in denial, now.
>
> So, does that imply there will be systems with only link-scope IP's
> reaching-out to global-scope IPs, getting their link-scope's adjusted by
> an IPv6 NAT?

The reason I ask is that getaddrinfo() in various places is being 
tweaked to not perform v6 lookups if only link-scope IPs are assigned to 
the system...

rick jones
