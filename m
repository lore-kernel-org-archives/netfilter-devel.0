From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: vfree during RCU
Date: Tue, 16 Nov 2010 20:14:45 +0800
Message-ID: <AANLkTi=o5bLXAfVo2FaqOgk1mMGSs8sBm2=AqKSXrP6_@mail.gmail.com>
References: <alpine.LNX.2.01.1011161307080.3591@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53995 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934352Ab0KPMPI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:15:08 -0500
Received: by fxm6 with SMTP id 6so388846fxm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Nov 2010 04:15:07 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1011161307080.3591@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 16, 2010 at 8:10 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> Hi,
>
>
> Given ruleset sizes, using kmalloc proves to be difficult currently, so
> vfree is generally used. I tried hooking that up with RCU, but quickly
> found that vfree in RCU is a bad idea. What comes to mind to solve this
> is to use an extra kthread which can tolerate sleeping. Do you know of
> ideas preferable to a cleaning-up kthread?
>

Please see kvfree().

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
