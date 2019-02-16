From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: ipt_CLUSTERIP: make symbol
 'cip_netdev_notifier' static
Date: Sat, 16 Feb 2019 10:44:13 +0100
Message-ID: <20190216094413.y6avvxz3f5krkm5c@salvia>
References: <20190216081606.91596-1-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Taehee Yoo <ap420073@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190216081606.91596-1-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Feb 16, 2019 at 08:16:06AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warnings:
> 
> net/ipv4/netfilter/ipt_CLUSTERIP.c:867:23: warning:
>  symbol 'cip_netdev_notifier' was not declared. Should it be static?

Applied, thanks.
