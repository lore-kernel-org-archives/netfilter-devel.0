From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.9.1 released
Date: Thu, 15 Sep 2011 16:19:13 +0100
Message-ID: <4E721771.1030900@googlemail.com>
References: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu> <4E713E0F.1050403@googlemail.com> <alpine.DEB.2.00.1109150846290.5001@blackhole.kfki.hu> <4E71CA91.5080402@googlemail.com> <alpine.DEB.2.00.1109151246320.5790@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40163 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1IOPTY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:19:24 -0400
In-Reply-To: <alpine.DEB.2.00.1109151246320.5790@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> The source tree is not supposed to be copied to the kernel tree.
>   
Right, I take it this is something new introduced with 6.9.1 as with 6.8 
I had no such problems.

> At the moment you have to hand-edit ip_set_core.c: delete
> the #ifdef .. #endif part around
>
> #ifdef IPSET_EXTERNAL_MODULE
> #include <linux/version.h>
> #endif
>
> In the next release I'll invert the logic of the condition and then it'll 
> work even when copied into the kernel tree.
>   
I'll do that, thanks Jozsef!

