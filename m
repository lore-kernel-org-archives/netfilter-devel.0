From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix ipt_ULOG panics on SMP kernels
Date: Fri, 11 Aug 2006 19:13:30 +0200
Message-ID: <44DCBABA.4090207@trash.net>
References: <44DB5F4E.2080608@cs.princeton.edu> <44DCAE2E.8040006@trash.net>
	<44DCB42B.7010009@cs.princeton.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mark Huang <mlhuang@CS.Princeton.EDU>
In-Reply-To: <44DCB42B.7010009@cs.princeton.edu>
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
> Fix kernel panic on various SMP machines. The culprit is a null
> ub->skb in ulog_send(). If ulog_timer() has already been scheduled on
> one CPU and is spinning on the lock, and ipt_ulog_packet() flushes the
> queue on another CPU by calling ulog_send() right before it exits,
> there will be no skbuff when ulog_timer() acquires the lock and calls
> ulog_send(). Cancelling the timer in ulog_send() doesn't help because
> it has already been scheduled and is running on the first CPU.
> 
> Similar problem exists in ebt_ulog.c and nfnetlink_log.c.

Applied, thanks Mark.
