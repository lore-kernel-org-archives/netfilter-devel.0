From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND] nft_flow_offload: Fix the peer route get from
 wrong daddr
Date: Wed, 9 Jan 2019 20:03:58 +0100
Message-ID: <20190109190358.o2asukctfbijhbqw@salvia>
References: <1547001611-26793-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547001611-26793-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 09, 2019 at 10:40:11AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> For nat example:
> client 1.1.1.7 ---> 2.2.2.7 which dnat to 10.0.0.7 server
> 
> When syn_rcv pkt from server it get the peer(client->server) route
> through daddr = ct->tuplehash[!dir].tuple.dst.u3.ip, the value 2.2.2.7
> is not correct in this situation. it should be 10.0.0.7
> ct->tuplehash[dir].tuple.src.u3.ip

Patch is correct, applied, thanks.
