From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: get rid of double sizeof
Date: Thu, 20 Sep 2018 18:22:56 +0200
Message-ID: <20180920162256.yrjkxw6n7q75ibom@salvia>
References: <1537359671-53720-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537359671-53720-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 19, 2018 at 08:21:11PM +0800, zhong jiang wrote:
> sizeof(sizeof()) is quite strange and does not seem to be what
> is wanted here.
> 
> The issue is detected with the help of Coccinelle.

Applied to nf, thanks.
