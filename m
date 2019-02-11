From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_tunnel: Add NFTA_TUNNEL_MODE options
Date: Tue, 12 Feb 2019 00:25:33 +0100
Message-ID: <20190211232533.lv2tvyohakvr22nt@salvia>
References: <1548748277-2587-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1548748277-2587-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 29, 2019 at 03:51:17PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> nft "tunnel" expr match both the tun_info of RX and TX. This patch
> provide the NFTA_TUNNEL_MODE to individually match the tun_info of
> RX or TX.

Applied, thanks.
