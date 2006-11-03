From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/11] Reduce timer updates in __nf_ct_refresh_acct()
Date: Fri, 03 Nov 2006 14:40:11 +0100
Message-ID: <454B46BB.9070908@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.886519886@wlug.westbo.se>
	<454B3867.5070004@trash.net>
	<Pine.LNX.4.58.0611031424520.2974@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0611031424520.2974@tux.rsn.bth.se>
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

Martin Josefsson wrote:
> On Fri, 3 Nov 2006, Patrick McHardy wrote:
> 
>>BTW, the "race avoidance" strikes me as racy,
>>there are multiple locations where we simply do
>>
>>if (del_timer(...))
>>   ct->timeout.function(...)
>>
>>and expect the conntrack to be either destroyed by the
>>ct->timeout.function call or by the expiring timer.
>>But without taking ip_conntrack_lock we could have:
>>
>>CPU1 (refresh)			CPU2
>>
>>if (del_timer) [success]
>>				if (del_timer) [no success]
>>	add_timer()
>>
>>which means the conntrack won't be destroyed. Did I miss
>>something?
> 
> 
> You are absolutely correct. I discussed this with Rusty some time ago and
> he thought it was fine since we mostly aim for "best effort", but I don't
> like it either. I have a patch that adds another variant of mod_timer()
> that doesn't activate an inactive timer, and use this instead of
> del_timer()/add_timer(). This avoids this race and reduces the number of
> locks taken. I'll send this patch to you after this weekend I think.


That sounds like a good way to fix it. I think I saw that patch on the
link you sent me some time ago, IIRC it touches core kernel code, so
you should probably send the timer part seperately to lkml.
