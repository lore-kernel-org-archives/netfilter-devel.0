From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_quota: Don't use aligned attribute in
 sizeof
Date: Tue, 9 Oct 2018 00:20:43 +0200
Message-ID: <20181008222043.u7vnwbnwu7fx3m44@salvia>
References: <20181006233331.13150-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181006233331.13150-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Oct 06, 2018 at 04:33:31PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> net/netfilter/xt_quota.c:47:44: warning: 'aligned' attribute ignored
> when parsing type [-Wignored-attributes]
>         BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__aligned_u64));
>                                                   ^~~~~~~~~~~~~
> 
> Use 'sizeof(__u64)' instead, as the alignment doesn't affect the size
> of the type.

Applied, thanks.
