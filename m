From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: drivers/net: Remove unnecessary skb_copy_expand
 OOM messages
Date: Thu, 15 Mar 2018 14:28:58 -0400 (EDT)
Message-ID: <20180315.142858.86991621405874666.davem@davemloft.net>
References: <782fa75ab2e443d275f19d97f2f3a073b6074517.1520867179.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        johannes@sipsolutions.net, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, kvalo@codeaurora.org,
        balbi@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: joe@perches.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <782fa75ab2e443d275f19d97f2f3a073b6074517.1520867179.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 12 Mar 2018 08:07:12 -0700

> skb_copy_expand without __GFP_NOWARN already does a dump_stack
> on OOM so these messages are redundant.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Ok, applied to net-next, thanks.
