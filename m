From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Can't build iptables (git as of today)
Date: Sun, 18 Sep 2011 15:36:18 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109181534440.20832@frira.zrqbmnf.qr>
References: <4E75E21D.6050000@nod.at> <alpine.LNX.2.01.1109181509580.16287@frira.zrqbmnf.qr> <4E75F1B4.6080307@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57941 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1IRNgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Sep 2011 09:36:19 -0400
In-Reply-To: <4E75F1B4.6080307@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-09-18 15:27, Richard Weinberger wrote:

>Am 18.09.2011 15:12, schrieb Jan Engelhardt:
>> On Sunday 2011-09-18 14:20, Richard Weinberger wrote:
>> 
>>> Hi!
>>>
>>> I'm trying to build the most recent iptables version but the build fails
>>> with:
>>>
>>> make[2]: *** No rule to make target `../extensions/libext.a', needed by
>>> `xtables-multi'.  Stop.
>>>
>>> It this a known problem?
>> 
>> Now it is; and this is the fix
>
>Not really.
>
>  CHECK    unknown symbols in .so files
>/bin/sh: line 1: ../iptables/libxtables.la: No such file or directory
>make[2]: *** [check] Error 1

>Shouldn't it be ../libxtables/libxtables.la?

Yeah, changed now. Thanks for testing.
