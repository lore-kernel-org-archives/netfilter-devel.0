From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] voluntary-preempt-2.6.9-rc1-bk4-Q8
Date: Fri, 03 Sep 2004 11:10:30 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1094126377.16999.49.camel@bach>
References: <OF04883085.9C3535D2-ON86256F00.0065652B@raytheon.com>
	<20040902063335.GA17657@elte.hu> <20040902065549.GA18860@elte.hu>
	<1094108653.11364.26.camel@krustophenia.net>
	<20040902071525.GA19925@elte.hu>
	<1094110289.11364.32.camel@krustophenia.net>
	<20040902074604.GA21144@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Daniel Schmitt <pnambic@unu.nu>, netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"K.R. Foley" <kr@cybsft.com>, Lee Revell <rlrevell@joe-job.com>,
	Mark_H_Johnson@raytheon.com, alsa-devel <alsa-devel@lists.sourceforge.net>,
	Felipe Alfaro Solana <lkml@felipe-alfaro.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20040902074604.GA21144@elte.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-09-02 at 17:46, Ingo Molnar wrote:
> Rusty, what's going on in this code?

Good question!  Not my code, fortunately...

> #1: we kmalloc(GFP_KERNEL) with a spinlock held and softirqs off - ouch!
> 
> #2: why does it do the kmalloc() anyway? It could store the position in
>     the seq pointer just fine. No need to alloc an integer pointer to
>     store the value in ...
> 
> #3: to fix the latency, ct_seq_show() could take the ip_conntrack_lock 
>     and could check the current index against ip_conntrack_htable_size. 
>     There's not much point in making this non-preemptible, there's 
>     a 4K granularity anyway.

The code tries to put an entire hash bucket into a single seq_read(). 
That's not going to work if the hash is really deep.  On the other hand,
not much will, and it's simple.

The lock is only needed on traversing: htable_size can't change after
init anyway, so it should be done in ct_seq_show.

Fix should be fairly simple...
Rusty.
-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell
