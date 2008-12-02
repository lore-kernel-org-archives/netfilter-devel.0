From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: sg_set_page not usable for .bss?
Date: Tue, 2 Dec 2008 01:13:34 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812020112480.19492@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812011952520.17726@fbirervta.pbzchgretzou.qr> <49345EE4.3070409@oracle.com> <alpine.LNX.1.10.0812012338270.22349@fbirervta.pbzchgretzou.qr> <20081201.161026.234536822.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: john.haxby@oracle.com, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33854 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYLBANf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:13:35 -0500
In-Reply-To: <20081201.161026.234536822.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-02 01:10, David Miller wrote:
>> On Monday 2008-12-01 23:02, John Haxby wrote:
>> >>>+	sg_init_table(sg, 2);
>> >>>+	sg_set_buf(&sg[0], data, n);
>> >>>+	strcpy(digest_password, sysrq_password);
>> >>>+	i = strlen(digest_password);
>> >>>+	sg_set_buf(&sg[1], digest_password, i);
>> >>
>> >> Could we directly use sysrq_password instead of copying it to
>> >> digest_password first?
>> >
>> > No :-)   Eventually I discovered the reason my code wasn't working
>> > boils down to the definition of sg_set_buf:
>> >
>> >   sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf))
>> >
>> > which doesn't work for sysrq_password.   I don't know why I'll
>> > double check.
>> 
>> Well, sysrq_password is in the .bss section, where as digest_password
>> is on the heap due to being kmalloc'ed. Maybe that makes a difference?
>> Someone more versed with the virtual memory layer might know.
>
>You can't use these interfaces on kernel image addresses.
>
Great :-)  So what is the best way to use the SHA1 crypto algo
with in-kernel addresses?


Jan
