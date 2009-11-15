From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset 4.1 released
Date: Sun, 15 Nov 2009 16:15:59 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911151610170.24638@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.0911112030200.25564@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37839 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZKOPPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:15:54 -0500
In-Reply-To: <alpine.DEB.2.00.0911112030200.25564@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-11-11 20:35, Jozsef Kadlecsik wrote:
>
>A minor fix and little improvement, but it worths a new release :-):
>
>Kernel part changes:
>  - Do not use init_MUTEX either (Jan Engelhardt)
>/* For the -rt branch, DECLARE_MUTEX/init_MUTEX avoided */

JFYI, Well, MUTEX really is a misnomer as it actually evaluates to 
struct semaphore rather than struct mutex. sema_init is available in 
both vanilla and rt and one may hope that the MUTEX removal spills into 
mainline sooner or later.
