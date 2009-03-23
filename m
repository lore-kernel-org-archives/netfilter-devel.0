From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: About conversion between iphdr->saddr and String-format IP
 Address
Date: Mon, 23 Mar 2009 22:18:55 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903232217190.2086@fbirervta.pbzchgretzou.qr>
References: <776021.17555.qm@web43411.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kunsheng Chen <kunsheng.chen@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55111 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZCWVS6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:18:58 -0400
In-Reply-To: <776021.17555.qm@web43411.mail.sp1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-23 22:10, Kunsheng Chen wrote:
>
>Hello everyone,
>
>I am looking for some functions to convert ip address in string format into=
> unsigned int and versa vice.
>
>Does it have some function like 'inet_addr' inside kernel for that?=A0 Basi=
>cally what I want to do is conver iphdr->s_addr into a String type, which w=
>ould give me a readable ip address for debugging.

printk(KERN_DEBUG "%pI6", &ih->saddr); /* 2.6.29+ */
printk(KERN_DEBUG NIP6_FMT, NIP6(ih->saddr)); /* older */
