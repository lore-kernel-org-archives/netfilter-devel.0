From: Joe Perches <joe@perches.com>
Subject: [PATCH 06/18] net: Remove pr_fmt duplicate logging prefixes
Date: Thu, 10 May 2018 08:45:32 -0700
Message-ID: <d299f1920dc8935067827c0b8d2071812282043e.1525964384.git.joe@perches.com>
References: <cover.1525964381.git.joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525964381.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Using KBUILD_MODNAME as the default pr_fmt prefix caused some
duplication on logging prefixes in net/.

Remove the duplicate prefixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv4/ipconfig.c                            | 59 ++++++++++++--------------
 net/ipv4/ipmr.c                                |  2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  9 ++--
 net/ipv6/ip6mr.c                               |  2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  6 +--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |  4 +-
 net/netfilter/nf_conntrack_helper.c            | 11 ++---
 net/netfilter/nf_conntrack_standalone.c        |  2 +-
 net/socket.c                                   |  2 +-
 9 files changed, 43 insertions(+), 54 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index d839d74853fc..fcf7a4f1b09a 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -224,7 +224,7 @@ static int __init ic_open_devs(void)
 		if (!(dev->flags & IFF_LOOPBACK) && !netdev_uses_dsa(dev))
 			continue;
 		if (dev_change_flags(dev, dev->flags | IFF_UP) < 0)
-			pr_err("IP-Config: Failed to open %s\n", dev->name);
+			pr_err("Failed to open %s\n", dev->name);
 	}
 
 	for_each_netdev(&init_net, dev) {
@@ -242,8 +242,7 @@ static int __init ic_open_devs(void)
 				continue;
 			oflags = dev->flags;
 			if (dev_change_flags(dev, oflags | IFF_UP) < 0) {
-				pr_err("IP-Config: Failed to open %s\n",
-				       dev->name);
+				pr_err("Failed to open %s\n", dev->name);
 				continue;
 			}
 			if (!(d = kmalloc(sizeof(struct ic_device), GFP_KERNEL))) {
@@ -260,7 +259,7 @@ static int __init ic_open_devs(void)
 			else
 				d->xid = 0;
 			ic_proto_have_if |= able;
-			pr_debug("IP-Config: %s UP (able=%d, xid=%08x)\n",
+			pr_debug("%s UP (able=%d, xid=%08x)\n",
 				 dev->name, able, d->xid);
 		}
 	}
@@ -287,7 +286,7 @@ static int __init ic_open_devs(void)
 
 		elapsed = jiffies_to_msecs(jiffies - start);
 		wait = (CONF_CARRIER_TIMEOUT - elapsed + 500)/1000;
-		pr_info("Waiting up to %d more seconds for network.\n", wait);
+		pr_info("Waiting up to %d more seconds for network\n", wait);
 		next_msg = jiffies + msecs_to_jiffies(CONF_CARRIER_TIMEOUT/12);
 	}
 have_carrier:
@@ -297,10 +296,9 @@ static int __init ic_open_devs(void)
 
 	if (!ic_first_dev) {
 		if (user_dev_name[0])
-			pr_err("IP-Config: Device `%s' not found\n",
-			       user_dev_name);
+			pr_err("Device `%s' not found\n", user_dev_name);
 		else
-			pr_err("IP-Config: No network devices available\n");
+			pr_err("No network devices available\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -317,7 +315,7 @@ static void __init ic_close_devs(void)
 		next = d->next;
 		dev = d->dev;
 		if (d != ic_dev && !netdev_uses_dsa(dev)) {
-			pr_debug("IP-Config: Downing %s\n", dev->name);
+			pr_debug("Downing %s\n", dev->name);
 			dev_change_flags(dev, d->flags);
 		}
 		kfree(d);
@@ -351,20 +349,17 @@ static int __init ic_setup_if(void)
 	strcpy(ir.ifr_ifrn.ifrn_name, ic_dev->dev->name);
 	set_sockaddr(sin, ic_myaddr, 0);
 	if ((err = devinet_ioctl(&init_net, SIOCSIFADDR, &ir)) < 0) {
-		pr_err("IP-Config: Unable to set interface address (%d)\n",
-		       err);
+		pr_err("Unable to set interface address (%d)\n", err);
 		return -1;
 	}
 	set_sockaddr(sin, ic_netmask, 0);
 	if ((err = devinet_ioctl(&init_net, SIOCSIFNETMASK, &ir)) < 0) {
-		pr_err("IP-Config: Unable to set interface netmask (%d)\n",
-		       err);
+		pr_err("Unable to set interface netmask (%d)\n", err);
 		return -1;
 	}
 	set_sockaddr(sin, ic_myaddr | ~ic_netmask, 0);
 	if ((err = devinet_ioctl(&init_net, SIOCSIFBRDADDR, &ir)) < 0) {
-		pr_err("IP-Config: Unable to set interface broadcast address (%d)\n",
-		       err);
+		pr_err("Unable to set interface broadcast address (%d)\n", err);
 		return -1;
 	}
 	/* Handle the case where we need non-standard MTU on the boot link (a network
@@ -374,7 +369,7 @@ static int __init ic_setup_if(void)
 	if (ic_dev_mtu != 0) {
 		rtnl_lock();
 		if ((err = dev_set_mtu(ic_dev->dev, ic_dev_mtu)) < 0)
-			pr_err("IP-Config: Unable to set interface mtu to %d (%d)\n",
+			pr_err("Unable to set interface mtu to %d (%d)\n",
 			       ic_dev_mtu, err);
 		rtnl_unlock();
 	}
@@ -391,7 +386,7 @@ static int __init ic_setup_routes(void)
 
 		memset(&rm, 0, sizeof(rm));
 		if ((ic_gateway ^ ic_myaddr) & ic_netmask) {
-			pr_err("IP-Config: Gateway not on directly connected network\n");
+			pr_err("Gateway not on directly connected network\n");
 			return -1;
 		}
 		set_sockaddr((struct sockaddr_in *) &rm.rt_dst, 0, 0);
@@ -399,8 +394,7 @@ static int __init ic_setup_routes(void)
 		set_sockaddr((struct sockaddr_in *) &rm.rt_gateway, ic_gateway, 0);
 		rm.rt_flags = RTF_UP | RTF_GATEWAY;
 		if ((err = ip_rt_ioctl(&init_net, SIOCADDRT, &rm)) < 0) {
-			pr_err("IP-Config: Cannot add default route (%d)\n",
-			       err);
+			pr_err("Cannot add default route (%d)\n", err);
 			return -1;
 		}
 	}
@@ -433,12 +427,11 @@ static int __init ic_defaults(void)
 		else if (IN_CLASSC(ntohl(ic_myaddr)))
 			ic_netmask = htonl(IN_CLASSC_NET);
 		else {
-			pr_err("IP-Config: Unable to guess netmask for address %pI4\n",
+			pr_err("Unable to guess netmask for address %pI4\n",
 			       &ic_myaddr);
 			return -1;
 		}
-		pr_notice("IP-Config: Guessing netmask %pI4\n",
-			  &ic_netmask);
+		pr_notice("Guessing netmask %pI4\n", &ic_netmask);
 	}
 
 	return 0;
@@ -834,8 +827,8 @@ static void __init ic_bootp_send_if(struct ic_device *d, unsigned long jiffies_d
 	else if (dev->type == ARPHRD_FDDI)
 		b->htype = ARPHRD_ETHER;
 	else {
-		pr_warn("Unknown ARP type 0x%04x for device %s\n", dev->type,
-			dev->name);
+		pr_warn("Unknown ARP type 0x%04x for device %s\n",
+			dev->type, dev->name);
 		b->htype = dev->type; /* can cause undefined behavior */
 	}
 
@@ -1169,7 +1162,7 @@ static int __init ic_dynamic(void)
 	 * are missing, and without DHCP/BOOTP/RARP we are unable to get it.
 	 */
 	if (!ic_proto_enabled) {
-		pr_err("IP-Config: Incomplete network configuration information\n");
+		pr_err("Incomplete network configuration information\n");
 		return -1;
 	}
 
@@ -1281,7 +1274,7 @@ static int __init ic_dynamic(void)
 		return -1;
 	}
 
-	pr_info("IP-Config: Got %s answer from %pI4, my address is %pI4\n",
+	pr_info("Got %s answer from %pI4, my address is %pI4\n",
 		((ic_got_reply & IC_RARP) ? "RARP"
 		: (ic_proto_enabled & IC_USE_DHCP) ? "DHCP" : "BOOTP"),
 		&ic_addrservaddr, &ic_myaddr);
@@ -1479,7 +1472,7 @@ static int __init ip_auto_config(void)
 	if (!ic_enable)
 		return 0;
 
-	pr_debug("IP-Config: Entered.\n");
+	pr_debug("Entered\n");
 #ifdef IPCONFIG_DYNAMIC
  try_try_again:
 #endif
@@ -1529,22 +1522,22 @@ static int __init ip_auto_config(void)
 			 */
 #ifdef CONFIG_ROOT_NFS
 			if (ROOT_DEV ==  Root_NFS) {
-				pr_err("IP-Config: Retrying forever (NFS root)...\n");
+				pr_err("Retrying forever (NFS root)...\n");
 				goto try_try_again;
 			}
 #endif
 
 			if (--retries) {
-				pr_err("IP-Config: Reopening network devices...\n");
+				pr_err("Reopening network devices...\n");
 				goto try_try_again;
 			}
 
 			/* Oh, well.  At least we tried. */
-			pr_err("IP-Config: Auto-configuration of network failed\n");
+			pr_err("Auto-configuration of network failed\n");
 			return -1;
 		}
 #else /* !DYNAMIC */
-		pr_err("IP-Config: Incomplete network configuration information\n");
+		pr_err("Incomplete network configuration information\n");
 		ic_close_devs();
 		return -1;
 #endif /* IPCONFIG_DYNAMIC */
@@ -1574,7 +1567,7 @@ static int __init ip_auto_config(void)
 	/*
 	 * Clue in the operator.
 	 */
-	pr_info("IP-Config: Complete:\n");
+	pr_info("Complete:\n");
 
 	pr_info("     device=%s, hwaddr=%*phC, ipaddr=%pI4, mask=%pI4, gw=%pI4\n",
 		ic_dev->dev->name, ic_dev->dev->addr_len, ic_dev->dev->dev_addr,
@@ -1718,7 +1711,7 @@ static int __init ip_auto_config_setup(char *addrs)
 		if ((cp = strchr(ip, ':')))
 			*cp++ = '\0';
 		if (strlen(ip) > 0) {
-			pr_debug("IP-Config: Parameter #%d: `%s'\n", num, ip);
+			pr_debug("Parameter #%d: `%s'\n", num, ip);
 			switch (num) {
 			case 0:
 				if ((ic_myaddr = in_aton(ip)) == ANY)
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 38e092eafc97..3c39f526c770 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1259,7 +1259,7 @@ static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
 	ret = rhltable_insert_key(&mrt->mfc_hash, &c->cmparg, &c->_c.mnode,
 				  ipmr_rht_params);
 	if (ret) {
-		pr_err("ipmr: rhtable insert error %d\n", ret);
+		pr_err("rhtable insert error %d\n", ret);
 		ipmr_cache_free(c);
 		return ret;
 	}
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 9db988f9a4d7..5bcd97269093 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -83,8 +83,7 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 	/* Check bogus IP headers */
 	if (*dataoff > skb->len) {
-		pr_debug("nf_conntrack_ipv4: bogus IPv4 packet: "
-			 "nhoff %u, ihl %u, skblen %u\n",
+		pr_debug("bogus IPv4 packet: nhoff %u, ihl %u, skblen %u\n",
 			 nhoff, iph->ihl << 2, skb->len);
 		return -NF_ACCEPT;
 	}
@@ -268,7 +267,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		else
 			return 0;
 	}
-	pr_debug("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u.\n",
+	pr_debug("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u\n",
 		 &tuple.src.u3.ip, ntohs(tuple.src.u.tcp.port),
 		 &tuple.dst.u3.ip, ntohs(tuple.dst.u.tcp.port));
 	return -ENOENT;
@@ -432,7 +431,7 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 
 	ret = register_pernet_subsys(&ipv4_net_ops);
 	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register pernet ops\n");
+		pr_err("can't register pernet ops\n");
 		goto cleanup_sockopt;
 	}
 
@@ -443,7 +442,7 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv4);
 	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register ipv4 proto.\n");
+		pr_err("can't register ipv4 proto\n");
 		goto cleanup_l4proto;
 	}
 
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 20a419ee8000..95cc0e8634cb 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1458,7 +1458,7 @@ static int ip6mr_mfc_add(struct net *net, struct mr_table *mrt,
 	err = rhltable_insert_key(&mrt->mfc_hash, &c->cmparg, &c->_c.mnode,
 				  ip6mr_rht_params);
 	if (err) {
-		pr_err("ip6mr: rhtable insert error %d\n", err);
+		pr_err("rhtable insert error %d\n", err);
 		ip6mr_cache_free(c);
 		return err;
 	}
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 663827ee3cf8..b15cc05dedd7 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -77,7 +77,7 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 	if (skb_copy_bits(skb, nhoff + offsetof(struct ipv6hdr, nexthdr),
 			  &nexthdr, sizeof(nexthdr)) != 0) {
-		pr_debug("ip6_conntrack_core: can't get nexthdr\n");
+		pr_debug("can't get nexthdr\n");
 		return -NF_ACCEPT;
 	}
 	protoff = ipv6_skip_exthdr(skb, extoff, &nexthdr, &frag_off);
@@ -86,7 +86,7 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	 * IPv6 and possibly extensions headers, but it is tracked anyway
 	 */
 	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
-		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
+		pr_debug("can't find proto in pkt\n");
 		return -NF_ACCEPT;
 	}
 
@@ -432,7 +432,7 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register ipv6 proto.\n");
+		pr_err("can't register ipv6 proto\n");
 		goto cleanup_l4proto;
 	}
 	return ret;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index c87b48359e8f..b0d42797d003 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -111,12 +111,12 @@ static int __init nf_defrag_init(void)
 
 	ret = nf_ct_frag6_init();
 	if (ret < 0) {
-		pr_err("nf_defrag_ipv6: can't initialize frag6.\n");
+		pr_err("can't initialize frag6\n");
 		return ret;
 	}
 	ret = register_pernet_subsys(&defrag6_net_ops);
 	if (ret < 0) {
-		pr_err("nf_defrag_ipv6: can't register pernet ops\n");
+		pr_err("can't register pernet ops\n");
 		goto cleanup_frag6;
 	}
 	return ret;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 551a1eddf0fa..716017f4131b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -74,7 +74,7 @@ static int nf_conntrack_helper_init_sysctl(struct net *net)
 		register_net_sysctl(net, "net/netfilter", table);
 
 	if (!net->ct.helper_sysctl_header) {
-		pr_err("nf_conntrack_helper: can't register to sysctl.\n");
+		pr_err("can't register to sysctl\n");
 		goto out_register;
 	}
 	return 0;
@@ -202,7 +202,7 @@ nf_ct_helper_ext_add(struct nf_conn *ct,
 	if (help)
 		INIT_HLIST_HEAD(&help->expectations);
 	else
-		pr_debug("failed to add helper extension area");
+		pr_debug("failed to add helper extension area\n");
 	return help;
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
@@ -215,10 +215,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 			return NULL;
 		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
 			return NULL;
-		pr_info("nf_conntrack: default automatic helper assignment "
-			"has been turned off for security reasons and CT-based "
-			" firewall rule not found. Use the iptables CT target "
-			"to attach helpers instead.\n");
+		pr_info("default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.\n");
 		net->ct.auto_assign_helper_warned = 1;
 		return NULL;
 	}
@@ -553,7 +550,7 @@ int nf_conntrack_helper_init(void)
 
 	ret = nf_ct_extend_register(&helper_extend);
 	if (ret < 0) {
-		pr_err("nf_ct_helper: Unable to register helper extension.\n");
+		pr_err("Unable to register helper extension\n");
 		goto out_extend;
 	}
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 037fec54c850..e5de8d609135 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -720,7 +720,7 @@ static int __init nf_conntrack_standalone_init(void)
 	nf_ct_netfilter_header =
 		register_net_sysctl(&init_net, "net", nf_ct_netfilter_table);
 	if (!nf_ct_netfilter_header) {
-		pr_err("nf_conntrack: can't register to sysctl.\n");
+		pr_err("can't register to sysctl\n");
 		ret = -ENOMEM;
 		goto out_sysctl;
 	}
diff --git a/net/socket.c b/net/socket.c
index 667a7b397134..0b7ce9fd9d35 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1248,7 +1248,7 @@ int __sock_create(struct net *net, int family, int type, int protocol,
 	 */
 	sock = sock_alloc();
 	if (!sock) {
-		net_warn_ratelimited("socket: no more sockets\n");
+		net_warn_ratelimited("no more sockets\n");
 		return -ENFILE;	/* Not exactly a match, but its the
 				   closest posix thing */
 	}
-- 
2.15.0
