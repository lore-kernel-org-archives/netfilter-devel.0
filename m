From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the netfilter-next tree
Date: Tue, 2 Jan 2018 12:14:51 +1100
Message-ID: <20180102121451.3f8f792d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

After merging the netfilter-next tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

In file included from net/ipv6/af_inet6.c:45:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/route.c:87:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/ip6_input.c:34:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/ip_input.c:145:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/ip_fragment.c:50:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/ip6_output.c:44:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/ip_forward.c:37:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/ndisc.c:74:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/ip_output.c:79:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/raw.c:32:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/xfrm6_state.c:18:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/mcast.c:51:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/xfrm6_input.c:16:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/xfrm6_output.c:17:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/xfrm4_output.c:15:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/raw.c:79:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/xfrm4_input.c:17:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/ip_tunnel_core.c:30:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/sit.c:36:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/icmp.c:78:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/xfrm4_state.c:15:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/igmp.c:102:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/af_inet.c:89:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv4/ip_tunnel.c:37:0:
include/linux/netfilter_ipv4.h:29:53: warning: 'struct nf_queue_entry' declared inside parameter list
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                     ^
include/linux/netfilter_ipv4.h:29:53: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from net/ipv6/ip6_tunnel.c:40:0:
include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
  int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
                                                   ^
include/linux/netfilter_ipv6.h:38:51: warning: its scope is only this definition or declaration, which is probably not what you want

Introduced by commit

  9faa679ee7ec ("netfilter: move reroute indirection to struct nf_ipv6_ops")

-- 
Cheers,
Stephen Rothwell
