From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft_flow_offload: Fix the peer route get from wrong daddr
Date: Sat, 29 Dec 2018 13:42:17 +0100
Message-ID: <20181229124217.b6wbizgjozvexhpj@salvia>
References: <1545977698-1635-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1545977698-1635-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 28, 2018 at 02:14:58PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> For nat example:
> client 1.1.1.7 ---> 2.2.2.7 which dnat to 10.0.0.7 server
> 
> When syn_rcv pkt from server it get the peer(client->server) route
> through daddr = ct->tuplehash[!dir].tuple.dst.u3.ip, the value 2.2.2.7
> is not correct in this situation. it should be 10.0.0.7
> ct->tuplehash[dir].tuple.src.u3.ip

Please, Cc netfilter-devel@vger.kernel.org for your netfilter patches.

Thanks.
