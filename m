From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd: questions about the new alarm implementation
Date: Mon, 21 Jan 2008 13:55:33 +0100
Message-ID: <47949645.3040307@netfilter.org>
References: <20080121062059.GA3995@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34877 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbYAUMzx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:55:53 -0500
In-Reply-To: <20080121062059.GA3995@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> I have had a look at your new alarm.c.  I have a few questions about
> it:
> 
> - Please explain why you now have 2048 (!) alarm queues, where the
>   correct one is determined by hashing the alarm struct.  I fail to
>   imagine how this hashing might be useful.  I can only see that it
>   makes the code more complex and 2048 times slower - except for
>   add_alarm(), which becomes a little bit faster, but there are only
>   few add_alarm() invocations compared with get_next_alarm_run() and
>   do_alarm_run().

This assumption is true for stats and sync-ftfw. However, it's not for
the sync-alarm implementation. The previous approach sucks up CPU in
add_alarm() with 25000 connections. Current the benchmarks report
smoother results.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
