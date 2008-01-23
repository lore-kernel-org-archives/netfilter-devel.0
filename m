From: Max Kellermann <max@duempel.org>
Subject: Re: [conntrack-utils PATCH r7285 00/11] conntrackd with libevent
Date: Wed, 23 Jan 2008 13:26:39 +0100
Message-ID: <20080123122639.GA17074@swift.blarg.de>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <47972E11.5040602@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:52347 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751130AbYAWM0l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:26:41 -0500
Content-Disposition: inline
In-Reply-To: <47972E11.5040602@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/23 13:07, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> My experience is that synchronization software is a bit hard because
> bugs are somehow more difficult to detect (you need a good testbed
> and QA testing requires a considerable amount of time). If we
> introduce more source code lines, chances to introduce bugs
> increase, for that reason I try to keep it as simple as possible.

I understand, but think about how many critical bugs we fixed in this
so simple 200 lines alarm implementation.  libevent has proven quite
stable in the past, many daemons use it nowadays.  We not only use it
for alarms, but also for socket events (local_server, nfnetlink) and
for signal handlers.  There is the decision between well-tested but
complex external code, and on the other hand untested new code, which
is simple currently but might grow in the future.

By the way, the libevent migration is not completely finished with my
patch, run() should be replaced with event_dispatch(), but for this,
STATE(mode)->run() has to be rewritten to be event driven.  I believe
this rewrite could make conntrackd even better and cleaner (and
faster), even if we do not use libevent.

Max
