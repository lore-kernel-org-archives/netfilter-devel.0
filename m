From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: sg_set_page not usable for .bss?
Date: Tue, 2 Dec 2008 02:41:02 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812020237520.23359@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812012338270.22349@fbirervta.pbzchgretzou.qr> <20081201.161026.234536822.davem@davemloft.net> <alpine.LNX.1.10.0812020112480.19492@fbirervta.pbzchgretzou.qr> <20081201.161418.51389602.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: john.haxby@oracle.com, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45599 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYLBBlF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:41:05 -0500
In-Reply-To: <20081201.161418.51389602.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-02 01:14, David Miller wrote:
>> >> 
>> >> Well, sysrq_password is in the .bss section, where as digest_password
>> >> is on the heap due to being kmalloc'ed. Maybe that makes a difference?
>> >> Someone more versed with the virtual memory layer might know.
>> >
>> >You can't use these interfaces on kernel image addresses.
>> >
>> Great :-)  So what is the best way to use the SHA1 crypto algo
>> with in-kernel addresses?
>
>kmalloc and copy it there, or something like that, you just
>can't use in-kernel addresses, ever.
>
Yes, kmalloc is already used. But then, what sort of address
does kmalloc return, if not an address within kernelspace?
(usually >=0xc0000000 on standard i386)
