From: Patrick Schaaf <bof@bof.de>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Fri, 14 Jan 2005 09:20:12 +0100
Message-ID: <20050114082012.GA22042@oknodo.bof.de>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1105686102.7311.101.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> 	timeout: move to a 32-bit seconds counter, and use a sweep-method to
> clean up connections rather than a timer per conn.  Save 28 bytes.

I don't like sweep...

This reminds me: what about my "timer management frequency reduction"
from longtimeago? Basic points:

1) Note that the normal, tcp stream, per-packet timer usually only increases,
   and is way out in the future (for ESTABLISHED connections).
2) Meditate
3) Have a store area for the jiffies target, per conntrack, which is
   independant of the kernel timer.
4) When the timeout jiffies target is set or modified, and the kernel timer
   is not already running, start it up, as usual. Also store the jiffies
   target in the conntrack.
5) When the timeout jiffies target changes, and we have an already running
   kernel timer, compare stored jiffies target with new jiffies target:
5a) New target is smaller than old target: store new target, modify kernel
    timer, as usual.
5b) New target is larger than old target: store new target. DONE.
6) when timeout happens, compare stored jiffies target to $now:
6a) If stored target and current time match (or stored is older),
    run the timer activity we have now, i.e. destroy conntrack, usually.
6b) If the stored target is in the future, restart kernel timer
    to the target time. DO NOT fire traditional timer activity.
7) Meditate
8) Note that the normal, tcp stream, per-packet timer usually only increases,
   and is way out in the future (for ESTABLISHED connections).

We'll save the whole kernel timer modification for each packet after the first,
for all usual ESTABLISHED connections. They'll only rearm their timer once
every few days.

I had this coded up and working (for some hours, on my box). Patch must be
somewhere in the archives...

> 	ip_nat_info: use hash tree.  Save 8 bytes.
> 	tuplehash: use hash tree, put proto in status word.  Save 24 bytes.

Umm. What exactly is meant with "hash tree", here?

best regards
  Patrick
