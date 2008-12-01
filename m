From: Jan Engelhardt <jengelh@medozas.de>
Subject: sg_set_page not usable for .bss?
Date: Mon, 1 Dec 2008 23:40:18 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812012338270.22349@fbirervta.pbzchgretzou.qr>
References: <492E926D.5020807@oracle.com> <alpine.LNX.1.10.0812011952520.17726@fbirervta.pbzchgretzou.qr> <49345EE4.3070409@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48444 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYLAWkU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:40:20 -0500
In-Reply-To: <49345EE4.3070409@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-12-01 23:02, John Haxby wrote:
>>>+	sg_init_table(sg, 2);
>>>+	sg_set_buf(&sg[0], data, n);
>>>+	strcpy(digest_password, sysrq_password);
>>>+	i = strlen(digest_password);
>>>+	sg_set_buf(&sg[1], digest_password, i);
>>
>> Could we directly use sysrq_password instead of copying it to
>> digest_password first?
>
> No :-)   Eventually I discovered the reason my code wasn't working
> boils down to the definition of sg_set_buf:
>
>   sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf))
>
> which doesn't work for sysrq_password.   I don't know why I'll
> double check.

Well, sysrq_password is in the .bss section, where as digest_password
is on the heap due to being kmalloc'ed. Maybe that makes a difference?
Someone more versed with the virtual memory layer might know.

>+static char sysrq_password[64];
>[...]
>+	digest_password = kmalloc(sizeof(sysrq_password), GFP_KERNEL);
