Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047ADC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 09:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B37E20675
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 09:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfDZJNM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:13:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfDZJNK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 05:13:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8BB2BAD45;
        Fri, 26 Apr 2019 09:13:06 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 110E8E0143; Fri, 26 Apr 2019 11:13:06 +0200 (CEST)
Message-Id: <5278b013a953d4fb2e7944fc810f783d70ea52a5.1556269635.git.mkubecek@suse.cz>
In-Reply-To: <cover.1556269635.git.mkubecek@suse.cz>
References: <cover.1556269635.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 1/3] netlink: make nla_nest_start() add NLA_F_NESTED
 flag
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 26 Apr 2019 11:13:06 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Even if the NLA_F_NESTED flag was introduced more than 11 years ago, most
netlink based interfaces (including recently added ones) are still not
setting it in kernel generated messages. Without the flag, message parsers
not aware of attribute semantics (e.g. wireshark dissector or libmnl's
mnl_nlmsg_fprintf()) cannot recognize nested attributes and won't display
the structure of their contents.

Unfortunately we cannot just add the flag everywhere as there may be
userspace applications which check nlattr::nla_type directly rather than
through a helper masking out the flags. Therefore the patch renames
nla_nest_start() to nla_nest_start_noflag() and introduces nla_nest_start()
as a wrapper adding NLA_F_NESTED. The calls which add NLA_F_NESTED manually
are rewritten to use nla_nest_start().

Except for changes in include/net/netlink.h, the patch was generated using
this semantic patch:

@@ expression E1, E2; @@
-nla_nest_start(E1, E2)
+nla_nest_start_noflag(E1, E2)

@@ expression E1, E2; @@
-nla_nest_start_noflag(E1, E2 | NLA_F_NESTED)
+nla_nest_start(E1, E2)

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/block/drbd/drbd_nl.c                |   8 +-
 drivers/block/nbd.c                         |   4 +-
 drivers/infiniband/core/nldev.c             |   9 +-
 drivers/infiniband/hw/cxgb4/restrack.c      |   8 +-
 drivers/net/bonding/bond_netlink.c          |   8 +-
 drivers/net/ieee802154/mac802154_hwsim.c    |   6 +-
 drivers/net/macsec.c                        |  27 +--
 drivers/net/macvlan.c                       |   2 +-
 drivers/net/team/team.c                     |   8 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c |   4 +-
 include/linux/netfilter/ipset/ip_set.h      |   2 +-
 include/net/netlink.h                       |  26 ++-
 kernel/taskstats.c                          |   2 +-
 net/8021q/vlan_netlink.c                    |   4 +-
 net/bridge/br_mdb.c                         |  17 +-
 net/bridge/br_netlink.c                     |   6 +-
 net/bridge/br_netlink_tunnel.c              |   2 +-
 net/core/devlink.c                          |  78 ++++----
 net/core/lwt_bpf.c                          |   2 +-
 net/core/lwtunnel.c                         |   2 +-
 net/core/neighbour.c                        |   2 +-
 net/core/rtnetlink.c                        |  48 ++---
 net/dcb/dcbnl.c                             |  40 ++--
 net/decnet/dn_table.c                       |   2 +-
 net/ieee802154/nl802154.c                   |  34 ++--
 net/ipv4/fib_semantics.c                    |   2 +-
 net/ipv4/ipmr.c                             |   6 +-
 net/ipv4/ipmr_base.c                        |   2 +-
 net/ipv4/tcp_metrics.c                      |   2 +-
 net/ipv6/addrconf.c                         |   2 +-
 net/ipv6/route.c                            |   2 +-
 net/ipv6/seg6_local.c                       |   2 +-
 net/l2tp/l2tp_netlink.c                     |   4 +-
 net/mpls/af_mpls.c                          |   2 +-
 net/ncsi/ncsi-netlink.c                     |  12 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |  10 +-
 net/netfilter/nf_conntrack_netlink.c        |  40 ++--
 net/netfilter/nf_conntrack_proto_dccp.c     |   2 +-
 net/netfilter/nf_conntrack_proto_sctp.c     |   2 +-
 net/netfilter/nf_conntrack_proto_tcp.c      |   2 +-
 net/netfilter/nf_tables_api.c               |  29 +--
 net/netfilter/nfnetlink_cthelper.c          |   7 +-
 net/netfilter/nfnetlink_cttimeout.c         |   4 +-
 net/netfilter/nfnetlink_queue.c             |   2 +-
 net/netfilter/nft_ct.c                      |   2 +-
 net/netfilter/nft_tunnel.c                  |   6 +-
 net/netlabel/netlabel_cipso_v4.c            |  14 +-
 net/netlabel/netlabel_mgmt.c                |   8 +-
 net/netlink/genetlink.c                     |  12 +-
 net/nfc/netlink.c                           |   4 +-
 net/openvswitch/conntrack.c                 |   6 +-
 net/openvswitch/datapath.c                  |   7 +-
 net/openvswitch/flow_netlink.c              |  33 ++--
 net/openvswitch/meter.c                     |   8 +-
 net/openvswitch/vport-vxlan.c               |   2 +-
 net/openvswitch/vport.c                     |   2 +-
 net/packet/diag.c                           |   2 +-
 net/sched/act_api.c                         |  14 +-
 net/sched/act_ife.c                         |   2 +-
 net/sched/act_pedit.c                       |   5 +-
 net/sched/act_tunnel_key.c                  |   4 +-
 net/sched/cls_api.c                         |   4 +-
 net/sched/cls_basic.c                       |   2 +-
 net/sched/cls_bpf.c                         |   2 +-
 net/sched/cls_cgroup.c                      |   2 +-
 net/sched/cls_flow.c                        |   2 +-
 net/sched/cls_flower.c                      |   8 +-
 net/sched/cls_fw.c                          |   2 +-
 net/sched/cls_matchall.c                    |   2 +-
 net/sched/cls_route.c                       |   2 +-
 net/sched/cls_rsvp.h                        |   2 +-
 net/sched/cls_tcindex.c                     |   2 +-
 net/sched/cls_u32.c                         |   2 +-
 net/sched/ematch.c                          |   4 +-
 net/sched/sch_api.c                         |   2 +-
 net/sched/sch_atm.c                         |   2 +-
 net/sched/sch_cake.c                        |  10 +-
 net/sched/sch_cbq.c                         |   4 +-
 net/sched/sch_cbs.c                         |   2 +-
 net/sched/sch_choke.c                       |   2 +-
 net/sched/sch_codel.c                       |   2 +-
 net/sched/sch_drr.c                         |   2 +-
 net/sched/sch_dsmark.c                      |   4 +-
 net/sched/sch_etf.c                         |   2 +-
 net/sched/sch_fq.c                          |   2 +-
 net/sched/sch_fq_codel.c                    |   2 +-
 net/sched/sch_gred.c                        |   8 +-
 net/sched/sch_hfsc.c                        |   2 +-
 net/sched/sch_hhf.c                         |   2 +-
 net/sched/sch_htb.c                         |   4 +-
 net/sched/sch_ingress.c                     |   2 +-
 net/sched/sch_mqprio.c                      |   4 +-
 net/sched/sch_netem.c                       |   2 +-
 net/sched/sch_pie.c                         |   2 +-
 net/sched/sch_qfq.c                         |   2 +-
 net/sched/sch_red.c                         |   2 +-
 net/sched/sch_sfb.c                         |   2 +-
 net/sched/sch_taprio.c                      |   7 +-
 net/sched/sch_tbf.c                         |   2 +-
 net/tipc/bearer.c                           |   8 +-
 net/tipc/group.c                            |   2 +-
 net/tipc/link.c                             |  12 +-
 net/tipc/monitor.c                          |   4 +-
 net/tipc/name_table.c                       |   4 +-
 net/tipc/net.c                              |   2 +-
 net/tipc/netlink_compat.c                   |  24 +--
 net/tipc/node.c                             |   4 +-
 net/tipc/socket.c                           |  10 +-
 net/tipc/udp_media.c                        |   2 +-
 net/wireless/nl80211.c                      | 192 +++++++++++---------
 net/wireless/pmsr.c                         |  12 +-
 111 files changed, 539 insertions(+), 466 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f2471172a961..1cb5a0b85fd9 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -114,7 +114,7 @@ static int drbd_msg_put_info(struct sk_buff *skb, const char *info)
 	if (!info || !info[0])
 		return 0;
 
-	nla = nla_nest_start(skb, DRBD_NLA_CFG_REPLY);
+	nla = nla_nest_start_noflag(skb, DRBD_NLA_CFG_REPLY);
 	if (!nla)
 		return err;
 
@@ -135,7 +135,7 @@ static int drbd_msg_sprintf_info(struct sk_buff *skb, const char *fmt, ...)
 	int err = -EMSGSIZE;
 	int len;
 
-	nla = nla_nest_start(skb, DRBD_NLA_CFG_REPLY);
+	nla = nla_nest_start_noflag(skb, DRBD_NLA_CFG_REPLY);
 	if (!nla)
 		return err;
 
@@ -3269,7 +3269,7 @@ static int nla_put_drbd_cfg_context(struct sk_buff *skb,
 				    struct drbd_device *device)
 {
 	struct nlattr *nla;
-	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
+	nla = nla_nest_start_noflag(skb, DRBD_NLA_CFG_CONTEXT);
 	if (!nla)
 		goto nla_put_failure;
 	if (device &&
@@ -3837,7 +3837,7 @@ static int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 	if (err)
 		goto nla_put_failure;
 
-	nla = nla_nest_start(skb, DRBD_NLA_STATE_INFO);
+	nla = nla_nest_start_noflag(skb, DRBD_NLA_STATE_INFO);
 	if (!nla)
 		goto nla_put_failure;
 	if (nla_put_u32(skb, T_sib_reason, sib ? sib->sib_reason : SIB_GET_STATUS_REPLY) ||
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 92b8aafb8bb4..cd27f236431d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2047,7 +2047,7 @@ static int populate_nbd_status(struct nbd_device *nbd, struct sk_buff *reply)
 	 */
 	if (refcount_read(&nbd->config_refs))
 		connected = 1;
-	dev_opt = nla_nest_start(reply, NBD_DEVICE_ITEM);
+	dev_opt = nla_nest_start_noflag(reply, NBD_DEVICE_ITEM);
 	if (!dev_opt)
 		return -EMSGSIZE;
 	ret = nla_put_u32(reply, NBD_DEVICE_INDEX, nbd->index);
@@ -2095,7 +2095,7 @@ static int nbd_genl_status(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	dev_list = nla_nest_start(reply, NBD_ATTR_DEVICE_LIST);
+	dev_list = nla_nest_start_noflag(reply, NBD_ATTR_DEVICE_LIST);
 	if (index == -1) {
 		ret = idr_for_each(&nbd_index_idr, &status_cb, reply);
 		if (ret) {
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 11ed58d3fce5..ad189a29cc67 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -292,7 +292,8 @@ static int fill_res_info_entry(struct sk_buff *msg,
 {
 	struct nlattr *entry_attr;
 
-	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY);
+	entry_attr = nla_nest_start_noflag(msg,
+					   RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY);
 	if (!entry_attr)
 		return -EMSGSIZE;
 
@@ -327,7 +328,7 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device)
 	if (fill_nldev_handle(msg, device))
 		return -EMSGSIZE;
 
-	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_SUMMARY);
+	table_attr = nla_nest_start_noflag(msg, RDMA_NLDEV_ATTR_RES_SUMMARY);
 	if (!table_attr)
 		return -EMSGSIZE;
 
@@ -1108,7 +1109,7 @@ static int res_get_common_dumpit(struct sk_buff *skb,
 		goto err;
 	}
 
-	table_attr = nla_nest_start(skb, fe->nldev_attr);
+	table_attr = nla_nest_start_noflag(skb, fe->nldev_attr);
 	if (!table_attr) {
 		ret = -EMSGSIZE;
 		goto err;
@@ -1134,7 +1135,7 @@ static int res_get_common_dumpit(struct sk_buff *skb,
 
 		filled = true;
 
-		entry_attr = nla_nest_start(skb, fe->entry);
+		entry_attr = nla_nest_start_noflag(skb, fe->entry);
 		if (!entry_attr) {
 			ret = -EMSGSIZE;
 			rdma_restrack_put(res);
diff --git a/drivers/infiniband/hw/cxgb4/restrack.c b/drivers/infiniband/hw/cxgb4/restrack.c
index 9a7520ee41e0..f82d46ed969d 100644
--- a/drivers/infiniband/hw/cxgb4/restrack.c
+++ b/drivers/infiniband/hw/cxgb4/restrack.c
@@ -149,7 +149,7 @@ static int fill_res_qp_entry(struct sk_buff *msg,
 	if (qhp->ucontext)
 		return 0;
 
-	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
+	table_attr = nla_nest_start_noflag(msg, RDMA_NLDEV_ATTR_DRIVER);
 	if (!table_attr)
 		goto err;
 
@@ -216,7 +216,7 @@ static int fill_res_ep_entry(struct sk_buff *msg,
 	if (!uep)
 		return 0;
 
-	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
+	table_attr = nla_nest_start_noflag(msg, RDMA_NLDEV_ATTR_DRIVER);
 	if (!table_attr)
 		goto err_free_uep;
 
@@ -387,7 +387,7 @@ static int fill_res_cq_entry(struct sk_buff *msg,
 	if (ibcq->uobject)
 		return 0;
 
-	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
+	table_attr = nla_nest_start_noflag(msg, RDMA_NLDEV_ATTR_DRIVER);
 	if (!table_attr)
 		goto err;
 
@@ -447,7 +447,7 @@ static int fill_res_mr_entry(struct sk_buff *msg,
 	if (!stag)
 		return 0;
 
-	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
+	table_attr = nla_nest_start_noflag(msg, RDMA_NLDEV_ATTR_DRIVER);
 	if (!table_attr)
 		goto err;
 
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index b286f591242e..022044b59d6a 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -546,7 +546,7 @@ static int bond_fill_info(struct sk_buff *skb,
 	if (nla_put_u32(skb, IFLA_BOND_ARP_INTERVAL, bond->params.arp_interval))
 		goto nla_put_failure;
 
-	targets = nla_nest_start(skb, IFLA_BOND_ARP_IP_TARGET);
+	targets = nla_nest_start_noflag(skb, IFLA_BOND_ARP_IP_TARGET);
 	if (!targets)
 		goto nla_put_failure;
 
@@ -644,7 +644,7 @@ static int bond_fill_info(struct sk_buff *skb,
 		if (!bond_3ad_get_active_agg_info(bond, &info)) {
 			struct nlattr *nest;
 
-			nest = nla_nest_start(skb, IFLA_BOND_AD_INFO);
+			nest = nla_nest_start_noflag(skb, IFLA_BOND_AD_INFO);
 			if (!nest)
 				goto nla_put_failure;
 
@@ -711,7 +711,7 @@ static int bond_fill_linkxstats(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	nest = nla_nest_start(skb, LINK_XSTATS_TYPE_BOND);
+	nest = nla_nest_start_noflag(skb, LINK_XSTATS_TYPE_BOND);
 	if (!nest)
 		return -EMSGSIZE;
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
@@ -722,7 +722,7 @@ static int bond_fill_linkxstats(struct sk_buff *skb,
 		else
 			stats = &BOND_AD_INFO(bond).stats;
 
-		nest2 = nla_nest_start(skb, BOND_XSTATS_3AD);
+		nest2 = nla_nest_start_noflag(skb, BOND_XSTATS_3AD);
 		if (!nest2) {
 			nla_nest_end(skb, nest);
 			return -EMSGSIZE;
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 707285953750..80ca300aba04 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -227,14 +227,16 @@ static int append_radio_msg(struct sk_buff *skb, struct hwsim_phy *phy)
 		return 0;
 	}
 
-	nl_edges = nla_nest_start(skb, MAC802154_HWSIM_ATTR_RADIO_EDGES);
+	nl_edges = nla_nest_start_noflag(skb,
+					 MAC802154_HWSIM_ATTR_RADIO_EDGES);
 	if (!nl_edges) {
 		rcu_read_unlock();
 		return -ENOBUFS;
 	}
 
 	list_for_each_entry_rcu(e, &phy->edges, list) {
-		nl_edge = nla_nest_start(skb, MAC802154_HWSIM_ATTR_RADIO_EDGE);
+		nl_edge = nla_nest_start_noflag(skb,
+						MAC802154_HWSIM_ATTR_RADIO_EDGE);
 		if (!nl_edge) {
 			rcu_read_unlock();
 			nla_nest_cancel(skb, nl_edges);
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 263bfafdb004..8dedb9a9781e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2365,7 +2365,8 @@ copy_secy_stats(struct sk_buff *skb, struct pcpu_secy_stats __percpu *pstats)
 static int nla_put_secy(struct macsec_secy *secy, struct sk_buff *skb)
 {
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
-	struct nlattr *secy_nest = nla_nest_start(skb, MACSEC_ATTR_SECY);
+	struct nlattr *secy_nest = nla_nest_start_noflag(skb,
+							 MACSEC_ATTR_SECY);
 	u64 csid;
 
 	if (!secy_nest)
@@ -2435,7 +2436,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	if (nla_put_secy(secy, skb))
 		goto nla_put_failure;
 
-	attr = nla_nest_start(skb, MACSEC_ATTR_TXSC_STATS);
+	attr = nla_nest_start_noflag(skb, MACSEC_ATTR_TXSC_STATS);
 	if (!attr)
 		goto nla_put_failure;
 	if (copy_tx_sc_stats(skb, tx_sc->stats)) {
@@ -2444,7 +2445,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	}
 	nla_nest_end(skb, attr);
 
-	attr = nla_nest_start(skb, MACSEC_ATTR_SECY_STATS);
+	attr = nla_nest_start_noflag(skb, MACSEC_ATTR_SECY_STATS);
 	if (!attr)
 		goto nla_put_failure;
 	if (copy_secy_stats(skb, macsec_priv(dev)->stats)) {
@@ -2453,7 +2454,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	}
 	nla_nest_end(skb, attr);
 
-	txsa_list = nla_nest_start(skb, MACSEC_ATTR_TXSA_LIST);
+	txsa_list = nla_nest_start_noflag(skb, MACSEC_ATTR_TXSA_LIST);
 	if (!txsa_list)
 		goto nla_put_failure;
 	for (i = 0, j = 1; i < MACSEC_NUM_AN; i++) {
@@ -2463,7 +2464,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		if (!tx_sa)
 			continue;
 
-		txsa_nest = nla_nest_start(skb, j++);
+		txsa_nest = nla_nest_start_noflag(skb, j++);
 		if (!txsa_nest) {
 			nla_nest_cancel(skb, txsa_list);
 			goto nla_put_failure;
@@ -2478,7 +2479,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			goto nla_put_failure;
 		}
 
-		attr = nla_nest_start(skb, MACSEC_SA_ATTR_STATS);
+		attr = nla_nest_start_noflag(skb, MACSEC_SA_ATTR_STATS);
 		if (!attr) {
 			nla_nest_cancel(skb, txsa_nest);
 			nla_nest_cancel(skb, txsa_list);
@@ -2496,7 +2497,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	}
 	nla_nest_end(skb, txsa_list);
 
-	rxsc_list = nla_nest_start(skb, MACSEC_ATTR_RXSC_LIST);
+	rxsc_list = nla_nest_start_noflag(skb, MACSEC_ATTR_RXSC_LIST);
 	if (!rxsc_list)
 		goto nla_put_failure;
 
@@ -2504,7 +2505,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	for_each_rxsc_rtnl(secy, rx_sc) {
 		int k;
 		struct nlattr *rxsa_list;
-		struct nlattr *rxsc_nest = nla_nest_start(skb, j++);
+		struct nlattr *rxsc_nest = nla_nest_start_noflag(skb, j++);
 
 		if (!rxsc_nest) {
 			nla_nest_cancel(skb, rxsc_list);
@@ -2519,7 +2520,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			goto nla_put_failure;
 		}
 
-		attr = nla_nest_start(skb, MACSEC_RXSC_ATTR_STATS);
+		attr = nla_nest_start_noflag(skb, MACSEC_RXSC_ATTR_STATS);
 		if (!attr) {
 			nla_nest_cancel(skb, rxsc_nest);
 			nla_nest_cancel(skb, rxsc_list);
@@ -2533,7 +2534,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		}
 		nla_nest_end(skb, attr);
 
-		rxsa_list = nla_nest_start(skb, MACSEC_RXSC_ATTR_SA_LIST);
+		rxsa_list = nla_nest_start_noflag(skb,
+						  MACSEC_RXSC_ATTR_SA_LIST);
 		if (!rxsa_list) {
 			nla_nest_cancel(skb, rxsc_nest);
 			nla_nest_cancel(skb, rxsc_list);
@@ -2547,7 +2549,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			if (!rx_sa)
 				continue;
 
-			rxsa_nest = nla_nest_start(skb, k++);
+			rxsa_nest = nla_nest_start_noflag(skb, k++);
 			if (!rxsa_nest) {
 				nla_nest_cancel(skb, rxsa_list);
 				nla_nest_cancel(skb, rxsc_nest);
@@ -2555,7 +2557,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 				goto nla_put_failure;
 			}
 
-			attr = nla_nest_start(skb, MACSEC_SA_ATTR_STATS);
+			attr = nla_nest_start_noflag(skb,
+						     MACSEC_SA_ATTR_STATS);
 			if (!attr) {
 				nla_nest_cancel(skb, rxsa_list);
 				nla_nest_cancel(skb, rxsc_nest);
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4a6be8fab884..b395423b19bc 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1624,7 +1624,7 @@ static int macvlan_fill_info(struct sk_buff *skb,
 	if (nla_put_u32(skb, IFLA_MACVLAN_MACADDR_COUNT, vlan->macaddr_count))
 		goto nla_put_failure;
 	if (vlan->macaddr_count > 0) {
-		nest = nla_nest_start(skb, IFLA_MACVLAN_MACADDR_DATA);
+		nest = nla_nest_start_noflag(skb, IFLA_MACVLAN_MACADDR_DATA);
 		if (nest == NULL)
 			goto nla_put_failure;
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index eb4711bfc52a..6306897c147f 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2290,7 +2290,7 @@ static int team_nl_fill_one_option_get(struct sk_buff *skb, struct team *team,
 	if (err)
 		return err;
 
-	option_item = nla_nest_start(skb, TEAM_ATTR_ITEM_OPTION);
+	option_item = nla_nest_start_noflag(skb, TEAM_ATTR_ITEM_OPTION);
 	if (!option_item)
 		return -EMSGSIZE;
 
@@ -2404,7 +2404,7 @@ static int team_nl_send_options_get(struct team *team, u32 portid, u32 seq,
 
 	if (nla_put_u32(skb, TEAM_ATTR_TEAM_IFINDEX, team->dev->ifindex))
 		goto nla_put_failure;
-	option_list = nla_nest_start(skb, TEAM_ATTR_LIST_OPTION);
+	option_list = nla_nest_start_noflag(skb, TEAM_ATTR_LIST_OPTION);
 	if (!option_list)
 		goto nla_put_failure;
 
@@ -2626,7 +2626,7 @@ static int team_nl_fill_one_port_get(struct sk_buff *skb,
 {
 	struct nlattr *port_item;
 
-	port_item = nla_nest_start(skb, TEAM_ATTR_ITEM_PORT);
+	port_item = nla_nest_start_noflag(skb, TEAM_ATTR_ITEM_PORT);
 	if (!port_item)
 		goto nest_cancel;
 	if (nla_put_u32(skb, TEAM_ATTR_PORT_IFINDEX, port->dev->ifindex))
@@ -2681,7 +2681,7 @@ static int team_nl_send_port_list_get(struct team *team, u32 portid, u32 seq,
 
 	if (nla_put_u32(skb, TEAM_ATTR_TEAM_IFINDEX, team->dev->ifindex))
 		goto nla_put_failure;
-	port_list = nla_nest_start(skb, TEAM_ATTR_LIST_PORT);
+	port_list = nla_nest_start_noflag(skb, TEAM_ATTR_LIST_PORT);
 	if (!port_list)
 		goto nla_put_failure;
 
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a1e226652b4a..cac18e61474e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -2679,13 +2679,13 @@ static int wil_rf_sector_get_cfg(struct wiphy *wiphy,
 			      QCA_ATTR_PAD))
 		goto nla_put_failure;
 
-	nl_cfgs = nla_nest_start(msg, QCA_ATTR_DMG_RF_SECTOR_CFG);
+	nl_cfgs = nla_nest_start_noflag(msg, QCA_ATTR_DMG_RF_SECTOR_CFG);
 	if (!nl_cfgs)
 		goto nla_put_failure;
 	for (i = 0; i < WMI_MAX_RF_MODULES_NUM; i++) {
 		if (!(rf_modules_vec & BIT(i)))
 			continue;
-		nl_cfg = nla_nest_start(msg, i);
+		nl_cfg = nla_nest_start_noflag(msg, i);
 		if (!nl_cfg)
 			goto nla_put_failure;
 		si = &reply.evt.sectors_info[i];
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index f2e1e6b13ca4..965dc6c6653e 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -401,7 +401,7 @@ ip_set_get_h16(const struct nlattr *attr)
 	return ntohs(nla_get_be16(attr));
 }
 
-#define ipset_nest_start(skb, attr) nla_nest_start(skb, attr | NLA_F_NESTED)
+#define ipset_nest_start(skb, attr) nla_nest_start(skb, attr)
 #define ipset_nest_end(skb, start)  nla_nest_end(skb, start)
 
 static inline int nla_put_ipaddr4(struct sk_buff *skb, int type, __be32 ipaddr)
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 23f27b0b3cef..1f18b47f41b4 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1415,13 +1415,18 @@ static inline void *nla_memdup(const struct nlattr *src, gfp_t gfp)
 }
 
 /**
- * nla_nest_start - Start a new level of nested attributes
+ * nla_nest_start_noflag - Start a new level of nested attributes
  * @skb: socket buffer to add attributes to
  * @attrtype: attribute type of container
  *
- * Returns the container attribute
+ * This function exists for backward compatibility to use in APIs which never
+ * marked their nest attributes with NLA_F_NESTED flag. New APIs should use
+ * nla_nest_start() which sets the flag.
+ *
+ * Returns the container attribute or NULL on error
  */
-static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
+static inline struct nlattr *nla_nest_start_noflag(struct sk_buff *skb,
+						   int attrtype)
 {
 	struct nlattr *start = (struct nlattr *)skb_tail_pointer(skb);
 
@@ -1431,6 +1436,21 @@ static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
 	return start;
 }
 
+/**
+ * nla_nest_start - Start a new level of nested attributes, with NLA_F_NESTED
+ * @skb: socket buffer to add attributes to
+ * @attrtype: attribute type of container
+ *
+ * Unlike nla_nest_start_noflag(), mark the nest attribute with NLA_F_NESTED
+ * flag. This is the preferred function to use in new code.
+ *
+ * Returns the container attribute or NULL on error
+ */
+static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
+{
+	return nla_nest_start_noflag(skb, attrtype | NLA_F_NESTED);
+}
+
 /**
  * nla_nest_end - Finalize nesting of attributes
  * @skb: socket buffer the attributes are stored in
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 1b942a7caf26..ef4f9cd980fd 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -375,7 +375,7 @@ static struct taskstats *mk_reply(struct sk_buff *skb, int type, u32 pid)
 			? TASKSTATS_TYPE_AGGR_PID
 			: TASKSTATS_TYPE_AGGR_TGID;
 
-	na = nla_nest_start(skb, aggr);
+	na = nla_nest_start_noflag(skb, aggr);
 	if (!na)
 		goto err;
 
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index a624dccf68fd..ab4921e7797b 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -227,7 +227,7 @@ static int vlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 			goto nla_put_failure;
 	}
 	if (vlan->nr_ingress_mappings) {
-		nest = nla_nest_start(skb, IFLA_VLAN_INGRESS_QOS);
+		nest = nla_nest_start_noflag(skb, IFLA_VLAN_INGRESS_QOS);
 		if (nest == NULL)
 			goto nla_put_failure;
 
@@ -245,7 +245,7 @@ static int vlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	}
 
 	if (vlan->nr_egress_mappings) {
-		nest = nla_nest_start(skb, IFLA_VLAN_EGRESS_QOS);
+		nest = nla_nest_start_noflag(skb, IFLA_VLAN_EGRESS_QOS);
 		if (nest == NULL)
 			goto nla_put_failure;
 
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index f69c8d91dc81..3619c1a12a77 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -26,14 +26,14 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	if (!br->multicast_router || hlist_empty(&br->router_list))
 		return 0;
 
-	nest = nla_nest_start(skb, MDBA_ROUTER);
+	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
 	if (nest == NULL)
 		return -EMSGSIZE;
 
 	hlist_for_each_entry_rcu(p, &br->router_list, rlist) {
 		if (!p)
 			continue;
-		port_nest = nla_nest_start(skb, MDBA_ROUTER_PORT);
+		port_nest = nla_nest_start_noflag(skb, MDBA_ROUTER_PORT);
 		if (!port_nest)
 			goto fail;
 		if (nla_put_nohdr(skb, sizeof(u32), &p->dev->ifindex) ||
@@ -86,7 +86,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return 0;
 
-	nest = nla_nest_start(skb, MDBA_MDB);
+	nest = nla_nest_start_noflag(skb, MDBA_MDB);
 	if (nest == NULL)
 		return -EMSGSIZE;
 
@@ -98,7 +98,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 		if (idx < s_idx)
 			goto skip;
 
-		nest2 = nla_nest_start(skb, MDBA_MDB_ENTRY);
+		nest2 = nla_nest_start_noflag(skb, MDBA_MDB_ENTRY);
 		if (!nest2) {
 			err = -EMSGSIZE;
 			break;
@@ -124,7 +124,8 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 				e.addr.u.ip6 = p->addr.u.ip6;
 #endif
 			e.addr.proto = p->addr.proto;
-			nest_ent = nla_nest_start(skb, MDBA_MDB_ENTRY_INFO);
+			nest_ent = nla_nest_start_noflag(skb,
+							 MDBA_MDB_ENTRY_INFO);
 			if (!nest_ent) {
 				nla_nest_cancel(skb, nest2);
 				err = -EMSGSIZE;
@@ -248,10 +249,10 @@ static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 	memset(bpm, 0, sizeof(*bpm));
 	bpm->family  = AF_BRIDGE;
 	bpm->ifindex = dev->ifindex;
-	nest = nla_nest_start(skb, MDBA_MDB);
+	nest = nla_nest_start_noflag(skb, MDBA_MDB);
 	if (nest == NULL)
 		goto cancel;
-	nest2 = nla_nest_start(skb, MDBA_MDB_ENTRY);
+	nest2 = nla_nest_start_noflag(skb, MDBA_MDB_ENTRY);
 	if (nest2 == NULL)
 		goto end;
 
@@ -444,7 +445,7 @@ static int nlmsg_populate_rtr_fill(struct sk_buff *skb,
 	memset(bpm, 0, sizeof(*bpm));
 	bpm->family = AF_BRIDGE;
 	bpm->ifindex = dev->ifindex;
-	nest = nla_nest_start(skb, MDBA_ROUTER);
+	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
 	if (!nest)
 		goto cancel;
 
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8dfcc2d285d8..0914477c4719 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -414,7 +414,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 
 	if (event == RTM_NEWLINK && port) {
 		struct nlattr *nest
-			= nla_nest_start(skb, IFLA_PROTINFO | NLA_F_NESTED);
+			= nla_nest_start(skb, IFLA_PROTINFO);
 
 		if (nest == NULL || br_port_fill_attrs(skb, port) < 0)
 			goto nla_put_failure;
@@ -439,7 +439,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			rcu_read_unlock();
 			goto done;
 		}
-		af = nla_nest_start(skb, IFLA_AF_SPEC);
+		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 		if (!af) {
 			rcu_read_unlock();
 			goto nla_put_failure;
@@ -1569,7 +1569,7 @@ static int br_fill_linkxstats(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	nest = nla_nest_start(skb, LINK_XSTATS_TYPE_BRIDGE);
+	nest = nla_nest_start_noflag(skb, LINK_XSTATS_TYPE_BRIDGE);
 	if (!nest)
 		return -EMSGSIZE;
 
diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index da8cb99fd259..787e140dc4b5 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -97,7 +97,7 @@ static int br_fill_vlan_tinfo(struct sk_buff *skb, u16 vid,
 	__be32 tid = tunnel_id_to_key32(tunnel_id);
 	struct nlattr *tmap;
 
-	tmap = nla_nest_start(skb, IFLA_BRIDGE_VLAN_TUNNEL_INFO);
+	tmap = nla_nest_start_noflag(skb, IFLA_BRIDGE_VLAN_TUNNEL_INFO);
 	if (!tmap)
 		return -EMSGSIZE;
 	if (nla_put_u32(skb, IFLA_BRIDGE_VLAN_TUNNEL_ID,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b91605e75d6..b94f326f5f06 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1671,7 +1671,7 @@ int devlink_dpipe_match_put(struct sk_buff *skb,
 	struct devlink_dpipe_field *field = &header->fields[match->field_id];
 	struct nlattr *match_attr;
 
-	match_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_MATCH);
+	match_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_MATCH);
 	if (!match_attr)
 		return -EMSGSIZE;
 
@@ -1696,7 +1696,8 @@ static int devlink_dpipe_matches_put(struct devlink_dpipe_table *table,
 {
 	struct nlattr *matches_attr;
 
-	matches_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_TABLE_MATCHES);
+	matches_attr = nla_nest_start_noflag(skb,
+					     DEVLINK_ATTR_DPIPE_TABLE_MATCHES);
 	if (!matches_attr)
 		return -EMSGSIZE;
 
@@ -1718,7 +1719,7 @@ int devlink_dpipe_action_put(struct sk_buff *skb,
 	struct devlink_dpipe_field *field = &header->fields[action->field_id];
 	struct nlattr *action_attr;
 
-	action_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_ACTION);
+	action_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_ACTION);
 	if (!action_attr)
 		return -EMSGSIZE;
 
@@ -1743,7 +1744,8 @@ static int devlink_dpipe_actions_put(struct devlink_dpipe_table *table,
 {
 	struct nlattr *actions_attr;
 
-	actions_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_TABLE_ACTIONS);
+	actions_attr = nla_nest_start_noflag(skb,
+					     DEVLINK_ATTR_DPIPE_TABLE_ACTIONS);
 	if (!actions_attr)
 		return -EMSGSIZE;
 
@@ -1765,7 +1767,7 @@ static int devlink_dpipe_table_put(struct sk_buff *skb,
 	u64 table_size;
 
 	table_size = table->table_ops->size_get(table->priv);
-	table_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_TABLE);
+	table_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_TABLE);
 	if (!table_attr)
 		return -EMSGSIZE;
 
@@ -1845,7 +1847,7 @@ static int devlink_dpipe_tables_fill(struct genl_info *info,
 
 	if (devlink_nl_put_handle(skb, devlink))
 		goto nla_put_failure;
-	tables_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_TABLES);
+	tables_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_TABLES);
 	if (!tables_attr)
 		goto nla_put_failure;
 
@@ -1946,8 +1948,8 @@ static int devlink_dpipe_action_values_put(struct sk_buff *skb,
 	int err;
 
 	for (i = 0; i < values_count; i++) {
-		action_attr = nla_nest_start(skb,
-					     DEVLINK_ATTR_DPIPE_ACTION_VALUE);
+		action_attr = nla_nest_start_noflag(skb,
+						    DEVLINK_ATTR_DPIPE_ACTION_VALUE);
 		if (!action_attr)
 			return -EMSGSIZE;
 		err = devlink_dpipe_action_value_put(skb, &values[i]);
@@ -1983,8 +1985,8 @@ static int devlink_dpipe_match_values_put(struct sk_buff *skb,
 	int err;
 
 	for (i = 0; i < values_count; i++) {
-		match_attr = nla_nest_start(skb,
-					    DEVLINK_ATTR_DPIPE_MATCH_VALUE);
+		match_attr = nla_nest_start_noflag(skb,
+						   DEVLINK_ATTR_DPIPE_MATCH_VALUE);
 		if (!match_attr)
 			return -EMSGSIZE;
 		err = devlink_dpipe_match_value_put(skb, &values[i]);
@@ -2005,7 +2007,7 @@ static int devlink_dpipe_entry_put(struct sk_buff *skb,
 	struct nlattr *entry_attr, *matches_attr, *actions_attr;
 	int err;
 
-	entry_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_ENTRY);
+	entry_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_ENTRY);
 	if (!entry_attr)
 		return  -EMSGSIZE;
 
@@ -2017,8 +2019,8 @@ static int devlink_dpipe_entry_put(struct sk_buff *skb,
 				      entry->counter, DEVLINK_ATTR_PAD))
 			goto nla_put_failure;
 
-	matches_attr = nla_nest_start(skb,
-				      DEVLINK_ATTR_DPIPE_ENTRY_MATCH_VALUES);
+	matches_attr = nla_nest_start_noflag(skb,
+					     DEVLINK_ATTR_DPIPE_ENTRY_MATCH_VALUES);
 	if (!matches_attr)
 		goto nla_put_failure;
 
@@ -2030,8 +2032,8 @@ static int devlink_dpipe_entry_put(struct sk_buff *skb,
 	}
 	nla_nest_end(skb, matches_attr);
 
-	actions_attr = nla_nest_start(skb,
-				      DEVLINK_ATTR_DPIPE_ENTRY_ACTION_VALUES);
+	actions_attr = nla_nest_start_noflag(skb,
+					     DEVLINK_ATTR_DPIPE_ENTRY_ACTION_VALUES);
 	if (!actions_attr)
 		goto nla_put_failure;
 
@@ -2088,8 +2090,8 @@ int devlink_dpipe_entry_ctx_prepare(struct devlink_dpipe_dump_ctx *dump_ctx)
 	devlink = dump_ctx->info->user_ptr[0];
 	if (devlink_nl_put_handle(dump_ctx->skb, devlink))
 		goto nla_put_failure;
-	dump_ctx->nest = nla_nest_start(dump_ctx->skb,
-					DEVLINK_ATTR_DPIPE_ENTRIES);
+	dump_ctx->nest = nla_nest_start_noflag(dump_ctx->skb,
+					       DEVLINK_ATTR_DPIPE_ENTRIES);
 	if (!dump_ctx->nest)
 		goto nla_put_failure;
 	return 0;
@@ -2199,7 +2201,8 @@ static int devlink_dpipe_fields_put(struct sk_buff *skb,
 
 	for (i = 0; i < header->fields_count; i++) {
 		field = &header->fields[i];
-		field_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_FIELD);
+		field_attr = nla_nest_start_noflag(skb,
+						   DEVLINK_ATTR_DPIPE_FIELD);
 		if (!field_attr)
 			return -EMSGSIZE;
 		if (nla_put_string(skb, DEVLINK_ATTR_DPIPE_FIELD_NAME, field->name) ||
@@ -2222,7 +2225,7 @@ static int devlink_dpipe_header_put(struct sk_buff *skb,
 	struct nlattr *fields_attr, *header_attr;
 	int err;
 
-	header_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_HEADER);
+	header_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_HEADER);
 	if (!header_attr)
 		return -EMSGSIZE;
 
@@ -2231,7 +2234,8 @@ static int devlink_dpipe_header_put(struct sk_buff *skb,
 	    nla_put_u8(skb, DEVLINK_ATTR_DPIPE_HEADER_GLOBAL, header->global))
 		goto nla_put_failure;
 
-	fields_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_HEADER_FIELDS);
+	fields_attr = nla_nest_start_noflag(skb,
+					    DEVLINK_ATTR_DPIPE_HEADER_FIELDS);
 	if (!fields_attr)
 		goto nla_put_failure;
 
@@ -2278,7 +2282,7 @@ static int devlink_dpipe_headers_fill(struct genl_info *info,
 
 	if (devlink_nl_put_handle(skb, devlink))
 		goto nla_put_failure;
-	headers_attr = nla_nest_start(skb, DEVLINK_ATTR_DPIPE_HEADERS);
+	headers_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_DPIPE_HEADERS);
 	if (!headers_attr)
 		goto nla_put_failure;
 
@@ -2502,7 +2506,7 @@ static int devlink_resource_put(struct devlink *devlink, struct sk_buff *skb,
 	struct nlattr *child_resource_attr;
 	struct nlattr *resource_attr;
 
-	resource_attr = nla_nest_start(skb, DEVLINK_ATTR_RESOURCE);
+	resource_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_RESOURCE);
 	if (!resource_attr)
 		return -EMSGSIZE;
 
@@ -2526,7 +2530,8 @@ static int devlink_resource_put(struct devlink *devlink, struct sk_buff *skb,
 		       resource->size_valid))
 		goto nla_put_failure;
 
-	child_resource_attr = nla_nest_start(skb, DEVLINK_ATTR_RESOURCE_LIST);
+	child_resource_attr = nla_nest_start_noflag(skb,
+						    DEVLINK_ATTR_RESOURCE_LIST);
 	if (!child_resource_attr)
 		goto nla_put_failure;
 
@@ -2577,7 +2582,8 @@ static int devlink_resource_fill(struct genl_info *info,
 	if (devlink_nl_put_handle(skb, devlink))
 		goto nla_put_failure;
 
-	resources_attr = nla_nest_start(skb, DEVLINK_ATTR_RESOURCE_LIST);
+	resources_attr = nla_nest_start_noflag(skb,
+					       DEVLINK_ATTR_RESOURCE_LIST);
 	if (!resources_attr)
 		goto nla_put_failure;
 
@@ -2831,7 +2837,8 @@ devlink_nl_param_value_fill_one(struct sk_buff *msg,
 {
 	struct nlattr *param_value_attr;
 
-	param_value_attr = nla_nest_start(msg, DEVLINK_ATTR_PARAM_VALUE);
+	param_value_attr = nla_nest_start_noflag(msg,
+						 DEVLINK_ATTR_PARAM_VALUE);
 	if (!param_value_attr)
 		goto nla_put_failure;
 
@@ -2922,7 +2929,7 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, port_index))
 			goto genlmsg_cancel;
 
-	param_attr = nla_nest_start(msg, DEVLINK_ATTR_PARAM);
+	param_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_PARAM);
 	if (!param_attr)
 		goto genlmsg_cancel;
 	if (nla_put_string(msg, DEVLINK_ATTR_PARAM_NAME, param->name))
@@ -2936,7 +2943,8 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_PARAM_TYPE, nla_type))
 		goto param_nest_cancel;
 
-	param_values_list = nla_nest_start(msg, DEVLINK_ATTR_PARAM_VALUES_LIST);
+	param_values_list = nla_nest_start_noflag(msg,
+						  DEVLINK_ATTR_PARAM_VALUES_LIST);
 	if (!param_values_list)
 		goto param_nest_cancel;
 
@@ -3336,7 +3344,7 @@ static int devlink_nl_region_snapshot_id_put(struct sk_buff *msg,
 	struct nlattr *snap_attr;
 	int err;
 
-	snap_attr = nla_nest_start(msg, DEVLINK_ATTR_REGION_SNAPSHOT);
+	snap_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_REGION_SNAPSHOT);
 	if (!snap_attr)
 		return -EINVAL;
 
@@ -3360,7 +3368,8 @@ static int devlink_nl_region_snapshots_id_put(struct sk_buff *msg,
 	struct nlattr *snapshots_attr;
 	int err;
 
-	snapshots_attr = nla_nest_start(msg, DEVLINK_ATTR_REGION_SNAPSHOTS);
+	snapshots_attr = nla_nest_start_noflag(msg,
+					       DEVLINK_ATTR_REGION_SNAPSHOTS);
 	if (!snapshots_attr)
 		return -EINVAL;
 
@@ -3576,7 +3585,7 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 	struct nlattr *chunk_attr;
 	int err;
 
-	chunk_attr = nla_nest_start(msg, DEVLINK_ATTR_REGION_CHUNK);
+	chunk_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_REGION_CHUNK);
 	if (!chunk_attr)
 		return -EINVAL;
 
@@ -3709,7 +3718,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	if (err)
 		goto nla_put_failure;
 
-	chunks_attr = nla_nest_start(skb, DEVLINK_ATTR_REGION_CHUNKS);
+	chunks_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_REGION_CHUNKS);
 	if (!chunks_attr) {
 		err = -EMSGSIZE;
 		goto nla_put_failure;
@@ -3785,7 +3794,7 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	struct nlattr *nest;
 	int err;
 
-	nest = nla_nest_start(req->msg, attr);
+	nest = nla_nest_start_noflag(req->msg, attr);
 	if (!nest)
 		return -EMSGSIZE;
 
@@ -4313,7 +4322,7 @@ devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	int i = 0;
 	int err;
 
-	fmsg_nlattr = nla_nest_start(skb, DEVLINK_ATTR_FMSG);
+	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
 	if (!fmsg_nlattr)
 		return -EMSGSIZE;
 
@@ -4665,7 +4674,8 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	if (devlink_nl_put_handle(msg, devlink))
 		goto genlmsg_cancel;
 
-	reporter_attr = nla_nest_start(msg, DEVLINK_ATTR_HEALTH_REPORTER);
+	reporter_attr = nla_nest_start_noflag(msg,
+					      DEVLINK_ATTR_HEALTH_REPORTER);
 	if (!reporter_attr)
 		goto genlmsg_cancel;
 	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 3c5c24a5d9f5..bbdfc8db1960 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -453,7 +453,7 @@ static int bpf_fill_lwt_prog(struct sk_buff *skb, int attr,
 	if (!prog->prog)
 		return 0;
 
-	nest = nla_nest_start(skb, attr);
+	nest = nla_nest_start_noflag(skb, attr);
 	if (!nest)
 		return -EMSGSIZE;
 
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 94749e0e2cfd..69e249fbc02f 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -237,7 +237,7 @@ int lwtunnel_fill_encap(struct sk_buff *skb, struct lwtunnel_state *lwtstate,
 	    lwtstate->type > LWTUNNEL_ENCAP_MAX)
 		return 0;
 
-	nest = nla_nest_start(skb, encap_attr);
+	nest = nla_nest_start_noflag(skb, encap_attr);
 	if (!nest)
 		return -EMSGSIZE;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 997cfa8f99ba..efd0b53d9ca4 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1979,7 +1979,7 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, NDTA_PARMS);
+	nest = nla_nest_start_noflag(skb, NDTA_PARMS);
 	if (nest == NULL)
 		return -ENOBUFS;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5fa5bf3e9945..8ad44b299e72 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -634,7 +634,7 @@ static int rtnl_link_slave_info_fill(struct sk_buff *skb,
 	if (nla_put_string(skb, IFLA_INFO_SLAVE_KIND, ops->kind) < 0)
 		return -EMSGSIZE;
 	if (ops->fill_slave_info) {
-		slave_data = nla_nest_start(skb, IFLA_INFO_SLAVE_DATA);
+		slave_data = nla_nest_start_noflag(skb, IFLA_INFO_SLAVE_DATA);
 		if (!slave_data)
 			return -EMSGSIZE;
 		err = ops->fill_slave_info(skb, master_dev, dev);
@@ -666,7 +666,7 @@ static int rtnl_link_info_fill(struct sk_buff *skb,
 			return err;
 	}
 	if (ops->fill_info) {
-		data = nla_nest_start(skb, IFLA_INFO_DATA);
+		data = nla_nest_start_noflag(skb, IFLA_INFO_DATA);
 		if (data == NULL)
 			return -EMSGSIZE;
 		err = ops->fill_info(skb, dev);
@@ -686,7 +686,7 @@ static int rtnl_link_fill(struct sk_buff *skb, const struct net_device *dev)
 	struct nlattr *linkinfo;
 	int err = -EMSGSIZE;
 
-	linkinfo = nla_nest_start(skb, IFLA_LINKINFO);
+	linkinfo = nla_nest_start_noflag(skb, IFLA_LINKINFO);
 	if (linkinfo == NULL)
 		goto out;
 
@@ -755,7 +755,7 @@ int rtnetlink_put_metrics(struct sk_buff *skb, u32 *metrics)
 	struct nlattr *mx;
 	int i, valid = 0;
 
-	mx = nla_nest_start(skb, RTA_METRICS);
+	mx = nla_nest_start_noflag(skb, RTA_METRICS);
 	if (mx == NULL)
 		return -ENOBUFS;
 
@@ -1036,12 +1036,12 @@ static int rtnl_vf_ports_fill(struct sk_buff *skb, struct net_device *dev)
 	int vf;
 	int err;
 
-	vf_ports = nla_nest_start(skb, IFLA_VF_PORTS);
+	vf_ports = nla_nest_start_noflag(skb, IFLA_VF_PORTS);
 	if (!vf_ports)
 		return -EMSGSIZE;
 
 	for (vf = 0; vf < dev_num_vf(dev->dev.parent); vf++) {
-		vf_port = nla_nest_start(skb, IFLA_VF_PORT);
+		vf_port = nla_nest_start_noflag(skb, IFLA_VF_PORT);
 		if (!vf_port)
 			goto nla_put_failure;
 		if (nla_put_u32(skb, IFLA_PORT_VF, vf))
@@ -1070,7 +1070,7 @@ static int rtnl_port_self_fill(struct sk_buff *skb, struct net_device *dev)
 	struct nlattr *port_self;
 	int err;
 
-	port_self = nla_nest_start(skb, IFLA_PORT_SELF);
+	port_self = nla_nest_start_noflag(skb, IFLA_PORT_SELF);
 	if (!port_self)
 		return -EMSGSIZE;
 
@@ -1247,7 +1247,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	vf_linkstate.link_state = ivi.linkstate;
 	vf_rss_query_en.setting = ivi.rss_query_en;
 	vf_trust.setting = ivi.trusted;
-	vf = nla_nest_start(skb, IFLA_VF_INFO);
+	vf = nla_nest_start_noflag(skb, IFLA_VF_INFO);
 	if (!vf)
 		goto nla_put_vfinfo_failure;
 	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
@@ -1266,7 +1266,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	    nla_put(skb, IFLA_VF_TRUST,
 		    sizeof(vf_trust), &vf_trust))
 		goto nla_put_vf_failure;
-	vfvlanlist = nla_nest_start(skb, IFLA_VF_VLAN_LIST);
+	vfvlanlist = nla_nest_start_noflag(skb, IFLA_VF_VLAN_LIST);
 	if (!vfvlanlist)
 		goto nla_put_vf_failure;
 	if (nla_put(skb, IFLA_VF_VLAN_INFO, sizeof(vf_vlan_info),
@@ -1279,7 +1279,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	if (dev->netdev_ops->ndo_get_vf_stats)
 		dev->netdev_ops->ndo_get_vf_stats(dev, vfs_num,
 						&vf_stats);
-	vfstats = nla_nest_start(skb, IFLA_VF_STATS);
+	vfstats = nla_nest_start_noflag(skb, IFLA_VF_STATS);
 	if (!vfstats)
 		goto nla_put_vf_failure;
 	if (nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_PACKETS,
@@ -1329,7 +1329,7 @@ static noinline_for_stack int rtnl_fill_vf(struct sk_buff *skb,
 	if (!dev->netdev_ops->ndo_get_vf_config)
 		return 0;
 
-	vfinfo = nla_nest_start(skb, IFLA_VFINFO_LIST);
+	vfinfo = nla_nest_start_noflag(skb, IFLA_VFINFO_LIST);
 	if (!vfinfo)
 		return -EMSGSIZE;
 
@@ -1414,7 +1414,7 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 	int err;
 	u8 mode;
 
-	xdp = nla_nest_start(skb, IFLA_XDP);
+	xdp = nla_nest_start_noflag(skb, IFLA_XDP);
 	if (!xdp)
 		return -EMSGSIZE;
 
@@ -1541,7 +1541,7 @@ static int rtnl_fill_link_af(struct sk_buff *skb,
 	const struct rtnl_af_ops *af_ops;
 	struct nlattr *af_spec;
 
-	af_spec = nla_nest_start(skb, IFLA_AF_SPEC);
+	af_spec = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 	if (!af_spec)
 		return -EMSGSIZE;
 
@@ -1552,7 +1552,7 @@ static int rtnl_fill_link_af(struct sk_buff *skb,
 		if (!af_ops->fill_link_af)
 			continue;
 
-		af = nla_nest_start(skb, af_ops->family);
+		af = nla_nest_start_noflag(skb, af_ops->family);
 		if (!af)
 			return -EMSGSIZE;
 
@@ -4273,7 +4273,7 @@ int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))))
 		goto nla_put_failure;
 
-	br_afspec = nla_nest_start(skb, IFLA_AF_SPEC);
+	br_afspec = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 	if (!br_afspec)
 		goto nla_put_failure;
 
@@ -4297,7 +4297,7 @@ int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	}
 	nla_nest_end(skb, br_afspec);
 
-	protinfo = nla_nest_start(skb, IFLA_PROTINFO | NLA_F_NESTED);
+	protinfo = nla_nest_start(skb, IFLA_PROTINFO);
 	if (!protinfo)
 		goto nla_put_failure;
 
@@ -4776,8 +4776,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 
 		if (ops && ops->fill_linkxstats) {
 			*idxattr = IFLA_STATS_LINK_XSTATS;
-			attr = nla_nest_start(skb,
-					      IFLA_STATS_LINK_XSTATS);
+			attr = nla_nest_start_noflag(skb,
+						     IFLA_STATS_LINK_XSTATS);
 			if (!attr)
 				goto nla_put_failure;
 
@@ -4799,8 +4799,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			ops = master->rtnl_link_ops;
 		if (ops && ops->fill_linkxstats) {
 			*idxattr = IFLA_STATS_LINK_XSTATS_SLAVE;
-			attr = nla_nest_start(skb,
-					      IFLA_STATS_LINK_XSTATS_SLAVE);
+			attr = nla_nest_start_noflag(skb,
+						     IFLA_STATS_LINK_XSTATS_SLAVE);
 			if (!attr)
 				goto nla_put_failure;
 
@@ -4815,7 +4815,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS,
 			     *idxattr)) {
 		*idxattr = IFLA_STATS_LINK_OFFLOAD_XSTATS;
-		attr = nla_nest_start(skb, IFLA_STATS_LINK_OFFLOAD_XSTATS);
+		attr = nla_nest_start_noflag(skb,
+					     IFLA_STATS_LINK_OFFLOAD_XSTATS);
 		if (!attr)
 			goto nla_put_failure;
 
@@ -4834,7 +4835,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		struct rtnl_af_ops *af_ops;
 
 		*idxattr = IFLA_STATS_AF_SPEC;
-		attr = nla_nest_start(skb, IFLA_STATS_AF_SPEC);
+		attr = nla_nest_start_noflag(skb, IFLA_STATS_AF_SPEC);
 		if (!attr)
 			goto nla_put_failure;
 
@@ -4844,7 +4845,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 				struct nlattr *af;
 				int err;
 
-				af = nla_nest_start(skb, af_ops->family);
+				af = nla_nest_start_noflag(skb,
+							   af_ops->family);
 				if (!af) {
 					rcu_read_unlock();
 					goto nla_put_failure;
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index a556cd708885..3fd3aa7348bd 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -246,7 +246,7 @@ static int dcbnl_getpfccfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (ret)
 		return ret;
 
-	nest = nla_nest_start(skb, DCB_ATTR_PFC_CFG);
+	nest = nla_nest_start_noflag(skb, DCB_ATTR_PFC_CFG);
 	if (!nest)
 		return -EMSGSIZE;
 
@@ -304,7 +304,7 @@ static int dcbnl_getcap(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (ret)
 		return ret;
 
-	nest = nla_nest_start(skb, DCB_ATTR_CAP);
+	nest = nla_nest_start_noflag(skb, DCB_ATTR_CAP);
 	if (!nest)
 		return -EMSGSIZE;
 
@@ -348,7 +348,7 @@ static int dcbnl_getnumtcs(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (ret)
 		return ret;
 
-	nest = nla_nest_start(skb, DCB_ATTR_NUMTCS);
+	nest = nla_nest_start_noflag(skb, DCB_ATTR_NUMTCS);
 	if (!nest)
 		return -EMSGSIZE;
 
@@ -479,7 +479,7 @@ static int dcbnl_getapp(struct net_device *netdev, struct nlmsghdr *nlh,
 		up = dcb_getapp(netdev, &app);
 	}
 
-	app_nest = nla_nest_start(skb, DCB_ATTR_APP);
+	app_nest = nla_nest_start_noflag(skb, DCB_ATTR_APP);
 	if (!app_nest)
 		return -EMSGSIZE;
 
@@ -578,7 +578,7 @@ static int __dcbnl_pg_getcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (ret)
 		return ret;
 
-	pg_nest = nla_nest_start(skb, DCB_ATTR_PG_CFG);
+	pg_nest = nla_nest_start_noflag(skb, DCB_ATTR_PG_CFG);
 	if (!pg_nest)
 		return -EMSGSIZE;
 
@@ -598,7 +598,7 @@ static int __dcbnl_pg_getcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 		if (ret)
 			goto err_pg;
 
-		param_nest = nla_nest_start(skb, i);
+		param_nest = nla_nest_start_noflag(skb, i);
 		if (!param_nest)
 			goto err_pg;
 
@@ -889,7 +889,7 @@ static int dcbnl_bcn_getcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (ret)
 		return ret;
 
-	bcn_nest = nla_nest_start(skb, DCB_ATTR_BCN);
+	bcn_nest = nla_nest_start_noflag(skb, DCB_ATTR_BCN);
 	if (!bcn_nest)
 		return -EMSGSIZE;
 
@@ -1002,7 +1002,7 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
 		 */
 		err = -EMSGSIZE;
 
-		app = nla_nest_start(skb, app_nested_type);
+		app = nla_nest_start_noflag(skb, app_nested_type);
 		if (!app)
 			goto nla_put_failure;
 
@@ -1036,7 +1036,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	if (nla_put_string(skb, DCB_ATTR_IFNAME, netdev->name))
 		return -EMSGSIZE;
 
-	ieee = nla_nest_start(skb, DCB_ATTR_IEEE);
+	ieee = nla_nest_start_noflag(skb, DCB_ATTR_IEEE);
 	if (!ieee)
 		return -EMSGSIZE;
 
@@ -1106,7 +1106,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 			return -EMSGSIZE;
 	}
 
-	app = nla_nest_start(skb, DCB_ATTR_IEEE_APP_TABLE);
+	app = nla_nest_start_noflag(skb, DCB_ATTR_IEEE_APP_TABLE);
 	if (!app)
 		return -EMSGSIZE;
 
@@ -1174,13 +1174,13 @@ static int dcbnl_cee_pg_fill(struct sk_buff *skb, struct net_device *dev,
 	u8 pgid, up_map, prio, tc_pct;
 	const struct dcbnl_rtnl_ops *ops = dev->dcbnl_ops;
 	int i = dir ? DCB_ATTR_CEE_TX_PG : DCB_ATTR_CEE_RX_PG;
-	struct nlattr *pg = nla_nest_start(skb, i);
+	struct nlattr *pg = nla_nest_start_noflag(skb, i);
 
 	if (!pg)
 		return -EMSGSIZE;
 
 	for (i = DCB_PG_ATTR_TC_0; i <= DCB_PG_ATTR_TC_7; i++) {
-		struct nlattr *tc_nest = nla_nest_start(skb, i);
+		struct nlattr *tc_nest = nla_nest_start_noflag(skb, i);
 
 		if (!tc_nest)
 			return -EMSGSIZE;
@@ -1231,7 +1231,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (nla_put_string(skb, DCB_ATTR_IFNAME, netdev->name))
 		goto nla_put_failure;
-	cee = nla_nest_start(skb, DCB_ATTR_CEE);
+	cee = nla_nest_start_noflag(skb, DCB_ATTR_CEE);
 	if (!cee)
 		goto nla_put_failure;
 
@@ -1250,7 +1250,8 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	/* local pfc */
 	if (ops->getpfccfg) {
-		struct nlattr *pfc_nest = nla_nest_start(skb, DCB_ATTR_CEE_PFC);
+		struct nlattr *pfc_nest = nla_nest_start_noflag(skb,
+								DCB_ATTR_CEE_PFC);
 
 		if (!pfc_nest)
 			goto nla_put_failure;
@@ -1265,14 +1266,14 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	/* local app */
 	spin_lock_bh(&dcb_lock);
-	app = nla_nest_start(skb, DCB_ATTR_CEE_APP_TABLE);
+	app = nla_nest_start_noflag(skb, DCB_ATTR_CEE_APP_TABLE);
 	if (!app)
 		goto dcb_unlock;
 
 	list_for_each_entry(itr, &dcb_app_list, list) {
 		if (itr->ifindex == netdev->ifindex) {
-			struct nlattr *app_nest = nla_nest_start(skb,
-								 DCB_ATTR_APP);
+			struct nlattr *app_nest = nla_nest_start_noflag(skb,
+									DCB_ATTR_APP);
 			if (!app_nest)
 				goto dcb_unlock;
 
@@ -1305,7 +1306,8 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	/* features flags */
 	if (ops->getfeatcfg) {
-		struct nlattr *feat = nla_nest_start(skb, DCB_ATTR_CEE_FEAT);
+		struct nlattr *feat = nla_nest_start_noflag(skb,
+							    DCB_ATTR_CEE_FEAT);
 		if (!feat)
 			goto nla_put_failure;
 
@@ -1607,7 +1609,7 @@ static int dcbnl_getfeatcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (ret)
 		return ret;
 
-	nest = nla_nest_start(skb, DCB_ATTR_FEATCFG);
+	nest = nla_nest_start_noflag(skb, DCB_ATTR_FEATCFG);
 	if (!nest)
 		return -EMSGSIZE;
 
diff --git a/net/decnet/dn_table.c b/net/decnet/dn_table.c
index f0710b5d037d..2fb764321b97 100644
--- a/net/decnet/dn_table.c
+++ b/net/decnet/dn_table.c
@@ -348,7 +348,7 @@ static int dn_fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		struct rtnexthop *nhp;
 		struct nlattr *mp_head;
 
-		if (!(mp_head = nla_nest_start(skb, RTA_MULTIPATH)))
+		if (!(mp_head = nla_nest_start_noflag(skb, RTA_MULTIPATH)))
 			goto errout;
 
 		for_nexthops(fi) {
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 308370cfd668..1a002eb85096 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -312,7 +312,7 @@ static inline void *nl802154hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
 static int
 nl802154_put_flags(struct sk_buff *msg, int attr, u32 mask)
 {
-	struct nlattr *nl_flags = nla_nest_start(msg, attr);
+	struct nlattr *nl_flags = nla_nest_start_noflag(msg, attr);
 	int i;
 
 	if (!nl_flags)
@@ -338,7 +338,7 @@ nl802154_send_wpan_phy_channels(struct cfg802154_registered_device *rdev,
 	struct nlattr *nl_page;
 	unsigned long page;
 
-	nl_page = nla_nest_start(msg, NL802154_ATTR_CHANNELS_SUPPORTED);
+	nl_page = nla_nest_start_noflag(msg, NL802154_ATTR_CHANNELS_SUPPORTED);
 	if (!nl_page)
 		return -ENOBUFS;
 
@@ -360,11 +360,11 @@ nl802154_put_capabilities(struct sk_buff *msg,
 	struct nlattr *nl_caps, *nl_channels;
 	int i;
 
-	nl_caps = nla_nest_start(msg, NL802154_ATTR_WPAN_PHY_CAPS);
+	nl_caps = nla_nest_start_noflag(msg, NL802154_ATTR_WPAN_PHY_CAPS);
 	if (!nl_caps)
 		return -ENOBUFS;
 
-	nl_channels = nla_nest_start(msg, NL802154_CAP_ATTR_CHANNELS);
+	nl_channels = nla_nest_start_noflag(msg, NL802154_CAP_ATTR_CHANNELS);
 	if (!nl_channels)
 		return -ENOBUFS;
 
@@ -380,8 +380,8 @@ nl802154_put_capabilities(struct sk_buff *msg,
 	if (rdev->wpan_phy.flags & WPAN_PHY_FLAG_CCA_ED_LEVEL) {
 		struct nlattr *nl_ed_lvls;
 
-		nl_ed_lvls = nla_nest_start(msg,
-					    NL802154_CAP_ATTR_CCA_ED_LEVELS);
+		nl_ed_lvls = nla_nest_start_noflag(msg,
+						   NL802154_CAP_ATTR_CCA_ED_LEVELS);
 		if (!nl_ed_lvls)
 			return -ENOBUFS;
 
@@ -396,7 +396,8 @@ nl802154_put_capabilities(struct sk_buff *msg,
 	if (rdev->wpan_phy.flags & WPAN_PHY_FLAG_TXPOWER) {
 		struct nlattr *nl_tx_pwrs;
 
-		nl_tx_pwrs = nla_nest_start(msg, NL802154_CAP_ATTR_TX_POWERS);
+		nl_tx_pwrs = nla_nest_start_noflag(msg,
+						   NL802154_CAP_ATTR_TX_POWERS);
 		if (!nl_tx_pwrs)
 			return -ENOBUFS;
 
@@ -504,7 +505,7 @@ static int nl802154_send_wpan_phy(struct cfg802154_registered_device *rdev,
 	if (nl802154_put_capabilities(msg, rdev))
 		goto nla_put_failure;
 
-	nl_cmds = nla_nest_start(msg, NL802154_ATTR_SUPPORTED_COMMANDS);
+	nl_cmds = nla_nest_start_noflag(msg, NL802154_ATTR_SUPPORTED_COMMANDS);
 	if (!nl_cmds)
 		goto nla_put_failure;
 
@@ -693,7 +694,8 @@ ieee802154_llsec_send_key_id(struct sk_buff *msg,
 
 	switch (desc->mode) {
 	case NL802154_KEY_ID_MODE_IMPLICIT:
-		nl_dev_addr = nla_nest_start(msg, NL802154_KEY_ID_ATTR_IMPLICIT);
+		nl_dev_addr = nla_nest_start_noflag(msg,
+						    NL802154_KEY_ID_ATTR_IMPLICIT);
 		if (!nl_dev_addr)
 			return -ENOBUFS;
 
@@ -768,7 +770,7 @@ static int nl802154_get_llsec_params(struct sk_buff *msg,
 			 params.frame_counter))
 		return -ENOBUFS;
 
-	nl_key_id = nla_nest_start(msg, NL802154_ATTR_SEC_OUT_KEY_ID);
+	nl_key_id = nla_nest_start_noflag(msg, NL802154_ATTR_SEC_OUT_KEY_ID);
 	if (!nl_key_id)
 		return -ENOBUFS;
 
@@ -1455,11 +1457,11 @@ static int nl802154_send_key(struct sk_buff *msg, u32 cmd, u32 portid,
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
-	nl_key = nla_nest_start(msg, NL802154_ATTR_SEC_KEY);
+	nl_key = nla_nest_start_noflag(msg, NL802154_ATTR_SEC_KEY);
 	if (!nl_key)
 		goto nla_put_failure;
 
-	nl_key_id = nla_nest_start(msg, NL802154_KEY_ATTR_ID);
+	nl_key_id = nla_nest_start_noflag(msg, NL802154_KEY_ATTR_ID);
 	if (!nl_key_id)
 		goto nla_put_failure;
 
@@ -1639,7 +1641,7 @@ static int nl802154_send_device(struct sk_buff *msg, u32 cmd, u32 portid,
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
-	nl_device = nla_nest_start(msg, NL802154_ATTR_SEC_DEVICE);
+	nl_device = nla_nest_start_noflag(msg, NL802154_ATTR_SEC_DEVICE);
 	if (!nl_device)
 		goto nla_put_failure;
 
@@ -1808,7 +1810,7 @@ static int nl802154_send_devkey(struct sk_buff *msg, u32 cmd, u32 portid,
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
-	nl_devkey = nla_nest_start(msg, NL802154_ATTR_SEC_DEVKEY);
+	nl_devkey = nla_nest_start_noflag(msg, NL802154_ATTR_SEC_DEVKEY);
 	if (!nl_devkey)
 		goto nla_put_failure;
 
@@ -1818,7 +1820,7 @@ static int nl802154_send_devkey(struct sk_buff *msg, u32 cmd, u32 portid,
 			devkey->frame_counter))
 		goto nla_put_failure;
 
-	nl_key_id = nla_nest_start(msg, NL802154_DEVKEY_ATTR_ID);
+	nl_key_id = nla_nest_start_noflag(msg, NL802154_DEVKEY_ATTR_ID);
 	if (!nl_key_id)
 		goto nla_put_failure;
 
@@ -1976,7 +1978,7 @@ static int nl802154_send_seclevel(struct sk_buff *msg, u32 cmd, u32 portid,
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
-	nl_seclevel = nla_nest_start(msg, NL802154_ATTR_SEC_LEVEL);
+	nl_seclevel = nla_nest_start_noflag(msg, NL802154_ATTR_SEC_LEVEL);
 	if (!nl_seclevel)
 		goto nla_put_failure;
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4336f1ec8ab0..71c2165a2ce3 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1550,7 +1550,7 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 {
 	struct nlattr *mp;
 
-	mp = nla_nest_start(skb, RTA_MULTIPATH);
+	mp = nla_nest_start_noflag(skb, RTA_MULTIPATH);
 	if (!mp)
 		goto nla_put_failure;
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index a8eb97777c0a..1322573b8228 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2783,7 +2783,7 @@ static bool ipmr_fill_vif(struct mr_table *mrt, u32 vifid, struct sk_buff *skb)
 		return true;
 
 	vif = &mrt->vif_table[vifid];
-	vif_nest = nla_nest_start(skb, IPMRA_VIF);
+	vif_nest = nla_nest_start_noflag(skb, IPMRA_VIF);
 	if (!vif_nest)
 		return false;
 	if (nla_put_u32(skb, IPMRA_VIFA_IFINDEX, vif->dev->ifindex) ||
@@ -2867,7 +2867,7 @@ static int ipmr_rtm_dumplink(struct sk_buff *skb, struct netlink_callback *cb)
 		memset(hdr, 0, sizeof(*hdr));
 		hdr->ifi_family = RTNL_FAMILY_IPMR;
 
-		af = nla_nest_start(skb, IFLA_AF_SPEC);
+		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 		if (!af) {
 			nlmsg_cancel(skb, nlh);
 			goto out;
@@ -2878,7 +2878,7 @@ static int ipmr_rtm_dumplink(struct sk_buff *skb, struct netlink_callback *cb)
 			goto out;
 		}
 
-		vifs = nla_nest_start(skb, IPMRA_TABLE_VIFS);
+		vifs = nla_nest_start_noflag(skb, IPMRA_TABLE_VIFS);
 		if (!vifs) {
 			nla_nest_end(skb, af);
 			nlmsg_end(skb, nlh);
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 3e614cc824f7..278834d4babc 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -228,7 +228,7 @@ int mr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 	if (c->mfc_flags & MFC_OFFLOAD)
 		rtm->rtm_flags |= RTNH_F_OFFLOAD;
 
-	mp_attr = nla_nest_start(skb, RTA_MULTIPATH);
+	mp_attr = nla_nest_start_noflag(skb, RTA_MULTIPATH);
 	if (!mp_attr)
 		return -EMSGSIZE;
 
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 4ccec4c705f7..9a08bfb0672c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -658,7 +658,7 @@ static int tcp_metrics_fill_info(struct sk_buff *msg,
 	{
 		int n = 0;
 
-		nest = nla_nest_start(msg, TCP_METRICS_ATTR_VALS);
+		nest = nla_nest_start_noflag(msg, TCP_METRICS_ATTR_VALS);
 		if (!nest)
 			goto nla_put_failure;
 		for (i = 0; i < TCP_METRIC_MAX_KERNEL + 1; i++) {
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 340a0f06f974..01f081aa718c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5752,7 +5752,7 @@ static int inet6_fill_ifinfo(struct sk_buff *skb, struct inet6_dev *idev,
 	    nla_put_u8(skb, IFLA_OPERSTATE,
 		       netif_running(dev) ? dev->operstate : IF_OPER_DOWN))
 		goto nla_put_failure;
-	protoinfo = nla_nest_start(skb, IFLA_PROTINFO);
+	protoinfo = nla_nest_start_noflag(skb, IFLA_PROTINFO);
 	if (!protoinfo)
 		goto nla_put_failure;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9c0127a44f9f..e2b47f47de92 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4777,7 +4777,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		struct fib6_info *sibling, *next_sibling;
 		struct nlattr *mp;
 
-		mp = nla_nest_start(skb, RTA_MULTIPATH);
+		mp = nla_nest_start_noflag(skb, RTA_MULTIPATH);
 		if (!mp)
 			goto nla_put_failure;
 
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 60325dbfe88b..67005ac71341 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -853,7 +853,7 @@ static int put_nla_bpf(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (!slwt->bpf.prog)
 		return 0;
 
-	nest = nla_nest_start(skb, SEG6_LOCAL_BPF);
+	nest = nla_nest_start_noflag(skb, SEG6_LOCAL_BPF);
 	if (!nest)
 		return -EMSGSIZE;
 
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 77595fcc9f75..c31b50cc48d9 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -345,7 +345,7 @@ static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int fla
 	    nla_put_u16(skb, L2TP_ATTR_ENCAP_TYPE, tunnel->encap))
 		goto nla_put_failure;
 
-	nest = nla_nest_start(skb, L2TP_ATTR_STATS);
+	nest = nla_nest_start_noflag(skb, L2TP_ATTR_STATS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
@@ -742,7 +742,7 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 			   session->reorder_timeout, L2TP_ATTR_PAD)))
 		goto nla_put_failure;
 
-	nest = nla_nest_start(skb, L2TP_ATTR_STATS);
+	nest = nla_nest_start_noflag(skb, L2TP_ATTR_STATS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index e321a5fafb87..01f8a4f97872 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2017,7 +2017,7 @@ static int mpls_dump_route(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		u8 linkdown = 0;
 		u8 dead = 0;
 
-		mp = nla_nest_start(skb, RTA_MULTIPATH);
+		mp = nla_nest_start_noflag(skb, RTA_MULTIPATH);
 		if (!mp)
 			goto nla_put_failure;
 
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index 367b2f6513e0..672ed56b5ef0 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -79,7 +79,7 @@ static int ncsi_write_channel_info(struct sk_buff *skb,
 	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.alpha2);
 	nla_put_string(skb, NCSI_CHANNEL_ATTR_VERSION_STR, nc->version.fw_name);
 
-	vid_nest = nla_nest_start(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
+	vid_nest = nla_nest_start_noflag(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
 	if (!vid_nest)
 		return -ENOMEM;
 	ncf = &nc->vlan_filter;
@@ -113,19 +113,19 @@ static int ncsi_write_package_info(struct sk_buff *skb,
 	NCSI_FOR_EACH_PACKAGE(ndp, np) {
 		if (np->id != id)
 			continue;
-		pnest = nla_nest_start(skb, NCSI_PKG_ATTR);
+		pnest = nla_nest_start_noflag(skb, NCSI_PKG_ATTR);
 		if (!pnest)
 			return -ENOMEM;
 		nla_put_u32(skb, NCSI_PKG_ATTR_ID, np->id);
 		if ((0x1 << np->id) == ndp->package_whitelist)
 			nla_put_flag(skb, NCSI_PKG_ATTR_FORCED);
-		cnest = nla_nest_start(skb, NCSI_PKG_ATTR_CHANNEL_LIST);
+		cnest = nla_nest_start_noflag(skb, NCSI_PKG_ATTR_CHANNEL_LIST);
 		if (!cnest) {
 			nla_nest_cancel(skb, pnest);
 			return -ENOMEM;
 		}
 		NCSI_FOR_EACH_CHANNEL(np, nc) {
-			nest = nla_nest_start(skb, NCSI_CHANNEL_ATTR);
+			nest = nla_nest_start_noflag(skb, NCSI_CHANNEL_ATTR);
 			if (!nest) {
 				nla_nest_cancel(skb, cnest);
 				nla_nest_cancel(skb, pnest);
@@ -187,7 +187,7 @@ static int ncsi_pkg_info_nl(struct sk_buff *msg, struct genl_info *info)
 
 	package_id = nla_get_u32(info->attrs[NCSI_ATTR_PACKAGE_ID]);
 
-	attr = nla_nest_start(skb, NCSI_ATTR_PACKAGE_LIST);
+	attr = nla_nest_start_noflag(skb, NCSI_ATTR_PACKAGE_LIST);
 	if (!attr) {
 		kfree_skb(skb);
 		return -EMSGSIZE;
@@ -250,7 +250,7 @@ static int ncsi_pkg_info_all_nl(struct sk_buff *skb,
 		goto err;
 	}
 
-	attr = nla_nest_start(skb, NCSI_ATTR_PACKAGE_LIST);
+	attr = nla_nest_start_noflag(skb, NCSI_ATTR_PACKAGE_LIST);
 	if (!attr) {
 		rc = -EMSGSIZE;
 		goto err;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ab119a7540db..39892e5d38a2 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2916,7 +2916,7 @@ static const struct nla_policy ip_vs_dest_policy[IPVS_DEST_ATTR_MAX + 1] = {
 static int ip_vs_genl_fill_stats(struct sk_buff *skb, int container_type,
 				 struct ip_vs_kstats *kstats)
 {
-	struct nlattr *nl_stats = nla_nest_start(skb, container_type);
+	struct nlattr *nl_stats = nla_nest_start_noflag(skb, container_type);
 
 	if (!nl_stats)
 		return -EMSGSIZE;
@@ -2946,7 +2946,7 @@ static int ip_vs_genl_fill_stats(struct sk_buff *skb, int container_type,
 static int ip_vs_genl_fill_stats64(struct sk_buff *skb, int container_type,
 				   struct ip_vs_kstats *kstats)
 {
-	struct nlattr *nl_stats = nla_nest_start(skb, container_type);
+	struct nlattr *nl_stats = nla_nest_start_noflag(skb, container_type);
 
 	if (!nl_stats)
 		return -EMSGSIZE;
@@ -2992,7 +2992,7 @@ static int ip_vs_genl_fill_service(struct sk_buff *skb,
 	struct ip_vs_kstats kstats;
 	char *sched_name;
 
-	nl_service = nla_nest_start(skb, IPVS_CMD_ATTR_SERVICE);
+	nl_service = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_SERVICE);
 	if (!nl_service)
 		return -EMSGSIZE;
 
@@ -3203,7 +3203,7 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 	struct nlattr *nl_dest;
 	struct ip_vs_kstats kstats;
 
-	nl_dest = nla_nest_start(skb, IPVS_CMD_ATTR_DEST);
+	nl_dest = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_DEST);
 	if (!nl_dest)
 		return -EMSGSIZE;
 
@@ -3373,7 +3373,7 @@ static int ip_vs_genl_fill_daemon(struct sk_buff *skb, __u32 state,
 {
 	struct nlattr *nl_daemon;
 
-	nl_daemon = nla_nest_start(skb, IPVS_CMD_ATTR_DAEMON);
+	nl_daemon = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_DAEMON);
 	if (!nl_daemon)
 		return -EMSGSIZE;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d547a777192f..148b99a15b21 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -63,7 +63,7 @@ static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 	int ret = 0;
 	struct nlattr *nest_parms;
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_PROTO | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_PROTO);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (nla_put_u8(skb, CTA_PROTO_NUM, tuple->dst.protonum))
@@ -104,7 +104,7 @@ static int ctnetlink_dump_tuples_ip(struct sk_buff *skb,
 	int ret = 0;
 	struct nlattr *nest_parms;
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_IP | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_IP);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -187,7 +187,7 @@ static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
 	if (!l4proto->to_nlattr)
 		return 0;
 
-	nest_proto = nla_nest_start(skb, CTA_PROTOINFO | NLA_F_NESTED);
+	nest_proto = nla_nest_start(skb, CTA_PROTOINFO);
 	if (!nest_proto)
 		goto nla_put_failure;
 
@@ -215,7 +215,7 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
 	if (!helper)
 		goto out;
 
-	nest_helper = nla_nest_start(skb, CTA_HELP | NLA_F_NESTED);
+	nest_helper = nla_nest_start(skb, CTA_HELP);
 	if (!nest_helper)
 		goto nla_put_failure;
 	if (nla_put_string(skb, CTA_HELP_NAME, helper->name))
@@ -249,7 +249,7 @@ dump_counters(struct sk_buff *skb, struct nf_conn_acct *acct,
 		bytes = atomic64_read(&counter[dir].bytes);
 	}
 
-	nest_count = nla_nest_start(skb, attr | NLA_F_NESTED);
+	nest_count = nla_nest_start(skb, attr);
 	if (!nest_count)
 		goto nla_put_failure;
 
@@ -293,7 +293,7 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!tstamp)
 		return 0;
 
-	nest_count = nla_nest_start(skb, CTA_TIMESTAMP | NLA_F_NESTED);
+	nest_count = nla_nest_start(skb, CTA_TIMESTAMP);
 	if (!nest_count)
 		goto nla_put_failure;
 
@@ -337,7 +337,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 		return 0;
 
 	ret = -1;
-	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
+	nest_secctx = nla_nest_start(skb, CTA_SECCTX);
 	if (!nest_secctx)
 		goto nla_put_failure;
 
@@ -397,7 +397,7 @@ static int ctnetlink_dump_master(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!(ct->status & IPS_EXPECTED))
 		return 0;
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_MASTER | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_MASTER);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, master_tuple(ct)) < 0)
@@ -415,7 +415,7 @@ dump_ct_seq_adj(struct sk_buff *skb, const struct nf_ct_seqadj *seq, int type)
 {
 	struct nlattr *nest_parms;
 
-	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, type);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -467,7 +467,7 @@ static int ctnetlink_dump_ct_synproxy(struct sk_buff *skb, struct nf_conn *ct)
 	if (!synproxy)
 		return 0;
 
-	nest_parms = nla_nest_start(skb, CTA_SYNPROXY | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_SYNPROXY);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -528,7 +528,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 
 	zone = nf_ct_zone(ct);
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
@@ -538,7 +538,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
@@ -720,7 +720,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 
 	zone = nf_ct_zone(ct);
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
@@ -730,7 +730,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
@@ -2400,7 +2400,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
@@ -2410,7 +2410,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
-	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
@@ -2472,7 +2472,7 @@ ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct,
 {
 	struct nlattr *nest_parms;
 
-	nest_parms = nla_nest_start(skb, ct_attr | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, ct_attr);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -2644,7 +2644,7 @@ static int ctnetlink_exp_dump_tuple(struct sk_buff *skb,
 {
 	struct nlattr *nest_parms;
 
-	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, type);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple) < 0)
@@ -2671,7 +2671,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	m.src.u.all = mask->src.u.all;
 	m.dst.protonum = tuple->dst.protonum;
 
-	nest_parms = nla_nest_start(skb, CTA_EXPECT_MASK | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_EXPECT_MASK);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -2743,7 +2743,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #if IS_ENABLED(CONFIG_NF_NAT)
 	if (!nf_inet_addr_cmp(&exp->saved_addr, &any_addr) ||
 	    exp->saved_proto.all) {
-		nest_parms = nla_nest_start(skb, CTA_EXPECT_NAT | NLA_F_NESTED);
+		nest_parms = nla_nest_start(skb, CTA_EXPECT_NAT);
 		if (!nest_parms)
 			goto nla_put_failure;
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 6fca80587505..a4deddebec0a 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -598,7 +598,7 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	struct nlattr *nest_parms;
 
 	spin_lock_bh(&ct->lock);
-	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_DCCP | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_DCCP);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state) ||
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index a7818101ad80..8cf36b684400 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -520,7 +520,7 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	struct nlattr *nest_parms;
 
 	spin_lock_bh(&ct->lock);
-	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_SCTP | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_SCTP);
 	if (!nest_parms)
 		goto nla_put_failure;
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a06875a466a4..ec6c3618333d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1192,7 +1192,7 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	struct nf_ct_tcp_flags tmp = {};
 
 	spin_lock_bh(&ct->lock);
-	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_TCP | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_TCP);
 	if (!nest_parms)
 		goto nla_put_failure;
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9d888dc6be38..2b79c250ecb4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1200,7 +1200,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 		total.pkts += pkts;
 		total.bytes += bytes;
 	}
-	nest = nla_nest_start(skb, NFTA_CHAIN_COUNTERS);
+	nest = nla_nest_start_noflag(skb, NFTA_CHAIN_COUNTERS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
@@ -1248,7 +1248,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nf_hook_ops *ops = &basechain->ops;
 		struct nlattr *nest;
 
-		nest = nla_nest_start(skb, NFTA_CHAIN_HOOK);
+		nest = nla_nest_start_noflag(skb, NFTA_CHAIN_HOOK);
 		if (nest == NULL)
 			goto nla_put_failure;
 		if (nla_put_be32(skb, NFTA_HOOK_HOOKNUM, htonl(ops->hooknum)))
@@ -2059,7 +2059,8 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (expr->ops->dump) {
-		struct nlattr *data = nla_nest_start(skb, NFTA_EXPR_DATA);
+		struct nlattr *data = nla_nest_start_noflag(skb,
+							    NFTA_EXPR_DATA);
 		if (data == NULL)
 			goto nla_put_failure;
 		if (expr->ops->dump(skb, expr) < 0)
@@ -2078,7 +2079,7 @@ int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, attr);
+	nest = nla_nest_start_noflag(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
 	if (nf_tables_fill_expr_info(skb, expr) < 0)
@@ -2289,7 +2290,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			goto nla_put_failure;
 	}
 
-	list = nla_nest_start(skb, NFTA_RULE_EXPRESSIONS);
+	list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
 	if (list == NULL)
 		goto nla_put_failure;
 	nft_rule_for_each_expr(expr, next, rule) {
@@ -3258,7 +3259,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
 		goto nla_put_failure;
 
-	desc = nla_nest_start(skb, NFTA_SET_DESC);
+	desc = nla_nest_start_noflag(skb, NFTA_SET_DESC);
 	if (desc == NULL)
 		goto nla_put_failure;
 	if (set->size &&
@@ -3908,7 +3909,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, NFTA_LIST_ELEM);
+	nest = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
 	if (nest == NULL)
 		goto nla_put_failure;
 
@@ -4052,7 +4053,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_SET, set->name))
 		goto nla_put_failure;
 
-	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
+	nest = nla_nest_start_noflag(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
@@ -4124,7 +4125,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
 		goto nla_put_failure;
 
-	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
+	nest = nla_nest_start_noflag(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
@@ -5014,7 +5015,7 @@ static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, attr);
+	nest = nla_nest_start_noflag(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
 	if (obj->ops->dump(skb, obj, reset) < 0)
@@ -5831,14 +5832,14 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
-	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
+	nest = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK);
 	if (!nest)
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_NUM, htonl(flowtable->hooknum)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->priority)))
 		goto nla_put_failure;
 
-	nest_devs = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK_DEVS);
+	nest_devs = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK_DEVS);
 	if (!nest_devs)
 		goto nla_put_failure;
 
@@ -7264,7 +7265,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type, const struct nft_verdict *v)
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, type);
+	nest = nla_nest_start_noflag(skb, type);
 	if (!nest)
 		goto nla_put_failure;
 
@@ -7377,7 +7378,7 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 	struct nlattr *nest;
 	int err;
 
-	nest = nla_nest_start(skb, attr);
+	nest = nla_nest_start_noflag(skb, attr);
 	if (nest == NULL)
 		return -1;
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index e5d27b2e4eba..74c9794d28d6 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -462,7 +462,7 @@ nfnl_cthelper_dump_tuple(struct sk_buff *skb,
 {
 	struct nlattr *nest_parms;
 
-	nest_parms = nla_nest_start(skb, NFCTH_TUPLE | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, NFCTH_TUPLE);
 	if (nest_parms == NULL)
 		goto nla_put_failure;
 
@@ -487,7 +487,7 @@ nfnl_cthelper_dump_policy(struct sk_buff *skb,
 	int i;
 	struct nlattr *nest_parms1, *nest_parms2;
 
-	nest_parms1 = nla_nest_start(skb, NFCTH_POLICY | NLA_F_NESTED);
+	nest_parms1 = nla_nest_start(skb, NFCTH_POLICY);
 	if (nest_parms1 == NULL)
 		goto nla_put_failure;
 
@@ -496,8 +496,7 @@ nfnl_cthelper_dump_policy(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
-		nest_parms2 = nla_nest_start(skb,
-				(NFCTH_POLICY_SET+i) | NLA_F_NESTED);
+		nest_parms2 = nla_nest_start(skb, (NFCTH_POLICY_SET + i));
 		if (nest_parms2 == NULL)
 			goto nla_put_failure;
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index c69b11ca5aad..572cb42e1ee1 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -184,7 +184,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			 htonl(refcount_read(&timeout->refcnt))))
 		goto nla_put_failure;
 
-	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -401,7 +401,7 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
 	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto))
 		goto nla_put_failure;
 
-	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA);
 	if (!nest_parms)
 		goto nla_put_failure;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e057b2961d31..be7d53943e2d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -351,7 +351,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 	if (skb_vlan_tag_present(entskb)) {
 		struct nlattr *nest;
 
-		nest = nla_nest_start(skb, NFQA_VLAN | NLA_F_NESTED);
+		nest = nla_nest_start(skb, NFQA_VLAN);
 		if (!nest)
 			goto nla_put_failure;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 7b717fad6cdc..1738ef6dcb56 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -928,7 +928,7 @@ static int nft_ct_timeout_obj_dump(struct sk_buff *skb,
 	    nla_put_be16(skb, NFTA_CT_TIMEOUT_L3PROTO, htons(timeout->l3num)))
 		return -1;
 
-	nest_params = nla_nest_start(skb, NFTA_CT_TIMEOUT_DATA | NLA_F_NESTED);
+	nest_params = nla_nest_start(skb, NFTA_CT_TIMEOUT_DATA);
 	if (!nest_params)
 		return -1;
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b113fcac94e1..66b52d015763 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -437,7 +437,7 @@ static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
 	struct nlattr *nest;
 
 	if (info->mode & IP_TUNNEL_INFO_IPV6) {
-		nest = nla_nest_start(skb, NFTA_TUNNEL_KEY_IP6);
+		nest = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_IP6);
 		if (!nest)
 			return -1;
 
@@ -448,7 +448,7 @@ static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
 
 		nla_nest_end(skb, nest);
 	} else {
-		nest = nla_nest_start(skb, NFTA_TUNNEL_KEY_IP);
+		nest = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_IP);
 		if (!nest)
 			return -1;
 
@@ -468,7 +468,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 	struct nft_tunnel_opts *opts = &priv->opts;
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, NFTA_TUNNEL_KEY_OPTS);
+	nest = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS);
 	if (!nest)
 		return -1;
 
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index ba7800f94ccc..c9775658fb98 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -498,7 +498,7 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 	if (ret_val != 0)
 		goto list_failure_lock;
 
-	nla_a = nla_nest_start(ans_skb, NLBL_CIPSOV4_A_TAGLST);
+	nla_a = nla_nest_start_noflag(ans_skb, NLBL_CIPSOV4_A_TAGLST);
 	if (nla_a == NULL) {
 		ret_val = -ENOMEM;
 		goto list_failure_lock;
@@ -517,7 +517,8 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 
 	switch (doi_def->type) {
 	case CIPSO_V4_MAP_TRANS:
-		nla_a = nla_nest_start(ans_skb, NLBL_CIPSOV4_A_MLSLVLLST);
+		nla_a = nla_nest_start_noflag(ans_skb,
+					      NLBL_CIPSOV4_A_MLSLVLLST);
 		if (nla_a == NULL) {
 			ret_val = -ENOMEM;
 			goto list_failure_lock;
@@ -529,7 +530,8 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 			    CIPSO_V4_INV_LVL)
 				continue;
 
-			nla_b = nla_nest_start(ans_skb, NLBL_CIPSOV4_A_MLSLVL);
+			nla_b = nla_nest_start_noflag(ans_skb,
+						      NLBL_CIPSOV4_A_MLSLVL);
 			if (nla_b == NULL) {
 				ret_val = -ENOMEM;
 				goto list_retry;
@@ -548,7 +550,8 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 		}
 		nla_nest_end(ans_skb, nla_a);
 
-		nla_a = nla_nest_start(ans_skb, NLBL_CIPSOV4_A_MLSCATLST);
+		nla_a = nla_nest_start_noflag(ans_skb,
+					      NLBL_CIPSOV4_A_MLSCATLST);
 		if (nla_a == NULL) {
 			ret_val = -ENOMEM;
 			goto list_retry;
@@ -560,7 +563,8 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 			    CIPSO_V4_INV_CAT)
 				continue;
 
-			nla_b = nla_nest_start(ans_skb, NLBL_CIPSOV4_A_MLSCAT);
+			nla_b = nla_nest_start_noflag(ans_skb,
+						      NLBL_CIPSOV4_A_MLSCAT);
 			if (nla_b == NULL) {
 				ret_val = -ENOMEM;
 				goto list_retry;
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index a16eacfb2236..c6c8a101f2ff 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -315,7 +315,7 @@ static int netlbl_mgmt_listentry(struct sk_buff *skb,
 
 	switch (entry->def.type) {
 	case NETLBL_NLTYPE_ADDRSELECT:
-		nla_a = nla_nest_start(skb, NLBL_MGMT_A_SELECTORLIST);
+		nla_a = nla_nest_start_noflag(skb, NLBL_MGMT_A_SELECTORLIST);
 		if (nla_a == NULL)
 			return -ENOMEM;
 
@@ -323,7 +323,8 @@ static int netlbl_mgmt_listentry(struct sk_buff *skb,
 			struct netlbl_domaddr4_map *map4;
 			struct in_addr addr_struct;
 
-			nla_b = nla_nest_start(skb, NLBL_MGMT_A_ADDRSELECTOR);
+			nla_b = nla_nest_start_noflag(skb,
+						      NLBL_MGMT_A_ADDRSELECTOR);
 			if (nla_b == NULL)
 				return -ENOMEM;
 
@@ -357,7 +358,8 @@ static int netlbl_mgmt_listentry(struct sk_buff *skb,
 		netlbl_af6list_foreach_rcu(iter6, &entry->def.addrsel->list6) {
 			struct netlbl_domaddr6_map *map6;
 
-			nla_b = nla_nest_start(skb, NLBL_MGMT_A_ADDRSELECTOR);
+			nla_b = nla_nest_start_noflag(skb,
+						      NLBL_MGMT_A_ADDRSELECTOR);
 			if (nla_b == NULL)
 				return -ENOMEM;
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 288456090710..83e876591f6c 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -665,7 +665,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 		struct nlattr *nla_ops;
 		int i;
 
-		nla_ops = nla_nest_start(skb, CTRL_ATTR_OPS);
+		nla_ops = nla_nest_start_noflag(skb, CTRL_ATTR_OPS);
 		if (nla_ops == NULL)
 			goto nla_put_failure;
 
@@ -681,7 +681,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 			if (family->policy)
 				op_flags |= GENL_CMD_CAP_HASPOL;
 
-			nest = nla_nest_start(skb, i + 1);
+			nest = nla_nest_start_noflag(skb, i + 1);
 			if (nest == NULL)
 				goto nla_put_failure;
 
@@ -699,7 +699,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 		struct nlattr *nla_grps;
 		int i;
 
-		nla_grps = nla_nest_start(skb, CTRL_ATTR_MCAST_GROUPS);
+		nla_grps = nla_nest_start_noflag(skb, CTRL_ATTR_MCAST_GROUPS);
 		if (nla_grps == NULL)
 			goto nla_put_failure;
 
@@ -709,7 +709,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 
 			grp = &family->mcgrps[i];
 
-			nest = nla_nest_start(skb, i + 1);
+			nest = nla_nest_start_noflag(skb, i + 1);
 			if (nest == NULL)
 				goto nla_put_failure;
 
@@ -749,11 +749,11 @@ static int ctrl_fill_mcgrp_info(const struct genl_family *family,
 	    nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, family->id))
 		goto nla_put_failure;
 
-	nla_grps = nla_nest_start(skb, CTRL_ATTR_MCAST_GROUPS);
+	nla_grps = nla_nest_start_noflag(skb, CTRL_ATTR_MCAST_GROUPS);
 	if (nla_grps == NULL)
 		goto nla_put_failure;
 
-	nest = nla_nest_start(skb, 1);
+	nest = nla_nest_start_noflag(skb, 1);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 4d9f3ac8d562..f91ce7c82746 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -392,7 +392,7 @@ int nfc_genl_llc_send_sdres(struct nfc_dev *dev, struct hlist_head *sdres_list)
 	if (nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx))
 		goto nla_put_failure;
 
-	sdp_attr = nla_nest_start(msg, NFC_ATTR_LLC_SDP);
+	sdp_attr = nla_nest_start_noflag(msg, NFC_ATTR_LLC_SDP);
 	if (sdp_attr == NULL) {
 		rc = -ENOMEM;
 		goto nla_put_failure;
@@ -402,7 +402,7 @@ int nfc_genl_llc_send_sdres(struct nfc_dev *dev, struct hlist_head *sdres_list)
 	hlist_for_each_entry_safe(sdres, n, sdres_list, node) {
 		pr_debug("uri: %s, sap: %d\n", sdres->uri, sdres->sap);
 
-		uri_attr = nla_nest_start(msg, i++);
+		uri_attr = nla_nest_start_noflag(msg, i++);
 		if (uri_attr == NULL) {
 			rc = -ENOMEM;
 			goto nla_put_failure;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 626629944450..ff8baf810bb3 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1683,7 +1683,7 @@ static bool ovs_ct_nat_to_attr(const struct ovs_conntrack_info *info,
 {
 	struct nlattr *start;
 
-	start = nla_nest_start(skb, OVS_CT_ATTR_NAT);
+	start = nla_nest_start_noflag(skb, OVS_CT_ATTR_NAT);
 	if (!start)
 		return false;
 
@@ -1750,7 +1750,7 @@ int ovs_ct_action_to_attr(const struct ovs_conntrack_info *ct_info,
 {
 	struct nlattr *start;
 
-	start = nla_nest_start(skb, OVS_ACTION_ATTR_CT);
+	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_CT);
 	if (!start)
 		return -EMSGSIZE;
 
@@ -2160,7 +2160,7 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(reply))
 		return PTR_ERR(reply);
 
-	nla_reply = nla_nest_start(reply, OVS_CT_LIMIT_ATTR_ZONE_LIMIT);
+	nla_reply = nla_nest_start_noflag(reply, OVS_CT_LIMIT_ATTR_ZONE_LIMIT);
 
 	if (a[OVS_CT_LIMIT_ATTR_ZONE_LIMIT]) {
 		err = ovs_ct_limit_get_zone_limit(
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index a64d3eb1f9a9..356677c3a0c2 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -463,7 +463,8 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 			  nla_data(upcall_info->userdata));
 
 	if (upcall_info->egress_tun_info) {
-		nla = nla_nest_start(user_skb, OVS_PACKET_ATTR_EGRESS_TUN_KEY);
+		nla = nla_nest_start_noflag(user_skb,
+					    OVS_PACKET_ATTR_EGRESS_TUN_KEY);
 		if (!nla) {
 			err = -EMSGSIZE;
 			goto out;
@@ -475,7 +476,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	}
 
 	if (upcall_info->actions_len) {
-		nla = nla_nest_start(user_skb, OVS_PACKET_ATTR_ACTIONS);
+		nla = nla_nest_start_noflag(user_skb, OVS_PACKET_ATTR_ACTIONS);
 		if (!nla) {
 			err = -EMSGSIZE;
 			goto out;
@@ -776,7 +777,7 @@ static int ovs_flow_cmd_fill_actions(const struct sw_flow *flow,
 	 * This can only fail for dump operations because the skb is always
 	 * properly sized for single flows.
 	 */
-	start = nla_nest_start(skb, OVS_FLOW_ATTR_ACTIONS);
+	start = nla_nest_start_noflag(skb, OVS_FLOW_ATTR_ACTIONS);
 	if (start) {
 		const struct sw_flow_actions *sf_acts;
 
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 3563acd5f92e..2427b672107a 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -856,7 +856,7 @@ static int vxlan_opt_to_nlattr(struct sk_buff *skb,
 	const struct vxlan_metadata *opts = tun_opts;
 	struct nlattr *nla;
 
-	nla = nla_nest_start(skb, OVS_TUNNEL_KEY_ATTR_VXLAN_OPTS);
+	nla = nla_nest_start_noflag(skb, OVS_TUNNEL_KEY_ATTR_VXLAN_OPTS);
 	if (!nla)
 		return -EMSGSIZE;
 
@@ -948,7 +948,7 @@ static int ip_tun_to_nlattr(struct sk_buff *skb,
 	struct nlattr *nla;
 	int err;
 
-	nla = nla_nest_start(skb, OVS_KEY_ATTR_TUNNEL);
+	nla = nla_nest_start_noflag(skb, OVS_KEY_ATTR_TUNNEL);
 	if (!nla)
 		return -EMSGSIZE;
 
@@ -1957,7 +1957,7 @@ static int nsh_key_to_nlattr(const struct ovs_key_nsh *nsh, bool is_mask,
 {
 	struct nlattr *start;
 
-	start = nla_nest_start(skb, OVS_KEY_ATTR_NSH);
+	start = nla_nest_start_noflag(skb, OVS_KEY_ATTR_NSH);
 	if (!start)
 		return -EMSGSIZE;
 
@@ -2040,14 +2040,15 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		if (swkey->eth.vlan.tci || eth_type_vlan(swkey->eth.type)) {
 			if (ovs_nla_put_vlan(skb, &output->eth.vlan, is_mask))
 				goto nla_put_failure;
-			encap = nla_nest_start(skb, OVS_KEY_ATTR_ENCAP);
+			encap = nla_nest_start_noflag(skb, OVS_KEY_ATTR_ENCAP);
 			if (!swkey->eth.vlan.tci)
 				goto unencap;
 
 			if (swkey->eth.cvlan.tci || eth_type_vlan(swkey->eth.type)) {
 				if (ovs_nla_put_vlan(skb, &output->eth.cvlan, is_mask))
 					goto nla_put_failure;
-				in_encap = nla_nest_start(skb, OVS_KEY_ATTR_ENCAP);
+				in_encap = nla_nest_start_noflag(skb,
+								 OVS_KEY_ATTR_ENCAP);
 				if (!swkey->eth.cvlan.tci)
 					goto unencap;
 			}
@@ -2226,7 +2227,7 @@ int ovs_nla_put_key(const struct sw_flow_key *swkey,
 	int err;
 	struct nlattr *nla;
 
-	nla = nla_nest_start(skb, attr);
+	nla = nla_nest_start_noflag(skb, attr);
 	if (!nla)
 		return -EMSGSIZE;
 	err = __ovs_nla_put_key(swkey, output, is_mask, skb);
@@ -3252,7 +3253,7 @@ static int sample_action_to_attr(const struct nlattr *attr,
 	const struct sample_arg *arg;
 	struct nlattr *actions;
 
-	start = nla_nest_start(skb, OVS_ACTION_ATTR_SAMPLE);
+	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_SAMPLE);
 	if (!start)
 		return -EMSGSIZE;
 
@@ -3265,7 +3266,7 @@ static int sample_action_to_attr(const struct nlattr *attr,
 		goto out;
 	}
 
-	ac_start = nla_nest_start(skb, OVS_SAMPLE_ATTR_ACTIONS);
+	ac_start = nla_nest_start_noflag(skb, OVS_SAMPLE_ATTR_ACTIONS);
 	if (!ac_start) {
 		err = -EMSGSIZE;
 		goto out;
@@ -3291,7 +3292,7 @@ static int clone_action_to_attr(const struct nlattr *attr,
 	struct nlattr *start;
 	int err = 0, rem = nla_len(attr);
 
-	start = nla_nest_start(skb, OVS_ACTION_ATTR_CLONE);
+	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_CLONE);
 	if (!start)
 		return -EMSGSIZE;
 
@@ -3313,7 +3314,7 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
 	const struct nlattr *a, *cpl_arg;
 	int err = 0, rem = nla_len(attr);
 
-	start = nla_nest_start(skb, OVS_ACTION_ATTR_CHECK_PKT_LEN);
+	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_CHECK_PKT_LEN);
 	if (!start)
 		return -EMSGSIZE;
 
@@ -3332,8 +3333,8 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
 	 * 'OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL'.
 	 */
 	a = nla_next(cpl_arg, &rem);
-	ac_start =  nla_nest_start(skb,
-		OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL);
+	ac_start =  nla_nest_start_noflag(skb,
+					  OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL);
 	if (!ac_start) {
 		err = -EMSGSIZE;
 		goto out;
@@ -3351,8 +3352,8 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
 	 * OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_GREATER.
 	 */
 	a = nla_next(a, &rem);
-	ac_start =  nla_nest_start(skb,
-				   OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_GREATER);
+	ac_start =  nla_nest_start_noflag(skb,
+					  OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_GREATER);
 	if (!ac_start) {
 		err = -EMSGSIZE;
 		goto out;
@@ -3386,7 +3387,7 @@ static int set_action_to_attr(const struct nlattr *a, struct sk_buff *skb)
 		struct ovs_tunnel_info *ovs_tun = nla_data(ovs_key);
 		struct ip_tunnel_info *tun_info = &ovs_tun->tun_dst->u.tun_info;
 
-		start = nla_nest_start(skb, OVS_ACTION_ATTR_SET);
+		start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_SET);
 		if (!start)
 			return -EMSGSIZE;
 
@@ -3418,7 +3419,7 @@ static int masked_set_action_to_set_action_attr(const struct nlattr *a,
 	/* Revert the conversion we did from a non-masked set action to
 	 * masked set action.
 	 */
-	nla = nla_nest_start(skb, OVS_ACTION_ATTR_SET);
+	nla = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_SET);
 	if (!nla)
 		return -EMSGSIZE;
 
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 0be3d097ae01..fdc8be7fd8f3 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -127,7 +127,7 @@ static int ovs_meter_cmd_reply_stats(struct sk_buff *reply, u32 meter_id,
 			      OVS_METER_ATTR_PAD))
 		goto error;
 
-	nla = nla_nest_start(reply, OVS_METER_ATTR_BANDS);
+	nla = nla_nest_start_noflag(reply, OVS_METER_ATTR_BANDS);
 	if (!nla)
 		goto error;
 
@@ -136,7 +136,7 @@ static int ovs_meter_cmd_reply_stats(struct sk_buff *reply, u32 meter_id,
 	for (i = 0; i < meter->n_bands; ++i, ++band) {
 		struct nlattr *band_nla;
 
-		band_nla = nla_nest_start(reply, OVS_BAND_ATTR_UNSPEC);
+		band_nla = nla_nest_start_noflag(reply, OVS_BAND_ATTR_UNSPEC);
 		if (!band_nla || nla_put(reply, OVS_BAND_ATTR_STATS,
 					 sizeof(struct ovs_flow_stats),
 					 &band->stats))
@@ -166,11 +166,11 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
 	    nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
 		goto nla_put_failure;
 
-	nla = nla_nest_start(reply, OVS_METER_ATTR_BANDS);
+	nla = nla_nest_start_noflag(reply, OVS_METER_ATTR_BANDS);
 	if (!nla)
 		goto nla_put_failure;
 
-	band_nla = nla_nest_start(reply, OVS_BAND_ATTR_UNSPEC);
+	band_nla = nla_nest_start_noflag(reply, OVS_BAND_ATTR_UNSPEC);
 	if (!band_nla)
 		goto nla_put_failure;
 	/* Currently only DROP band type is supported. */
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 8f16f11f7ad3..54965ff8cc66 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -43,7 +43,7 @@ static int vxlan_get_options(const struct vport *vport, struct sk_buff *skb)
 	if (vxlan->cfg.flags & VXLAN_F_GBP) {
 		struct nlattr *exts;
 
-		exts = nla_nest_start(skb, OVS_TUNNEL_ATTR_EXTENSION);
+		exts = nla_nest_start_noflag(skb, OVS_TUNNEL_ATTR_EXTENSION);
 		if (!exts)
 			return -EMSGSIZE;
 
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 19f6765566e7..258ce3b7b452 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -319,7 +319,7 @@ int ovs_vport_get_options(const struct vport *vport, struct sk_buff *skb)
 	if (!vport->ops->get_options)
 		return 0;
 
-	nla = nla_nest_start(skb, OVS_VPORT_ATTR_OPTIONS);
+	nla = nla_nest_start_noflag(skb, OVS_VPORT_ATTR_OPTIONS);
 	if (!nla)
 		return -EMSGSIZE;
 
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 7ef1c881ae74..98abfd8644a4 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -39,7 +39,7 @@ static int pdiag_put_mclist(const struct packet_sock *po, struct sk_buff *nlskb)
 	struct nlattr *mca;
 	struct packet_mclist *ml;
 
-	mca = nla_nest_start(nlskb, PACKET_DIAG_MCLIST);
+	mca = nla_nest_start_noflag(nlskb, PACKET_DIAG_MCLIST);
 	if (!mca)
 		return -EMSGSIZE;
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5a87e271d35a..641ad7575f24 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -242,7 +242,7 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			       (unsigned long)p->tcfa_tm.lastuse))
 			continue;
 
-		nest = nla_nest_start(skb, n_i);
+		nest = nla_nest_start_noflag(skb, n_i);
 		if (!nest) {
 			index--;
 			goto nla_put_failure;
@@ -299,7 +299,7 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	struct tc_action *p;
 	unsigned long id = 1;
 
-	nest = nla_nest_start(skb, 0);
+	nest = nla_nest_start_noflag(skb, 0);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (nla_put_string(skb, TCA_KIND, ops->kind))
@@ -776,7 +776,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	err = tcf_action_dump_old(skb, a, bind, ref);
@@ -800,7 +800,7 @@ int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
 
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
-		nest = nla_nest_start(skb, a->order);
+		nest = nla_nest_start_noflag(skb, a->order);
 		if (nest == NULL)
 			goto nla_put_failure;
 		err = tcf_action_dump_1(skb, a, bind, ref);
@@ -1052,7 +1052,7 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	t->tca__pad1 = 0;
 	t->tca__pad2 = 0;
 
-	nest = nla_nest_start(skb, TCA_ACT_TAB);
+	nest = nla_nest_start_noflag(skb, TCA_ACT_TAB);
 	if (!nest)
 		goto out_nlmsg_trim;
 
@@ -1176,7 +1176,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 	t->tca__pad1 = 0;
 	t->tca__pad2 = 0;
 
-	nest = nla_nest_start(skb, TCA_ACT_TAB);
+	nest = nla_nest_start_noflag(skb, TCA_ACT_TAB);
 	if (!nest) {
 		NL_SET_ERR_MSG(extack, "Failed to add new netlink message");
 		goto out_module_put;
@@ -1508,7 +1508,7 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!count_attr)
 		goto out_module_put;
 
-	nest = nla_nest_start(skb, TCA_ACT_TAB);
+	nest = nla_nest_start_noflag(skb, TCA_ACT_TAB);
 	if (nest == NULL)
 		goto out_module_put;
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 31c6ffb6abe7..7a87ce2e5a76 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -387,7 +387,7 @@ static int dump_metalist(struct sk_buff *skb, struct tcf_ife_info *ife)
 	if (list_empty(&ife->metalist))
 		return 0;
 
-	nest = nla_nest_start(skb, TCA_IFE_METALST);
+	nest = nla_nest_start_noflag(skb, TCA_IFE_METALST);
 	if (!nest)
 		goto out_nlmsg_trim;
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 287793abfaf9..ce4b54fa7834 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -108,14 +108,15 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
 				 struct tcf_pedit_key_ex *keys_ex, int n)
 {
-	struct nlattr *keys_start = nla_nest_start(skb, TCA_PEDIT_KEYS_EX);
+	struct nlattr *keys_start = nla_nest_start_noflag(skb,
+							  TCA_PEDIT_KEYS_EX);
 
 	if (!keys_start)
 		goto nla_failure;
 	for (; n > 0; n--) {
 		struct nlattr *key_start;
 
-		key_start = nla_nest_start(skb, TCA_PEDIT_KEY_EX);
+		key_start = nla_nest_start_noflag(skb, TCA_PEDIT_KEY_EX);
 		if (!key_start)
 			goto nla_failure;
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index d5aaf90a3971..45c0c253c7e8 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -426,7 +426,7 @@ static int tunnel_key_geneve_opts_dump(struct sk_buff *skb,
 	u8 *src = (u8 *)(info + 1);
 	struct nlattr *start;
 
-	start = nla_nest_start(skb, TCA_TUNNEL_KEY_ENC_OPTS_GENEVE);
+	start = nla_nest_start_noflag(skb, TCA_TUNNEL_KEY_ENC_OPTS_GENEVE);
 	if (!start)
 		return -EMSGSIZE;
 
@@ -460,7 +460,7 @@ static int tunnel_key_opts_dump(struct sk_buff *skb,
 	if (!info->options_len)
 		return 0;
 
-	start = nla_nest_start(skb, TCA_TUNNEL_KEY_ENC_OPTS);
+	start = nla_nest_start_noflag(skb, TCA_TUNNEL_KEY_ENC_OPTS);
 	if (!start)
 		return -EMSGSIZE;
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9115f053883f..78de717afddf 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3111,7 +3111,7 @@ int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts)
 		 * tc data even if iproute2  was newer - jhs
 		 */
 		if (exts->type != TCA_OLD_COMPAT) {
-			nest = nla_nest_start(skb, exts->action);
+			nest = nla_nest_start_noflag(skb, exts->action);
 			if (nest == NULL)
 				goto nla_put_failure;
 
@@ -3120,7 +3120,7 @@ int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts)
 			nla_nest_end(skb, nest);
 		} else if (exts->police) {
 			struct tc_action *act = tcf_exts_first_act(exts);
-			nest = nla_nest_start(skb, exts->police);
+			nest = nla_nest_start_noflag(skb, exts->police);
 			if (nest == NULL || !act)
 				goto nla_put_failure;
 			if (tcf_action_dump_old(skb, act, 0, 0) < 0)
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 687b0af67878..dd5fdb62c6df 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -288,7 +288,7 @@ static int basic_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = f->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index b4ac58039cb1..6fd569c5a036 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -591,7 +591,7 @@ static int cls_bpf_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	cls_bpf_offload_update_stats(tp, prog);
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 4c1567854f95..b680dd684282 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -176,7 +176,7 @@ static int cls_cgroup_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = head->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index eece1ee26930..cb29fe7d5ed3 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -629,7 +629,7 @@ static int flow_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = f->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0d8968803e98..8d4f7a672f14 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2051,7 +2051,7 @@ static int fl_dump_key_geneve_opt(struct sk_buff *skb,
 	struct nlattr *nest;
 	int opt_off = 0;
 
-	nest = nla_nest_start(skb, TCA_FLOWER_KEY_ENC_OPTS_GENEVE);
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_GENEVE);
 	if (!nest)
 		goto nla_put_failure;
 
@@ -2087,7 +2087,7 @@ static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 	if (!enc_opts->len)
 		return 0;
 
-	nest = nla_nest_start(skb, enc_opt_type);
+	nest = nla_nest_start_noflag(skb, enc_opt_type);
 	if (!nest)
 		goto nla_put_failure;
 
@@ -2333,7 +2333,7 @@ static int fl_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = f->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
 		goto nla_put_failure;
 
@@ -2384,7 +2384,7 @@ static int fl_tmplt_dump(struct sk_buff *skb, struct net *net, void *tmplt_priv)
 	struct fl_flow_key *key, *mask;
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index ad036b00427d..3fcc1d51b9d7 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -402,7 +402,7 @@ static int fw_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	if (!f->res.classid && !tcf_exts_has_actions(&f->exts))
 		return skb->len;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index a13bc351a414..d54fa8e11b9e 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -303,7 +303,7 @@ static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = head->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index f006af23b64a..b3b9b151a61d 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -607,7 +607,7 @@ static int route4_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = f->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 0719a21d9c41..fa059cf934a6 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -706,7 +706,7 @@ static int rsvp_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = f->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 24e0a62a65cc..1a2e7d5a8776 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -601,7 +601,7 @@ static int tcindex_dump(struct net *net, struct tcf_proto *tp, void *fh,
 		 tp, fh, skb, t, p, r);
 	pr_debug("p->perfect %p p->h %p\n", p->perfect, p->h);
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 48e76a3acf8a..499477058b2d 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1294,7 +1294,7 @@ static int u32_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	t->tcm_handle = n->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index 1331a4c2d8ff..6f2d6a761dbe 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -440,14 +440,14 @@ int tcf_em_tree_dump(struct sk_buff *skb, struct tcf_ematch_tree *tree, int tlv)
 	struct nlattr *top_start;
 	struct nlattr *list_start;
 
-	top_start = nla_nest_start(skb, tlv);
+	top_start = nla_nest_start_noflag(skb, tlv);
 	if (top_start == NULL)
 		goto nla_put_failure;
 
 	if (nla_put(skb, TCA_EMATCH_TREE_HDR, sizeof(tree->hdr), &tree->hdr))
 		goto nla_put_failure;
 
-	list_start = nla_nest_start(skb, TCA_EMATCH_TREE_LIST);
+	list_start = nla_nest_start_noflag(skb, TCA_EMATCH_TREE_LIST);
 	if (list_start == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index c126b9f78d6e..6c81b22d214f 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -542,7 +542,7 @@ static int qdisc_dump_stab(struct sk_buff *skb, struct qdisc_size_table *stab)
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_STAB);
+	nest = nla_nest_start_noflag(skb, TCA_STAB);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_STAB_BASE, sizeof(stab->szopts), &stab->szopts))
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index d714d3747bcb..c36aa57eb4af 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -609,7 +609,7 @@ static int atm_tc_dump_class(struct Qdisc *sch, unsigned long cl,
 	tcm->tcm_handle = flow->common.classid;
 	tcm->tcm_info = flow->q->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 259d97bc2abd..50db72fe44de 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2735,7 +2735,7 @@ static int cake_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct cake_sched_data *q = qdisc_priv(sch);
 	struct nlattr *opts;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!opts)
 		goto nla_put_failure;
 
@@ -2806,7 +2806,7 @@ static int cake_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
-	struct nlattr *stats = nla_nest_start(d->skb, TCA_STATS_APP);
+	struct nlattr *stats = nla_nest_start_noflag(d->skb, TCA_STATS_APP);
 	struct cake_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tstats, *ts;
 	int i;
@@ -2836,7 +2836,7 @@ static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 #undef PUT_STAT_U32
 #undef PUT_STAT_U64
 
-	tstats = nla_nest_start(d->skb, TCA_CAKE_STATS_TIN_STATS);
+	tstats = nla_nest_start_noflag(d->skb, TCA_CAKE_STATS_TIN_STATS);
 	if (!tstats)
 		goto nla_put_failure;
 
@@ -2853,7 +2853,7 @@ static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	for (i = 0; i < q->tin_cnt; i++) {
 		struct cake_tin_data *b = &q->tins[q->tin_order[i]];
 
-		ts = nla_nest_start(d->skb, i + 1);
+		ts = nla_nest_start_noflag(d->skb, i + 1);
 		if (!ts)
 			goto nla_put_failure;
 
@@ -2973,7 +2973,7 @@ static int cake_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 	if (flow) {
 		ktime_t now = ktime_get();
 
-		stats = nla_nest_start(d->skb, TCA_STATS_APP);
+		stats = nla_nest_start_noflag(d->skb, TCA_STATS_APP);
 		if (!stats)
 			return -1;
 
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 114b9048ea7e..243bce4b888b 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1305,7 +1305,7 @@ static int cbq_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct cbq_sched_data *q = qdisc_priv(sch);
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (cbq_dump_attr(skb, &q->link) < 0)
@@ -1340,7 +1340,7 @@ cbq_dump_class(struct Qdisc *sch, unsigned long arg,
 	tcm->tcm_handle = cl->common.classid;
 	tcm->tcm_info = cl->q->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (cbq_dump_attr(skb, cl) < 0)
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index f68fd7a0e038..adffc6d68c06 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -449,7 +449,7 @@ static int cbs_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_cbs_qopt opt = { };
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index eafc0d17d174..eda21dc94bde 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -452,7 +452,7 @@ static int choke_dump(struct Qdisc *sch, struct sk_buff *skb)
 		.Scell_log	= q->parms.Scell_log,
 	};
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 17cd81f84b5d..60ac4e61ce3a 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -217,7 +217,7 @@ static int codel_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct codel_sched_data *q = qdisc_priv(sch);
 	struct nlattr *opts;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 430df9a55ec4..022db73fd5a9 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -244,7 +244,7 @@ static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
 	tcm->tcm_handle	= cl->common.classid;
 	tcm->tcm_info	= cl->qdisc->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (nla_put_u32(skb, TCA_DRR_QUANTUM, cl->quantum))
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 42471464ded3..cdf744e710f1 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -432,7 +432,7 @@ static int dsmark_dump_class(struct Qdisc *sch, unsigned long cl,
 	tcm->tcm_handle = TC_H_MAKE(TC_H_MAJ(sch->handle), cl - 1);
 	tcm->tcm_info = p->q->handle;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 	if (nla_put_u8(skb, TCA_DSMARK_MASK, p->mv[cl - 1].mask) ||
@@ -451,7 +451,7 @@ static int dsmark_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct dsmark_qdisc_data *p = qdisc_priv(sch);
 	struct nlattr *opts = NULL;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 	if (nla_put_u16(skb, TCA_DSMARK_INDICES, p->indices))
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index 1150f22983df..67107caa287c 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -460,7 +460,7 @@ static int etf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_etf_qopt opt = { };
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 1a662f2bb7bb..5ca370e78d3a 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -823,7 +823,7 @@ static int fq_dump(struct Qdisc *sch, struct sk_buff *skb)
 	u64 ce_threshold = q->ce_threshold;
 	struct nlattr *opts;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index cd04d40c30b6..825a933b019a 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -527,7 +527,7 @@ static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct nlattr *opts;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 234afbf9115b..9bfa15e12d23 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -772,7 +772,7 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (gred_offload_dump_stats(sch))
 		goto nla_put_failure;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_GRED_DPS, sizeof(sopt), &sopt))
@@ -790,7 +790,7 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 		goto nla_put_failure;
 
 	/* Old style all-in-one dump of VQs */
-	parms = nla_nest_start(skb, TCA_GRED_PARMS);
+	parms = nla_nest_start_noflag(skb, TCA_GRED_PARMS);
 	if (parms == NULL)
 		goto nla_put_failure;
 
@@ -841,7 +841,7 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_end(skb, parms);
 
 	/* Dump the VQs again, in more structured way */
-	vqs = nla_nest_start(skb, TCA_GRED_VQ_LIST);
+	vqs = nla_nest_start_noflag(skb, TCA_GRED_VQ_LIST);
 	if (!vqs)
 		goto nla_put_failure;
 
@@ -852,7 +852,7 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 		if (!q)
 			continue;
 
-		vq = nla_nest_start(skb, TCA_GRED_VQ_ENTRY);
+		vq = nla_nest_start_noflag(skb, TCA_GRED_VQ_ENTRY);
 		if (!vq)
 			goto nla_put_failure;
 
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index d2ab463f22ae..97d2fb91c39f 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1300,7 +1300,7 @@ hfsc_dump_class(struct Qdisc *sch, unsigned long arg, struct sk_buff *skb,
 	if (cl->level == 0)
 		tcm->tcm_info = cl->qdisc->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (hfsc_dump_curves(skb, cl) < 0)
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index 9d6a47697406..43bc159c4f7c 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -654,7 +654,7 @@ static int hhf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct hhf_sched_data *q = qdisc_priv(sch);
 	struct nlattr *opts;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2f9883b196e8..64010aec5437 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1057,7 +1057,7 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	gopt.defcls = q->defcls;
 	gopt.debug = 0;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_HTB_INIT, sizeof(gopt), &gopt) ||
@@ -1086,7 +1086,7 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	if (!cl->level && cl->leaf.q)
 		tcm->tcm_info = cl->leaf.q->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index ce3f55259d0d..0bac926b46c7 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -106,7 +106,7 @@ static int ingress_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index ea0dc112b38d..7afefed72d35 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -349,7 +349,7 @@ static int dump_rates(struct mqprio_sched *priv,
 	int i;
 
 	if (priv->flags & TC_MQPRIO_F_MIN_RATE) {
-		nest = nla_nest_start(skb, TCA_MQPRIO_MIN_RATE64);
+		nest = nla_nest_start_noflag(skb, TCA_MQPRIO_MIN_RATE64);
 		if (!nest)
 			goto nla_put_failure;
 
@@ -363,7 +363,7 @@ static int dump_rates(struct mqprio_sched *priv,
 	}
 
 	if (priv->flags & TC_MQPRIO_F_MAX_RATE) {
-		nest = nla_nest_start(skb, TCA_MQPRIO_MAX_RATE64);
+		nest = nla_nest_start_noflag(skb, TCA_MQPRIO_MAX_RATE64);
 		if (!nest)
 			goto nla_put_failure;
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index cc9d8133afcd..0242c0d4a2d0 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1079,7 +1079,7 @@ static int dump_loss_model(const struct netem_sched_data *q,
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, TCA_NETEM_LOSS);
+	nest = nla_nest_start_noflag(skb, TCA_NETEM_LOSS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 1cc0c7b74aa3..9bf41f4a2312 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -491,7 +491,7 @@ static int pie_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct pie_sched_data *q = qdisc_priv(sch);
 	struct nlattr *opts;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!opts)
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 1589364b54da..bab2d4026e8b 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -619,7 +619,7 @@ static int qfq_dump_class(struct Qdisc *sch, unsigned long arg,
 	tcm->tcm_handle	= cl->common.classid;
 	tcm->tcm_info	= cl->qdisc->handle;
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	if (nla_put_u32(skb, TCA_QFQ_WEIGHT, cl->agg->class_weight) ||
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 4e8c0abf6194..b9f34e057e87 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -318,7 +318,7 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (err)
 		goto nla_put_failure;
 
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 2419fdb75966..f54b00a431a3 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -580,7 +580,7 @@ static int sfb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	};
 
 	sch->qstats.backlog = q->qdisc->qstats.backlog;
-	opts = nla_nest_start(skb, TCA_OPTIONS);
+	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (opts == NULL)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_SFB_PARMS, sizeof(opt), &opt))
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index df848a36b222..e016ee07dd1f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -841,7 +841,7 @@ static int dump_entry(struct sk_buff *msg,
 {
 	struct nlattr *item;
 
-	item = nla_nest_start(msg, TCA_TAPRIO_SCHED_ENTRY);
+	item = nla_nest_start_noflag(msg, TCA_TAPRIO_SCHED_ENTRY);
 	if (!item)
 		return -ENOSPC;
 
@@ -883,7 +883,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 		opt.offset[i] = dev->tc_to_txq[i].offset;
 	}
 
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
 		return -ENOSPC;
 
@@ -897,7 +897,8 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
 		goto options_error;
 
-	entry_list = nla_nest_start(skb, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST);
+	entry_list = nla_nest_start_noflag(skb,
+					   TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST);
 	if (!entry_list)
 		goto options_error;
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index f71578dbb9e3..3ae5a29eeab3 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -448,7 +448,7 @@ static int tbf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_tbf_qopt opt;
 
 	sch->qstats.backlog = q->qdisc->qstats.backlog;
-	nest = nla_nest_start(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index d27f30a9a01d..fd8e4e83f5e0 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -687,14 +687,14 @@ static int __tipc_nl_add_bearer(struct tipc_nl_msg *msg,
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_BEARER);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_BEARER);
 	if (!attrs)
 		goto msg_full;
 
 	if (nla_put_string(msg->skb, TIPC_NLA_BEARER_NAME, bearer->name))
 		goto attr_msg_full;
 
-	prop = nla_nest_start(msg->skb, TIPC_NLA_BEARER_PROP);
+	prop = nla_nest_start_noflag(msg->skb, TIPC_NLA_BEARER_PROP);
 	if (!prop)
 		goto prop_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_PRIO, bearer->priority))
@@ -1033,14 +1033,14 @@ static int __tipc_nl_add_media(struct tipc_nl_msg *msg,
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_MEDIA);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_MEDIA);
 	if (!attrs)
 		goto msg_full;
 
 	if (nla_put_string(msg->skb, TIPC_NLA_MEDIA_NAME, media->name))
 		goto attr_msg_full;
 
-	prop = nla_nest_start(msg->skb, TIPC_NLA_MEDIA_PROP);
+	prop = nla_nest_start_noflag(msg->skb, TIPC_NLA_MEDIA_PROP);
 	if (!prop)
 		goto prop_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_PRIO, media->priority))
diff --git a/net/tipc/group.c b/net/tipc/group.c
index 63f39201e41e..992be6113676 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -917,7 +917,7 @@ void tipc_group_member_evt(struct tipc_group *grp,
 
 int tipc_group_fill_sock_diag(struct tipc_group *grp, struct sk_buff *skb)
 {
-	struct nlattr *group = nla_nest_start(skb, TIPC_NLA_SOCK_GROUP);
+	struct nlattr *group = nla_nest_start_noflag(skb, TIPC_NLA_SOCK_GROUP);
 
 	if (!group)
 		return -EMSGSIZE;
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 6053489c8063..0327c8ff8d48 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2228,7 +2228,7 @@ static int __tipc_nl_add_stats(struct sk_buff *skb, struct tipc_stats *s)
 			(s->accu_queue_sz / s->queue_sz_counts) : 0}
 	};
 
-	stats = nla_nest_start(skb, TIPC_NLA_LINK_STATS);
+	stats = nla_nest_start_noflag(skb, TIPC_NLA_LINK_STATS);
 	if (!stats)
 		return -EMSGSIZE;
 
@@ -2260,7 +2260,7 @@ int __tipc_nl_add_link(struct net *net, struct tipc_nl_msg *msg,
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_LINK);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_LINK);
 	if (!attrs)
 		goto msg_full;
 
@@ -2282,7 +2282,7 @@ int __tipc_nl_add_link(struct net *net, struct tipc_nl_msg *msg,
 		if (nla_put_flag(msg->skb, TIPC_NLA_LINK_ACTIVE))
 			goto attr_msg_full;
 
-	prop = nla_nest_start(msg->skb, TIPC_NLA_LINK_PROP);
+	prop = nla_nest_start_noflag(msg->skb, TIPC_NLA_LINK_PROP);
 	if (!prop)
 		goto attr_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_PRIO, link->priority))
@@ -2349,7 +2349,7 @@ static int __tipc_nl_add_bc_link_stat(struct sk_buff *skb,
 			(stats->accu_queue_sz / stats->queue_sz_counts) : 0}
 	};
 
-	nest = nla_nest_start(skb, TIPC_NLA_LINK_STATS);
+	nest = nla_nest_start_noflag(skb, TIPC_NLA_LINK_STATS);
 	if (!nest)
 		return -EMSGSIZE;
 
@@ -2389,7 +2389,7 @@ int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg)
 		return -EMSGSIZE;
 	}
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_LINK);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_LINK);
 	if (!attrs)
 		goto msg_full;
 
@@ -2406,7 +2406,7 @@ int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg)
 	if (nla_put_u32(msg->skb, TIPC_NLA_LINK_TX, 0))
 		goto attr_msg_full;
 
-	prop = nla_nest_start(msg->skb, TIPC_NLA_LINK_PROP);
+	prop = nla_nest_start_noflag(msg->skb, TIPC_NLA_LINK_PROP);
 	if (!prop)
 		goto attr_msg_full;
 	if (nla_put_u32(msg->skb, TIPC_NLA_PROP_WIN, bcl->window))
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 67f69389ec17..6a6eae88442f 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -696,7 +696,7 @@ static int __tipc_nl_add_monitor_peer(struct tipc_peer *peer,
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_MON_PEER);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_MON_PEER);
 	if (!attrs)
 		goto msg_full;
 
@@ -785,7 +785,7 @@ int __tipc_nl_add_monitor(struct net *net, struct tipc_nl_msg *msg,
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_MON);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_MON);
 	if (!attrs)
 		goto msg_full;
 
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 89993afe0fbd..66a65c2cdb23 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -829,11 +829,11 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
 		if (!hdr)
 			return -EMSGSIZE;
 
-		attrs = nla_nest_start(msg->skb, TIPC_NLA_NAME_TABLE);
+		attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_NAME_TABLE);
 		if (!attrs)
 			goto msg_full;
 
-		b = nla_nest_start(msg->skb, TIPC_NLA_NAME_TABLE_PUBL);
+		b = nla_nest_start_noflag(msg->skb, TIPC_NLA_NAME_TABLE_PUBL);
 		if (!b)
 			goto attr_msg_full;
 
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 7ce1e86b024f..0bba4e6b005c 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -187,7 +187,7 @@ static int __tipc_nl_add_net(struct net *net, struct tipc_nl_msg *msg)
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_NET);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_NET);
 	if (!attrs)
 		goto msg_full;
 
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 340a6e7c43a7..36fe2dbb6d87 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -399,7 +399,7 @@ static int tipc_nl_compat_bearer_enable(struct tipc_nl_compat_cmd_doit *cmd,
 
 	b = (struct tipc_bearer_config *)TLV_DATA(msg->req);
 
-	bearer = nla_nest_start(skb, TIPC_NLA_BEARER);
+	bearer = nla_nest_start_noflag(skb, TIPC_NLA_BEARER);
 	if (!bearer)
 		return -EMSGSIZE;
 
@@ -419,7 +419,7 @@ static int tipc_nl_compat_bearer_enable(struct tipc_nl_compat_cmd_doit *cmd,
 		return -EMSGSIZE;
 
 	if (ntohl(b->priority) <= TIPC_MAX_LINK_PRI) {
-		prop = nla_nest_start(skb, TIPC_NLA_BEARER_PROP);
+		prop = nla_nest_start_noflag(skb, TIPC_NLA_BEARER_PROP);
 		if (!prop)
 			return -EMSGSIZE;
 		if (nla_put_u32(skb, TIPC_NLA_PROP_PRIO, ntohl(b->priority)))
@@ -441,7 +441,7 @@ static int tipc_nl_compat_bearer_disable(struct tipc_nl_compat_cmd_doit *cmd,
 
 	name = (char *)TLV_DATA(msg->req);
 
-	bearer = nla_nest_start(skb, TIPC_NLA_BEARER);
+	bearer = nla_nest_start_noflag(skb, TIPC_NLA_BEARER);
 	if (!bearer)
 		return -EMSGSIZE;
 
@@ -685,7 +685,7 @@ static int tipc_nl_compat_media_set(struct sk_buff *skb,
 
 	lc = (struct tipc_link_config *)TLV_DATA(msg->req);
 
-	media = nla_nest_start(skb, TIPC_NLA_MEDIA);
+	media = nla_nest_start_noflag(skb, TIPC_NLA_MEDIA);
 	if (!media)
 		return -EMSGSIZE;
 
@@ -696,7 +696,7 @@ static int tipc_nl_compat_media_set(struct sk_buff *skb,
 	if (nla_put_string(skb, TIPC_NLA_MEDIA_NAME, lc->name))
 		return -EMSGSIZE;
 
-	prop = nla_nest_start(skb, TIPC_NLA_MEDIA_PROP);
+	prop = nla_nest_start_noflag(skb, TIPC_NLA_MEDIA_PROP);
 	if (!prop)
 		return -EMSGSIZE;
 
@@ -717,7 +717,7 @@ static int tipc_nl_compat_bearer_set(struct sk_buff *skb,
 
 	lc = (struct tipc_link_config *)TLV_DATA(msg->req);
 
-	bearer = nla_nest_start(skb, TIPC_NLA_BEARER);
+	bearer = nla_nest_start_noflag(skb, TIPC_NLA_BEARER);
 	if (!bearer)
 		return -EMSGSIZE;
 
@@ -728,7 +728,7 @@ static int tipc_nl_compat_bearer_set(struct sk_buff *skb,
 	if (nla_put_string(skb, TIPC_NLA_BEARER_NAME, lc->name))
 		return -EMSGSIZE;
 
-	prop = nla_nest_start(skb, TIPC_NLA_BEARER_PROP);
+	prop = nla_nest_start_noflag(skb, TIPC_NLA_BEARER_PROP);
 	if (!prop)
 		return -EMSGSIZE;
 
@@ -748,14 +748,14 @@ static int __tipc_nl_compat_link_set(struct sk_buff *skb,
 
 	lc = (struct tipc_link_config *)TLV_DATA(msg->req);
 
-	link = nla_nest_start(skb, TIPC_NLA_LINK);
+	link = nla_nest_start_noflag(skb, TIPC_NLA_LINK);
 	if (!link)
 		return -EMSGSIZE;
 
 	if (nla_put_string(skb, TIPC_NLA_LINK_NAME, lc->name))
 		return -EMSGSIZE;
 
-	prop = nla_nest_start(skb, TIPC_NLA_LINK_PROP);
+	prop = nla_nest_start_noflag(skb, TIPC_NLA_LINK_PROP);
 	if (!prop)
 		return -EMSGSIZE;
 
@@ -811,7 +811,7 @@ static int tipc_nl_compat_link_reset_stats(struct tipc_nl_compat_cmd_doit *cmd,
 
 	name = (char *)TLV_DATA(msg->req);
 
-	link = nla_nest_start(skb, TIPC_NLA_LINK);
+	link = nla_nest_start_noflag(skb, TIPC_NLA_LINK);
 	if (!link)
 		return -EMSGSIZE;
 
@@ -973,7 +973,7 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 		return -EMSGSIZE;
 	}
 
-	nest = nla_nest_start(args, TIPC_NLA_SOCK);
+	nest = nla_nest_start_noflag(args, TIPC_NLA_SOCK);
 	if (!nest) {
 		kfree_skb(args);
 		return -EMSGSIZE;
@@ -1100,7 +1100,7 @@ static int tipc_nl_compat_net_set(struct tipc_nl_compat_cmd_doit *cmd,
 
 	val = ntohl(*(__be32 *)TLV_DATA(msg->req));
 
-	net = nla_nest_start(skb, TIPC_NLA_NET);
+	net = nla_nest_start_noflag(skb, TIPC_NLA_NET);
 	if (!net)
 		return -EMSGSIZE;
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 7478e2d4ec02..3777254a508f 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1359,7 +1359,7 @@ static int __tipc_nl_add_node(struct tipc_nl_msg *msg, struct tipc_node *node)
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_NODE);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_NODE);
 	if (!attrs)
 		goto msg_full;
 
@@ -2353,7 +2353,7 @@ static int __tipc_nl_add_monitor_prop(struct net *net, struct tipc_nl_msg *msg)
 	if (!hdr)
 		return -EMSGSIZE;
 
-	attrs = nla_nest_start(msg->skb, TIPC_NLA_MON);
+	attrs = nla_nest_start_noflag(msg->skb, TIPC_NLA_MON);
 	if (!attrs)
 		goto msg_full;
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 1385207a301f..7918f4763fdc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3273,7 +3273,7 @@ static int __tipc_nl_add_sk_con(struct sk_buff *skb, struct tipc_sock *tsk)
 	peer_node = tsk_peer_node(tsk);
 	peer_port = tsk_peer_port(tsk);
 
-	nest = nla_nest_start(skb, TIPC_NLA_SOCK_CON);
+	nest = nla_nest_start_noflag(skb, TIPC_NLA_SOCK_CON);
 	if (!nest)
 		return -EMSGSIZE;
 
@@ -3332,7 +3332,7 @@ static int __tipc_nl_add_sk(struct sk_buff *skb, struct netlink_callback *cb,
 	if (!hdr)
 		goto msg_cancel;
 
-	attrs = nla_nest_start(skb, TIPC_NLA_SOCK);
+	attrs = nla_nest_start_noflag(skb, TIPC_NLA_SOCK);
 	if (!attrs)
 		goto genlmsg_cancel;
 
@@ -3437,7 +3437,7 @@ int tipc_sk_fill_sock_diag(struct sk_buff *skb, struct netlink_callback *cb,
 	if (!(sk_filter_state & (1 << sk->sk_state)))
 		return 0;
 
-	attrs = nla_nest_start(skb, TIPC_NLA_SOCK);
+	attrs = nla_nest_start_noflag(skb, TIPC_NLA_SOCK);
 	if (!attrs)
 		goto msg_cancel;
 
@@ -3455,7 +3455,7 @@ int tipc_sk_fill_sock_diag(struct sk_buff *skb, struct netlink_callback *cb,
 			      TIPC_NLA_SOCK_PAD))
 		goto attr_msg_cancel;
 
-	stat = nla_nest_start(skb, TIPC_NLA_SOCK_STAT);
+	stat = nla_nest_start_noflag(skb, TIPC_NLA_SOCK_STAT);
 	if (!stat)
 		goto attr_msg_cancel;
 
@@ -3512,7 +3512,7 @@ static int __tipc_nl_add_sk_publ(struct sk_buff *skb,
 	if (!hdr)
 		goto msg_cancel;
 
-	attrs = nla_nest_start(skb, TIPC_NLA_PUBL);
+	attrs = nla_nest_start_noflag(skb, TIPC_NLA_PUBL);
 	if (!attrs)
 		goto genlmsg_cancel;
 
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 7413cbc9b638..08d63566a7aa 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -524,7 +524,7 @@ int tipc_udp_nl_add_bearer_data(struct tipc_nl_msg *msg, struct tipc_bearer *b)
 	if (!ub)
 		return -ENODEV;
 
-	nest = nla_nest_start(msg->skb, TIPC_NLA_BEARER_UDP_OPTS);
+	nest = nla_nest_start_noflag(msg->skb, TIPC_NLA_BEARER_UDP_OPTS);
 	if (!nest)
 		goto msg_full;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e7ee18ab6cb7..3a0494434d19 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -740,13 +740,13 @@ static int nl80211_msg_put_wmm_rules(struct sk_buff *msg,
 {
 	int j;
 	struct nlattr *nl_wmm_rules =
-		nla_nest_start(msg, NL80211_FREQUENCY_ATTR_WMM);
+		nla_nest_start_noflag(msg, NL80211_FREQUENCY_ATTR_WMM);
 
 	if (!nl_wmm_rules)
 		goto nla_put_failure;
 
 	for (j = 0; j < IEEE80211_NUM_ACS; j++) {
-		struct nlattr *nl_wmm_rule = nla_nest_start(msg, j);
+		struct nlattr *nl_wmm_rule = nla_nest_start_noflag(msg, j);
 
 		if (!nl_wmm_rule)
 			goto nla_put_failure;
@@ -875,7 +875,7 @@ static bool nl80211_put_txq_stats(struct sk_buff *msg,
 		return false;						  \
 	} while (0)
 
-	txqattr = nla_nest_start(msg, attrtype);
+	txqattr = nla_nest_start_noflag(msg, attrtype);
 	if (!txqattr)
 		return false;
 
@@ -1187,7 +1187,7 @@ static struct ieee80211_channel *nl80211_get_valid_chan(struct wiphy *wiphy,
 
 static int nl80211_put_iftypes(struct sk_buff *msg, u32 attr, u16 ifmodes)
 {
-	struct nlattr *nl_modes = nla_nest_start(msg, attr);
+	struct nlattr *nl_modes = nla_nest_start_noflag(msg, attr);
 	int i;
 
 	if (!nl_modes)
@@ -1215,8 +1215,8 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 	struct nlattr *nl_combis;
 	int i, j;
 
-	nl_combis = nla_nest_start(msg,
-				NL80211_ATTR_INTERFACE_COMBINATIONS);
+	nl_combis = nla_nest_start_noflag(msg,
+					  NL80211_ATTR_INTERFACE_COMBINATIONS);
 	if (!nl_combis)
 		goto nla_put_failure;
 
@@ -1226,18 +1226,19 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 
 		c = &wiphy->iface_combinations[i];
 
-		nl_combi = nla_nest_start(msg, i + 1);
+		nl_combi = nla_nest_start_noflag(msg, i + 1);
 		if (!nl_combi)
 			goto nla_put_failure;
 
-		nl_limits = nla_nest_start(msg, NL80211_IFACE_COMB_LIMITS);
+		nl_limits = nla_nest_start_noflag(msg,
+						  NL80211_IFACE_COMB_LIMITS);
 		if (!nl_limits)
 			goto nla_put_failure;
 
 		for (j = 0; j < c->n_limits; j++) {
 			struct nlattr *nl_limit;
 
-			nl_limit = nla_nest_start(msg, j + 1);
+			nl_limit = nla_nest_start_noflag(msg, j + 1);
 			if (!nl_limit)
 				goto nla_put_failure;
 			if (nla_put_u32(msg, NL80211_IFACE_LIMIT_MAX,
@@ -1290,7 +1291,8 @@ static int nl80211_send_wowlan_tcp_caps(struct cfg80211_registered_device *rdev,
 	if (!tcp)
 		return 0;
 
-	nl_tcp = nla_nest_start(msg, NL80211_WOWLAN_TRIG_TCP_CONNECTION);
+	nl_tcp = nla_nest_start_noflag(msg,
+				       NL80211_WOWLAN_TRIG_TCP_CONNECTION);
 	if (!nl_tcp)
 		return -ENOBUFS;
 
@@ -1330,7 +1332,8 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 	if (!rdev->wiphy.wowlan)
 		return 0;
 
-	nl_wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED);
+	nl_wowlan = nla_nest_start_noflag(msg,
+					  NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED);
 	if (!nl_wowlan)
 		return -ENOBUFS;
 
@@ -1459,7 +1462,8 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
 
 	if (sband->n_iftype_data) {
 		struct nlattr *nl_iftype_data =
-			nla_nest_start(msg, NL80211_BAND_ATTR_IFTYPE_DATA);
+			nla_nest_start_noflag(msg,
+					      NL80211_BAND_ATTR_IFTYPE_DATA);
 		int err;
 
 		if (!nl_iftype_data)
@@ -1468,7 +1472,7 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
 		for (i = 0; i < sband->n_iftype_data; i++) {
 			struct nlattr *iftdata;
 
-			iftdata = nla_nest_start(msg, i + 1);
+			iftdata = nla_nest_start_noflag(msg, i + 1);
 			if (!iftdata)
 				return -ENOBUFS;
 
@@ -1484,12 +1488,12 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
 	}
 
 	/* add bitrates */
-	nl_rates = nla_nest_start(msg, NL80211_BAND_ATTR_RATES);
+	nl_rates = nla_nest_start_noflag(msg, NL80211_BAND_ATTR_RATES);
 	if (!nl_rates)
 		return -ENOBUFS;
 
 	for (i = 0; i < sband->n_bitrates; i++) {
-		nl_rate = nla_nest_start(msg, i);
+		nl_rate = nla_nest_start_noflag(msg, i);
 		if (!nl_rate)
 			return -ENOBUFS;
 
@@ -1522,12 +1526,12 @@ nl80211_send_mgmt_stypes(struct sk_buff *msg,
 	if (!mgmt_stypes)
 		return 0;
 
-	nl_ifs = nla_nest_start(msg, NL80211_ATTR_TX_FRAME_TYPES);
+	nl_ifs = nla_nest_start_noflag(msg, NL80211_ATTR_TX_FRAME_TYPES);
 	if (!nl_ifs)
 		return -ENOBUFS;
 
 	for (ift = 0; ift < NUM_NL80211_IFTYPES; ift++) {
-		nl_ftypes = nla_nest_start(msg, ift);
+		nl_ftypes = nla_nest_start_noflag(msg, ift);
 		if (!nl_ftypes)
 			return -ENOBUFS;
 		i = 0;
@@ -1545,12 +1549,12 @@ nl80211_send_mgmt_stypes(struct sk_buff *msg,
 
 	nla_nest_end(msg, nl_ifs);
 
-	nl_ifs = nla_nest_start(msg, NL80211_ATTR_RX_FRAME_TYPES);
+	nl_ifs = nla_nest_start_noflag(msg, NL80211_ATTR_RX_FRAME_TYPES);
 	if (!nl_ifs)
 		return -ENOBUFS;
 
 	for (ift = 0; ift < NUM_NL80211_IFTYPES; ift++) {
-		nl_ftypes = nla_nest_start(msg, ift);
+		nl_ftypes = nla_nest_start_noflag(msg, ift);
 		if (!nl_ftypes)
 			return -ENOBUFS;
 		i = 0;
@@ -1668,7 +1672,7 @@ nl80211_send_pmsr_ftm_capa(const struct cfg80211_pmsr_capabilities *cap,
 	if (!cap->ftm.supported)
 		return 0;
 
-	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
+	ftm = nla_nest_start_noflag(msg, NL80211_PMSR_TYPE_FTM);
 	if (!ftm)
 		return -ENOBUFS;
 
@@ -1716,7 +1720,7 @@ static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
 	 * will genlmsg_cancel() if we fail
 	 */
 
-	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
+	pmsr = nla_nest_start_noflag(msg, NL80211_ATTR_PEER_MEASUREMENTS);
 	if (!pmsr)
 		return -ENOBUFS;
 
@@ -1731,7 +1735,7 @@ static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
 	    nla_put_flag(msg, NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR))
 		return -ENOBUFS;
 
-	caps = nla_nest_start(msg, NL80211_PMSR_ATTR_TYPE_CAPA);
+	caps = nla_nest_start_noflag(msg, NL80211_PMSR_ATTR_TYPE_CAPA);
 	if (!caps)
 		return -ENOBUFS;
 
@@ -1892,7 +1896,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			break;
 		/* fall through */
 	case 3:
-		nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
+		nl_bands = nla_nest_start_noflag(msg,
+						 NL80211_ATTR_WIPHY_BANDS);
 		if (!nl_bands)
 			goto nla_put_failure;
 
@@ -1905,7 +1910,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			if (!sband)
 				continue;
 
-			nl_band = nla_nest_start(msg, band);
+			nl_band = nla_nest_start_noflag(msg, band);
 			if (!nl_band)
 				goto nla_put_failure;
 
@@ -1919,15 +1924,16 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				/* fall through */
 			default:
 				/* add frequencies */
-				nl_freqs = nla_nest_start(
-					msg, NL80211_BAND_ATTR_FREQS);
+				nl_freqs = nla_nest_start_noflag(msg,
+								 NL80211_BAND_ATTR_FREQS);
 				if (!nl_freqs)
 					goto nla_put_failure;
 
 				for (i = state->chan_start - 1;
 				     i < sband->n_channels;
 				     i++) {
-					nl_freq = nla_nest_start(msg, i);
+					nl_freq = nla_nest_start_noflag(msg,
+									i);
 					if (!nl_freq)
 						goto nla_put_failure;
 
@@ -1972,7 +1978,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			break;
 		/* fall through */
 	case 4:
-		nl_cmds = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_COMMANDS);
+		nl_cmds = nla_nest_start_noflag(msg,
+						NL80211_ATTR_SUPPORTED_COMMANDS);
 		if (!nl_cmds)
 			goto nla_put_failure;
 
@@ -2120,7 +2127,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			const struct nl80211_vendor_cmd_info *info;
 			struct nlattr *nested;
 
-			nested = nla_nest_start(msg, NL80211_ATTR_VENDOR_DATA);
+			nested = nla_nest_start_noflag(msg,
+						       NL80211_ATTR_VENDOR_DATA);
 			if (!nested)
 				goto nla_put_failure;
 
@@ -2136,8 +2144,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			const struct nl80211_vendor_cmd_info *info;
 			struct nlattr *nested;
 
-			nested = nla_nest_start(msg,
-						NL80211_ATTR_VENDOR_EVENTS);
+			nested = nla_nest_start_noflag(msg,
+						       NL80211_ATTR_VENDOR_EVENTS);
 			if (!nested)
 				goto nla_put_failure;
 
@@ -2174,7 +2182,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			struct nlattr *nested;
 			u32 bss_select_support = rdev->wiphy.bss_select_support;
 
-			nested = nla_nest_start(msg, NL80211_ATTR_BSS_SELECT);
+			nested = nla_nest_start_noflag(msg,
+						       NL80211_ATTR_BSS_SELECT);
 			if (!nested)
 				goto nla_put_failure;
 
@@ -2196,8 +2205,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		    rdev->wiphy.iftype_ext_capab) {
 			struct nlattr *nested_ext_capab, *nested;
 
-			nested = nla_nest_start(msg,
-						NL80211_ATTR_IFTYPE_EXT_CAPA);
+			nested = nla_nest_start_noflag(msg,
+						       NL80211_ATTR_IFTYPE_EXT_CAPA);
 			if (!nested)
 				goto nla_put_failure;
 
@@ -2207,7 +2216,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 
 				capab = &rdev->wiphy.iftype_ext_capab[i];
 
-				nested_ext_capab = nla_nest_start(msg, i);
+				nested_ext_capab = nla_nest_start_noflag(msg,
+									 i);
 				if (!nested_ext_capab ||
 				    nla_put_u32(msg, NL80211_ATTR_IFTYPE,
 						capab->iftype) ||
@@ -3521,7 +3531,7 @@ static void get_key_callback(void *c, struct key_params *params)
 			 params->cipher)))
 		goto nla_put_failure;
 
-	key = nla_nest_start(cookie->msg, NL80211_ATTR_KEY);
+	key = nla_nest_start_noflag(cookie->msg, NL80211_ATTR_KEY);
 	if (!key)
 		goto nla_put_failure;
 
@@ -4686,7 +4696,7 @@ bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info, int attr)
 	u16 bitrate_compat;
 	enum nl80211_rate_info rate_flg;
 
-	rate = nla_nest_start(msg, attr);
+	rate = nla_nest_start_noflag(msg, attr);
 	if (!rate)
 		return false;
 
@@ -4773,7 +4783,7 @@ static bool nl80211_put_signal(struct sk_buff *msg, u8 mask, s8 *signal,
 	if (!mask)
 		return true;
 
-	attr = nla_nest_start(msg, id);
+	attr = nla_nest_start_noflag(msg, id);
 	if (!attr)
 		return false;
 
@@ -4808,7 +4818,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION, sinfo->generation))
 		goto nla_put_failure;
 
-	sinfoattr = nla_nest_start(msg, NL80211_ATTR_STA_INFO);
+	sinfoattr = nla_nest_start_noflag(msg, NL80211_ATTR_STA_INFO);
 	if (!sinfoattr)
 		goto nla_put_failure;
 
@@ -4896,7 +4906,8 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(CONNECTED_TO_GATE, connected_to_gate, u8);
 
 	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_BSS_PARAM)) {
-		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
+		bss_param = nla_nest_start_noflag(msg,
+						  NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
 			goto nla_put_failure;
 
@@ -4939,7 +4950,8 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		struct nlattr *tidsattr;
 		int tid;
 
-		tidsattr = nla_nest_start(msg, NL80211_STA_INFO_TID_STATS);
+		tidsattr = nla_nest_start_noflag(msg,
+						 NL80211_STA_INFO_TID_STATS);
 		if (!tidsattr)
 			goto nla_put_failure;
 
@@ -4952,7 +4964,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 			if (!tidstats->filled)
 				continue;
 
-			tidattr = nla_nest_start(msg, tid + 1);
+			tidattr = nla_nest_start_noflag(msg, tid + 1);
 			if (!tidattr)
 				goto nla_put_failure;
 
@@ -5799,7 +5811,7 @@ static int nl80211_send_mpath(struct sk_buff *msg, u32 portid, u32 seq,
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION, pinfo->generation))
 		goto nla_put_failure;
 
-	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MPATH_INFO);
+	pinfoattr = nla_nest_start_noflag(msg, NL80211_ATTR_MPATH_INFO);
 	if (!pinfoattr)
 		goto nla_put_failure;
 	if ((pinfo->filled & MPATH_INFO_FRAME_QLEN) &&
@@ -6250,7 +6262,7 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			     NL80211_CMD_GET_MESH_CONFIG);
 	if (!hdr)
 		goto out;
-	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_CONFIG);
+	pinfoattr = nla_nest_start_noflag(msg, NL80211_ATTR_MESH_CONFIG);
 	if (!pinfoattr)
 		goto nla_put_failure;
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
@@ -6629,7 +6641,7 @@ static int nl80211_put_regdom(const struct ieee80211_regdomain *regdom,
 	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)))
 		goto nla_put_failure;
 
-	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
+	nl_reg_rules = nla_nest_start_noflag(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules)
 		goto nla_put_failure;
 
@@ -6644,7 +6656,7 @@ static int nl80211_put_regdom(const struct ieee80211_regdomain *regdom,
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
-		nl_reg_rule = nla_nest_start(msg, i);
+		nl_reg_rule = nla_nest_start_noflag(msg, i);
 		if (!nl_reg_rule)
 			goto nla_put_failure;
 
@@ -8269,7 +8281,7 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			      NL80211_ATTR_PAD))
 		goto nla_put_failure;
 
-	bss = nla_nest_start(msg, NL80211_ATTR_BSS);
+	bss = nla_nest_start_noflag(msg, NL80211_ATTR_BSS);
 	if (!bss)
 		goto nla_put_failure;
 	if ((!is_zero_ether_addr(res->bssid) &&
@@ -8446,7 +8458,7 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
-	infoattr = nla_nest_start(msg, NL80211_ATTR_SURVEY_INFO);
+	infoattr = nla_nest_start_noflag(msg, NL80211_ATTR_SURVEY_INFO);
 	if (!infoattr)
 		goto nla_put_failure;
 
@@ -9287,7 +9299,7 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 			goto nla_put_failure;
 	}
 
-	data = nla_nest_start(skb, attr);
+	data = nla_nest_start_noflag(skb, attr);
 	if (!data)
 		goto nla_put_failure;
 
@@ -9461,7 +9473,7 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 			break;
 		}
 
-		tmdata = nla_nest_start(skb, NL80211_ATTR_TESTDATA);
+		tmdata = nla_nest_start_noflag(skb, NL80211_ATTR_TESTDATA);
 		if (!tmdata) {
 			genlmsg_cancel(skb, hdr);
 			break;
@@ -10739,12 +10751,12 @@ static int nl80211_send_wowlan_patterns(struct sk_buff *msg,
 	if (!wowlan->n_patterns)
 		return 0;
 
-	nl_pats = nla_nest_start(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN);
+	nl_pats = nla_nest_start_noflag(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN);
 	if (!nl_pats)
 		return -ENOBUFS;
 
 	for (i = 0; i < wowlan->n_patterns; i++) {
-		nl_pat = nla_nest_start(msg, i + 1);
+		nl_pat = nla_nest_start_noflag(msg, i + 1);
 		if (!nl_pat)
 			return -ENOBUFS;
 		pat_len = wowlan->patterns[i].pattern_len;
@@ -10770,7 +10782,8 @@ static int nl80211_send_wowlan_tcp(struct sk_buff *msg,
 	if (!tcp)
 		return 0;
 
-	nl_tcp = nla_nest_start(msg, NL80211_WOWLAN_TRIG_TCP_CONNECTION);
+	nl_tcp = nla_nest_start_noflag(msg,
+				       NL80211_WOWLAN_TRIG_TCP_CONNECTION);
 	if (!nl_tcp)
 		return -ENOBUFS;
 
@@ -10814,7 +10827,7 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 	if (!req)
 		return 0;
 
-	nd = nla_nest_start(msg, NL80211_WOWLAN_TRIG_NET_DETECT);
+	nd = nla_nest_start_noflag(msg, NL80211_WOWLAN_TRIG_NET_DETECT);
 	if (!nd)
 		return -ENOBUFS;
 
@@ -10840,7 +10853,7 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 			return -ENOBUFS;
 	}
 
-	freqs = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
+	freqs = nla_nest_start_noflag(msg, NL80211_ATTR_SCAN_FREQUENCIES);
 	if (!freqs)
 		return -ENOBUFS;
 
@@ -10852,12 +10865,13 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 	nla_nest_end(msg, freqs);
 
 	if (req->n_match_sets) {
-		matches = nla_nest_start(msg, NL80211_ATTR_SCHED_SCAN_MATCH);
+		matches = nla_nest_start_noflag(msg,
+						NL80211_ATTR_SCHED_SCAN_MATCH);
 		if (!matches)
 			return -ENOBUFS;
 
 		for (i = 0; i < req->n_match_sets; i++) {
-			match = nla_nest_start(msg, i);
+			match = nla_nest_start_noflag(msg, i);
 			if (!match)
 				return -ENOBUFS;
 
@@ -10870,12 +10884,12 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 		nla_nest_end(msg, matches);
 	}
 
-	scan_plans = nla_nest_start(msg, NL80211_ATTR_SCHED_SCAN_PLANS);
+	scan_plans = nla_nest_start_noflag(msg, NL80211_ATTR_SCHED_SCAN_PLANS);
 	if (!scan_plans)
 		return -ENOBUFS;
 
 	for (i = 0; i < req->n_scan_plans; i++) {
-		scan_plan = nla_nest_start(msg, i + 1);
+		scan_plan = nla_nest_start_noflag(msg, i + 1);
 		if (!scan_plan)
 			return -ENOBUFS;
 
@@ -10924,7 +10938,8 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 	if (rdev->wiphy.wowlan_config) {
 		struct nlattr *nl_wowlan;
 
-		nl_wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
+		nl_wowlan = nla_nest_start_noflag(msg,
+						  NL80211_ATTR_WOWLAN_TRIGGERS);
 		if (!nl_wowlan)
 			goto nla_put_failure;
 
@@ -11358,12 +11373,12 @@ static int nl80211_send_coalesce_rules(struct sk_buff *msg,
 	if (!rdev->coalesce->n_rules)
 		return 0;
 
-	nl_rules = nla_nest_start(msg, NL80211_ATTR_COALESCE_RULE);
+	nl_rules = nla_nest_start_noflag(msg, NL80211_ATTR_COALESCE_RULE);
 	if (!nl_rules)
 		return -ENOBUFS;
 
 	for (i = 0; i < rdev->coalesce->n_rules; i++) {
-		nl_rule = nla_nest_start(msg, i + 1);
+		nl_rule = nla_nest_start_noflag(msg, i + 1);
 		if (!nl_rule)
 			return -ENOBUFS;
 
@@ -11376,13 +11391,13 @@ static int nl80211_send_coalesce_rules(struct sk_buff *msg,
 				rule->condition))
 			return -ENOBUFS;
 
-		nl_pats = nla_nest_start(msg,
-				NL80211_ATTR_COALESCE_RULE_PKT_PATTERN);
+		nl_pats = nla_nest_start_noflag(msg,
+						NL80211_ATTR_COALESCE_RULE_PKT_PATTERN);
 		if (!nl_pats)
 			return -ENOBUFS;
 
 		for (j = 0; j < rule->n_patterns; j++) {
-			nl_pat = nla_nest_start(msg, j + 1);
+			nl_pat = nla_nest_start_noflag(msg, j + 1);
 			if (!nl_pat)
 				return -ENOBUFS;
 			pat_len = rule->patterns[j].pattern_len;
@@ -12134,7 +12149,7 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 			      NL80211_ATTR_PAD))
 		goto nla_put_failure;
 
-	func_attr = nla_nest_start(msg, NL80211_ATTR_NAN_FUNC);
+	func_attr = nla_nest_start_noflag(msg, NL80211_ATTR_NAN_FUNC);
 	if (!func_attr)
 		goto nla_put_failure;
 
@@ -12251,11 +12266,12 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, match->addr))
 		goto nla_put_failure;
 
-	match_attr = nla_nest_start(msg, NL80211_ATTR_NAN_MATCH);
+	match_attr = nla_nest_start_noflag(msg, NL80211_ATTR_NAN_MATCH);
 	if (!match_attr)
 		goto nla_put_failure;
 
-	local_func_attr = nla_nest_start(msg, NL80211_NAN_MATCH_FUNC_LOCAL);
+	local_func_attr = nla_nest_start_noflag(msg,
+						NL80211_NAN_MATCH_FUNC_LOCAL);
 	if (!local_func_attr)
 		goto nla_put_failure;
 
@@ -12264,7 +12280,8 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
 
 	nla_nest_end(msg, local_func_attr);
 
-	peer_func_attr = nla_nest_start(msg, NL80211_NAN_MATCH_FUNC_PEER);
+	peer_func_attr = nla_nest_start_noflag(msg,
+					       NL80211_NAN_MATCH_FUNC_PEER);
 	if (!peer_func_attr)
 		goto nla_put_failure;
 
@@ -12330,7 +12347,7 @@ void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
 			      NL80211_ATTR_PAD))
 		goto nla_put_failure;
 
-	func_attr = nla_nest_start(msg, NL80211_ATTR_NAN_FUNC);
+	func_attr = nla_nest_start_noflag(msg, NL80211_ATTR_NAN_FUNC);
 	if (!func_attr)
 		goto nla_put_failure;
 
@@ -12679,7 +12696,8 @@ static int nl80211_vendor_cmd_dump(struct sk_buff *skb,
 			break;
 		}
 
-		vendor_data = nla_nest_start(skb, NL80211_ATTR_VENDOR_DATA);
+		vendor_data = nla_nest_start_noflag(skb,
+						    NL80211_ATTR_VENDOR_DATA);
 		if (!vendor_data) {
 			genlmsg_cancel(skb, hdr);
 			break;
@@ -13223,7 +13241,8 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
-	ftm_stats_attr = nla_nest_start(msg, NL80211_ATTR_FTM_RESPONDER_STATS);
+	ftm_stats_attr = nla_nest_start_noflag(msg,
+					       NL80211_ATTR_FTM_RESPONDER_STATS);
 	if (!ftm_stats_attr)
 		goto nla_put_failure;
 
@@ -14166,7 +14185,7 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	if (WARN_ON(!req))
 		return 0;
 
-	nest = nla_nest_start(msg, NL80211_ATTR_SCAN_SSIDS);
+	nest = nla_nest_start_noflag(msg, NL80211_ATTR_SCAN_SSIDS);
 	if (!nest)
 		goto nla_put_failure;
 	for (i = 0; i < req->n_ssids; i++) {
@@ -14175,7 +14194,7 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	}
 	nla_nest_end(msg, nest);
 
-	nest = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
+	nest = nla_nest_start_noflag(msg, NL80211_ATTR_SCAN_FREQUENCIES);
 	if (!nest)
 		goto nla_put_failure;
 	for (i = 0; i < req->n_channels; i++) {
@@ -14437,7 +14456,7 @@ static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 
 	if (uapsd_queues >= 0) {
 		struct nlattr *nla_wmm =
-			nla_nest_start(msg, NL80211_ATTR_STA_WME);
+			nla_nest_start_noflag(msg, NL80211_ATTR_STA_WME);
 		if (!nla_wmm)
 			goto nla_put_failure;
 
@@ -14878,7 +14897,7 @@ void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 		goto nla_put_failure;
 
 	/* Before */
-	nl_freq = nla_nest_start(msg, NL80211_ATTR_FREQ_BEFORE);
+	nl_freq = nla_nest_start_noflag(msg, NL80211_ATTR_FREQ_BEFORE);
 	if (!nl_freq)
 		goto nla_put_failure;
 
@@ -14887,7 +14906,7 @@ void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 	nla_nest_end(msg, nl_freq);
 
 	/* After */
-	nl_freq = nla_nest_start(msg, NL80211_ATTR_FREQ_AFTER);
+	nl_freq = nla_nest_start_noflag(msg, NL80211_ATTR_FREQ_AFTER);
 	if (!nl_freq)
 		goto nla_put_failure;
 
@@ -15321,7 +15340,7 @@ static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
 	if (mac && nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac))
 		goto nla_put_failure;
 
-	cb[1] = nla_nest_start(msg, NL80211_ATTR_CQM);
+	cb[1] = nla_nest_start_noflag(msg, NL80211_ATTR_CQM);
 	if (!cb[1])
 		goto nla_put_failure;
 
@@ -15482,7 +15501,7 @@ static void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid))
 		goto nla_put_failure;
 
-	rekey_attr = nla_nest_start(msg, NL80211_ATTR_REKEY_DATA);
+	rekey_attr = nla_nest_start_noflag(msg, NL80211_ATTR_REKEY_DATA);
 	if (!rekey_attr)
 		goto nla_put_failure;
 
@@ -15537,7 +15556,7 @@ nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
 		goto nla_put_failure;
 
-	attr = nla_nest_start(msg, NL80211_ATTR_PMKSA_CANDIDATE);
+	attr = nla_nest_start_noflag(msg, NL80211_ATTR_PMKSA_CANDIDATE);
 	if (!attr)
 		goto nla_put_failure;
 
@@ -15842,15 +15861,15 @@ static int cfg80211_net_detect_results(struct sk_buff *msg,
 	struct nlattr *nl_results, *nl_match, *nl_freqs;
 	int i, j;
 
-	nl_results = nla_nest_start(
-		msg, NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS);
+	nl_results = nla_nest_start_noflag(msg,
+					   NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS);
 	if (!nl_results)
 		return -EMSGSIZE;
 
 	for (i = 0; i < nd->n_matches; i++) {
 		struct cfg80211_wowlan_nd_match *match = nd->matches[i];
 
-		nl_match = nla_nest_start(msg, i);
+		nl_match = nla_nest_start_noflag(msg, i);
 		if (!nl_match)
 			break;
 
@@ -15868,8 +15887,8 @@ static int cfg80211_net_detect_results(struct sk_buff *msg,
 		}
 
 		if (match->n_channels) {
-			nl_freqs = nla_nest_start(
-				msg, NL80211_ATTR_SCAN_FREQUENCIES);
+			nl_freqs = nla_nest_start_noflag(msg,
+							 NL80211_ATTR_SCAN_FREQUENCIES);
 			if (!nl_freqs) {
 				nla_nest_cancel(msg, nl_match);
 				goto out;
@@ -15928,7 +15947,8 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 	if (wakeup) {
 		struct nlattr *reasons;
 
-		reasons = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
+		reasons = nla_nest_start_noflag(msg,
+						NL80211_ATTR_WOWLAN_TRIGGERS);
 		if (!reasons)
 			goto free_msg;
 
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 5e2ab01d325c..5c80bccc8b3c 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -420,22 +420,22 @@ static int nl80211_pmsr_send_result(struct sk_buff *msg,
 {
 	struct nlattr *pmsr, *peers, *peer, *resp, *data, *typedata;
 
-	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
+	pmsr = nla_nest_start_noflag(msg, NL80211_ATTR_PEER_MEASUREMENTS);
 	if (!pmsr)
 		goto error;
 
-	peers = nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
+	peers = nla_nest_start_noflag(msg, NL80211_PMSR_ATTR_PEERS);
 	if (!peers)
 		goto error;
 
-	peer = nla_nest_start(msg, 1);
+	peer = nla_nest_start_noflag(msg, 1);
 	if (!peer)
 		goto error;
 
 	if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN, res->addr))
 		goto error;
 
-	resp = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_RESP);
+	resp = nla_nest_start_noflag(msg, NL80211_PMSR_PEER_ATTR_RESP);
 	if (!resp)
 		goto error;
 
@@ -452,11 +452,11 @@ static int nl80211_pmsr_send_result(struct sk_buff *msg,
 	if (res->final && nla_put_flag(msg, NL80211_PMSR_RESP_ATTR_FINAL))
 		goto error;
 
-	data = nla_nest_start(msg, NL80211_PMSR_RESP_ATTR_DATA);
+	data = nla_nest_start_noflag(msg, NL80211_PMSR_RESP_ATTR_DATA);
 	if (!data)
 		goto error;
 
-	typedata = nla_nest_start(msg, res->type);
+	typedata = nla_nest_start_noflag(msg, res->type);
 	if (!typedata)
 		goto error;
 
-- 
2.21.0

