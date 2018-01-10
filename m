From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: core: make local function
 __nf_unregister_net_hook static
Date: Wed, 10 Jan 2018 14:41:00 +0100
Message-ID: <20180110134100.byszps2seudvz66u@salvia>
References: <1515567906-188180-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515567906-188180-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 10, 2018 at 07:05:06AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warning:
> 
> net/netfilter/core.c:380:6: warning:
>  symbol '__nf_unregister_net_hook' was not declared. Should it be static?

Also applied, thanks.
