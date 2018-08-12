From: Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [RFC/RFT, net-next, 00/17] net: Convert neighbor tables to
 per-namespace
Date: Sun, 12 Aug 2018 09:46:58 +0300
Message-ID: <dc9cd93c-61d4-dc8c-9ba1-cd8584908ba2@virtuozzo.com>
References: <20180717120651.15748-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: dsahern@kernel.org, netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 07/17/2018 03:06 PM, dsahern@kernel.org wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Nikita Leshenko reported that neighbor entries in one namespace can
> evict neighbor entries in another. The problem is that the neighbor
> tables have entries across all namespaces without separate accounting
> and with global limits on when to scan for entries to evict.
> 
> Resolve by making the neighbor tables for ipv4, ipv6 and decnet per
> namespace and making the accounting and threshold limits per namespace.

Dear David,
I prepared own patch set to fix this problem and found your one.
It looks perfect for me, and I hope David Miller will merge it soon,
however I have found a few drawbacks:

1) I know that if net_device exist it always have correct net reference,
so dev_net(dev) will be always correct.
However I afraid that device reference itself is correct in some places.
For example, 
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -376,9 +377,10 @@ mlxsw_sp_span_entry_gretap4_parms(const struct net_device *to_dev,
 		return mlxsw_sp_span_entry_unoffloadable(sparmsp);
 
 	l3edev = mlxsw_sp_span_gretap4_route(to_dev, &saddr.addr4, &gw.addr4);
+	tbl = ipv4_neigh_table(dev_net(l3edev));
 	return mlxsw_sp_span_entry_tunnel_parms_common(l3edev, saddr, daddr, gw,
 						       tparm.iph.ttl,
-						       &arp_tbl, sparmsp);
+						       tbl, sparmsp);
 }
 
mlxsw_sp_span_entry_tunnel_parms_common() have "if (!edev)" check inside,
so it seems l3edev can be set to NULL here and lead to crash inside dev_net(l3edev).
There are few other suspicious places and I think they should be carefully re-checked.

2) modified arp_net_init() does not check return value neigh_sysctl_register() and lacks correct rollback.
It was acceptable in arp_init, because it was called only once on boot, but now it will be called 
for each new net namespace, it can have real chances to fail lead to memory crash/memory corruption.

3) modified neigh_table_init() is called many times per netns but it can panic in case failed memory allocation.
I think it should be reworked to return errors in such cases, its callers should check it and add correct rollbacks.

4) currently neigh_table_clear() always return 0, I think it makes sense to change it to return void.

Thank you,
	Vasily Averin 
