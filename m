From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: conntrack: get rid of double sizeof
Date: Wed, 19 Sep 2018 14:40:05 +0200
Message-ID: <20180919124005.eidjr2qtryrongae@breakpoint.cc>
References: <1537359671-53720-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kadlec@blackhole.kfki.hu, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537359671-53720-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:
> sizeof(sizeof()) is quite strange and does not seem to be what
> is wanted here.

Fixes: 39215846740a9f ("netfilter: conntrack: remove nlattr_size pointer from l4proto trackers")
Acked-by: Florian Westphal <fw@strlen.de>
