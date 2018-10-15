From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: cttimeout: remove set but not used
 variable 'l3num'
Date: Mon, 15 Oct 2018 13:55:23 +0200
Message-ID: <20181015115523.mw6bwoqieifrv5n4@salvia>
References: <1539137652-64831-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539137652-64831-1-git-send-email-yuehaibing@huawei.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 10, 2018 at 02:14:12AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/netfilter/nfnetlink_cttimeout.c: In function 'cttimeout_default_set':
> net/netfilter/nfnetlink_cttimeout.c:353:8: warning:
>  variable 'l3num' set but not used [-Wunused-but-set-variable]
> 
> It not used any more after
> commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping information")

Applied.
