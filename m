From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Wed, 21 Apr 2010 15:21:09 +0200
Message-ID: <1271856071-32179-2-git-send-email-jengelh@medozas.de>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58569 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab0DUNVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:21:14 -0400
In-Reply-To: <1271856071-32179-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Netfilter traditionally used debug prints that were omitted unless
someone explicitly defined DEBUG. Recently that has no longer been the
case (see explanation in commit v2.6.30-rc2-184-g4ccb457). Switch our
pr_debug calls to pr_devel.

Cc: Bart De Schuymer <bdschuym@pandora.be>
Cc: Pablo Neira Ayusa <pablo@netfilter.org>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebt_ulog.c                |    8 +-
 net/bridge/netfilter/ebt_vlan.c                |   14 ++--
 net/bridge/netfilter/ebtables.c                |    6 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   12 ++--
 net/ipv4/netfilter/ipt_LOG.c                   |    4 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    4 +-
 net/ipv4/netfilter/ipt_NETMAP.c                |    4 +-
 net/ipv4/netfilter/ipt_REDIRECT.c              |    4 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |   28 +++---
 net/ipv4/netfilter/ipt_ah.c                    |    8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    8 +-
 net/ipv4/netfilter/nf_nat_core.c               |    6 +-
 net/ipv4/netfilter/nf_nat_ftp.c                |    4 +-
 net/ipv4/netfilter/nf_nat_h323.c               |   18 ++--
 net/ipv4/netfilter/nf_nat_helper.c             |   16 ++--
 net/ipv4/netfilter/nf_nat_irc.c                |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c               |   18 ++--
 net/ipv4/netfilter/nf_nat_proto_gre.c          |   10 +-
 net/ipv4/netfilter/nf_nat_rule.c               |    2 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    4 +-
 net/ipv6/netfilter/ip6t_LOG.c                  |    4 +-
 net/ipv6/netfilter/ip6t_REJECT.c               |   14 ++--
 net/ipv6/netfilter/ip6t_ah.c                   |   18 ++--
 net/ipv6/netfilter/ip6t_frag.c                 |   26 +++---
 net/ipv6/netfilter/ip6t_hbh.c                  |   26 +++---
 net/ipv6/netfilter/ip6t_mh.c                   |    4 +-
 net/ipv6/netfilter/ip6t_rt.c                   |   42 +++++-----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |   44 +++++-----
 net/netfilter/ipvs/ip_vs_proto.c               |    4 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c        |    4 +-
 net/netfilter/nf_conntrack_core.c              |   32 ++++----
 net/netfilter/nf_conntrack_ftp.c               |   48 ++++++------
 net/netfilter/nf_conntrack_h323_main.c         |  106 ++++++++++++------------
 net/netfilter/nf_conntrack_helper.c            |    2 +-
 net/netfilter/nf_conntrack_irc.c               |    8 +-
 net/netfilter/nf_conntrack_pptp.c              |   44 +++++-----
 net/netfilter/nf_conntrack_proto_gre.c         |   18 ++--
 net/netfilter/nf_conntrack_proto_sctp.c        |   44 +++++-----
 net/netfilter/nf_conntrack_proto_tcp.c         |   28 +++---
 net/netfilter/nf_conntrack_sane.c              |   10 +-
 net/netfilter/nf_conntrack_sip.c               |    8 +-
 net/netfilter/nf_conntrack_tftp.c              |    8 +-
 net/netfilter/nf_tproxy_core.c                 |    2 +-
 net/netfilter/x_tables.c                       |    4 +-
 net/netfilter/xt_TPROXY.c                      |    4 +-
 net/netfilter/xt_esp.c                         |    8 +-
 net/netfilter/xt_iprange.c                     |    4 +-
 net/netfilter/xt_multiport.c                   |    6 +-
 net/netfilter/xt_sctp.c                        |   12 ++--
 net/netfilter/xt_socket.c                      |    2 +-
 net/netfilter/xt_tcpudp.c                      |    8 +-
 54 files changed, 397 insertions(+), 397 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 852f37c..23a1622 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -104,13 +104,13 @@ static struct sk_buff *ulog_alloc_skb(unsigned int size)
 	n = max(size, nlbufsiz);
 	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
-		pr_debug("cannot alloc whole buffer of size %ub!\n", n);
+		pr_devel("cannot alloc whole buffer of size %ub!\n", n);
 		if (n > size) {
 			/* try to allocate only as much as we need for
 			 * current packet */
 			skb = alloc_skb(size, GFP_ATOMIC);
 			if (!skb)
-				pr_debug("cannot even allocate "
+				pr_devel("cannot even allocate "
 					 "buffer of size %ub\n", size);
 		}
 	}
@@ -138,7 +138,7 @@ static void ebt_ulog_packet(unsigned int hooknr, const struct sk_buff *skb,
 
 	size = NLMSG_SPACE(sizeof(*pm) + copy_len);
 	if (size > nlbufsiz) {
-		pr_debug("Size %Zd needed, but nlbufsiz=%d\n", size, nlbufsiz);
+		pr_devel("Size %Zd needed, but nlbufsiz=%d\n", size, nlbufsiz);
 		return;
 	}
 
@@ -212,7 +212,7 @@ unlock:
 	return;
 
 nlmsg_failure:
-	pr_debug("error during NLMSG_PUT. This should "
+	pr_devel("error during NLMSG_PUT. This should "
 		 "not happen, please report to author.\n");
 	goto unlock;
 alloc_failure:
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index bf8ae5c..b03dbb1 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -86,7 +86,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 
 	/* Is it 802.1Q frame checked? */
 	if (e->ethproto != htons(ETH_P_8021Q)) {
-		pr_debug("passed entry proto %2.4X is not 802.1Q (8100)\n",
+		pr_devel("passed entry proto %2.4X is not 802.1Q (8100)\n",
 			 ntohs(e->ethproto));
 		return -EINVAL;
 	}
@@ -94,14 +94,14 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	/* Check for bitmask range
 	 * True if even one bit is out of mask */
 	if (info->bitmask & ~EBT_VLAN_MASK) {
-		pr_debug("bitmask %2X is out of mask (%2X)\n",
+		pr_devel("bitmask %2X is out of mask (%2X)\n",
 			 info->bitmask, EBT_VLAN_MASK);
 		return -EINVAL;
 	}
 
 	/* Check for inversion flags range */
 	if (info->invflags & ~EBT_VLAN_MASK) {
-		pr_debug("inversion flags %2X is out of mask (%2X)\n",
+		pr_devel("inversion flags %2X is out of mask (%2X)\n",
 			 info->invflags, EBT_VLAN_MASK);
 		return -EINVAL;
 	}
@@ -115,7 +115,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	if (GET_BITMASK(EBT_VLAN_ID)) {
 		if (!!info->id) { /* if id!=0 => check vid range */
 			if (info->id > VLAN_GROUP_ARRAY_LEN) {
-				pr_debug("id %d is out of range (1-4096)\n",
+				pr_devel("id %d is out of range (1-4096)\n",
 					 info->id);
 				return -EINVAL;
 			}
@@ -130,7 +130,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 
 	if (GET_BITMASK(EBT_VLAN_PRIO)) {
 		if ((unsigned char) info->prio > 7) {
-			pr_debug("prio %d is out of range (0-7)\n",
+			pr_devel("prio %d is out of range (0-7)\n",
 				 info->prio);
 			return -EINVAL;
 		}
@@ -140,7 +140,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	 * if_ether.h:  ETH_ZLEN        60   -  Min. octets in frame sans FCS */
 	if (GET_BITMASK(EBT_VLAN_ENCAP)) {
 		if ((unsigned short) ntohs(info->encap) < ETH_ZLEN) {
-			pr_debug("encap frame length %d is less than "
+			pr_devel("encap frame length %d is less than "
 				 "minimal\n", ntohs(info->encap));
 			return -EINVAL;
 		}
@@ -161,7 +161,7 @@ static struct xt_match ebt_vlan_mt_reg __read_mostly = {
 
 static int __init ebt_vlan_init(void)
 {
-	pr_debug("ebtables 802.1Q extension module v" MODULE_VERS "\n");
+	pr_devel("ebtables 802.1Q extension module v" MODULE_VERS "\n");
 	return xt_register_match(&ebt_vlan_mt_reg);
 }
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1d8c2c0..3d5990b 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1738,7 +1738,7 @@ static int compat_calc_entry(const struct ebt_entry *e,
 		if (info->hook_entry[i] &&
 		    (e < (struct ebt_entry *)(base - hookptr))) {
 			newinfo->hook_entry[i] -= off;
-			pr_debug("0x%08X -> 0x%08X\n",
+			pr_devel("0x%08X -> 0x%08X\n",
 					newinfo->hook_entry[i] + off,
 					newinfo->hook_entry[i]);
 		}
@@ -2115,7 +2115,7 @@ static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
 			return ret;
 		new_offset += ret;
 		if (offsets_update && new_offset) {
-			pr_debug("change offset %d to %d\n",
+			pr_devel("change offset %d to %d\n",
 				offsets_update[i], offsets[j] + new_offset);
 			offsets_update[i] = offsets[j] + new_offset;
 		}
@@ -2233,7 +2233,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 	if (ret < 0)
 		goto out_unlock;
 
-	pr_debug("tmp.entries_size %d, kern off %d, user off %d delta %d\n",
+	pr_devel("tmp.entries_size %d, kern off %d, user off %d delta %d\n",
 		tmp.entries_size, state.buf_kern_offset, state.buf_user_offset,
 		xt_compat_calc_jump(NFPROTO_BRIDGE, tmp.entries_size));
 
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 8815d45..39d3428 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -334,12 +334,12 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
 #ifdef DEBUG
 	nf_ct_dump_tuple_ip(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
+	pr_devel("hash=%u ct_hash=%u ", hash, ct->mark);
 	if (!clusterip_responsible(cipinfo->config, hash)) {
-		pr_debug("not responsible\n");
+		pr_devel("not responsible\n");
 		return NF_DROP;
 	}
-	pr_debug("responsible\n");
+	pr_devel("responsible\n");
 
 	/* despite being received via linklayer multicast, this is
 	 * actually a unicast IP packet. TCP doesn't like PACKET_MULTICAST */
@@ -478,7 +478,7 @@ static void arp_print(struct arp_payload *payload)
 	}
 	hbuffer[--k]='\0';
 
-	pr_debug("src %pI4@%s, dst %pI4\n",
+	pr_devel("src %pI4@%s, dst %pI4\n",
 		 &payload->src_ip, hbuffer, &payload->dst_ip);
 }
 #endif
@@ -518,7 +518,7 @@ arp_mangle(unsigned int hook,
 	 * this wouldn't work, since we didn't subscribe the mcast group on
 	 * other interfaces */
 	if (c->dev != out) {
-		pr_debug("not mangling arp reply on different "
+		pr_devel("not mangling arp reply on different "
 			 "interface: cip'%s'-skb'%s'\n",
 			 c->dev->name, out->name);
 		clusterip_config_put(c);
@@ -529,7 +529,7 @@ arp_mangle(unsigned int hook,
 	memcpy(payload->src_hw, c->clustermac, arp->ar_hln);
 
 #ifdef DEBUG
-	pr_debug("mangled arp reply: ");
+	pr_devel("mangled arp reply: ");
 	arp_print(payload);
 #endif
 
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 3bd35f3..728af45 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -444,11 +444,11 @@ static int log_tg_check(const struct xt_tgchk_param *par)
 	const struct ipt_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
-		pr_debug("level %u >= 8\n", loginfo->level);
+		pr_devel("level %u >= 8\n", loginfo->level);
 		return -EINVAL;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
-		pr_debug("prefix is not null-terminated\n");
+		pr_devel("prefix is not null-terminated\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 02b1bc4..4bfb9a0 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -33,11 +33,11 @@ static int masquerade_tg_check(const struct xt_tgchk_param *par)
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
-		pr_debug("bad MAP_IPS.\n");
+		pr_devel("bad MAP_IPS.\n");
 		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
-		pr_debug("bad rangesize %u\n", mr->rangesize);
+		pr_devel("bad rangesize %u\n", mr->rangesize);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 708c7f8..6c6a64e 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -27,11 +27,11 @@ static int netmap_tg_check(const struct xt_tgchk_param *par)
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
-		pr_debug("bad MAP_IPS.\n");
+		pr_devel("bad MAP_IPS.\n");
 		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
-		pr_debug("bad rangesize %u.\n", mr->rangesize);
+		pr_devel("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 3cf1019..cba839a 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -31,11 +31,11 @@ static int redirect_tg_check(const struct xt_tgchk_param *par)
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
-		pr_debug("bad MAP_IPS.\n");
+		pr_devel("bad MAP_IPS.\n");
 		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
-		pr_debug("bad rangesize %u.\n", mr->rangesize);
+		pr_devel("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 8f60749..03fd5d5 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -89,12 +89,12 @@ static void ulog_send(unsigned int nlgroupnum)
 	ulog_buff_t *ub = &ulog_buffers[nlgroupnum];
 
 	if (timer_pending(&ub->timer)) {
-		pr_debug("ulog_send: timer was pending, deleting\n");
+		pr_devel("ulog_send: timer was pending, deleting\n");
 		del_timer(&ub->timer);
 	}
 
 	if (!ub->skb) {
-		pr_debug("ulog_send: nothing to send\n");
+		pr_devel("ulog_send: nothing to send\n");
 		return;
 	}
 
@@ -103,7 +103,7 @@ static void ulog_send(unsigned int nlgroupnum)
 		ub->lastnlh->nlmsg_type = NLMSG_DONE;
 
 	NETLINK_CB(ub->skb).dst_group = nlgroupnum + 1;
-	pr_debug("throwing %d packets to netlink group %u\n",
+	pr_devel("throwing %d packets to netlink group %u\n",
 		 ub->qlen, nlgroupnum + 1);
 	netlink_broadcast(nflognl, ub->skb, 0, nlgroupnum + 1, GFP_ATOMIC);
 
@@ -116,7 +116,7 @@ static void ulog_send(unsigned int nlgroupnum)
 /* timer function to flush queue in flushtimeout time */
 static void ulog_timer(unsigned long data)
 {
-	pr_debug("timer function called, calling ulog_send\n");
+	pr_devel("timer function called, calling ulog_send\n");
 
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
@@ -137,7 +137,7 @@ static struct sk_buff *ulog_alloc_skb(unsigned int size)
 	n = max(size, nlbufsiz);
 	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
-		pr_debug("cannot alloc whole buffer %ub!\n", n);
+		pr_devel("cannot alloc whole buffer %ub!\n", n);
 
 		if (n > size) {
 			/* try to allocate only as much as we need for
@@ -145,7 +145,7 @@ static struct sk_buff *ulog_alloc_skb(unsigned int size)
 
 			skb = alloc_skb(size, GFP_ATOMIC);
 			if (!skb)
-				pr_debug("cannot even allocate %ub\n", size);
+				pr_devel("cannot even allocate %ub\n", size);
 		}
 	}
 
@@ -196,7 +196,7 @@ static void ipt_ulog_packet(unsigned int hooknum,
 			goto alloc_failure;
 	}
 
-	pr_debug("qlen %d, qthreshold %Zu\n", ub->qlen, loginfo->qthreshold);
+	pr_devel("qlen %d, qthreshold %Zu\n", ub->qlen, loginfo->qthreshold);
 
 	/* NLMSG_PUT contains a hidden goto nlmsg_failure !!! */
 	nlh = NLMSG_PUT(ub->skb, 0, ub->qlen, ULOG_NL_EVENT,
@@ -269,9 +269,9 @@ static void ipt_ulog_packet(unsigned int hooknum,
 	return;
 
 nlmsg_failure:
-	pr_debug("error during NLMSG_PUT\n");
+	pr_devel("error during NLMSG_PUT\n");
 alloc_failure:
-	pr_debug("Error building netlink message\n");
+	pr_devel("Error building netlink message\n");
 	spin_unlock_bh(&ulog_lock);
 }
 
@@ -313,11 +313,11 @@ static int ulog_tg_check(const struct xt_tgchk_param *par)
 	const struct ipt_ulog_info *loginfo = par->targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
-		pr_debug("prefix not null-terminated\n");
+		pr_devel("prefix not null-terminated\n");
 		return -EINVAL;
 	}
 	if (loginfo->qthreshold > ULOG_MAX_QLEN) {
-		pr_debug("queue threshold %Zu > MAX_QLEN\n",
+		pr_devel("queue threshold %Zu > MAX_QLEN\n",
 			 loginfo->qthreshold);
 		return -EINVAL;
 	}
@@ -383,7 +383,7 @@ static int __init ulog_tg_init(void)
 {
 	int ret, i;
 
-	pr_debug("init module\n");
+	pr_devel("init module\n");
 
 	if (nlbufsiz > 128*1024) {
 		pr_warning("Netlink buffer has to be <= 128kB\n");
@@ -416,7 +416,7 @@ static void __exit ulog_tg_exit(void)
 	ulog_buff_t *ub;
 	int i;
 
-	pr_debug("cleanup_module\n");
+	pr_devel("cleanup_module\n");
 
 	if (nflog)
 		nf_log_unregister(&ipt_ulog_logger);
@@ -427,7 +427,7 @@ static void __exit ulog_tg_exit(void)
 	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
 		if (timer_pending(&ub->timer)) {
-			pr_debug("timer was pending, deleting\n");
+			pr_devel("timer was pending, deleting\n");
 			del_timer(&ub->timer);
 		}
 
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 9f98102..bce7efc 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -23,10 +23,10 @@ static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
 	bool r;
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
+	pr_devel("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
 		 invert ? '!' : ' ', min, spi, max);
 	r=(spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
+	pr_devel(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -45,7 +45,7 @@ static bool ah_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil AH tinygram.\n");
+		pr_devel("Dropping evil AH tinygram.\n");
 		*par->hotdrop = true;
 		return 0;
 	}
@@ -61,7 +61,7 @@ static int ah_mt_check(const struct xt_mtchk_param *par)
 
 	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
-		pr_debug("unknown flags %X\n", ahinfo->invflags);
+		pr_devel("unknown flags %X\n", ahinfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 2bb1f87..130fea9 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -257,12 +257,12 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 
 	/* We only do TCP and SCTP at the moment: is there a better way? */
 	if (sk->sk_protocol != IPPROTO_TCP && sk->sk_protocol != IPPROTO_SCTP) {
-		pr_debug("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
+		pr_devel("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
 		return -ENOPROTOOPT;
 	}
 
 	if ((unsigned int) *len < sizeof(struct sockaddr_in)) {
-		pr_debug("SO_ORIGINAL_DST: len %d not %Zu\n",
+		pr_devel("SO_ORIGINAL_DST: len %d not %Zu\n",
 			 *len, sizeof(struct sockaddr_in));
 		return -EINVAL;
 	}
@@ -279,7 +279,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 			.tuple.dst.u3.ip;
 		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
 
-		pr_debug("SO_ORIGINAL_DST: %pI4 %u\n",
+		pr_devel("SO_ORIGINAL_DST: %pI4 %u\n",
 			 &sin.sin_addr.s_addr, ntohs(sin.sin_port));
 		nf_ct_put(ct);
 		if (copy_to_user(user, &sin, sizeof(sin)) != 0)
@@ -287,7 +287,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		else
 			return 0;
 	}
-	pr_debug("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u.\n",
+	pr_devel("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u.\n",
 		 &tuple.src.u3.ip, ntohs(tuple.src.u.tcp.port),
 		 &tuple.dst.u3.ip, ntohs(tuple.dst.u.tcp.port));
 	return -ENOENT;
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 7404bde..e710ff2 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -105,7 +105,7 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	if (ct->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new) ||
 	    !valid_new[ct->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
-		pr_debug("icmp: can't create new conn with type %u\n",
+		pr_devel("icmp: can't create new conn with type %u\n",
 			 ct->tuplehash[0].tuple.dst.u.icmp.type);
 		nf_ct_dump_tuple_ip(&ct->tuplehash[0].tuple);
 		return false;
@@ -131,7 +131,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 			       skb_network_offset(skb) + ip_hdrlen(skb)
 						       + sizeof(struct icmphdr),
 			       PF_INET, &origtuple)) {
-		pr_debug("icmp_error_message: failed to get tuple\n");
+		pr_devel("icmp_error_message: failed to get tuple\n");
 		return -NF_ACCEPT;
 	}
 
@@ -142,7 +142,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	   been preserved inside the ICMP. */
 	if (!nf_ct_invert_tuple(&innertuple, &origtuple,
 				&nf_conntrack_l3proto_ipv4, innerproto)) {
-		pr_debug("icmp_error_message: no match\n");
+		pr_devel("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
 	}
 
@@ -150,7 +150,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 
 	h = nf_conntrack_find_get(net, zone, &innertuple);
 	if (!h) {
-		pr_debug("icmp_error_message: no match\n");
+		pr_devel("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 4f8bddb..330acae 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -244,7 +244,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (maniptype == IP_NAT_MANIP_SRC &&
 	    !(range->flags & IP_NAT_RANGE_PROTO_RANDOM)) {
 		if (find_appropriate_src(net, zone, orig_tuple, tuple, range)) {
-			pr_debug("get_unique_tuple: Found current src map\n");
+			pr_devel("get_unique_tuple: Found current src map\n");
 			if (!nf_nat_used_tuple(tuple, ct))
 				return;
 		}
@@ -294,7 +294,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (!nat) {
 		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
 		if (nat == NULL) {
-			pr_debug("failed to add NAT extension\n");
+			pr_devel("failed to add NAT extension\n");
 			return NF_ACCEPT;
 		}
 	}
@@ -463,7 +463,7 @@ int nf_nat_icmp_reply_translation(struct nf_conn *ct,
 			return 0;
 	}
 
-	pr_debug("icmp_reply_translation: translating error %p manip %u "
+	pr_devel("icmp_reply_translation: translating error %p manip %u "
 		 "dir %s\n", skb, manip,
 		 dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
 
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
index 86e0e84..ef736ab 100644
--- a/net/ipv4/netfilter/nf_nat_ftp.c
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -66,7 +66,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	char buffer[sizeof("|1|255.255.255.255|65535|")];
 	unsigned int buflen;
 
-	pr_debug("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
+	pr_devel("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
 
 	/* Connection will come from wherever this packet goes, hence !dir */
 	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
@@ -91,7 +91,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	if (!buflen)
 		goto out;
 
-	pr_debug("calling nf_nat_mangle_tcp_packet\n");
+	pr_devel("calling nf_nat_mangle_tcp_packet\n");
 
 	if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo, matchoff,
 				      matchlen, buffer, buflen))
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index d4c0618..827d8f6 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -118,7 +118,7 @@ static int set_sig_addr(struct sk_buff *skb, struct nf_conn *ct,
 				    (ntohl(addr.ip) & 0xff000000) == 0x7f000000)
 					i = 0;
 
-				pr_debug("nf_nat_ras: set signal address %pI4:%hu->%pI4:%hu\n",
+				pr_devel("nf_nat_ras: set signal address %pI4:%hu->%pI4:%hu\n",
 					 &addr.ip, port,
 					 &ct->tuplehash[!dir].tuple.dst.u3.ip,
 					 info->sig_port[!dir]);
@@ -129,7 +129,7 @@ static int set_sig_addr(struct sk_buff *skb, struct nf_conn *ct,
 			} else if (addr.ip == ct->tuplehash[dir].tuple.dst.u3.ip &&
 				   port == info->sig_port[dir]) {
 				/* GK->GW */
-				pr_debug("nf_nat_ras: set signal address %pI4:%hu->%pI4:%hu\n",
+				pr_devel("nf_nat_ras: set signal address %pI4:%hu->%pI4:%hu\n",
 					 &addr.ip, port,
 					 &ct->tuplehash[!dir].tuple.src.u3.ip,
 					 info->sig_port[!dir]);
@@ -159,7 +159,7 @@ static int set_ras_addr(struct sk_buff *skb, struct nf_conn *ct,
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port) &&
 		    addr.ip == ct->tuplehash[dir].tuple.src.u3.ip &&
 		    port == ct->tuplehash[dir].tuple.src.u.udp.port) {
-			pr_debug("nf_nat_ras: set rasAddress %pI4:%hu->%pI4:%hu\n",
+			pr_devel("nf_nat_ras: set rasAddress %pI4:%hu->%pI4:%hu\n",
 				 &addr.ip, ntohs(port),
 				 &ct->tuplehash[!dir].tuple.dst.u3.ip,
 				 ntohs(ct->tuplehash[!dir].tuple.dst.u.udp.port));
@@ -253,12 +253,12 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	/* Success */
-	pr_debug("nf_nat_h323: expect RTP %pI4:%hu->%pI4:%hu\n",
+	pr_devel("nf_nat_h323: expect RTP %pI4:%hu->%pI4:%hu\n",
 		 &rtp_exp->tuple.src.u3.ip,
 		 ntohs(rtp_exp->tuple.src.u.udp.port),
 		 &rtp_exp->tuple.dst.u3.ip,
 		 ntohs(rtp_exp->tuple.dst.u.udp.port));
-	pr_debug("nf_nat_h323: expect RTCP %pI4:%hu->%pI4:%hu\n",
+	pr_devel("nf_nat_h323: expect RTCP %pI4:%hu->%pI4:%hu\n",
 		 &rtcp_exp->tuple.src.u3.ip,
 		 ntohs(rtcp_exp->tuple.src.u.udp.port),
 		 &rtcp_exp->tuple.dst.u3.ip,
@@ -303,7 +303,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 		return -1;
 	}
 
-	pr_debug("nf_nat_h323: expect T.120 %pI4:%hu->%pI4:%hu\n",
+	pr_devel("nf_nat_h323: expect T.120 %pI4:%hu->%pI4:%hu\n",
 		 &exp->tuple.src.u3.ip,
 		 ntohs(exp->tuple.src.u.tcp.port),
 		 &exp->tuple.dst.u3.ip,
@@ -357,7 +357,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 		return -1;
 	}
 
-	pr_debug("nf_nat_q931: expect H.245 %pI4:%hu->%pI4:%hu\n",
+	pr_devel("nf_nat_q931: expect H.245 %pI4:%hu->%pI4:%hu\n",
 		 &exp->tuple.src.u3.ip,
 		 ntohs(exp->tuple.src.u.tcp.port),
 		 &exp->tuple.dst.u3.ip,
@@ -451,7 +451,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	/* Success */
-	pr_debug("nf_nat_ras: expect Q.931 %pI4:%hu->%pI4:%hu\n",
+	pr_devel("nf_nat_ras: expect Q.931 %pI4:%hu->%pI4:%hu\n",
 		 &exp->tuple.src.u3.ip,
 		 ntohs(exp->tuple.src.u.tcp.port),
 		 &exp->tuple.dst.u3.ip,
@@ -520,7 +520,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	/* Success */
-	pr_debug("nf_nat_q931: expect Call Forwarding %pI4:%hu->%pI4:%hu\n",
+	pr_devel("nf_nat_q931: expect Call Forwarding %pI4:%hu->%pI4:%hu\n",
 		 &exp->tuple.src.u3.ip,
 		 ntohs(exp->tuple.src.u.tcp.port),
 		 &exp->tuple.dst.u3.ip,
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 4a0c6b5..6981402 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -30,7 +30,7 @@
 #include <net/netfilter/nf_nat_helper.h>
 
 #define DUMP_OFFSET(x) \
-	pr_debug("offset_before=%d, offset_after=%d, correction_pos=%u\n", \
+	pr_devel("offset_before=%d, offset_after=%d, correction_pos=%u\n", \
 		 x->offset_before, x->offset_after, x->correction_pos);
 
 static DEFINE_SPINLOCK(nf_nat_seqofs_lock);
@@ -46,10 +46,10 @@ adjust_tcp_sequence(u32 seq,
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_seq *this_way = &nat->seq[dir];
 
-	pr_debug("adjust_tcp_sequence: seq = %u, sizediff = %d\n",
+	pr_devel("adjust_tcp_sequence: seq = %u, sizediff = %d\n",
 		 seq, sizediff);
 
-	pr_debug("adjust_tcp_sequence: Seq_offset before: ");
+	pr_devel("adjust_tcp_sequence: Seq_offset before: ");
 	DUMP_OFFSET(this_way);
 
 	spin_lock_bh(&nf_nat_seqofs_lock);
@@ -66,7 +66,7 @@ adjust_tcp_sequence(u32 seq,
 	}
 	spin_unlock_bh(&nf_nat_seqofs_lock);
 
-	pr_debug("adjust_tcp_sequence: Seq_offset after: ");
+	pr_devel("adjust_tcp_sequence: Seq_offset after: ");
 	DUMP_OFFSET(this_way);
 }
 
@@ -116,11 +116,11 @@ static void mangle_contents(struct sk_buff *skb,
 
 	/* update skb info */
 	if (rep_len > match_len) {
-		pr_debug("nf_nat_mangle_packet: Extending packet by "
+		pr_devel("nf_nat_mangle_packet: Extending packet by "
 			 "%u from %u bytes\n", rep_len - match_len, skb->len);
 		skb_put(skb, rep_len - match_len);
 	} else {
-		pr_debug("nf_nat_mangle_packet: Shrinking packet from "
+		pr_devel("nf_nat_mangle_packet: Shrinking packet from "
 			 "%u from %u bytes\n", match_len - rep_len, skb->len);
 		__skb_trim(skb, skb->len + rep_len - match_len);
 	}
@@ -331,7 +331,7 @@ sack_adjust(struct sk_buff *skb,
 			new_end_seq = htonl(ntohl(sack->end_seq)
 				      - natseq->offset_before);
 
-		pr_debug("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
+		pr_devel("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
 			 ntohl(sack->start_seq), new_start_seq,
 			 ntohl(sack->end_seq), new_end_seq);
 
@@ -429,7 +429,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, 0);
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->ack_seq, newack, 0);
 
-	pr_debug("Adjusting sequence number from %u->%u, ack from %u->%u\n",
+	pr_devel("Adjusting sequence number from %u->%u, ack from %u->%u\n",
 		 ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
 		 ntohl(newack));
 
diff --git a/net/ipv4/netfilter/nf_nat_irc.c b/net/ipv4/netfilter/nf_nat_irc.c
index ea83a88..641a624 100644
--- a/net/ipv4/netfilter/nf_nat_irc.c
+++ b/net/ipv4/netfilter/nf_nat_irc.c
@@ -55,7 +55,7 @@ static unsigned int help(struct sk_buff *skb,
 
 	ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
 	sprintf(buffer, "%u %u", ip, port);
-	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
+	pr_devel("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
 		 buffer, &ip, port);
 
 	ret = nf_nat_mangle_tcp_packet(skb, exp->master, ctinfo,
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 4c06003..956d6c1 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -54,7 +54,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 
 	/* And here goes the grand finale of corrosion... */
 	if (exp->dir == IP_CT_DIR_ORIGINAL) {
-		pr_debug("we are PNS->PAC\n");
+		pr_devel("we are PNS->PAC\n");
 		/* therefore, build tuple for PAC->PNS */
 		t.src.l3num = AF_INET;
 		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
@@ -63,7 +63,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 		t.dst.u.gre.key = ct_pptp_info->pns_call_id;
 		t.dst.protonum = IPPROTO_GRE;
 	} else {
-		pr_debug("we are PAC->PNS\n");
+		pr_devel("we are PAC->PNS\n");
 		/* build tuple for PNS->PAC */
 		t.src.l3num = AF_INET;
 		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
@@ -73,15 +73,15 @@ static void pptp_nat_expected(struct nf_conn *ct,
 		t.dst.protonum = IPPROTO_GRE;
 	}
 
-	pr_debug("trying to unexpect other dir: ");
+	pr_devel("trying to unexpect other dir: ");
 	nf_ct_dump_tuple_ip(&t);
 	other_exp = nf_ct_expect_find_get(net, nf_ct_zone(ct), &t);
 	if (other_exp) {
 		nf_ct_unexpect_related(other_exp);
 		nf_ct_expect_put(other_exp);
-		pr_debug("success\n");
+		pr_devel("success\n");
 	} else {
-		pr_debug("not found!\n");
+		pr_devel("not found!\n");
 	}
 
 	/* This must be a fresh one. */
@@ -153,7 +153,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		cid_off = offsetof(union pptp_ctrl_union, clrreq.callID);
 		break;
 	default:
-		pr_debug("unknown outbound packet 0x%04x:%s\n", msg,
+		pr_devel("unknown outbound packet 0x%04x:%s\n", msg,
 			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
 					       pptp_msg_name[0]);
 		/* fall through */
@@ -171,7 +171,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 
 	/* only OUT_CALL_REQUEST, IN_CALL_REPLY, CALL_CLEAR_REQUEST pass
 	 * down to here */
-	pr_debug("altering call id from 0x%04x to 0x%04x\n",
+	pr_devel("altering call id from 0x%04x to 0x%04x\n",
 		 ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
 
 	/* mangle packet */
@@ -247,7 +247,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		pcid_off = offsetof(union pptp_ctrl_union, setlink.peersCallID);
 		break;
 	default:
-		pr_debug("unknown inbound packet %s\n",
+		pr_devel("unknown inbound packet %s\n",
 			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
 					       pptp_msg_name[0]);
 		/* fall through */
@@ -265,7 +265,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	 * WAN_ERROR_NOTIFY, CALL_DISCONNECT_NOTIFY pass down here */
 
 	/* mangle packet */
-	pr_debug("altering peer call id from 0x%04x to 0x%04x\n",
+	pr_devel("altering peer call id from 0x%04x to 0x%04x\n",
 		 ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
 
 	if (nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index d7e8920..4e6ef5d 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -58,7 +58,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		keyptr = &tuple->dst.u.gre.key;
 
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
-		pr_debug("%p: NATing GRE PPTP\n", ct);
+		pr_devel("%p: NATing GRE PPTP\n", ct);
 		min = 1;
 		range_size = 0xffff;
 	} else {
@@ -66,7 +66,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		range_size = ntohs(range->max.gre.key) - min + 1;
 	}
 
-	pr_debug("min = %u, range_size = %u\n", min, range_size);
+	pr_devel("min = %u, range_size = %u\n", min, range_size);
 
 	for (i = 0; i < range_size; i++, key++) {
 		*keyptr = htons(min + key % range_size);
@@ -74,7 +74,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 			return true;
 	}
 
-	pr_debug("%p: no NAT mapping\n", ct);
+	pr_devel("%p: no NAT mapping\n", ct);
 	return false;
 }
 
@@ -107,11 +107,11 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 		 * Try to behave like "nf_nat_proto_unknown" */
 		break;
 	case GRE_VERSION_PPTP:
-		pr_debug("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
+		pr_devel("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
 		pgreh->call_id = tuple->dst.u.gre.key;
 		break;
 	default:
-		pr_debug("can't nat unknown GRE version\n");
+		pr_devel("can't nat unknown GRE version\n");
 		return false;
 	}
 	return true;
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index b48a0fc..5cc1d34 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -113,7 +113,7 @@ alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 	struct nf_nat_range range
 		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } };
 
-	pr_debug("Allocating NULL binding for %p (%pI4)\n", ct, &ip);
+	pr_devel("Allocating NULL binding for %p (%pI4)\n", ct, &ip);
 	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 84c7974..904b1a9 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -108,7 +108,7 @@ nf_nat_fn(unsigned int hooknum,
 			return NF_ACCEPT;
 		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
 		if (nat == NULL) {
-			pr_debug("failed to add NAT extension\n");
+			pr_devel("failed to add NAT extension\n");
 			return NF_ACCEPT;
 		}
 	}
@@ -141,7 +141,7 @@ nf_nat_fn(unsigned int hooknum,
 			if (ret != NF_ACCEPT)
 				return ret;
 		} else
-			pr_debug("Already setup manip %s for ct %p\n",
+			pr_devel("Already setup manip %s for ct %p\n",
 				 maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
 				 ct);
 		break;
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 1f47a52..d0b66f8 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -456,11 +456,11 @@ static int log_tg6_check(const struct xt_tgchk_param *par)
 	const struct ip6t_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
-		pr_debug("level %u >= 8\n", loginfo->level);
+		pr_devel("level %u >= 8\n", loginfo->level);
 		return -EINVAL;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
-		pr_debug("prefix not null-terminated\n");
+		pr_devel("prefix not null-terminated\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index af1d649..3679416 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -51,7 +51,7 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 
 	if ((!(ipv6_addr_type(&oip6h->saddr) & IPV6_ADDR_UNICAST)) ||
 	    (!(ipv6_addr_type(&oip6h->daddr) & IPV6_ADDR_UNICAST))) {
-		pr_debug("addr is not unicast.\n");
+		pr_devel("addr is not unicast.\n");
 		return;
 	}
 
@@ -59,7 +59,7 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 	tcphoff = ipv6_skip_exthdr(oldskb, ((u8*)(oip6h+1) - oldskb->data), &proto);
 
 	if ((tcphoff < 0) || (tcphoff > oldskb->len)) {
-		pr_debug("Cannot get TCP header.\n");
+		pr_devel("Cannot get TCP header.\n");
 		return;
 	}
 
@@ -67,7 +67,7 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 
 	/* IP header checks: fragment, too short. */
 	if (proto != IPPROTO_TCP || otcplen < sizeof(struct tcphdr)) {
-		pr_debug("proto(%d) != IPPROTO_TCP, "
+		pr_devel("proto(%d) != IPPROTO_TCP, "
 			 "or too short. otcplen = %d\n",
 			 proto, otcplen);
 		return;
@@ -78,14 +78,14 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 
 	/* No RST for RST. */
 	if (otcph.rst) {
-		pr_debug("RST is set\n");
+		pr_devel("RST is set\n");
 		return;
 	}
 
 	/* Check checksum. */
 	if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
 			    skb_checksum(oldskb, tcphoff, otcplen, 0))) {
-		pr_debug("TCP checksum is invalid\n");
+		pr_devel("TCP checksum is invalid\n");
 		return;
 	}
 
@@ -109,7 +109,7 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 
 	if (!nskb) {
 		if (net_ratelimit())
-			pr_debug("cannot alloc skb\n");
+			pr_devel("cannot alloc skb\n");
 		dst_release(dst);
 		return;
 	}
@@ -180,7 +180,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	const struct ip6t_reject_info *reject = par->targinfo;
 	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);
 
-	pr_debug("%s: medium point\n", __func__);
+	pr_devel("%s: medium point\n", __func__);
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
 		send_unreach(net, skb, ICMPV6_NOROUTE, par->hooknum);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 1580693..e292ec8 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -29,10 +29,10 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
 	bool r;
 
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
+	pr_devel("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
 		 invert ? '!' : ' ', min, spi, max);
 	r = (spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
+	pr_devel(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -60,20 +60,20 @@ static bool ah_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 
 	hdrlen = (ah->hdrlen + 2) << 2;
 
-	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
-	pr_debug("RES %04X ", ah->reserved);
-	pr_debug("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
+	pr_devel("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
+	pr_devel("RES %04X ", ah->reserved);
+	pr_devel("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
 
-	pr_debug("IPv6 AH spi %02X ",
+	pr_devel("IPv6 AH spi %02X ",
 		 spi_match(ahinfo->spis[0], ahinfo->spis[1],
 			   ntohl(ah->spi),
 			   !!(ahinfo->invflags & IP6T_AH_INV_SPI)));
-	pr_debug("len %02X %04X %02X ",
+	pr_devel("len %02X %04X %02X ",
 		 ahinfo->hdrlen, hdrlen,
 		 (!ahinfo->hdrlen ||
 		  (ahinfo->hdrlen == hdrlen) ^
 		  !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
-	pr_debug("res %02X %04X %02X\n",
+	pr_devel("res %02X %04X %02X\n",
 		 ahinfo->hdrres, ah->reserved,
 		 !(ahinfo->hdrres && ah->reserved));
 
@@ -92,7 +92,7 @@ static int ah_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ah *ahinfo = par->matchinfo;
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
-		pr_debug("unknown flags %X\n", ahinfo->invflags);
+		pr_devel("unknown flags %X\n", ahinfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index a5daf0f..cdab2df 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -27,10 +27,10 @@ static inline bool
 id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
 	bool r;
-	pr_debug("id_match:%c 0x%x <= 0x%x <= 0x%x\n", invert ? '!' : ' ',
+	pr_devel("id_match:%c 0x%x <= 0x%x <= 0x%x\n", invert ? '!' : ' ',
 		 min, id, max);
 	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
+	pr_devel(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -56,33 +56,33 @@ frag_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		return false;
 	}
 
-	pr_debug("INFO %04X ", fh->frag_off);
-	pr_debug("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
-	pr_debug("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
-	pr_debug("MF %04X ", fh->frag_off & htons(IP6_MF));
-	pr_debug("ID %u %08X\n", ntohl(fh->identification),
+	pr_devel("INFO %04X ", fh->frag_off);
+	pr_devel("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
+	pr_devel("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
+	pr_devel("MF %04X ", fh->frag_off & htons(IP6_MF));
+	pr_devel("ID %u %08X\n", ntohl(fh->identification),
 		 ntohl(fh->identification));
 
-	pr_debug("IPv6 FRAG id %02X ",
+	pr_devel("IPv6 FRAG id %02X ",
 		 id_match(fraginfo->ids[0], fraginfo->ids[1],
 			  ntohl(fh->identification),
 			  !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)));
-	pr_debug("res %02X %02X%04X %02X ",
+	pr_devel("res %02X %02X%04X %02X ",
 		 fraginfo->flags & IP6T_FRAG_RES, fh->reserved,
 		 ntohs(fh->frag_off) & 0x6,
 		 !((fraginfo->flags & IP6T_FRAG_RES) &&
 		   (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
-	pr_debug("first %02X %02X %02X ",
+	pr_devel("first %02X %02X %02X ",
 		 fraginfo->flags & IP6T_FRAG_FST,
 		 ntohs(fh->frag_off) & ~0x7,
 		 !((fraginfo->flags & IP6T_FRAG_FST) &&
 		   (ntohs(fh->frag_off) & ~0x7)));
-	pr_debug("mf %02X %02X %02X ",
+	pr_devel("mf %02X %02X %02X ",
 		 fraginfo->flags & IP6T_FRAG_MF,
 		 ntohs(fh->frag_off) & IP6_MF,
 		 !((fraginfo->flags & IP6T_FRAG_MF) &&
 		   !((ntohs(fh->frag_off) & IP6_MF))));
-	pr_debug("last %02X %02X %02X\n",
+	pr_devel("last %02X %02X %02X\n",
 		 fraginfo->flags & IP6T_FRAG_NMF,
 		 ntohs(fh->frag_off) & IP6_MF,
 		 !((fraginfo->flags & IP6T_FRAG_NMF) &&
@@ -107,7 +107,7 @@ static int frag_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_frag *fraginfo = par->matchinfo;
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
-		pr_debug("unknown flags %X\n", fraginfo->invflags);
+		pr_devel("unknown flags %X\n", fraginfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index e424e7c..fc6dae5 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -81,9 +81,9 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
+	pr_devel("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
 
-	pr_debug("len %02X %04X %02X ",
+	pr_devel("len %02X %04X %02X ",
 		 optinfo->hdrlen, hdrlen,
 		 (!(optinfo->flags & IP6T_OPTS_LEN) ||
 		  ((optinfo->hdrlen == hdrlen) ^
@@ -99,8 +99,8 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
 		return ret;
 	} else {
-		pr_debug("Strict ");
-		pr_debug("#%d ", optinfo->optsnr);
+		pr_devel("Strict ");
+		pr_devel("#%d ", optinfo->optsnr);
 		for (temp = 0; temp < optinfo->optsnr; temp++) {
 			/* type field exists ? */
 			if (hdrlen < 1)
@@ -112,11 +112,11 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 
 			/* Type check */
 			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
-				pr_debug("Tbad %02X %02X\n", *tp,
+				pr_devel("Tbad %02X %02X\n", *tp,
 					 (optinfo->opts[temp] & 0xFF00) >> 8);
 				return false;
 			} else {
-				pr_debug("Tok ");
+				pr_devel("Tok ");
 			}
 			/* Length check */
 			if (*tp) {
@@ -133,23 +133,23 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
 				if (spec_len != 0x00FF && spec_len != *lp) {
-					pr_debug("Lbad %02X %04X\n", *lp,
+					pr_devel("Lbad %02X %04X\n", *lp,
 						 spec_len);
 					return false;
 				}
-				pr_debug("Lok ");
+				pr_devel("Lok ");
 				optlen = *lp + 2;
 			} else {
-				pr_debug("Pad1\n");
+				pr_devel("Pad1\n");
 				optlen = 1;
 			}
 
 			/* Step to the next */
-			pr_debug("len%04X\n", optlen);
+			pr_devel("len%04X\n", optlen);
 
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
 			    temp < optinfo->optsnr - 1) {
-				pr_debug("new pointer is too large!\n");
+				pr_devel("new pointer is too large!\n");
 				break;
 			}
 			ptr += optlen;
@@ -169,12 +169,12 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_opts *optsinfo = par->matchinfo;
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
-		pr_debug("unknown flags %X\n", optsinfo->invflags);
+		pr_devel("unknown flags %X\n", optsinfo->invflags);
 		return -EINVAL;
 	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
-		pr_debug("Not strict - not implemented");
+		pr_devel("Not strict - not implemented");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index c9f443e..42af21c 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -46,13 +46,13 @@ static bool mh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	if (mh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
-		pr_debug("Dropping evil MH tinygram.\n");
+		pr_devel("Dropping evil MH tinygram.\n");
 		*par->hotdrop = true;
 		return false;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
-		pr_debug("Dropping invalid MH Payload Proto: %u\n",
+		pr_devel("Dropping invalid MH Payload Proto: %u\n",
 			 mh->ip6mh_proto);
 		*par->hotdrop = true;
 		return false;
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 0932272..6947314 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -29,10 +29,10 @@ static inline bool
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
 	bool r;
-	pr_debug("segsleft_match:%c 0x%x <= 0x%x <= 0x%x\n",
+	pr_devel("segsleft_match:%c 0x%x <= 0x%x <= 0x%x\n",
 		 invert ? '!' : ' ', min, id, max);
 	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
+	pr_devel(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -68,25 +68,25 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-	pr_debug("TYPE %04X ", rh->type);
-	pr_debug("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
+	pr_devel("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
+	pr_devel("TYPE %04X ", rh->type);
+	pr_devel("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
 
-	pr_debug("IPv6 RT segsleft %02X ",
+	pr_devel("IPv6 RT segsleft %02X ",
 		 segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 				rh->segments_left,
 				!!(rtinfo->invflags & IP6T_RT_INV_SGS)));
-	pr_debug("type %02X %02X %02X ",
+	pr_devel("type %02X %02X %02X ",
 		 rtinfo->rt_type, rh->type,
 		 (!(rtinfo->flags & IP6T_RT_TYP) ||
 		  ((rtinfo->rt_type == rh->type) ^
 		   !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-	pr_debug("len %02X %04X %02X ",
+	pr_devel("len %02X %04X %02X ",
 		 rtinfo->hdrlen, hdrlen,
 		 !(rtinfo->flags & IP6T_RT_LEN) ||
 		  ((rtinfo->hdrlen == hdrlen) ^
 		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	pr_debug("res %02X %02X %02X ",
+	pr_devel("res %02X %02X %02X ",
 		 rtinfo->flags & IP6T_RT_RES,
 		 ((const struct rt0_hdr *)rh)->reserved,
 		 !((rtinfo->flags & IP6T_RT_RES) &&
@@ -115,18 +115,18 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		ret = (*rp == 0);
 	}
 
-	pr_debug("#%d ", rtinfo->addrnr);
+	pr_devel("#%d ", rtinfo->addrnr);
 	if (!(rtinfo->flags & IP6T_RT_FST)) {
 		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
-		pr_debug("Not strict ");
+		pr_devel("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
+			pr_devel("There isn't enough space\n");
 			return false;
 		} else {
 			unsigned int i = 0;
 
-			pr_debug("#%d ", rtinfo->addrnr);
+			pr_devel("#%d ", rtinfo->addrnr);
 			for (temp = 0;
 			     temp < (unsigned int)((hdrlen - 8) / 16);
 			     temp++) {
@@ -140,25 +140,25 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 				BUG_ON(ap == NULL);
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					pr_debug("i=%d temp=%d;\n", i, temp);
+					pr_devel("i=%d temp=%d;\n", i, temp);
 					i++;
 				}
 				if (i == rtinfo->addrnr)
 					break;
 			}
-			pr_debug("i=%d #%d\n", i, rtinfo->addrnr);
+			pr_devel("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
 				return false;
 		}
 	} else {
-		pr_debug("Strict ");
+		pr_devel("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
+			pr_devel("There isn't enough space\n");
 			return false;
 		} else {
-			pr_debug("#%d ", rtinfo->addrnr);
+			pr_devel("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -171,7 +171,7 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
 			}
-			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
+			pr_devel("temp=%d #%d\n", temp, rtinfo->addrnr);
 			if (temp == rtinfo->addrnr &&
 			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
@@ -188,14 +188,14 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_rt *rtinfo = par->matchinfo;
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
-		pr_debug("unknown flags %X\n", rtinfo->invflags);
+		pr_devel("unknown flags %X\n", rtinfo->invflags);
 		return -EINVAL;
 	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
 	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
-		pr_debug("`--rt-type 0' required before `--rt-0-*'");
+		pr_devel("`--rt-type 0' required before `--rt-0-*'");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 996c3f4..143a960 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -125,7 +125,7 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 	if (skb_copy_bits(skb, nhoff + offsetof(struct ipv6hdr, nexthdr),
 			  &pnum, sizeof(pnum)) != 0) {
-		pr_debug("ip6_conntrack_core: can't get nexthdr\n");
+		pr_devel("ip6_conntrack_core: can't get nexthdr\n");
 		return -NF_ACCEPT;
 	}
 	protoff = nf_ct_ipv6_skip_exthdr(skb, extoff, &pnum, skb->len - extoff);
@@ -134,7 +134,7 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	 * except of IPv6 & ext headers. but it's tracked anyway. - YK
 	 */
 	if ((protoff < 0) || (protoff > skb->len)) {
-		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
+		pr_devel("ip6_conntrack_core: can't find proto in pkt\n");
 		return -NF_ACCEPT;
 	}
 
@@ -174,7 +174,7 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 	protoff = nf_ct_ipv6_skip_exthdr(skb, extoff, &pnum,
 					 skb->len - extoff);
 	if (protoff > skb->len || pnum == NEXTHDR_FRAGMENT) {
-		pr_debug("proto header not found\n");
+		pr_devel("proto header not found\n");
 		return NF_ACCEPT;
 	}
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 9be8177..d320c97 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -116,7 +116,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
 		/* Can't create a new ICMPv6 `conn' with this. */
-		pr_debug("icmpv6: can't create new conn with type %u\n",
+		pr_devel("icmpv6: can't create new conn with type %u\n",
 			 type + 128);
 		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
 		if (LOG_INVALID(nf_ct_net(ct), IPPROTO_ICMPV6))
@@ -148,7 +148,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 				+ sizeof(struct ipv6hdr)
 				+ sizeof(struct icmp6hdr),
 			       PF_INET6, &origtuple)) {
-		pr_debug("icmpv6_error: Can't get tuple\n");
+		pr_devel("icmpv6_error: Can't get tuple\n");
 		return -NF_ACCEPT;
 	}
 
@@ -159,7 +159,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	   been preserved inside the ICMP. */
 	if (!nf_ct_invert_tuple(&intuple, &origtuple,
 				&nf_conntrack_l3proto_ipv6, inproto)) {
-		pr_debug("icmpv6_error: Can't invert tuple\n");
+		pr_devel("icmpv6_error: Can't invert tuple\n");
 		return -NF_ACCEPT;
 	}
 
@@ -167,7 +167,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	h = nf_conntrack_find_get(net, zone, &intuple);
 	if (!h) {
-		pr_debug("icmpv6_error: no match\n");
+		pr_devel("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
 	} else {
 		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 6fb8901..45af52e 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -189,7 +189,7 @@ fq_find(__be32 id, u32 user, struct in6_addr *src, struct in6_addr *dst)
 	return container_of(q, struct nf_ct_frag6_queue, q);
 
 oom:
-	pr_debug("Can't alloc new queue\n");
+	pr_devel("Can't alloc new queue\n");
 	return NULL;
 }
 
@@ -201,7 +201,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 	int offset, end;
 
 	if (fq->q.last_in & INET_FRAG_COMPLETE) {
-		pr_debug("Allready completed\n");
+		pr_devel("Allready completed\n");
 		goto err;
 	}
 
@@ -210,7 +210,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 			((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
 
 	if ((unsigned int)end > IPV6_MAXPLEN) {
-		pr_debug("offset is too large.\n");
+		pr_devel("offset is too large.\n");
 		return -1;
 	}
 
@@ -228,7 +228,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 		 */
 		if (end < fq->q.len ||
 		    ((fq->q.last_in & INET_FRAG_LAST_IN) && end != fq->q.len)) {
-			pr_debug("already received last fragment\n");
+			pr_devel("already received last fragment\n");
 			goto err;
 		}
 		fq->q.last_in |= INET_FRAG_LAST_IN;
@@ -241,13 +241,13 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 			/* RFC2460 says always send parameter problem in
 			 * this case. -DaveM
 			 */
-			pr_debug("end of fragment not rounded to 8 bytes.\n");
+			pr_devel("end of fragment not rounded to 8 bytes.\n");
 			return -1;
 		}
 		if (end > fq->q.len) {
 			/* Some bits beyond end -> corruption. */
 			if (fq->q.last_in & INET_FRAG_LAST_IN) {
-				pr_debug("last packet already reached.\n");
+				pr_devel("last packet already reached.\n");
 				goto err;
 			}
 			fq->q.len = end;
@@ -259,11 +259,11 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 
 	/* Point into the IP datagram 'data' part. */
 	if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data)) {
-		pr_debug("queue: message is too short.\n");
+		pr_devel("queue: message is too short.\n");
 		goto err;
 	}
 	if (pskb_trim_rcsum(skb, end - offset)) {
-		pr_debug("Can't trim\n");
+		pr_devel("Can't trim\n");
 		goto err;
 	}
 
@@ -288,11 +288,11 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 		if (i > 0) {
 			offset += i;
 			if (end <= offset) {
-				pr_debug("overlap\n");
+				pr_devel("overlap\n");
 				goto err;
 			}
 			if (!pskb_pull(skb, i)) {
-				pr_debug("Can't pull\n");
+				pr_devel("Can't pull\n");
 				goto err;
 			}
 			if (skb->ip_summed != CHECKSUM_UNNECESSARY)
@@ -311,7 +311,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 			/* Eat head of the next overlapped fragment
 			 * and leave the loop. The next ones cannot overlap.
 			 */
-			pr_debug("Eat head of the overlapped parts.: %d", i);
+			pr_devel("Eat head of the overlapped parts.: %d", i);
 			if (!pskb_pull(next, i))
 				goto err;
 
@@ -394,13 +394,13 @@ nf_ct_frag6_reasm(struct nf_ct_frag6_queue *fq, struct net_device *dev)
 		       sizeof(struct ipv6hdr) + fq->q.len -
 		       sizeof(struct frag_hdr));
 	if (payload_len > IPV6_MAXPLEN) {
-		pr_debug("payload len is too large.\n");
+		pr_devel("payload len is too large.\n");
 		goto out_oversize;
 	}
 
 	/* Head of list must not be cloned. */
 	if (skb_cloned(head) && pskb_expand_head(head, 0, 0, GFP_ATOMIC)) {
-		pr_debug("skb is cloned but can't expand head");
+		pr_devel("skb is cloned but can't expand head");
 		goto out_oom;
 	}
 
@@ -412,7 +412,7 @@ nf_ct_frag6_reasm(struct nf_ct_frag6_queue *fq, struct net_device *dev)
 		int i, plen = 0;
 
 		if ((clone = alloc_skb(0, GFP_ATOMIC)) == NULL) {
-			pr_debug("Can't alloc skb\n");
+			pr_devel("Can't alloc skb\n");
 			goto out_oom;
 		}
 		clone->next = head->next;
@@ -527,11 +527,11 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 			return -1;
 		}
 		if (nexthdr == NEXTHDR_NONE) {
-			pr_debug("next header is none\n");
+			pr_devel("next header is none\n");
 			return -1;
 		}
 		if (len < (int)sizeof(struct ipv6_opt_hdr)) {
-			pr_debug("too short\n");
+			pr_devel("too short\n");
 			return -1;
 		}
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
@@ -572,7 +572,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 
 	/* Jumbo payload inhibits frag. header */
 	if (ipv6_hdr(skb)->payload_len == 0) {
-		pr_debug("payload len = 0\n");
+		pr_devel("payload len = 0\n");
 		return skb;
 	}
 
@@ -581,14 +581,14 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 
 	clone = skb_clone(skb, GFP_ATOMIC);
 	if (clone == NULL) {
-		pr_debug("Can't clone skb\n");
+		pr_devel("Can't clone skb\n");
 		return skb;
 	}
 
 	NFCT_FRAG6_CB(clone)->orig = skb;
 
 	if (!pskb_may_pull(clone, fhoff + sizeof(*fhdr))) {
-		pr_debug("message is too short.\n");
+		pr_devel("message is too short.\n");
 		goto ret_orig;
 	}
 
@@ -601,7 +601,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 
 	fq = fq_find(fhdr->identification, user, &hdr->saddr, &hdr->daddr);
 	if (fq == NULL) {
-		pr_debug("Can't find and can't create new queue\n");
+		pr_devel("Can't find and can't create new queue\n");
 		goto ret_orig;
 	}
 
@@ -609,7 +609,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 
 	if (nf_ct_frag6_queue(fq, clone, fhdr, nhoff) < 0) {
 		spin_unlock_bh(&fq->q.lock);
-		pr_debug("Can't insert skb to queue\n");
+		pr_devel("Can't insert skb to queue\n");
 		fq_put(fq);
 		goto ret_orig;
 	}
@@ -618,7 +618,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 	    fq->q.meat == fq->q.len) {
 		ret_skb = nf_ct_frag6_reasm(fq, dev);
 		if (ret_skb == NULL)
-			pr_debug("Can't reassemble fragmented packets\n");
+			pr_devel("Can't reassemble fragmented packets\n");
 	}
 	spin_unlock_bh(&fq->q.lock);
 
diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index 2d3d5e4..00a4e43 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -184,7 +184,7 @@ ip_vs_tcpudp_debug_packet_v4(struct ip_vs_protocol *pp,
 				&ih->daddr, ntohs(pptr[1]));
 	}
 
-	pr_debug("%s: %s %s\n", msg, pp->name, buf);
+	pr_devel("%s: %s %s\n", msg, pp->name, buf);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -216,7 +216,7 @@ ip_vs_tcpudp_debug_packet_v6(struct ip_vs_protocol *pp,
 				&ih->daddr, ntohs(pptr[1]));
 	}
 
-	pr_debug("%s: %s %s\n", msg, pp->name, buf);
+	pr_devel("%s: %s %s\n", msg, pp->name, buf);
 }
 #endif
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_ah_esp.c b/net/netfilter/ipvs/ip_vs_proto_ah_esp.c
index 1892dfc..bddd1b6 100644
--- a/net/netfilter/ipvs/ip_vs_proto_ah_esp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_ah_esp.c
@@ -140,7 +140,7 @@ ah_esp_debug_packet_v4(struct ip_vs_protocol *pp, const struct sk_buff *skb,
 	else
 		sprintf(buf, "%pI4->%pI4", &ih->saddr, &ih->daddr);
 
-	pr_debug("%s: %s %s\n", msg, pp->name, buf);
+	pr_devel("%s: %s %s\n", msg, pp->name, buf);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -157,7 +157,7 @@ ah_esp_debug_packet_v6(struct ip_vs_protocol *pp, const struct sk_buff *skb,
 	else
 		sprintf(buf, "%pI6->%pI6", &ih->saddr, &ih->daddr);
 
-	pr_debug("%s: %s %s\n", msg, pp->name, buf);
+	pr_devel("%s: %s %s\n", msg, pp->name, buf);
 }
 #endif
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c9bbe9..bf84623 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -166,7 +166,7 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
 static void
 clean_from_lists(struct nf_conn *ct)
 {
-	pr_debug("clean_from_lists(%p)\n", ct);
+	pr_devel("clean_from_lists(%p)\n", ct);
 	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode);
 
@@ -181,7 +181,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_l4proto *l4proto;
 
-	pr_debug("destroy_conntrack(%p)\n", ct);
+	pr_devel("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
@@ -214,7 +214,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (ct->master)
 		nf_ct_put(ct->master);
 
-	pr_debug("destroy_conntrack: returning ct=%p to slab\n", ct);
+	pr_devel("destroy_conntrack: returning ct=%p to slab\n", ct);
 	nf_conntrack_free(ct);
 }
 
@@ -418,7 +418,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	/* No external references means noone else could have
 	   confirmed us. */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
-	pr_debug("Confirming conntrack %p\n", ct);
+	pr_devel("Confirming conntrack %p\n", ct);
 
 	spin_lock_bh(&nf_conntrack_lock);
 
@@ -590,7 +590,7 @@ struct nf_conn *nf_conntrack_alloc(struct net *net, u16 zone,
 	 */
 	ct = kmem_cache_alloc(net->ct.nf_conntrack_cachep, gfp);
 	if (ct == NULL) {
-		pr_debug("nf_conntrack_alloc: Can't alloc conntrack.\n");
+		pr_devel("nf_conntrack_alloc: Can't alloc conntrack.\n");
 		atomic_dec(&net->ct.count);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -664,19 +664,19 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
-		pr_debug("Can't invert tuple.\n");
+		pr_devel("Can't invert tuple.\n");
 		return NULL;
 	}
 
 	ct = nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC);
 	if (IS_ERR(ct)) {
-		pr_debug("Can't allocate conntrack.\n");
+		pr_devel("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)ct;
 	}
 
 	if (!l4proto->new(ct, skb, dataoff)) {
 		nf_conntrack_free(ct);
-		pr_debug("init conntrack: can't track with proto module\n");
+		pr_devel("init conntrack: can't track with proto module\n");
 		return NULL;
 	}
 
@@ -690,7 +690,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	spin_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(net, zone, tuple);
 	if (exp) {
-		pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
+		pr_devel("conntrack: expectation arrives ct=%p exp=%p\n",
 			 ct, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
@@ -749,7 +749,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, l3num, protonum, &tuple, l3proto,
 			     l4proto)) {
-		pr_debug("resolve_normal_ct: Can't get tuple\n");
+		pr_devel("resolve_normal_ct: Can't get tuple\n");
 		return NULL;
 	}
 
@@ -773,14 +773,14 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: normal packet for %p\n", ct);
+			pr_devel("nf_conntrack_in: normal packet for %p\n", ct);
 			*ctinfo = IP_CT_ESTABLISHED;
 		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: related packet for %p\n",
+			pr_devel("nf_conntrack_in: related packet for %p\n",
 				 ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
-			pr_debug("nf_conntrack_in: new packet for %p\n", ct);
+			pr_devel("nf_conntrack_in: new packet for %p\n", ct);
 			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
@@ -818,7 +818,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
 				   &dataoff, &protonum);
 	if (ret <= 0) {
-		pr_debug("not prepared to track yet or error occured\n");
+		pr_devel("not prepared to track yet or error occured\n");
 		NF_CT_STAT_INC_ATOMIC(net, error);
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
 		ret = -ret;
@@ -863,7 +863,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
-		pr_debug("nf_conntrack_in: Can't track with proto module\n");
+		pr_devel("nf_conntrack_in: Can't track with proto module\n");
 		nf_conntrack_put(skb->nfct);
 		skb->nfct = NULL;
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
@@ -908,7 +908,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	/* Should be unconfirmed, so not in hash table yet */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 
-	pr_debug("Altering reply tuple of %p to ", ct);
+	pr_devel("Altering reply tuple of %p to ", ct);
 	nf_ct_dump_tuple(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 2ae3169..7823d20 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -134,12 +134,12 @@ static int try_number(const char *data, size_t dlen, u_int32_t array[],
 			if (*data == term && i == array_size - 1)
 				return len;
 
-			pr_debug("Char %u (got %u nums) `%u' unexpected\n",
+			pr_devel("Char %u (got %u nums) `%u' unexpected\n",
 				 len, i, *data);
 			return 0;
 		}
 	}
-	pr_debug("Failed to fill %u numbers separated by %c\n",
+	pr_devel("Failed to fill %u numbers separated by %c\n",
 		 array_size, sep);
 	return 0;
 }
@@ -174,13 +174,13 @@ static int get_port(const char *data, int start, size_t dlen, char delim,
 			if (tmp_port == 0)
 				break;
 			*port = htons(tmp_port);
-			pr_debug("get_port: return %d\n", tmp_port);
+			pr_devel("get_port: return %d\n", tmp_port);
 			return i + 1;
 		}
 		else if (data[i] >= '0' && data[i] <= '9')
 			tmp_port = tmp_port*10 + data[i] - '0';
 		else { /* Some other crap */
-			pr_debug("get_port: invalid char.\n");
+			pr_devel("get_port: invalid char.\n");
 			break;
 		}
 	}
@@ -197,22 +197,22 @@ static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
 	/* First character is delimiter, then "1" for IPv4 or "2" for IPv6,
 	   then delimiter again. */
 	if (dlen <= 3) {
-		pr_debug("EPRT: too short\n");
+		pr_devel("EPRT: too short\n");
 		return 0;
 	}
 	delim = data[0];
 	if (isdigit(delim) || delim < 33 || delim > 126 || data[2] != delim) {
-		pr_debug("try_eprt: invalid delimitter.\n");
+		pr_devel("try_eprt: invalid delimitter.\n");
 		return 0;
 	}
 
 	if ((cmd->l3num == PF_INET && data[1] != '1') ||
 	    (cmd->l3num == PF_INET6 && data[1] != '2')) {
-		pr_debug("EPRT: invalid protocol number.\n");
+		pr_devel("EPRT: invalid protocol number.\n");
 		return 0;
 	}
 
-	pr_debug("EPRT: Got %c%c%c\n", delim, data[1], delim);
+	pr_devel("EPRT: Got %c%c%c\n", delim, data[1], delim);
 
 	if (data[1] == '1') {
 		u_int32_t array[4];
@@ -230,7 +230,7 @@ static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
 
 	if (length == 0)
 		return 0;
-	pr_debug("EPRT: Got IP address!\n");
+	pr_devel("EPRT: Got IP address!\n");
 	/* Start offset includes initial "|1|", and trailing delimiter */
 	return get_port(data, 3 + length + 1, dlen, delim, &cmd->u.tcp.port);
 }
@@ -263,7 +263,7 @@ static int find_pattern(const char *data, size_t dlen,
 {
 	size_t i;
 
-	pr_debug("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
+	pr_devel("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
 	if (dlen == 0)
 		return 0;
 
@@ -278,9 +278,9 @@ static int find_pattern(const char *data, size_t dlen,
 #if 0
 		size_t i;
 
-		pr_debug("ftp: string mismatch\n");
+		pr_devel("ftp: string mismatch\n");
 		for (i = 0; i < plen; i++) {
-			pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
+			pr_devel("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
 				 i, data[i], data[i],
 				 pattern[i], pattern[i]);
 		}
@@ -288,7 +288,7 @@ static int find_pattern(const char *data, size_t dlen,
 		return 0;
 	}
 
-	pr_debug("Pattern matches!\n");
+	pr_devel("Pattern matches!\n");
 	/* Now we've found the constant string, try to skip
 	   to the 'skip' character */
 	for (i = plen; data[i] != skip; i++)
@@ -297,14 +297,14 @@ static int find_pattern(const char *data, size_t dlen,
 	/* Skip over the last character */
 	i++;
 
-	pr_debug("Skipped up to `%c'!\n", skip);
+	pr_devel("Skipped up to `%c'!\n", skip);
 
 	*numoff = i;
 	*numlen = getnum(data + i, dlen - i, cmd, term);
 	if (!*numlen)
 		return -1;
 
-	pr_debug("Match succeeded!\n");
+	pr_devel("Match succeeded!\n");
 	return 1;
 }
 
@@ -369,7 +369,7 @@ static int help(struct sk_buff *skb,
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
-		pr_debug("ftp: Conntrackinfo = %u\n", ctinfo);
+		pr_devel("ftp: Conntrackinfo = %u\n", ctinfo);
 		return NF_ACCEPT;
 	}
 
@@ -380,7 +380,7 @@ static int help(struct sk_buff *skb,
 	dataoff = protoff + th->doff * 4;
 	/* No data? */
 	if (dataoff >= skb->len) {
-		pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
+		pr_devel("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
 			 skb->len);
 		return NF_ACCEPT;
 	}
@@ -396,7 +396,7 @@ static int help(struct sk_buff *skb,
 	/* Look up to see if we're just after a \n. */
 	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
 		/* Now if this ends in \n, update ftp info. */
-		pr_debug("nf_conntrack_ftp: wrong seq pos %s(%u) or %s(%u)\n",
+		pr_devel("nf_conntrack_ftp: wrong seq pos %s(%u) or %s(%u)\n",
 			 ct_ftp_info->seq_aft_nl_num[dir] > 0 ? "" : "(UNSET)",
 			 ct_ftp_info->seq_aft_nl[dir][0],
 			 ct_ftp_info->seq_aft_nl_num[dir] > 1 ? "" : "(UNSET)",
@@ -427,7 +427,7 @@ static int help(struct sk_buff *skb,
 		   connection tracking, not packet filtering.
 		   However, it is necessary for accurate tracking in
 		   this case. */
-		pr_debug("conntrack_ftp: partial %s %u+%u\n",
+		pr_devel("conntrack_ftp: partial %s %u+%u\n",
 			 search[dir][i].pattern,  ntohl(th->seq), datalen);
 		ret = NF_DROP;
 		goto out;
@@ -436,7 +436,7 @@ static int help(struct sk_buff *skb,
 		goto out_update_nl;
 	}
 
-	pr_debug("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
+	pr_devel("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
 		 matchlen, fb_ptr + matchoff,
 		 matchlen, ntohl(th->seq) + matchoff);
 
@@ -460,11 +460,11 @@ static int help(struct sk_buff *skb,
 		   different IP address.  Simply don't record it for
 		   NAT. */
 		if (cmd.l3num == PF_INET) {
-			pr_debug("conntrack_ftp: NOT RECORDING: %pI4 != %pI4\n",
+			pr_devel("conntrack_ftp: NOT RECORDING: %pI4 != %pI4\n",
 				 &cmd.u3.ip,
 				 &ct->tuplehash[dir].tuple.src.u3.ip);
 		} else {
-			pr_debug("conntrack_ftp: NOT RECORDING: %pI6 != %pI6\n",
+			pr_devel("conntrack_ftp: NOT RECORDING: %pI6 != %pI6\n",
 				 cmd.u3.ip6,
 				 ct->tuplehash[dir].tuple.src.u3.ip6);
 		}
@@ -528,7 +528,7 @@ static void nf_conntrack_ftp_fini(void)
 			if (ftp[i][j].me == NULL)
 				continue;
 
-			pr_debug("nf_ct_ftp: unregistering helper for pf: %d "
+			pr_devel("nf_ct_ftp: unregistering helper for pf: %d "
 				 "port: %d\n",
 				 ftp[i][j].tuple.src.l3num, ports[i]);
 			nf_conntrack_helper_unregister(&ftp[i][j]);
@@ -568,7 +568,7 @@ static int __init nf_conntrack_ftp_init(void)
 				sprintf(tmpname, "ftp-%d", ports[i]);
 			ftp[i][j].name = tmpname;
 
-			pr_debug("nf_ct_ftp: registering helper for pf: %d "
+			pr_devel("nf_ct_ftp: registering helper for pf: %d "
 				 "port: %d\n",
 				 ftp[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&ftp[i][j]);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index a487c80..4be158e 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -147,7 +147,7 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 		if (tcpdatalen < 4 || tpkt[0] != 0x03 || tpkt[1] != 0) {
 			/* Netmeeting sends TPKT header and data separately */
 			if (info->tpkt_len[dir] > 0) {
-				pr_debug("nf_ct_h323: previous packet "
+				pr_devel("nf_ct_h323: previous packet "
 					 "indicated separate TPKT data of %hu "
 					 "bytes\n", info->tpkt_len[dir]);
 				if (info->tpkt_len[dir] <= tcpdatalen) {
@@ -160,7 +160,7 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 				}
 
 				/* Fragmented TPKT */
-				pr_debug("nf_ct_h323: fragmented TPKT\n");
+				pr_devel("nf_ct_h323: fragmented TPKT\n");
 				goto clear_out;
 			}
 
@@ -187,7 +187,7 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 	if (tpktlen > tcpdatalen) {
 		if (tcpdatalen == 4) {	/* Separate TPKT header */
 			/* Netmeeting sends TPKT header and data separately */
-			pr_debug("nf_ct_h323: separate TPKT header indicates "
+			pr_devel("nf_ct_h323: separate TPKT header indicates "
 				 "there will be TPKT data of %hu bytes\n",
 				 tpktlen - 4);
 			info->tpkt_len[dir] = tpktlen - 4;
@@ -304,9 +304,9 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(rtp_exp) == 0) {
 			if (nf_ct_expect_related(rtcp_exp) == 0) {
-				pr_debug("nf_ct_h323: expect RTP ");
+				pr_devel("nf_ct_h323: expect RTP ");
 				nf_ct_dump_tuple(&rtp_exp->tuple);
-				pr_debug("nf_ct_h323: expect RTCP ");
+				pr_devel("nf_ct_h323: expect RTCP ");
 				nf_ct_dump_tuple(&rtcp_exp->tuple);
 			} else {
 				nf_ct_unexpect_related(rtp_exp);
@@ -361,7 +361,7 @@ static int expect_t120(struct sk_buff *skb,
 			       port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			pr_debug("nf_ct_h323: expect T.120 ");
+			pr_devel("nf_ct_h323: expect T.120 ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
 			ret = -1;
@@ -409,7 +409,7 @@ static int process_olc(struct sk_buff *skb, struct nf_conn *ct,
 {
 	int ret;
 
-	pr_debug("nf_ct_h323: OpenLogicalChannel\n");
+	pr_devel("nf_ct_h323: OpenLogicalChannel\n");
 
 	if (olc->forwardLogicalChannelParameters.multiplexParameters.choice ==
 	    eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h2250LogicalChannelParameters)
@@ -469,7 +469,7 @@ static int process_olca(struct sk_buff *skb, struct nf_conn *ct,
 	H2250LogicalChannelAckParameters *ack;
 	int ret;
 
-	pr_debug("nf_ct_h323: OpenLogicalChannelAck\n");
+	pr_devel("nf_ct_h323: OpenLogicalChannelAck\n");
 
 	if ((olca->options &
 	     eOpenLogicalChannelAck_reverseLogicalChannelParameters) &&
@@ -540,7 +540,7 @@ static int process_h245(struct sk_buff *skb, struct nf_conn *ct,
 			return process_olc(skb, ct, ctinfo, data, dataoff,
 					   &mscm->request.openLogicalChannel);
 		}
-		pr_debug("nf_ct_h323: H.245 Request %d\n",
+		pr_devel("nf_ct_h323: H.245 Request %d\n",
 			 mscm->request.choice);
 		break;
 	case eMultimediaSystemControlMessage_response:
@@ -550,11 +550,11 @@ static int process_h245(struct sk_buff *skb, struct nf_conn *ct,
 					    &mscm->response.
 					    openLogicalChannelAck);
 		}
-		pr_debug("nf_ct_h323: H.245 Response %d\n",
+		pr_devel("nf_ct_h323: H.245 Response %d\n",
 			 mscm->response.choice);
 		break;
 	default:
-		pr_debug("nf_ct_h323: H.245 signal %d\n", mscm->choice);
+		pr_devel("nf_ct_h323: H.245 signal %d\n", mscm->choice);
 		break;
 	}
 
@@ -576,21 +576,21 @@ static int h245_help(struct sk_buff *skb, unsigned int protoff,
 	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
 		return NF_ACCEPT;
 	}
-	pr_debug("nf_ct_h245: skblen = %u\n", skb->len);
+	pr_devel("nf_ct_h245: skblen = %u\n", skb->len);
 
 	spin_lock_bh(&nf_h323_lock);
 
 	/* Process each TPKT */
 	while (get_tpkt_data(skb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
-		pr_debug("nf_ct_h245: TPKT len=%d ", datalen);
+		pr_devel("nf_ct_h245: TPKT len=%d ", datalen);
 		nf_ct_dump_tuple(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 		/* Decode H.245 signal */
 		ret = DecodeMultimediaSystemControlMessage(data, datalen,
 							   &mscm);
 		if (ret < 0) {
-			pr_debug("nf_ct_h245: decoding error: %s\n",
+			pr_devel("nf_ct_h245: decoding error: %s\n",
 				 ret == H323_ERROR_BOUND ?
 				 "out of bound" : "out of range");
 			/* We don't drop when decoding error */
@@ -697,7 +697,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			       port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			pr_debug("nf_ct_q931: expect H.245 ");
+			pr_devel("nf_ct_q931: expect H.245 ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
 			ret = -1;
@@ -791,7 +791,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	if (callforward_filter &&
 	    callforward_do_filter(&addr, &ct->tuplehash[!dir].tuple.src.u3,
 				  nf_ct_l3num(ct))) {
-		pr_debug("nf_ct_q931: Call Forwarding not tracked\n");
+		pr_devel("nf_ct_q931: Call Forwarding not tracked\n");
 		return 0;
 	}
 
@@ -813,7 +813,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 					 taddr, port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			pr_debug("nf_ct_q931: expect Call Forwarding ");
+			pr_devel("nf_ct_q931: expect Call Forwarding ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
 			ret = -1;
@@ -837,7 +837,7 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 	union nf_inet_addr addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
 
-	pr_debug("nf_ct_q931: Setup\n");
+	pr_devel("nf_ct_q931: Setup\n");
 
 	if (setup->options & eSetup_UUIE_h245Address) {
 		ret = expect_h245(skb, ct, ctinfo, data, dataoff,
@@ -852,7 +852,7 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 	    get_h225_addr(ct, *data, &setup->destCallSignalAddress,
 			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.src.u3, sizeof(addr))) {
-		pr_debug("nf_ct_q931: set destCallSignalAddress %pI6:%hu->%pI6:%hu\n",
+		pr_devel("nf_ct_q931: set destCallSignalAddress %pI6:%hu->%pI6:%hu\n",
 			 &addr, ntohs(port), &ct->tuplehash[!dir].tuple.src.u3,
 			 ntohs(ct->tuplehash[!dir].tuple.src.u.tcp.port));
 		ret = set_h225_addr(skb, data, dataoff,
@@ -868,7 +868,7 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 	    get_h225_addr(ct, *data, &setup->sourceCallSignalAddress,
 			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.dst.u3, sizeof(addr))) {
-		pr_debug("nf_ct_q931: set sourceCallSignalAddress %pI6:%hu->%pI6:%hu\n",
+		pr_devel("nf_ct_q931: set sourceCallSignalAddress %pI6:%hu->%pI6:%hu\n",
 			 &addr, ntohs(port), &ct->tuplehash[!dir].tuple.dst.u3,
 			 ntohs(ct->tuplehash[!dir].tuple.dst.u.tcp.port));
 		ret = set_h225_addr(skb, data, dataoff,
@@ -901,7 +901,7 @@ static int process_callproceeding(struct sk_buff *skb,
 	int ret;
 	int i;
 
-	pr_debug("nf_ct_q931: CallProceeding\n");
+	pr_devel("nf_ct_q931: CallProceeding\n");
 
 	if (callproc->options & eCallProceeding_UUIE_h245Address) {
 		ret = expect_h245(skb, ct, ctinfo, data, dataoff,
@@ -931,7 +931,7 @@ static int process_connect(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	pr_debug("nf_ct_q931: Connect\n");
+	pr_devel("nf_ct_q931: Connect\n");
 
 	if (connect->options & eConnect_UUIE_h245Address) {
 		ret = expect_h245(skb, ct, ctinfo, data, dataoff,
@@ -961,7 +961,7 @@ static int process_alerting(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	pr_debug("nf_ct_q931: Alerting\n");
+	pr_devel("nf_ct_q931: Alerting\n");
 
 	if (alert->options & eAlerting_UUIE_h245Address) {
 		ret = expect_h245(skb, ct, ctinfo, data, dataoff,
@@ -991,7 +991,7 @@ static int process_facility(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	pr_debug("nf_ct_q931: Facility\n");
+	pr_devel("nf_ct_q931: Facility\n");
 
 	if (facility->reason.choice == eFacilityReason_callForwarded) {
 		if (facility->options & eFacility_UUIE_alternativeAddress)
@@ -1030,7 +1030,7 @@ static int process_progress(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	pr_debug("nf_ct_q931: Progress\n");
+	pr_devel("nf_ct_q931: Progress\n");
 
 	if (progress->options & eProgress_UUIE_h245Address) {
 		ret = expect_h245(skb, ct, ctinfo, data, dataoff,
@@ -1087,7 +1087,7 @@ static int process_q931(struct sk_buff *skb, struct nf_conn *ct,
 				       &pdu->h323_message_body.progress);
 		break;
 	default:
-		pr_debug("nf_ct_q931: Q.931 signal %d\n",
+		pr_devel("nf_ct_q931: Q.931 signal %d\n",
 			 pdu->h323_message_body.choice);
 		break;
 	}
@@ -1122,20 +1122,20 @@ static int q931_help(struct sk_buff *skb, unsigned int protoff,
 	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
 		return NF_ACCEPT;
 	}
-	pr_debug("nf_ct_q931: skblen = %u\n", skb->len);
+	pr_devel("nf_ct_q931: skblen = %u\n", skb->len);
 
 	spin_lock_bh(&nf_h323_lock);
 
 	/* Process each TPKT */
 	while (get_tpkt_data(skb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
-		pr_debug("nf_ct_q931: TPKT len=%d ", datalen);
+		pr_devel("nf_ct_q931: TPKT len=%d ", datalen);
 		nf_ct_dump_tuple(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 		/* Decode Q.931 signal */
 		ret = DecodeQ931(data, datalen, &q931);
 		if (ret < 0) {
-			pr_debug("nf_ct_q931: decoding error: %s\n",
+			pr_devel("nf_ct_q931: decoding error: %s\n",
 				 ret == H323_ERROR_BOUND ?
 				 "out of bound" : "out of range");
 			/* We don't drop when decoding error */
@@ -1279,7 +1279,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_q931(skb, ct, ctinfo, data, taddr, i, port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			pr_debug("nf_ct_ras: expect Q.931 ");
+			pr_devel("nf_ct_ras: expect Q.931 ");
 			nf_ct_dump_tuple(&exp->tuple);
 
 			/* Save port for looking up expect in processing RCF */
@@ -1300,7 +1300,7 @@ static int process_grq(struct sk_buff *skb, struct nf_conn *ct,
 {
 	typeof(set_ras_addr_hook) set_ras_addr;
 
-	pr_debug("nf_ct_ras: GRQ\n");
+	pr_devel("nf_ct_ras: GRQ\n");
 
 	set_ras_addr = rcu_dereference(set_ras_addr_hook);
 	if (set_ras_addr && ct->status & IPS_NAT_MASK)	/* NATed */
@@ -1320,7 +1320,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 
-	pr_debug("nf_ct_ras: GCF\n");
+	pr_devel("nf_ct_ras: GCF\n");
 
 	if (!get_h225_addr(ct, *data, &gcf->rasAddress, &addr, &port))
 		return 0;
@@ -1343,7 +1343,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->helper = nf_conntrack_helper_ras;
 
 	if (nf_ct_expect_related(exp) == 0) {
-		pr_debug("nf_ct_ras: expect RAS ");
+		pr_devel("nf_ct_ras: expect RAS ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
 		ret = -1;
@@ -1362,7 +1362,7 @@ static int process_rrq(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	typeof(set_ras_addr_hook) set_ras_addr;
 
-	pr_debug("nf_ct_ras: RRQ\n");
+	pr_devel("nf_ct_ras: RRQ\n");
 
 	ret = expect_q931(skb, ct, ctinfo, data,
 			  rrq->callSignalAddress.item,
@@ -1380,7 +1380,7 @@ static int process_rrq(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	if (rrq->options & eRegistrationRequest_timeToLive) {
-		pr_debug("nf_ct_ras: RRQ TTL = %u seconds\n", rrq->timeToLive);
+		pr_devel("nf_ct_ras: RRQ TTL = %u seconds\n", rrq->timeToLive);
 		info->timeout = rrq->timeToLive;
 	} else
 		info->timeout = default_rrq_ttl;
@@ -1399,7 +1399,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 	struct nf_conntrack_expect *exp;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	pr_debug("nf_ct_ras: RCF\n");
+	pr_devel("nf_ct_ras: RCF\n");
 
 	set_sig_addr = rcu_dereference(set_sig_addr_hook);
 	if (set_sig_addr && ct->status & IPS_NAT_MASK) {
@@ -1411,12 +1411,12 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	if (rcf->options & eRegistrationConfirm_timeToLive) {
-		pr_debug("nf_ct_ras: RCF TTL = %u seconds\n", rcf->timeToLive);
+		pr_devel("nf_ct_ras: RCF TTL = %u seconds\n", rcf->timeToLive);
 		info->timeout = rcf->timeToLive;
 	}
 
 	if (info->timeout > 0) {
-		pr_debug("nf_ct_ras: set RAS connection timeout to "
+		pr_devel("nf_ct_ras: set RAS connection timeout to "
 			 "%u seconds\n", info->timeout);
 		nf_ct_refresh(ct, skb, info->timeout * HZ);
 
@@ -1425,7 +1425,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 		exp = find_expect(ct, &ct->tuplehash[dir].tuple.dst.u3,
 				  info->sig_port[!dir]);
 		if (exp) {
-			pr_debug("nf_ct_ras: set Q.931 expect "
+			pr_devel("nf_ct_ras: set Q.931 expect "
 				 "timeout to %u seconds for",
 				 info->timeout);
 			nf_ct_dump_tuple(&exp->tuple);
@@ -1447,7 +1447,7 @@ static int process_urq(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	pr_debug("nf_ct_ras: URQ\n");
+	pr_devel("nf_ct_ras: URQ\n");
 
 	set_sig_addr = rcu_dereference(set_sig_addr_hook);
 	if (set_sig_addr && ct->status & IPS_NAT_MASK) {
@@ -1480,7 +1480,7 @@ static int process_arq(struct sk_buff *skb, struct nf_conn *ct,
 	union nf_inet_addr addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
 
-	pr_debug("nf_ct_ras: ARQ\n");
+	pr_devel("nf_ct_ras: ARQ\n");
 
 	set_h225_addr = rcu_dereference(set_h225_addr_hook);
 	if ((arq->options & eAdmissionRequest_destCallSignalAddress) &&
@@ -1523,7 +1523,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	struct nf_conntrack_expect *exp;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	pr_debug("nf_ct_ras: ACF\n");
+	pr_devel("nf_ct_ras: ACF\n");
 
 	if (!get_h225_addr(ct, *data, &acf->destCallSignalAddress,
 			   &addr, &port))
@@ -1548,7 +1548,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->helper = nf_conntrack_helper_q931;
 
 	if (nf_ct_expect_related(exp) == 0) {
-		pr_debug("nf_ct_ras: expect Q.931 ");
+		pr_devel("nf_ct_ras: expect Q.931 ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
 		ret = -1;
@@ -1565,7 +1565,7 @@ static int process_lrq(struct sk_buff *skb, struct nf_conn *ct,
 {
 	typeof(set_ras_addr_hook) set_ras_addr;
 
-	pr_debug("nf_ct_ras: LRQ\n");
+	pr_devel("nf_ct_ras: LRQ\n");
 
 	set_ras_addr = rcu_dereference(set_ras_addr_hook);
 	if (set_ras_addr && ct->status & IPS_NAT_MASK)
@@ -1585,7 +1585,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 
-	pr_debug("nf_ct_ras: LCF\n");
+	pr_devel("nf_ct_ras: LCF\n");
 
 	if (!get_h225_addr(ct, *data, &lcf->callSignalAddress,
 			   &addr, &port))
@@ -1601,7 +1601,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->helper = nf_conntrack_helper_q931;
 
 	if (nf_ct_expect_related(exp) == 0) {
-		pr_debug("nf_ct_ras: expect Q.931 ");
+		pr_devel("nf_ct_ras: expect Q.931 ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
 		ret = -1;
@@ -1622,7 +1622,7 @@ static int process_irr(struct sk_buff *skb, struct nf_conn *ct,
 	typeof(set_ras_addr_hook) set_ras_addr;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	pr_debug("nf_ct_ras: IRR\n");
+	pr_devel("nf_ct_ras: IRR\n");
 
 	set_ras_addr = rcu_dereference(set_ras_addr_hook);
 	if (set_ras_addr && ct->status & IPS_NAT_MASK) {
@@ -1681,7 +1681,7 @@ static int process_ras(struct sk_buff *skb, struct nf_conn *ct,
 		return process_irr(skb, ct, ctinfo, data,
 				   &ras->infoRequestResponse);
 	default:
-		pr_debug("nf_ct_ras: RAS message %d\n", ras->choice);
+		pr_devel("nf_ct_ras: RAS message %d\n", ras->choice);
 		break;
 	}
 
@@ -1697,7 +1697,7 @@ static int ras_help(struct sk_buff *skb, unsigned int protoff,
 	int datalen = 0;
 	int ret;
 
-	pr_debug("nf_ct_ras: skblen = %u\n", skb->len);
+	pr_devel("nf_ct_ras: skblen = %u\n", skb->len);
 
 	spin_lock_bh(&nf_h323_lock);
 
@@ -1705,13 +1705,13 @@ static int ras_help(struct sk_buff *skb, unsigned int protoff,
 	data = get_udp_data(skb, protoff, &datalen);
 	if (data == NULL)
 		goto accept;
-	pr_debug("nf_ct_ras: RAS message len=%d ", datalen);
+	pr_devel("nf_ct_ras: RAS message len=%d ", datalen);
 	nf_ct_dump_tuple(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 	/* Decode RAS message */
 	ret = DecodeRasMessage(data, datalen, &ras);
 	if (ret < 0) {
-		pr_debug("nf_ct_ras: decoding error: %s\n",
+		pr_devel("nf_ct_ras: decoding error: %s\n",
 			 ret == H323_ERROR_BOUND ?
 			 "out of bound" : "out of range");
 		goto accept;
@@ -1768,7 +1768,7 @@ static void __exit nf_conntrack_h323_fini(void)
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[0]);
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 	kfree(h323_buffer);
-	pr_debug("nf_ct_h323: fini\n");
+	pr_devel("nf_ct_h323: fini\n");
 }
 
 /****************************************************************************/
@@ -1794,7 +1794,7 @@ static int __init nf_conntrack_h323_init(void)
 	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras[1]);
 	if (ret < 0)
 		goto err5;
-	pr_debug("nf_ct_h323: init success\n");
+	pr_devel("nf_ct_h323: init success\n");
 	return 0;
 
 err5:
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 59e1a4c..ff1375f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -109,7 +109,7 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 	if (help)
 		INIT_HLIST_HEAD(&help->expectations);
 	else
-		pr_debug("failed to add helper extension area");
+		pr_devel("failed to add helper extension area");
 	return help;
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 7673930..3a4ca85 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -158,7 +158,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 		/* we have at least (19+MINMATCHLEN)-5 bytes valid data left */
 
 		iph = ip_hdr(skb);
-		pr_debug("DCC found in master %pI4:%u %pI4:%u\n",
+		pr_devel("DCC found in master %pI4:%u %pI4:%u\n",
 			 &iph->saddr, ntohs(th->source),
 			 &iph->daddr, ntohs(th->dest));
 
@@ -168,18 +168,18 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 				continue;
 			}
 			data += strlen(dccprotos[i]);
-			pr_debug("DCC %s detected\n", dccprotos[i]);
+			pr_devel("DCC %s detected\n", dccprotos[i]);
 
 			/* we have at least
 			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
-				pr_debug("unable to parse dcc command\n");
+				pr_devel("unable to parse dcc command\n");
 				continue;
 			}
 
-			pr_debug("DCC bound ip/port: %pI4:%u\n",
+			pr_devel("DCC bound ip/port: %pI4:%u\n",
 				 &dcc_ip, dcc_port);
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP */
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 0889448..a387af0 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -102,7 +102,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 {
 	struct net *net = nf_ct_net(ct);
 	typeof(nf_nat_pptp_hook_expectfn) nf_nat_pptp_expectfn;
-	pr_debug("increasing timeouts\n");
+	pr_devel("increasing timeouts\n");
 
 	/* increase timeout of GRE data channel conntrack entry */
 	ct->proto.gre.timeout	     = PPTP_GRE_TIMEOUT;
@@ -121,17 +121,17 @@ static void pptp_expectfn(struct nf_conn *ct,
 
 		/* obviously this tuple inversion only works until you do NAT */
 		nf_ct_invert_tuplepr(&inv_t, &exp->tuple);
-		pr_debug("trying to unexpect other dir: ");
+		pr_devel("trying to unexpect other dir: ");
 		nf_ct_dump_tuple(&inv_t);
 
 		exp_other = nf_ct_expect_find_get(net, nf_ct_zone(ct), &inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
-			pr_debug("found\n");
+			pr_devel("found\n");
 			nf_ct_unexpect_related(exp_other);
 			nf_ct_expect_put(exp_other);
 		} else {
-			pr_debug("not found\n");
+			pr_devel("not found\n");
 		}
 	}
 	rcu_read_unlock();
@@ -145,13 +145,13 @@ static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
 	struct nf_conn *sibling;
 	u16 zone = nf_ct_zone(ct);
 
-	pr_debug("trying to timeout ct or exp for tuple ");
+	pr_devel("trying to timeout ct or exp for tuple ");
 	nf_ct_dump_tuple(t);
 
 	h = nf_conntrack_find_get(net, zone, t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
-		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
+		pr_devel("setting timeout of conntrack %p to 0\n", sibling);
 		sibling->proto.gre.timeout	  = 0;
 		sibling->proto.gre.stream_timeout = 0;
 		if (del_timer(&sibling->timeout))
@@ -161,7 +161,7 @@ static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
 	} else {
 		exp = nf_ct_expect_find_get(net, zone, t);
 		if (exp) {
-			pr_debug("unexpect_related of expect %p\n", exp);
+			pr_devel("unexpect_related of expect %p\n", exp);
 			nf_ct_unexpect_related(exp);
 			nf_ct_expect_put(exp);
 			return 1;
@@ -185,7 +185,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.src.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	if (!destroy_sibling_or_exp(net, ct, &t))
-		pr_debug("failed to timeout original pns->pac ct/exp\n");
+		pr_devel("failed to timeout original pns->pac ct/exp\n");
 
 	/* try reply (pac->pns) tuple */
 	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
@@ -193,7 +193,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.src.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	if (!destroy_sibling_or_exp(net, ct, &t))
-		pr_debug("failed to timeout reply pac->pns ct/exp\n");
+		pr_devel("failed to timeout reply pac->pns ct/exp\n");
 }
 
 /* expect GRE connections (PNS->PAC and PAC->PNS direction) */
@@ -275,7 +275,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("inbound control message %s\n", pptp_msg_name[msg]);
+	pr_devel("inbound control message %s\n", pptp_msg_name[msg]);
 
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
@@ -310,7 +310,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		pcid = pptpReq->ocack.peersCallID;
 		if (info->pns_call_id != pcid)
 			goto invalid;
-		pr_debug("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
+		pr_devel("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
 			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->ocack.resultCode == PPTP_OUTCALL_CONNECT) {
@@ -327,7 +327,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 			goto invalid;
 
 		cid = pptpReq->icreq.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_devel("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->cstate = PPTP_CALL_IN_REQ;
 		info->pac_call_id = cid;
 		break;
@@ -346,7 +346,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		if (info->pns_call_id != pcid)
 			goto invalid;
 
-		pr_debug("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		pr_devel("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_CONF;
 
 		/* we expect a GRE connection from PAC to PNS */
@@ -356,7 +356,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	case PPTP_CALL_DISCONNECT_NOTIFY:
 		/* server confirms disconnect */
 		cid = pptpReq->disc.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_devel("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
@@ -379,7 +379,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	return NF_ACCEPT;
 
 invalid:
-	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
+	pr_devel("invalid %s: type=%d cid=%u pcid=%u "
 		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
 		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
 		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
@@ -401,7 +401,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("outbound control message %s\n", pptp_msg_name[msg]);
+	pr_devel("outbound control message %s\n", pptp_msg_name[msg]);
 
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
@@ -423,7 +423,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		info->cstate = PPTP_CALL_OUT_REQ;
 		/* track PNS call id */
 		cid = pptpReq->ocreq.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_devel("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->pns_call_id = cid;
 		break;
 
@@ -437,7 +437,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		pcid = pptpReq->icack.peersCallID;
 		if (info->pac_call_id != pcid)
 			goto invalid;
-		pr_debug("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
+		pr_devel("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
 			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
@@ -474,7 +474,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 	return NF_ACCEPT;
 
 invalid:
-	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
+	pr_devel("invalid %s: type=%d cid=%u pcid=%u "
 		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
 		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
 		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
@@ -531,7 +531,7 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 
 	pptph = skb_header_pointer(skb, nexthdr_off, sizeof(_pptph), &_pptph);
 	if (!pptph) {
-		pr_debug("no full PPTP header, can't track\n");
+		pr_devel("no full PPTP header, can't track\n");
 		return NF_ACCEPT;
 	}
 	nexthdr_off += sizeof(_pptph);
@@ -540,7 +540,7 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 	/* if it's not a control message we can't do anything with it */
 	if (ntohs(pptph->packetType) != PPTP_PACKET_CONTROL ||
 	    ntohl(pptph->magicCookie) != PPTP_MAGIC_COOKIE) {
-		pr_debug("not a control packet\n");
+		pr_devel("not a control packet\n");
 		return NF_ACCEPT;
 	}
 
@@ -576,7 +576,7 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 		/* server -> client (PAC -> PNS) */
 		ret = pptp_inbound_pkt(skb, ctlh, pptpReq, reqlen, ct,
 				       ctinfo);
-	pr_debug("sstate: %d->%d, cstate: %d->%d\n",
+	pr_devel("sstate: %d->%d, cstate: %d->%d\n",
 		 oldsstate, info->sstate, oldcstate, info->cstate);
 	spin_unlock_bh(&nf_pptp_lock);
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index cf616e5..996f0dd 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -90,7 +90,7 @@ static __be16 gre_keymap_lookup(struct net *net, struct nf_conntrack_tuple *t)
 	}
 	read_unlock_bh(&net_gre->keymap_lock);
 
-	pr_debug("lookup src key 0x%x for ", key);
+	pr_devel("lookup src key 0x%x for ", key);
 	nf_ct_dump_tuple(t);
 
 	return key;
@@ -116,7 +116,7 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			}
 		}
 		read_unlock_bh(&net_gre->keymap_lock);
-		pr_debug("trying to override keymap_%s for ct %p\n",
+		pr_devel("trying to override keymap_%s for ct %p\n",
 			 dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
 		return -EEXIST;
 	}
@@ -127,7 +127,7 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	memcpy(&km->tuple, t, sizeof(*t));
 	*kmp = km;
 
-	pr_debug("adding new entry %p: ", km);
+	pr_devel("adding new entry %p: ", km);
 	nf_ct_dump_tuple(&km->tuple);
 
 	write_lock_bh(&net_gre->keymap_lock);
@@ -146,12 +146,12 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct)
 	struct nf_conn_help *help = nfct_help(ct);
 	enum ip_conntrack_dir dir;
 
-	pr_debug("entering for ct %p\n", ct);
+	pr_devel("entering for ct %p\n", ct);
 
 	write_lock_bh(&net_gre->keymap_lock);
 	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
 		if (help->help.ct_pptp_info.keymap[dir]) {
-			pr_debug("removing %p from list\n",
+			pr_devel("removing %p from list\n",
 				 help->help.ct_pptp_info.keymap[dir]);
 			list_del(&help->help.ct_pptp_info.keymap[dir]->list);
 			kfree(help->help.ct_pptp_info.keymap[dir]);
@@ -199,7 +199,7 @@ static bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 		return true;
 
 	if (ntohs(grehdr->protocol) != GRE_PROTOCOL_PPTP) {
-		pr_debug("GRE_VERSION_PPTP but unknown proto\n");
+		pr_devel("GRE_VERSION_PPTP but unknown proto\n");
 		return false;
 	}
 
@@ -254,7 +254,7 @@ static int gre_packet(struct nf_conn *ct,
 static bool gre_new(struct nf_conn *ct, const struct sk_buff *skb,
 		    unsigned int dataoff)
 {
-	pr_debug(": ");
+	pr_devel(": ");
 	nf_ct_dump_tuple(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
 	/* initialize to sane value.  Ideally a conntrack helper
@@ -270,10 +270,10 @@ static bool gre_new(struct nf_conn *ct, const struct sk_buff *skb,
 static void gre_destroy(struct nf_conn *ct)
 {
 	struct nf_conn *master = ct->master;
-	pr_debug(" entering\n");
+	pr_devel(" entering\n");
 
 	if (!master)
-		pr_debug("no master !?!\n");
+		pr_devel("no master !?!\n");
 	else
 		nf_ct_gre_keymap_destroy(master);
 }
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index b68ff15..70d4730 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -191,7 +191,7 @@ static int do_basic_checks(struct nf_conn *ct,
 	flag = 0;
 
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
+		pr_devel("Chunk Num: %d  Type: %d\n", count, sch->type);
 
 		if (sch->type == SCTP_CID_INIT ||
 		    sch->type == SCTP_CID_INIT_ACK ||
@@ -207,7 +207,7 @@ static int do_basic_checks(struct nf_conn *ct,
 		      sch->type == SCTP_CID_COOKIE_ECHO ||
 		      flag) &&
 		     count != 0) || !sch->length) {
-			pr_debug("Basic checks failed\n");
+			pr_devel("Basic checks failed\n");
 			return 1;
 		}
 
@@ -215,7 +215,7 @@ static int do_basic_checks(struct nf_conn *ct,
 			set_bit(sch->type, map);
 	}
 
-	pr_debug("Basic checks passed\n");
+	pr_devel("Basic checks passed\n");
 	return count == 0;
 }
 
@@ -225,54 +225,54 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 {
 	int i;
 
-	pr_debug("Chunk type: %d\n", chunk_type);
+	pr_devel("Chunk type: %d\n", chunk_type);
 
 	switch (chunk_type) {
 	case SCTP_CID_INIT:
-		pr_debug("SCTP_CID_INIT\n");
+		pr_devel("SCTP_CID_INIT\n");
 		i = 0;
 		break;
 	case SCTP_CID_INIT_ACK:
-		pr_debug("SCTP_CID_INIT_ACK\n");
+		pr_devel("SCTP_CID_INIT_ACK\n");
 		i = 1;
 		break;
 	case SCTP_CID_ABORT:
-		pr_debug("SCTP_CID_ABORT\n");
+		pr_devel("SCTP_CID_ABORT\n");
 		i = 2;
 		break;
 	case SCTP_CID_SHUTDOWN:
-		pr_debug("SCTP_CID_SHUTDOWN\n");
+		pr_devel("SCTP_CID_SHUTDOWN\n");
 		i = 3;
 		break;
 	case SCTP_CID_SHUTDOWN_ACK:
-		pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
+		pr_devel("SCTP_CID_SHUTDOWN_ACK\n");
 		i = 4;
 		break;
 	case SCTP_CID_ERROR:
-		pr_debug("SCTP_CID_ERROR\n");
+		pr_devel("SCTP_CID_ERROR\n");
 		i = 5;
 		break;
 	case SCTP_CID_COOKIE_ECHO:
-		pr_debug("SCTP_CID_COOKIE_ECHO\n");
+		pr_devel("SCTP_CID_COOKIE_ECHO\n");
 		i = 6;
 		break;
 	case SCTP_CID_COOKIE_ACK:
-		pr_debug("SCTP_CID_COOKIE_ACK\n");
+		pr_devel("SCTP_CID_COOKIE_ACK\n");
 		i = 7;
 		break;
 	case SCTP_CID_SHUTDOWN_COMPLETE:
-		pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
+		pr_devel("SCTP_CID_SHUTDOWN_COMPLETE\n");
 		i = 8;
 		break;
 	default:
 		/* Other chunks like DATA, SACK, HEARTBEAT and
 		its ACK do not cause a change in state */
-		pr_debug("Unknown chunk type, Will stay in %s\n",
+		pr_devel("Unknown chunk type, Will stay in %s\n",
 			 sctp_conntrack_names[cur_state]);
 		return cur_state;
 	}
 
-	pr_debug("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
+	pr_devel("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
 		 dir, sctp_conntrack_names[cur_state], chunk_type,
 		 sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
 
@@ -310,7 +310,7 @@ static int sctp_packet(struct nf_conn *ct,
 	    !test_bit(SCTP_CID_ABORT, map) &&
 	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
 	    sh->vtag != ct->proto.sctp.vtag[dir]) {
-		pr_debug("Verification tag check failed\n");
+		pr_devel("Verification tag check failed\n");
 		goto out;
 	}
 
@@ -344,7 +344,7 @@ static int sctp_packet(struct nf_conn *ct,
 
 		/* Invalid */
 		if (new_state == SCTP_CONNTRACK_MAX) {
-			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
+			pr_devel("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
 				 "conntrack=%u\n",
 				 dir, sch->type, old_state);
 			goto out_unlock;
@@ -359,7 +359,7 @@ static int sctp_packet(struct nf_conn *ct,
 						sizeof(_inithdr), &_inithdr);
 			if (ih == NULL)
 				goto out_unlock;
-			pr_debug("Setting vtag %x for dir %d\n",
+			pr_devel("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
 		}
@@ -375,7 +375,7 @@ static int sctp_packet(struct nf_conn *ct,
 	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
 	    dir == IP_CT_DIR_REPLY &&
 	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
-		pr_debug("Setting assured bit\n");
+		pr_devel("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &ct->status);
 		nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	}
@@ -422,7 +422,7 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		/* Invalid: delete conntrack */
 		if (new_state == SCTP_CONNTRACK_NONE ||
 		    new_state == SCTP_CONNTRACK_MAX) {
-			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
+			pr_devel("nf_conntrack_sctp: invalid new deleting.\n");
 			return false;
 		}
 
@@ -436,7 +436,7 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 				if (ih == NULL)
 					return false;
 
-				pr_debug("Setting vtag %x for new conn\n",
+				pr_devel("Setting vtag %x for new conn\n",
 					 ih->init_tag);
 
 				ct->proto.sctp.vtag[IP_CT_DIR_REPLY] =
@@ -449,7 +449,7 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		/* If it is a shutdown ack OOTB packet, we expect a return
 		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
 		else {
-			pr_debug("Setting vtag %x for new conn OOTB\n",
+			pr_devel("Setting vtag %x for new conn OOTB\n",
 				 sh->vtag);
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 9dd8cd4..6933642 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -540,12 +540,12 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	ack -= receiver_offset;
 	sack -= receiver_offset;
 
-	pr_debug("tcp_in_window: START\n");
-	pr_debug("tcp_in_window: ");
+	pr_devel("tcp_in_window: START\n");
+	pr_devel("tcp_in_window: ");
 	nf_ct_dump_tuple(tuple);
-	pr_debug("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
+	pr_devel("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
 		 seq, ack, receiver_offset, sack, receiver_offset, win, end);
-	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
+	pr_devel("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
 		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		 sender->td_end, sender->td_maxend, sender->td_maxwin,
 		 sender->td_scale,
@@ -632,18 +632,18 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		 */
 		seq = end = sender->td_end;
 
-	pr_debug("tcp_in_window: ");
+	pr_devel("tcp_in_window: ");
 	nf_ct_dump_tuple(tuple);
-	pr_debug("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
+	pr_devel("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
 		 seq, ack, receiver_offset, sack, receiver_offset, win, end);
-	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
+	pr_devel("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
 		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		 sender->td_end, sender->td_maxend, sender->td_maxwin,
 		 sender->td_scale,
 		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		 receiver->td_scale);
 
-	pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
+	pr_devel("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
 		 before(seq, sender->td_maxend + 1),
 		 after(end, sender->td_end - receiver->td_maxwin - 1),
 		 before(sack, receiver->td_end + 1),
@@ -728,7 +728,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			: "SEQ is over the upper bound (over the window of the receiver)");
 	}
 
-	pr_debug("tcp_in_window: res=%u sender end=%u maxend=%u maxwin=%u "
+	pr_devel("tcp_in_window: res=%u sender end=%u maxend=%u maxwin=%u "
 		 "receiver end=%u maxend=%u maxwin=%u\n",
 		 res, sender->td_end, sender->td_maxend, sender->td_maxwin,
 		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
@@ -951,7 +951,7 @@ static int tcp_packet(struct nf_conn *ct,
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
-		pr_debug("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
+		pr_devel("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
 			 dir, get_conntrack_index(th), old_state);
 		spin_unlock_bh(&ct->lock);
 		if (LOG_INVALID(net, IPPROTO_TCP))
@@ -1002,9 +1002,9 @@ static int tcp_packet(struct nf_conn *ct,
 	ct->proto.tcp.last_index = index;
 	ct->proto.tcp.last_dir = dir;
 
-	pr_debug("tcp_conntracks: ");
+	pr_devel("tcp_conntracks: ");
 	nf_ct_dump_tuple(tuple);
-	pr_debug("syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
+	pr_devel("syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
 		 (th->syn ? 1 : 0), (th->ack ? 1 : 0),
 		 (th->fin ? 1 : 0), (th->rst ? 1 : 0),
 		 old_state, new_state);
@@ -1072,7 +1072,7 @@ static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	/* Invalid: delete conntrack */
 	if (new_state >= TCP_CONNTRACK_MAX) {
-		pr_debug("nf_ct_tcp: invalid new deleting.\n");
+		pr_devel("nf_ct_tcp: invalid new deleting.\n");
 		return false;
 	}
 
@@ -1125,7 +1125,7 @@ static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	ct->proto.tcp.state = TCP_CONNTRACK_NONE;
 	ct->proto.tcp.last_index = TCP_NONE_SET;
 
-	pr_debug("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
+	pr_devel("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
 		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		 sender->td_end, sender->td_maxend, sender->td_maxwin,
 		 sender->td_scale,
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index d9e2773..771a776 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -121,14 +121,14 @@ static int help(struct sk_buff *skb,
 	ct_sane_info->state = SANE_STATE_NORMAL;
 
 	if (datalen < sizeof(struct sane_reply_net_start)) {
-		pr_debug("nf_ct_sane: NET_START reply too short\n");
+		pr_devel("nf_ct_sane: NET_START reply too short\n");
 		goto out;
 	}
 
 	reply = sb_ptr;
 	if (reply->status != htonl(SANE_STATUS_SUCCESS)) {
 		/* saned refused the command */
-		pr_debug("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
+		pr_devel("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
 			 ntohl(reply->status));
 		goto out;
 	}
@@ -148,7 +148,7 @@ static int help(struct sk_buff *skb,
 			  &tuple->src.u3, &tuple->dst.u3,
 			  IPPROTO_TCP, NULL, &reply->port);
 
-	pr_debug("nf_ct_sane: expect: ");
+	pr_devel("nf_ct_sane: expect: ");
 	nf_ct_dump_tuple(&exp->tuple);
 
 	/* Can't expect this?  Best to drop packet now. */
@@ -177,7 +177,7 @@ static void nf_conntrack_sane_fini(void)
 
 	for (i = 0; i < ports_c; i++) {
 		for (j = 0; j < 2; j++) {
-			pr_debug("nf_ct_sane: unregistering helper for pf: %d "
+			pr_devel("nf_ct_sane: unregistering helper for pf: %d "
 				 "port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
 			nf_conntrack_helper_unregister(&sane[i][j]);
@@ -217,7 +217,7 @@ static int __init nf_conntrack_sane_init(void)
 				sprintf(tmpname, "sane-%d", ports[i]);
 			sane[i][j].name = tmpname;
 
-			pr_debug("nf_ct_sane: registering helper for pf: %d "
+			pr_devel("nf_ct_sane: registering helper for pf: %d "
 				 "port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&sane[i][j]);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c6cd1b8..41c32cf 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -179,7 +179,7 @@ static int epaddr_len(const struct nf_conn *ct, const char *dptr,
 	const char *aux = dptr;
 
 	if (!parse_addr(ct, dptr, &dptr, &addr, limit)) {
-		pr_debug("ip: %s parse failed.!\n", dptr);
+		pr_devel("ip: %s parse failed.!\n", dptr);
 		return 0;
 	}
 
@@ -1394,7 +1394,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_refresh(ct, skb, sip_timeout * HZ);
 
 	if (skb_is_nonlinear(skb)) {
-		pr_debug("Copy of skbuff not supported yet.\n");
+		pr_devel("Copy of skbuff not supported yet.\n");
 		return NF_ACCEPT;
 	}
 
@@ -1456,7 +1456,7 @@ static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_refresh(ct, skb, sip_timeout * HZ);
 
 	if (skb_is_nonlinear(skb)) {
-		pr_debug("Copy of skbuff not supported yet.\n");
+		pr_devel("Copy of skbuff not supported yet.\n");
 		return NF_ACCEPT;
 	}
 
@@ -1545,7 +1545,7 @@ static int __init nf_conntrack_sip_init(void)
 				sprintf(tmpname, "sip-%u", i);
 			sip[i][j].name = tmpname;
 
-			pr_debug("port #%u: %u\n", i, ports[i]);
+			pr_devel("port #%u: %u\n", i, ports[i]);
 
 			ret = nf_conntrack_helper_register(&sip[i][j]);
 			if (ret) {
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 46e646b..2566d03 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -68,7 +68,7 @@ static int tftp_help(struct sk_buff *skb,
 				  &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_UDP, NULL, &tuple->dst.u.udp.port);
 
-		pr_debug("expect: ");
+		pr_devel("expect: ");
 		nf_ct_dump_tuple(&exp->tuple);
 
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
@@ -80,13 +80,13 @@ static int tftp_help(struct sk_buff *skb,
 		break;
 	case TFTP_OPCODE_DATA:
 	case TFTP_OPCODE_ACK:
-		pr_debug("Data/ACK opcode\n");
+		pr_devel("Data/ACK opcode\n");
 		break;
 	case TFTP_OPCODE_ERROR:
-		pr_debug("Error opcode\n");
+		pr_devel("Error opcode\n");
 		break;
 	default:
-		pr_debug("Unknown opcode\n");
+		pr_devel("Unknown opcode\n");
 	}
 	return ret;
 }
diff --git a/net/netfilter/nf_tproxy_core.c b/net/netfilter/nf_tproxy_core.c
index 5490fc3..edac813 100644
--- a/net/netfilter/nf_tproxy_core.c
+++ b/net/netfilter/nf_tproxy_core.c
@@ -47,7 +47,7 @@ nf_tproxy_get_sock_v4(struct net *net, const u8 protocol,
 		sk = NULL;
 	}
 
-	pr_debug("tproxy socket lookup: proto %u %08x:%u -> %08x:%u, listener only: %d, sock %p\n",
+	pr_devel("tproxy socket lookup: proto %u %08x:%u -> %08x:%u, listener only: %d, sock %p\n",
 		 protocol, ntohl(saddr), ntohs(sport), ntohl(daddr), ntohs(dport), listening_only, sk);
 
 	return sk;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 445de70..3a3c5cb 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -813,7 +813,7 @@ xt_replace_table(struct xt_table *table,
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
-		pr_debug("num_counters != table->private->number (%u/%u)\n",
+		pr_devel("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
 		local_bh_enable();
 		*error = -EAGAIN;
@@ -874,7 +874,7 @@ struct xt_table *xt_register_table(struct net *net,
 		goto unlock;
 
 	private = table->private;
-	pr_debug("table->private->number = %u\n", private->number);
+	pr_devel("table->private->number = %u\n", private->number);
 
 	/* save number of initial entries */
 	private->initial_entries = private->number;
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 4f246dd..e6fbe63 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -47,13 +47,13 @@ tproxy_tg(struct sk_buff *skb, const struct xt_target_param *par)
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
 
-		pr_debug("redirecting: proto %u %08x:%u -> %08x:%u, mark: %x\n",
+		pr_devel("redirecting: proto %u %08x:%u -> %08x:%u, mark: %x\n",
 			 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
 			 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %u %08x:%u -> %08x:%u, mark: %x\n",
+	pr_devel("no socket, dropping: proto %u %08x:%u -> %08x:%u, mark: %x\n",
 		 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
 		 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
 	return NF_DROP;
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 143bfdc..303f5db 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -29,10 +29,10 @@ static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
 	bool r;
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
+	pr_devel("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
 		 invert ? '!' : ' ', min, spi, max);
 	r = (spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
+	pr_devel(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -51,7 +51,7 @@ static bool esp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil ESP tinygram.\n");
+		pr_devel("Dropping evil ESP tinygram.\n");
 		*par->hotdrop = true;
 		return false;
 	}
@@ -65,7 +65,7 @@ static int esp_mt_check(const struct xt_mtchk_param *par)
 	const struct xt_esp *espinfo = par->matchinfo;
 
 	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
-		pr_debug("unknown flags %X\n", espinfo->invflags);
+		pr_devel("unknown flags %X\n", espinfo->invflags);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 8471d97..b327d36 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -28,7 +28,7 @@ iprange_mt4(const struct sk_buff *skb, const struct xt_match_param *par)
 		m |= ntohl(iph->saddr) > ntohl(info->src_max.ip);
 		m ^= !!(info->flags & IPRANGE_SRC_INV);
 		if (m) {
-			pr_debug("src IP %pI4 NOT in range %s%pI4-%pI4\n",
+			pr_devel("src IP %pI4 NOT in range %s%pI4-%pI4\n",
 			         &iph->saddr,
 			         (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
 			         &info->src_max.ip,
@@ -41,7 +41,7 @@ iprange_mt4(const struct sk_buff *skb, const struct xt_match_param *par)
 		m |= ntohl(iph->daddr) > ntohl(info->dst_max.ip);
 		m ^= !!(info->flags & IPRANGE_DST_INV);
 		if (m) {
-			pr_debug("dst IP %pI4 NOT in range %s%pI4-%pI4\n",
+			pr_devel("dst IP %pI4 NOT in range %s%pI4-%pI4\n",
 			         &iph->daddr,
 			         (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
 			         &info->dst_min.ip,
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 83b77ce..0718af1 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -40,7 +40,7 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 		if (minfo->pflags[i]) {
 			/* range port matching */
 			e = minfo->ports[++i];
-			pr_debug("src or dst matches with %d-%d?\n", s, e);
+			pr_devel("src or dst matches with %d-%d?\n", s, e);
 
 			if (minfo->flags == XT_MULTIPORT_SOURCE
 			    && src >= s && src <= e)
@@ -54,7 +54,7 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 				return true ^ minfo->invert;
 		} else {
 			/* exact port matching */
-			pr_debug("src or dst matches with %d?\n", s);
+			pr_devel("src or dst matches with %d?\n", s);
 
 			if (minfo->flags == XT_MULTIPORT_SOURCE
 			    && src == s)
@@ -86,7 +86,7 @@ multiport_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil offset=0 tinygram.\n");
+		pr_devel("Dropping evil offset=0 tinygram.\n");
 		*par->hotdrop = true;
 		return false;
 	}
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index c3694df..5c29111 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -57,19 +57,19 @@ match_packet(const struct sk_buff *skb,
 	do {
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
 		if (sch == NULL || sch->length == 0) {
-			pr_debug("Dropping invalid SCTP packet.\n");
+			pr_devel("Dropping invalid SCTP packet.\n");
 			*hotdrop = true;
 			return false;
 		}
 #ifdef DEBUG
-		pr_debug("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d"
+		pr_devel("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d"
 			 "\tflags: %x\n",
 			 ++i, offset, sch->type, htons(sch->length),
 			 sch->flags);
 #endif
 		offset += (ntohs(sch->length) + 3) & ~3;
 
-		pr_debug("skb->len: %d\toffset: %d\n", skb->len, offset);
+		pr_devel("skb->len: %d\toffset: %d\n", skb->len, offset);
 
 		if (SCTP_CHUNKMAP_IS_SET(info->chunkmap, sch->type)) {
 			switch (chunk_match_type) {
@@ -121,17 +121,17 @@ sctp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	sctp_sctphdr_t _sh;
 
 	if (par->fragoff != 0) {
-		pr_debug("Dropping non-first fragment.. FIXME\n");
+		pr_devel("Dropping non-first fragment.. FIXME\n");
 		return false;
 	}
 
 	sh = skb_header_pointer(skb, par->thoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
-		pr_debug("Dropping evil TCP offset=0 tinygram.\n");
+		pr_devel("Dropping evil TCP offset=0 tinygram.\n");
 		*par->hotdrop = true;
 		return false;
 	}
-	pr_debug("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
+	pr_devel("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
 
 	return  SCCHECK(ntohs(sh->source) >= info->spts[0]
 			&& ntohs(sh->source) <= info->spts[1],
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index a9b1686..4be0aea 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -165,7 +165,7 @@ socket_match(const struct sk_buff *skb, const struct xt_match_param *par,
 			sk = NULL;
 	}
 
-	pr_debug("proto %u %08x:%u -> %08x:%u (orig %08x:%u) sock %p\n",
+	pr_devel("proto %u %08x:%u -> %08x:%u (orig %08x:%u) sock %p\n",
 		 protocol, ntohl(saddr), ntohs(sport),
 		 ntohl(daddr), ntohs(dport),
 		 ntohl(iph->daddr), hp ? ntohs(hp->dest) : 0, sk);
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index efa2ede..fdd9664 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -40,7 +40,7 @@ tcp_find_option(u_int8_t option,
 	u_int8_t _opt[60 - sizeof(struct tcphdr)];
 	unsigned int i;
 
-	pr_debug("finding option\n");
+	pr_devel("finding option\n");
 
 	if (!optlen)
 		return invert;
@@ -76,7 +76,7 @@ static bool tcp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		   flag overwrite to pass the direction checks.
 		*/
 		if (par->fragoff == 1) {
-			pr_debug("Dropping evil TCP offset=1 frag.\n");
+			pr_devel("Dropping evil TCP offset=1 frag.\n");
 			*par->hotdrop = true;
 		}
 		/* Must not be a fragment. */
@@ -89,7 +89,7 @@ static bool tcp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	if (th == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
-		pr_debug("Dropping evil TCP offset=0 tinygram.\n");
+		pr_devel("Dropping evil TCP offset=0 tinygram.\n");
 		*par->hotdrop = true;
 		return false;
 	}
@@ -142,7 +142,7 @@ static bool udp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	if (uh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
-		pr_debug("Dropping evil UDP tinygram.\n");
+		pr_devel("Dropping evil UDP tinygram.\n");
 		*par->hotdrop = true;
 		return false;
 	}
-- 
1.7.0.5

