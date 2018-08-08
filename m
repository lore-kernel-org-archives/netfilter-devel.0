From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: nfnetlink_osf: fix using plain
 integer as NULL warning
Date: Wed, 8 Aug 2018 19:05:53 +0200
Message-ID: <20180808170553.e6icrd5uq6bdjwwx@salvia>
References: <1533698624-107304-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533698624-107304-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Aug 08, 2018 at 03:23:44AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warning:
> 
> net/netfilter/nfnetlink_osf.c:274:24: warning:
>  Using plain integer as NULL pointer

Applied, thanks.
