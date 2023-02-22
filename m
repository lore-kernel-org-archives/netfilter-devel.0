Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30419C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 11:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjBVLDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 06:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjBVLDu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 06:03:50 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2115.outbound.protection.outlook.com [40.107.7.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA8E6E96
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 03:03:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwEpDB41X11xC9hf/SpWCRDyN7TmbwXfGtH727XMLQDZSsDnPy+vmaUvJX3W4CEogZWm14Aw0nKX+A2msX1Qme2IvGUUikCJC/16kUHK3mYFH/aJuiHc5DXBjSnQmH30qnjKhKN41CCHWVLaxaZI+ZtUVJalS/Rd5CjifzM1C4gTVGVfQcOEj7n9LbMbQVrtBYyWTEEKJku0wGJnIWZGmIJiwSdBcQLNuaJMdkFSpjGou+eid3184Iy85nzLyLmm6roMlISBKpFzFV4n00e2iWtAVslBxEI7R6wjzhpzHUcZYRxmAbLufIq8JVPQgLyJ1OiLQpbSVmleko21XKxtSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12HQxcOxcWYU9svEUFj91Uhvb2PAtvysF5csDk5O7Rw=;
 b=SUqwhR4YCE1kqg9LByRy2w5kf64eFQvL+NqcFtekWlMaU3MqV+G9MrNenqg9Gd9YPdJ5bkvLzcRnj3Dkfh8w4b2GSzS8tKDmtM2hZPZTgcA40TLymUU5Pc5a2RE81fCIZP+5PImchfVh+qoqUv8hyk+x3h4gxJyFXag1GY1bhdsIhwO9lH2X2O2SfLm3YRXNZtDukQLlFGMa7qcIQvjH2YZcV6RthJU7xfKuvwuLkJFLnlgh/BRJ9DBrC8uz0N9Jd2PyZsMV91p481ZPAEYa4WBcotBBAxnw5KxtmIyz1nSOD4N9sNLdHMusxupOlVhjKdEaowgjMg9DEpOd/B/mRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12HQxcOxcWYU9svEUFj91Uhvb2PAtvysF5csDk5O7Rw=;
 b=lb6/5TQsup8WWyry/ycKn6dWHf0b0SijetrpFNcDlvdeADtppTTgFi+HKRjQ/dV6BR66VxLyepuFVU40awZZtZYSjVAZ3uk7lKji8iacQkpgdL+rdIn6Zsxk7ryNBHpPj1WL2kqQB0pXgkmVFg5ycvTG0OJo2CH6weYU4gBKv1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB1967.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:4b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Wed, 22 Feb
 2023 11:03:42 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 11:03:41 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Date:   Wed, 22 Feb 2023 12:03:37 +0100
Message-Id: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0020.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::16) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AS4P189MB1967:EE_
X-MS-Office365-Filtering-Correlation-Id: c1604736-9995-48b8-ebd5-08db14c47531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3utUtuDLqRe4eTyxFU00LuraTPJMqBjCLySEqG8arH90TCqxWp09eKrvcm16qhpcUsX+9IDATsYJSH/a2bZaZ5KAlPGbOd8se/gbVMptDXBV+X1kdk7ioTnqkTVy5f5Q6jh4t0Wg4gXxSAksjqRruSmshIjM2hpbKCgO4jeH2z0/wb630QE3+0AysZPuDoO0F+TgSqJTQgZgXuVpscGOn9iCT3O2Md3lE9Vrz+KcSz39Bf8CzTh5fZSuftqMICouw6J6npz5q0TJgWGrAioghLtDfCh2O1Zz8/sGqHmwjVb4eZlFKuAY+8oVSD6LNx2u9qFWCATCd0IeXX6gHfIEDOXlFae3KB5fK28YGfmk5gHwE8cNs440jNnTTkjYasJU9KUV+JVaGDu2HK+1KNuMSfHI88u583u3mbuXviSH9ScnSAPnm8oeQOBZosg9HZZs1eyetUFiaNPlufMfU+VDaaLlaqszk7KC3HiI/LUYYbdYpMrC0rUjcmjCXvjY0Zm/4AA3jGbFNnrBSLMWw/BwOMVKe7JxOb0TJa/tHJW2Wt9KdJxw5bBw+DI+1P2PgmSiSIJXCEIFaceHmgkRh5H6lQrLTokL/uu56GOuD7Bkq3Gq+dqXPZ7becaP82ol7onh8NLeS9Ow+73RMvbYZ6vRZmeZWaydjpa54c+euV9IZ7c1QdLLC4p2CnTy2wKWhY73
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39840400004)(346002)(136003)(451199018)(2906002)(83380400001)(316002)(44832011)(36756003)(5660300002)(6916009)(41300700001)(86362001)(8676002)(66946007)(66476007)(70586007)(66556008)(4326008)(8936002)(38100700002)(54906003)(6512007)(26005)(186003)(2616005)(1076003)(6506007)(478600001)(6666004)(6486002)(966005)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ct8hlcpQBZVbalCfAa2/JkEVVBANdDPsoa7JSdeU6WFr4AAV14Ly27WBfG0I?=
 =?us-ascii?Q?9rn1nc7kRNtQGXgMvK8A94d9K0DceKrNnsKYqW/bfQRiblqA5dtzVjWMujbB?=
 =?us-ascii?Q?d+iJoHSvv48JclJEO00+z4cbPhjeSm93cg+O6X5cJAngWjz0qq5UeuEn9VEg?=
 =?us-ascii?Q?a1gxGhTm24Pcweuva8zrG3+TEKW34whZ2YT/IDRrNIkrcACrrDhd9Z+lXcwi?=
 =?us-ascii?Q?BosZ0RFwVFfjdU0j88T4Enq4S1ToQLYGZ7wfvJJm+v+PxKMLfUBRCwdRG3de?=
 =?us-ascii?Q?jUSvC3acWADFxYqZdgrJXh3OsmwBFbSGbtKw+msVMa7bYxRFKl2Cn2IkT4fQ?=
 =?us-ascii?Q?H+aHbm3FdtgyreyQEcxVRwUgirqn9EjIreLng7k5o2HaJhUczD172cIqE3Uq?=
 =?us-ascii?Q?lKviEkJnuVYphycIleh61anzfFTTA1eLfLoniQ138X7BiQygh9HrTxCg5yEN?=
 =?us-ascii?Q?6JLT3vUWlJMTSJk+Yv1B/pgz2f6iLBT9hy2Y9XAQtTIyug2yqOCGgR9tNFOy?=
 =?us-ascii?Q?aV06dCHQ6xqAhb45Z3NVJDv8Wx0e/T9P/EdqlGovGCtZ4BS/xyXU5E8V1U3/?=
 =?us-ascii?Q?PFctr3RUFIhaGRRAwjzlzUpVykG2pgmKAKiI/DOwtu8R7hl/QBiekfUCQ8JY?=
 =?us-ascii?Q?d1TMGiDnDrDnReOtu1rWZ29eqQFf687nDW/fCtlQ0Us0WV5uUUfpzhC5VC2w?=
 =?us-ascii?Q?1nMYFAsbTvrIoYLDPSuFidAC6aaQoplNcrZYG9YmWFiQpxQpiDXJjA4cdTRB?=
 =?us-ascii?Q?sg0fbQ6swbCYC76fipkMYxLAOi2oACfKx7Fq0gANM/GuY29p47c8mZZGUJaX?=
 =?us-ascii?Q?7WinzxnB+GKT5CIGQEQpiSPzxkebuheWISCBujSwnwzPlBd7DLEcmr9OkXf/?=
 =?us-ascii?Q?PDCcpRH4r0xsc6PgoUMtiPJNgBl2WOUMYXoZ6KTTzG34+YiL8mVMgHq4dWPM?=
 =?us-ascii?Q?lDh3pNltS+fvcKsEm0zytyMOkVBwXT6vY1DBOLXdEZpyjf2pAaG0vNvOAij4?=
 =?us-ascii?Q?qOlNeT4anTv/Cz5AeRXOFy03EUbZpntTkcmzb+g9UtXfQXExgGgztbTSh1gh?=
 =?us-ascii?Q?T0xE9BvuX2dFbJgQqu3WqHXt7smPsJckkZNzsPuLjr42KQlQ0iINmSDc98Bh?=
 =?us-ascii?Q?BZ5V1a0Z5h++uBaAo9u3K4rgqhAdHJ0QY9nqfl4/FUluVqT7JmlZLXOBdph3?=
 =?us-ascii?Q?cKrJO0j1xBUzUI+pLAxynnA0jd87qvXadiwzxyce2c94wk8mdY8N01h52iF/?=
 =?us-ascii?Q?1xycNLGeSAfClY0/BIV2AJCLcKbcCszHORiNvJFgHY9sqtyCADPfQygX8ZWV?=
 =?us-ascii?Q?xHSuuSYaiKg4pMwnO4Kb4/P4gxtaZLwd3rpAZQLILxOBBFZKq1OHbr7/ldh2?=
 =?us-ascii?Q?4a3qmTpAqQAplfwATIxNfqMw9shXR1Ej3d275oNHSdyaHm9wWquTHYtXsdQ5?=
 =?us-ascii?Q?oJnToLcHM8PmVM/2AZUsxObfDPSieKoAq5lcHuq5EFMR4MafOLHf72JA8l3E?=
 =?us-ascii?Q?4WSLIFZ1GoMTRitA55JEGl/WuCu0IsH8F8DgNOTvVjmuGzkBoCUjb5jWMprC?=
 =?us-ascii?Q?MqJS2jTnm6dzyk/UD6uysYQONUi5YgEjhXTXa46k7NyZUAe+TjTLZs1x3nd9?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: c1604736-9995-48b8-ebd5-08db14c47531
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 11:03:41.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUv5Ryozz7QOnqnmxN3kHWmIM5yK2XkAxu6tauyUSLB5LDQv8XiLgXHsqoLFiu+4UJqiK0I3iwUewoObQgmqamse/X3RbwQJstAu1UrcLgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB1967
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Is there any interest or plan to implement BROUTE chain type for nftables?

We have a situation when a network interface that is part of a bridge is
used to receive PTP and/or EAPOL packets. Userspace daemons that use
AF_PACKET to capture specific ether types do not receive the packets,
and they are instead bridged. We are currently still using etables -t
broute to send packets packets up the stack. This functionality seems to
be missing in nftables. Below you can find a proposal that could be used,
of course there is some work to introduce the chain type and a default
priority in nftables userspace tool. 

I could see there are other users asking for BROUTE:
[1]: https://bugzilla.netfilter.org/show_bug.cgi?id=1316
[2]: https://lore.kernel.org/netfilter-devel/20191024114653.GU25052@breakpoint.cc/
[3]: https://marc.info/?l=netfilter&m=154807010116514

broute chain type is just a copy from etables -t broute implementation.
NF_DROP: skb is routed instead of bridged, and mapped to NF_ACCEPT.
All other verdicts are returned as it is.

Please advise if there are better ways to solve this instead of using
the br_netfilter_broute flag.

---
 include/net/netfilter/nf_tables.h |  4 ++
 net/netfilter/Makefile            |  2 +-
 net/netfilter/nf_tables_api.c     |  2 +
 net/netfilter/nft_chain_broute.c  | 82 +++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nft_chain_broute.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9430128aae99..cf7b36d54115 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1090,6 +1090,7 @@ enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
 	NFT_CHAIN_T_ROUTE,
 	NFT_CHAIN_T_NAT,
+	NFT_CHAIN_T_BROUTE,
 	NFT_CHAIN_T_MAX
 };
 
@@ -1665,6 +1666,9 @@ void nft_chain_filter_fini(void);
 void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
 
+void __init nft_chain_broute_init(void);
+void nft_chain_broute_fini(void);
+
 void nf_tables_trans_destroy_flush_work(void);
 
 int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5ffef1cd6143..fd0e79d2d11e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -91,7 +91,7 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nft_counter.o nft_objref.o nft_inner.o \
 		  nft_chain_route.o nf_tables_offload.o \
 		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
-		  nft_set_pipapo.o
+		  nft_set_pipapo.o nft_chain_broute.o
 
 ifdef CONFIG_X86_64
 ifndef CONFIG_UML
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d73edbd4eec4..a95f138562e2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10389,6 +10389,7 @@ static int __init nf_tables_module_init(void)
 		goto err_nfnl_subsys;
 
 	nft_chain_route_init();
+	nft_chain_broute_init();
 
 	return err;
 
@@ -10417,6 +10418,7 @@ static void __exit nf_tables_module_exit(void)
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
 	nft_chain_route_fini();
+	nft_chain_broute_fini();
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
diff --git a/net/netfilter/nft_chain_broute.c b/net/netfilter/nft_chain_broute.c
new file mode 100644
index 000000000000..9c8461ec8fde
--- /dev/null
+++ b/net/netfilter/nft_chain_broute.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter_bridge.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
+#include "../bridge/br_private.h"
+
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static unsigned int
+nft_do_chain_broute(void *priv,
+		    struct sk_buff *skb,
+		    const struct nf_hook_state *state)
+{
+	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
+	unsigned char *dest;
+	struct nft_pktinfo pkt;
+	int ret;
+
+	nft_set_pktinfo(&pkt, skb, state);
+
+	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_IP):
+		nft_set_pktinfo_ipv4_validate(&pkt);
+		break;
+	case htons(ETH_P_IPV6):
+		nft_set_pktinfo_ipv6_validate(&pkt);
+		break;
+	default:
+		nft_set_pktinfo_unspec(&pkt);
+		break;
+	}
+
+	ret = nft_do_chain(&pkt, priv);
+	if ((ret & NF_VERDICT_MASK) == NF_DROP) {
+		/* DROP in ebtables -t broute means that the
+		* skb should be routed, not bridged.
+		* This is awkward, but can't be changed for compatibility
+		* reasons.
+		*
+		* We map DROP to ACCEPT and set the ->br_netfilter_broute flag.
+		*/
+		ret = NF_ACCEPT;
+		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = 1;
+		/* undo PACKET_HOST mangling done in br_input in case the dst
+		* address matches the logical bridge but not the port.
+		*/
+		dest = eth_hdr(skb)->h_dest;
+		if (skb->pkt_type == PACKET_HOST &&
+		    !ether_addr_equal(skb->dev->dev_addr, dest) &&
+		    ether_addr_equal(p->br->dev->dev_addr, dest))
+			skb->pkt_type = PACKET_OTHERHOST;
+	}
+	return ret;
+}
+
+static const struct nft_chain_type nft_chain_broute = {
+	.name		= "broute",
+	.type		= NFT_CHAIN_T_BROUTE,
+	.family		= NFPROTO_BRIDGE,
+	.hook_mask	= (1 << NF_BR_PRE_ROUTING),
+	.hooks		= {
+		[NF_BR_PRE_ROUTING]	= nft_do_chain_broute,
+	},
+};
+#endif
+
+void __init nft_chain_broute_init(void)
+{
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	nft_register_chain_type(&nft_chain_broute);
+#endif
+}
+
+void __exit nft_chain_broute_fini(void)
+{
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	nft_unregister_chain_type(&nft_chain_broute);
+#endif
+}
-- 
2.34.1

