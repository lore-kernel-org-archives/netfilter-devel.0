From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] voluntary-preempt-2.6.9-rc1-bk4-Q8
Date: Thu, 2 Sep 2004 09:46:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040902074604.GA21144@elte.hu>
References: <OF04883085.9C3535D2-ON86256F00.0065652B@raytheon.com> <20040902063335.GA17657@elte.hu> <20040902065549.GA18860@elte.hu> <1094108653.11364.26.camel@krustophenia.net> <20040902071525.GA19925@elte.hu> <1094110289.11364.32.camel@krustophenia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark_H_Johnson@raytheon.com, "K.R. Foley" <kr@cybsft.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Felipe Alfaro Solana <lkml@felipe-alfaro.com>,
	Daniel Schmitt <pnambic@unu.nu>,
	alsa-devel <alsa-devel@lists.sourceforge.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267777AbUIBHos@vger.kernel.org>
To: Lee Revell <rlrevell@joe-job.com>
Content-Disposition: inline
In-Reply-To: <1094110289.11364.32.camel@krustophenia.net>
List-Id: netfilter-devel.vger.kernel.org


* Lee Revell <rlrevell@joe-job.com> wrote:

> > these all seem to be single-packet processing latencies - it would be
> > quite hard to make those codepaths preemptible.
> 
> I suspected as much, these are not a problem.  The large latencies
> from reading the /proc filesystem are a bit worrisome (trace1.txt), I
> will report these again if they still happen with Q8.

conntrack's ct_seq ops indeed seems to have latency problems - the quick
workaround is to disable conntrack.

The reason for the latency is that ct_seq_start() does a read_lock() on
ip_conntrack_lock and only ct_seq_stop() releases it - possibly
milliseconds later. But the whole conntrack /proc code is quite flawed:

        READ_LOCK(&ip_conntrack_lock);

        if (*pos >= ip_conntrack_htable_size)
                return NULL;

        bucket = kmalloc(sizeof(unsigned int), GFP_KERNEL);
        if (!bucket) {
                return ERR_PTR(-ENOMEM);
        }
        *bucket = *pos;
        return bucket;

#1: we kmalloc(GFP_KERNEL) with a spinlock held and softirqs off - ouch!

#2: why does it do the kmalloc() anyway? It could store the position in
    the seq pointer just fine. No need to alloc an integer pointer to
    store the value in ...

#3: to fix the latency, ct_seq_show() could take the ip_conntrack_lock 
    and could check the current index against ip_conntrack_htable_size. 
    There's not much point in making this non-preemptible, there's 
    a 4K granularity anyway.

Rusty, what's going on in this code?

	Ingo
