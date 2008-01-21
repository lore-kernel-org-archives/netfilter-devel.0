From: Max Kellermann <max@duempel.org>
Subject: Re: conntrackd: questions about the new alarm implementation
Date: Mon, 21 Jan 2008 14:05:20 +0100
Message-ID: <20080121130520.GB29741@swift.blarg.de>
References: <20080121062059.GA3995@swift.blarg.de> <47949645.3040307@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:51956 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755009AbYAUNFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:05:21 -0500
Content-Disposition: inline
In-Reply-To: <47949645.3040307@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/21 13:55, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Max Kellermann wrote:
> > I have had a look at your new alarm.c.  I have a few questions about
> > it:
> > 
> > - Please explain why you now have 2048 (!) alarm queues, where the
> >   correct one is determined by hashing the alarm struct.  I fail to
> >   imagine how this hashing might be useful.  I can only see that it
> >   makes the code more complex and 2048 times slower - except for
> >   add_alarm(), which becomes a little bit faster, but there are only
> >   few add_alarm() invocations compared with get_next_alarm_run() and
> >   do_alarm_run().
> 
> This assumption is true for stats and sync-ftfw. However, it's not for
> the sync-alarm implementation. The previous approach sucks up CPU in
> add_alarm() with 25000 connections. Current the benchmarks report
> smoother results.

I wasn't aware that the alarm library has to scale up to so many alarm
objects.  Of course, linear search in a linked list is slow in these
dimensions, but there *has* to be a better algorithm.  I will send a
patch as soon as I have time to think about that.

Max
