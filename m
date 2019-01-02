From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] vrf: Add VRF_F_BYPASS_RCV_NF flag to vrf device
Date: Wed, 2 Jan 2019 23:19:16 +0100
Message-ID: <20190102221916.sgz3loomskxs3vnu@breakpoint.cc>
References: <1545896287-7282-1-git-send-email-wenxu@ucloud.cn>
 <5bd204fe-14d9-f118-1da2-7b91027ae55e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wenxu@ucloud.cn, netdev@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>
To: David Ahern <dsahern@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5bd204fe-14d9-f118-1da2-7b91027ae55e@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> On 12/27/18 12:38 AM, wenxu@ucloud.cn wrote:
> > nft add table firewall
> > nft add chain firewall zones { type filter hook prerouting  priority - 300 \; }
> > nft add rule firewall zones counter ct zone set iif map { "eth1" : 1, "eth2" : 2 }
> > nft add chain firewall rule-1000-ingress
> > nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
> > nft add rule firewall rule-1000-ingress counter drop
> > nft add chain firewall rule-1000-egress
> > nft add rule firewall rule-1000-egress tcp dport 22 ct state new counter drop
> > nft add rule firewall rule-1000-egress counter accept
> > 
> > nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
> > nft add rule firewall rules-all ip daddr vmap { "2.2.2.11" : jump rule-1000-ingress }
> > nft add rule firewall rules-all ct zone vmap { 1 : jump rule-1000-egress }
> 
> Bug report to the netfilter crowd: After this set of commands, 'nft list
> tables' goes into a loop over recvmsg. This is debian stretch with
> nftables from backports - version 0.9.0-1~bpo9+1

Thanks for reporting, I will have a look.
