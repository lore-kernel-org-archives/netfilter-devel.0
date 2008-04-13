From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 12/13] Add all necessary header files - compilation fix
 for various cases
Date: Sun, 13 Apr 2008 11:35:38 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804130808320.30942@fbirervta.pbzchgretzou.qr>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <0b061f76d73e268a7dd95d036235812728b9c120.1207813085.git.jengelh@computergmbh.de> <4801986E.9070500@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40742 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYDMJfj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:35:39 -0400
In-Reply-To: <4801986E.9070500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Whoops, left this in "Drafts" :)


On Sunday 2008-04-13 07:21, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> Allow iptables to compile without a kernel source tree. This
>> implies fixing build for older kernels, such as 2.6.17 which
>> lack xt_SECMARK.h.
>
> Which version are these headers based on?

There is just one version. The file never changed since it
was initially added as v2.6.17-69-g5e6874c.

>> --- /dev/null
>> +++ b/include/linux/compiler.h
>> @@ -0,0 +1,179 @@
>
>> +#ifdef __KERNEL__
>
> Sanitized headers please. compiler.h seems wrong to include in
> iptables, which parts do we actually need?

I fixed that up in the batch I just sent.

