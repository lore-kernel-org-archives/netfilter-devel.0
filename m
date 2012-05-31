From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] conntrackd: resolve a compiler error
Date: Thu, 31 May 2012 15:50:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205311547570.31132@frira.zrqbmnf.qr>
References: <1338465797-9797-1-git-send-email-jengelh@inai.de> <1338465797-9797-2-git-send-email-jengelh@inai.de> <20120531131945.GA961@1984> <20120531133114.GA10522@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:37454 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab2EaNuN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 09:50:13 -0400
In-Reply-To: <20120531133114.GA10522@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-05-31 15:31, Florian Westphal wrote:
>> > 
>> >   CC     parse.o
>> > parse.c: In function 'msg2ct':
>> > parse.c:258:34: error: 'NULL' undeclared (first use in this function)
>> > parse.c:258:34: note: each undeclared identifier is reported only once for each function it appears in
>> > parse.c: In function 'msg2exp':
>> > parse.c:438:16: error: 'NULL' undeclared (first use in this function)
>> 
>> Similar patch was already applied.
>> 
>> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=d44489648c1a56d543a84bbebe455227bb25cf34
>
>NULL is defined in stddef.h, stdlib.h does not necessarily pull that
>header in, too.

I believe that the C standard defines that NULL has to become available
through (at least) stdio.h. Though wikipedia may not always be authoritative,
I will use it as an excuse now: http://en.wikipedia.org/wiki/Stdio.h

So if #include <stddef.h> makes NULL available, good for glibc, but it
may not satisfy certain implementations.
