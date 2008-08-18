From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 01/06: Move linux/in.h and linux/in6.h inclusions outside
 of
Date: Mon, 18 Aug 2008 19:01:12 +0200
Message-ID: <48A9AAD8.9050104@trash.net>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain> <20080818165149.18978.80469.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0808181253010.3180@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYHRRBP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:01:15 -0400
In-Reply-To: <alpine.LNX.1.10.0808181253010.3180@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-08-18 12:51, Patrick McHardy wrote:
> 
>> netfilter: Move linux/in.h and linux/in6.h inclusions outside of #ifdef __KERNEL__
>>
>> netfilter.h can't be used in userspace without including linux/in.h
>> and linux/in6.h first. netfilter.h includes its own linux/in.h and
>> linux/in6.h include statements, these are stripped by make
>> headers-install because they are inside #ifdef __KERNEL__ however.
>> Move them out to fix this.
> 
> Humm - no, I do not think this is right.
> 
> 
> $ cat test2.c 
> #include <netinet/in.h>
> 
> /* simulate netfilter.h as proposed */
> #include <linux/in.h>

Hmm good point. Dave, please drop this patch.
