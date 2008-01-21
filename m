From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd: questions about the new alarm implementation
Date: Mon, 21 Jan 2008 14:52:29 +0100
Message-ID: <4794A39D.80903@netfilter.org>
References: <20080121062059.GA3995@swift.blarg.de> <47949645.3040307@netfilter.org> <20080121130520.GB29741@swift.blarg.de> <47949BAF.6020203@netfilter.org> <20080121133313.GA32375@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59124 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbYAUNxY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:53:24 -0500
In-Reply-To: <20080121133313.GA32375@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> On 2008/01/21 14:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Sure. Current approach gives good results to my benchmarks and I can
>> make peace since it's not linear anymore ;).
> 
> It's still linear.  add_alarm() is still O(n), or better: it is
> O(n/2048) which is mathematically the same as O(n).  But you made
> everything else O(n*2048) = O(n), which is why I dislike this
> optimization - you optimized for one artificial test case, penalizing
> the majority of conntrackd users who don't have 25.000 connections.

Indeed, it's still linear, what I meant to say is that we keep n smaller
since now it depends on the number of alarms in the bucket. The
statistics users are not penalized since they never run alarms. This is
true for sync-ftfw users though which only use one alarm, probably we
can tune the alarm scheduler (ALARM_HASH_SIZE) depending on the
conntrackd working mode.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
