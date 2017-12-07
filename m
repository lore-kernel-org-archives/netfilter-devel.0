From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix clusterip_net_exit build regression
Date: Thu, 7 Dec 2017 23:23:16 +0100
Message-ID: <20171207222316.GC1329@salvia>
References: <20171207132636.259066-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Xin Long <lucien.xin@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207132636.259066-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 07, 2017 at 02:26:09PM +0100, Arnd Bergmann wrote:
> The added check produces a build error when CONFIG_PROC_FS is
> disabled:
> 
> net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_net_exit':
> net/ipv4/netfilter/ipt_CLUSTERIP.c:822:28: error: 'cn' undeclared (first use in this function)
> 
> This moves the variable declaration out of the #ifdef to make it
> available to the WARN_ON_ONCE().

Applied, thanks Arnd.
