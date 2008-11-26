From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Wed, 26 Nov 2008 18:14:27 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811261814020.5487@fbirervta.pbzchgretzou.qr>
References: <op.uky4wc2dqigx4y@cyprus.local> <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr> <op.ukze8tjtqigx4y@cyprus.local> <alpine.LNX.1.10.0811221204080.25317@fbirervta.pbzchgretzou.qr> <op.uk6pzalwqigx4y@cyprus.local>
 <alpine.LNX.1.10.0811251841070.15844@fbirervta.pbzchgretzou.qr> <op.uk6vd0boqigx4y@cyprus.local> <alpine.LNX.1.10.0811261711080.2741@fbirervta.pbzchgretzou.qr> <492D7869.6090808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Wu <davidwu@arcturusnetworks.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49285 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYKZROa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:14:30 -0500
In-Reply-To: <492D7869.6090808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-26 17:25, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> (Patrick, try not to screw up utf-8 in the git log too often ;-)
>
> If you try not to use it at every possible opportunity ... :)

You fail it ;-)


Date:   Wed Nov 26 17:18:08 2008 +0100

    libiptc: guard chain index allocation for different malloc implementations
    
    Some libc implementations such as <265>Clibc return NULL on malloc(0).
    They are free to do that per C standard.
