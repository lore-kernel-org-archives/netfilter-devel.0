From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset 4.0 released
Date: Wed, 11 Nov 2009 14:14:41 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911111413460.14207@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.0911102208000.23130@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0911102208000.23130@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tuesday 2009-11-10 22:15, Jozsef Kadlecsik wrote:

>Hi,
>
>I'm happy to announce the new ipset release which fixes kernel version 
>compatibility and alignment issues:
>
>Kernel part changes:
>  - Do not use DECLARE_MUTEX (compatibility fix on 2.6.31-rt, Jan
>    Engelhardt)

This is partially missing from ipset4 -- there is still a
call to init_MUTEX(...) in __init, which is not possible in -rt;
it should be sema_init(&lock, 1).
