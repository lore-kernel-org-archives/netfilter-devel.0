From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
Date: Thu, 23 Jun 2016 12:12:53 +0200
Message-ID: <20160623101253.GA9665@salvia>
References: <1464836396-15671-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464836396-15671-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 02, 2016 at 10:59:56AM +0800, Xiubo Li wrote:
> Since we cannot make sure that the 'hook_mask' will always be none
> zero here. If it equals to zero, the num_hooks will be zero too,
> and then kmalloc() will return ZERO_SIZE_PTR, which is (void *)16.
> 
> Then the following error check will fails:
>   ops = kmalloc(sizeof(*ops) * num_hooks, GFP_KERNEL);
>   if (ops == NULL)
>           return ERR_PTR(-ENOMEM);
> 
> So this patch will fix this with just doing the zero check before
> kmalloc() is called.
> 
> Maybe the case above will never happen here, but in theory.

Applied, thanks.
