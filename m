From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: linux-next: build failure after merge of the netfilter tree
Date: Mon, 16 Apr 2018 17:51:12 -0700
Message-ID: <CAM_iQpXT2p1tQFHdRG9iZf_Wc5=H6P+0Q493k3VOLJ+fqr8GYQ@mail.gmail.com>
References: <20180417092859.358573be@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417092859.358573be@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Apr 16, 2018 at 4:28 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the netfilter tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> net/netfilter/nf_conntrack_extend.c: In function 'nf_ct_ext_
> add':
> net/netfilter/nf_conntrack_extend.c:74:2: error: implicit declaration of function 'kmemleak_not_leak' [-Werror=implicit-function-declaration]
>   kmemleak_not_leak(old);
>   ^~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
>
> Caused by commit
>
>   114aa35d06d4 ("netfilter: conntrack: silent a memory leak warning")
>
> I have added this patch for today:

Ouch, this is actually a correct fix.

Can you please send it formally or maybe Pablo can just take it directly?

Thanks!
