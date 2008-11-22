From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Sat, 22 Nov 2008 12:06:33 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811221204080.25317@fbirervta.pbzchgretzou.qr>
References: <op.uky4wc2dqigx4y@cyprus.local> <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr> <op.ukze8tjtqigx4y@cyprus.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Wu <davidwu@arcturusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36609 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbYKVLGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:06:35 -0500
In-Reply-To: <op.ukze8tjtqigx4y@cyprus.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-11-21 19:35, David Wu wrote:
>
> I have built it with: (I added --disable-largefile)
> $ ../configure --host=m68k-uclinux
> --with-kernel=/home/wmq/HG-REV/5329/uCmib.devel/kernel --disable-largefile
> --disable-shared CFLAGS=-DNO_SHARED_LIBS
> on a machine (uname -a Linux ivymike 2.6.18.2-34-bigsmp #1 SMP Mon Nov 27
> 11:46:27 UTC 2006 i686 i686 i386 GNU/Linux, openSUSE 10.2 (i586) VERSION =
> 10.2)
> kernel version is 2.6.26-rc7
>
> embedded system is 32bit, building system is also 32 bit.
> I don't have a clue where goes wrong. Could you give more info about which ABI
> involved.(libc ?)

ABI includes size of types and their alignment, especially:

	sizeof(int), sizeof(long),
	alignof(int), alignof(long),
	alignof(uint32_t), alignof(uint64_t)
