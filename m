From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix ipt_ULOG panics on SMP kernels
Date: Fri, 11 Aug 2006 18:19:58 +0200
Message-ID: <44DCAE2E.8040006@trash.net>
References: <44DB5F4E.2080608@cs.princeton.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mark Huang <mlhuang@CS.Princeton.EDU>
In-Reply-To: <44DB5F4E.2080608@cs.princeton.edu>
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

Mark Huang wrote:
> I've run into the same kernel panic as these reports:
> 
> https://lists.gnumonks.org/pipermail/ulogd/2005-August/000776.html
> http://lists.netfilter.org/pipermail/netfilter/2006-January/064509.html
> https://lists.gnumonks.org/pipermail/ulogd/2006-April/000853.html
> 
> On various SMP machines. The culprit is a null ub->skb in ulog_send(). I
> believe
> that this can occur for the following reason. If ulog_timer() has
> already been
> scheduled on one CPU and is spinning on the lock, and ipt_ulog_packet()
> flushes
> the queue on another CPU by calling ulog_send() right before it exits
> (because
> the threshold is reached), there will be no skbuff when ulog_timer()
> acquires
> the lock and calls ulog_send(). Cancelling the timer in ulog_send()
> doesn't help
>   because it has already been scheduled and is running on the first CPU.
> 
> There are two solutions that I can see: re-allocate ub->skb at the end of
> ipt_ulog_packet(), just like it does toward the beginning of the
> function. But
> the problem will still happen if the allocation fails. The second solution,
> implemented by the attached patch, is to just return from ulog_send() if
> ub->skb
> is null.

Very nice catch, thank you. The second solution is perfectly fine I
think, if the skb has already been sent there is no need to do
anything, a new allocation could be useless if no further traffic
arrives. If you could add a similar fix to
net/bridge/netfilter/ebt_ulog.c and net/netfilter/nfnetlink_log.c
and send me a Signed-off-by: line I'll push it in 2.6.18. Thanks.
