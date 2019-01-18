From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: x_tables: add xt_tunnel match
Date: Fri, 18 Jan 2019 15:18:55 +0100
Message-ID: <20190118141855.nahvtvabfysclv55@salvia>
References: <1547097368-31835-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547097368-31835-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 10, 2019 at 01:16:08PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch allows us to match on the tunnel metadata that is available
> of the packet. We can use this to validate if the packet comes from/goes
> to tunnel and the corresponding tunnel ID in the iptables.

One more question, we already have support for this in nft_tunnel.c,
would it be good if we just add the missing pieces to userspace there?
I have some patches here I need to push out for this...
