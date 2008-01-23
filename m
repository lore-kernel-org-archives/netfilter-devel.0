From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 00/11] conntrackd with libevent
Date: Wed, 23 Jan 2008 13:50:36 +0100
Message-ID: <4797381C.5060307@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <47972E11.5040602@netfilter.org> <20080123122639.GA17074@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53700 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbYAWMux (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:50:53 -0500
In-Reply-To: <20080123122639.GA17074@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> On 2008/01/23 13:07, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> My experience is that synchronization software is a bit hard because
>> bugs are somehow more difficult to detect (you need a good testbed
>> and QA testing requires a considerable amount of time). If we
>> introduce more source code lines, chances to introduce bugs
>> increase, for that reason I try to keep it as simple as possible.
> 
> I understand, but think about how many critical bugs we fixed in this
> so simple 200 lines alarm implementation.  libevent has proven quite
> stable in the past, many daemons use it nowadays.  We not only use it
> for alarms, but also for socket events (local_server, nfnetlink) and
> for signal handlers.  There is the decision between well-tested but
> complex external code, and on the other hand untested new code, which
> is simple currently but might grow in the future.

You can blame me for those critical bugs during the development, I
should take my time before comitting untested code. We don't use that
many descriptors so conntrackd cannot exploit the main benefit of
libevent IMO.

BTW, there's an implementation of the RB-trees in the kernel under lib/
that seems to be quite stable and which has several clients. We may use
it to implement the alarm scheduler. Moreover it is GPLv2 or any later.
Although I have not investigate it further yet.

> By the way, the libevent migration is not completely finished with my
> patch, run() should be replaced with event_dispatch(), but for this,
> STATE(mode)->run() has to be rewritten to be event driven.  I believe
> this rewrite could make conntrackd even better and cleaner (and
> faster), even if we do not use libevent.

I would apply such rewrite on the fly if it improves the code and
doesn't depend on libevent for now.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
