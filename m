From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix int overflow in xt_alloc_table_info()
Date: Sat, 6 Jan 2018 23:52:12 +0100
Message-ID: <20180106225212.s3xa7disqmsfw7ob@salvia>
References: <20171228084854.247843-1-dvyukov@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171228084854.247843-1-dvyukov@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 28, 2017 at 09:48:54AM +0100, Dmitry Vyukov wrote:
> syzkaller triggered OOM kills by passing ipt_replace.size = -1
> to IPT_SO_SET_REPLACE. The root cause is that SMP_ALIGN() in
> xt_alloc_table_info() causes int overflow and the size check passes
> when it should not. SMP_ALIGN() is no longer needed leftover.
> 
> Remove SMP_ALIGN() call in xt_alloc_table_info().

Applied, thanks.
