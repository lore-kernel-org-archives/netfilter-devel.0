From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipt_CLUSTERIP: fix warning unused variable cn
Date: Mon, 28 Jan 2019 10:51:43 +0100
Message-ID: <20190128095143.5yxst4dn7pvodqwn@salvia>
References: <20190123114811.25388-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123114811.25388-1-anders.roxell@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 23, 2019 at 12:48:11PM +0100, Anders Roxell wrote:
> When CONFIG_PROC_FS isn't set the variable cn isn't used.
> 
> net/ipv4/netfilter/ipt_CLUSTERIP.c: In function ‘clusterip_net_exit’:
> net/ipv4/netfilter/ipt_CLUSTERIP.c:849:24: warning: unused variable ‘cn’ [-Wunused-variable]
>   struct clusterip_net *cn = clusterip_pernet(net);
>                         ^~
> 
> Rework so the variable 'cn' is declared inside "#ifdef CONFIG_PROC_FS".

Applied, thanks.
