From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 00/11] conntrackd with libevent
Date: Wed, 23 Jan 2008 13:07:45 +0100
Message-ID: <47972E11.5040602@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37410 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbYAWMH7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:07:59 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Max,

Max Kellermann wrote:
> another patch series, some smaller fixes, and the big part is
> conntrackd with libevent.  While looking for a nice solutions for the
> "huge sorted list of alarms" scaling problem, I thought about storing
> alarms in some sort of tree.  After a quick look at libevent, I saw
> they did it exactly this way.  Let's benchmark libevent against the
> existing alarm library.  I don't think it's worth it to continue work
> on alarm.c, when well-tested code is already available in libevent.

I agree here. Using a tree should scale up better than the current alarm
hash table.

BTW, I have noticed that next release of libevent has replaced RB-tree
by a heap. One of my concerns with introducing a new library dependency
is this sort of changes as well as supporting conntrackd with way many
different versions of libevent. And probably, having people reporting
problems or different behaviours of conntrackd that are not my fault.
Don't get me wrong I have enough with bugs :). Also, I still think that
libevent is way to much since basically we would only be using their
alarm implementation. The current alarm scheduler is barely 200 lines long.

My experience is that synchronization software is a bit hard because
bugs are somehow more difficult to detect (you need a good testbed and
QA testing requires a considerable amount of time). If we introduce more
source code lines, chances to introduce bugs increase, for that reason I
try to keep it as simple as possible.

In any case, I'm going to benchmark your patch and get back to you.

> I did not update configure.ac yet to check for libevent, I am waiting
> for your benchmark results.

Never mind on the autoconf crap. Thanks for the libevent patch.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
