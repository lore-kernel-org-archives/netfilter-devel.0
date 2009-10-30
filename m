From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Fri, 30 Oct 2009 18:49:21 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0910301737320.8401@obet.zrqbmnf.qr>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200910271149.10969.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910281840390.15948@obet.zrqbmnf.qr> <200910301707.05490.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39007 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbZJ3RtR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 13:49:17 -0400
In-Reply-To: <200910301707.05490.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-10-30 17:07, Thomas Jarosch wrote:
>
>> I am in the process of annotating the entire source with the BE
>> markers and I am already getting into situations where I think
>> "there's more bswapping amiss"
>
>One more thing came to my mind: The new code transfers the data in
>network order from kernel to userspace. This will break existing 
>applications which make use of libipt_ACCOUNT like the included "iptaccount"
>tool or other applications. We should keep it in host order if possible
>or transform it inside libipt_ACCOUNT. Even if we transform it,
>it will break systems without updated libipt_ACCOUNT versions.
>
>What do you think?

I think it is a non-issue, because all three of libxt_ACCOUNT,
xt_ACCOUNT.ko and iptaccount are updated at the same time.
Especially so if you are an Xtables-addons user!

I will bump the .revision too so that the chance of accidental 
collisions is lowered.

Transfer via IPT_SO_... still uses host order.

And I went through the source and annotated it with appropriate __be 
markers plus a htonl->ntohl fix.

