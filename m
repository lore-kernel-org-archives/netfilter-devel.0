From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Tue, 25 Nov 2008 18:45:55 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811251841070.15844@fbirervta.pbzchgretzou.qr>
References: <op.uky4wc2dqigx4y@cyprus.local> <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr> <op.ukze8tjtqigx4y@cyprus.local> <alpine.LNX.1.10.0811221204080.25317@fbirervta.pbzchgretzou.qr> <op.uk6pzalwqigx4y@cyprus.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Wu <davidwu@arcturusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55352 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYKYRp5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:45:57 -0500
In-Reply-To: <op.uk6pzalwqigx4y@cyprus.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-25 18:10, David Wu wrote:
>
> It seems that I really have a 0 chains to start. Does this include default
> chains or is it only user defined chains?

Apparently only user-defined chains. Seems ok to me.

> I have compiled on x86(openSUSE 11.0 (X86-64)VERSION = 11.0)
> (Linux cyprus 2.6.25.11-0.1-default #1 SMP 2008-07-13 20:48:28 +0200 x86_64
> x86_64 x86_64 GNU/Linux)
> and enable debug() in libiptc/libiptc.c
>
