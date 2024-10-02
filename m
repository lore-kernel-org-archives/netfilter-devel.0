Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41AB216A0E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897944; cv=none; b=dQ8j75ujYQKAc15WGkhOmVN8g6Y45IK3PSECTf6C4qiVDCnppFf/DjNMsTDRT3eKHzNXTQPNXvHUHspk/V4ul5PHs3VXHEeq2m6NSy+ojOB4lt5dZg/2DU5OdlapfBtR/H1FkUszIcX8q4R9LOnHGU9t04/hl0xUf33+u2MKnOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897944; c=relaxed/simple;
	bh=74CnUTSOHGcFKcmZ+1rR4Csd2KZvgPCC8zIDjhTjbx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jigjl5HDCgweVdiAe8nrTBm8pgMv2VKiXZcXJTxqb7yobdvFIE754A+9HX2aoKK8Mc2H6j5clhUKdcJDbt9NL+eq/x182Mhc8xbHkh9buFzGBvNqCyNSfO+U2RQpVXfld1NnJHgmM5Z4vWL5kiexlh1Bm36CHey8YtfbKCKQJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U+aHybMR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U+aHybMR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/Z/PhoiMXdeyA0y5FGWHX7S4ytXdi8bDpkD5goAus+A=; b=U+aHybMRVahF1JcV1eTwgq8P35
	MxheSS3fuLA8tsgxyGcy5z1oF53Vafd0fJ4MicwMoMgjTWHu9OM7z+SgeIi/fESac1cLx3SxAEO2S
	xouclU4MqpTw+fvjokPV0qGobUym3TVSODdXXixm+NI0JhTu/ocv87k+PmaQ1Rtxlhb+GqNfA9qat
	csY27+zg1SgDXMPc8P+zaNWFUQRxDuX/yC02nWMU6ZIzyi2yXT9pdWvZBD8r/09v09Gq9p7XlBR1w
	/AW07DBnapNPx7NZ2zxxQAEJl9ZUZ65AQfdnxE0Tv0WH4d3Nvy0QxZh9YuzkeYqghX5UBi1US7QzX
	yRYxnYhA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Bc-0000000031F-2rkw;
	Wed, 02 Oct 2024 21:39:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 9/9] monitor: Support NFT_MSG_(NEW|DEL)DEV events
Date: Wed,  2 Oct 2024 21:38:53 +0200
Message-ID: <20241002193853.13818-10-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernels with name-based netdev hooks emit these messages when a device
is added to or removed from an existing flowtable or netdev-family
base-chain.

This patch depends on respective support code in libnftnl.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/json.h                             | 10 ++++
 include/linux/netfilter/nf_tables.h        | 10 ++++
 src/json.c                                 | 27 +++++++++
 src/monitor.c                              | 64 +++++++++++++++++++++
 tests/monitor/testcases/chain-netdev.t     | 66 ++++++++++++++++++++++
 tests/monitor/testcases/flowtable-simple.t | 56 ++++++++++++++++++
 6 files changed, 233 insertions(+)
 create mode 100644 tests/monitor/testcases/chain-netdev.t

diff --git a/include/json.h b/include/json.h
index 0670b8714519b..10a75ba050a6c 100644
--- a/include/json.h
+++ b/include/json.h
@@ -20,6 +20,7 @@ struct nft_ctx;
 struct location;
 struct output_ctx;
 struct list_head;
+struct nftnl_device;
 
 #ifdef HAVE_LIBJANSSON
 
@@ -118,6 +119,8 @@ void monitor_print_flowtable_json(struct netlink_mon_handler *monh,
 				  const char *cmd, struct flowtable *ft);
 void monitor_print_rule_json(struct netlink_mon_handler *monh,
 			     const char *cmd, struct rule *r);
+void monitor_print_device_json(struct netlink_mon_handler *monh,
+			       const char *cmd, struct nftnl_device *nld);
 
 int json_events_cb(const struct nlmsghdr *nlh,
 		   struct netlink_mon_handler *monh);
@@ -270,6 +273,13 @@ static inline void monitor_print_rule_json(struct netlink_mon_handler *monh,
 	/* empty */
 }
 
+static inline void
+monitor_print_device_json(struct netlink_mon_handler *monh,
+			  const char *cmd, struct nftnl_device *nld)
+{
+	/* empty */
+}
+
 static inline int json_events_cb(const struct nlmsghdr *nlh,
                                  struct netlink_mon_handler *monh)
 {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c62e6ac563988..206d90b190951 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -142,6 +142,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_DESTROYOBJ,
 	NFT_MSG_DESTROYFLOWTABLE,
 	NFT_MSG_GETSETELEM_RESET,
+	NFT_MSG_NEWDEV,
+	NFT_MSG_DELDEV,
 	NFT_MSG_MAX,
 };
 
@@ -1761,10 +1763,18 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_TABLE: table containing the flowtable or chain hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_FLOWTABLE: flowtable hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_CHAIN: chain hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_SPEC: hook spec matching the device (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_TABLE,
+	NFTA_DEVICE_FLOWTABLE,
+	NFTA_DEVICE_CHAIN,
+	NFTA_DEVICE_SPEC,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/src/json.c b/src/json.c
index 64a6888f9e0ac..02f21bb6b0d92 100644
--- a/src/json.c
+++ b/src/json.c
@@ -17,6 +17,8 @@
 #include <rt.h>
 #include "nftutils.h"
 
+#include <libnftnl/device.h>
+
 #include <netdb.h>
 #include <netinet/icmp6.h>
 #include <netinet/in.h>
@@ -2122,6 +2124,31 @@ void monitor_print_rule_json(struct netlink_mon_handler *monh,
 	monitor_print_json(monh, cmd, rule_print_json(octx, r));
 }
 
+void monitor_print_device_json(struct netlink_mon_handler *monh,
+			       const char *cmd, struct nftnl_device *nld)
+{
+	int32_t family = nftnl_device_get_s32(nld, NFTNL_DEVICE_FAMILY);
+	const char *key, *val;
+	json_t *root;
+
+	if (nftnl_device_is_set(nld, NFTNL_DEVICE_CHAIN)) {
+		key = "chain";
+		val = nftnl_device_get_str(nld, NFTNL_DEVICE_CHAIN);
+	} else if (nftnl_device_is_set(nld, NFTNL_DEVICE_FLOWTABLE)) {
+		key = "flowtable";
+		val = nftnl_device_get_str(nld, NFTNL_DEVICE_FLOWTABLE);
+	} else {
+		return;
+	}
+	root = json_pack("{s:{s:s, s:s, s:s, s:s, s:s}}", "device",
+			 "family", family2str(family),
+			 "table", nftnl_device_get_str(nld, NFTNL_DEVICE_TABLE),
+			 key, val,
+			 "name", nftnl_device_get_str(nld, NFTNL_DEVICE_NAME),
+			 "spec", nftnl_device_get_str(nld, NFTNL_DEVICE_SPEC));
+	monitor_print_json(monh, cmd, root);
+}
+
 void json_alloc_echo(struct nft_ctx *nft)
 {
 	nft->json_echo = json_array();
diff --git a/src/monitor.c b/src/monitor.c
index a787db8cbf5a3..3d53f62a61280 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -25,6 +25,7 @@
 #include <libnftnl/udata.h>
 #include <libnftnl/ruleset.h>
 #include <libnftnl/common.h>
+#include <libnftnl/device.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
@@ -154,6 +155,7 @@ static uint32_t netlink_msg2nftnl_of(uint32_t type, uint16_t flags)
 	case NFT_MSG_NEWSETELEM:
 	case NFT_MSG_NEWOBJ:
 	case NFT_MSG_NEWFLOWTABLE:
+	case NFT_MSG_NEWDEV:
 		if (flags & NLM_F_EXCL)
 			return NFT_OF_EVENT_CREATE;
 		else
@@ -165,6 +167,7 @@ static uint32_t netlink_msg2nftnl_of(uint32_t type, uint16_t flags)
 	case NFT_MSG_DELRULE:
 	case NFT_MSG_DELOBJ:
 	case NFT_MSG_DELFLOWTABLE:
+	case NFT_MSG_DELDEV:
 		return NFTNL_OF_EVENT_DEL;
 	}
 
@@ -599,6 +602,61 @@ static int netlink_events_flowtable_cb(const struct nlmsghdr *nlh, int type,
 	return MNL_CB_OK;
 }
 
+static struct nftnl_device *netlink_device_alloc(const struct nlmsghdr *nlh)
+{
+	struct nftnl_device *nld;
+
+	nld = nftnl_device_alloc();
+	if (nld == NULL)
+		memory_allocation_error();
+	if (nftnl_device_nlmsg_parse(nlh, nld) < 0)
+		netlink_abi_error();
+
+	return nld;
+}
+
+static int netlink_events_dev_cb(const struct nlmsghdr *nlh, int type,
+				 struct netlink_mon_handler *monh)
+{
+	struct nftnl_device *nld = netlink_device_alloc(nlh);
+	const char *cmd, *obj;
+	uint32_t objattr;
+	int32_t family;
+
+	if (nftnl_device_is_set(nld, NFTNL_DEVICE_CHAIN)) {
+		objattr = NFTNL_DEVICE_CHAIN;
+		obj = "chain";
+	} else if (nftnl_device_is_set(nld, NFTNL_DEVICE_FLOWTABLE)) {
+		objattr = NFTNL_DEVICE_FLOWTABLE;
+		obj = "flowtable";
+	} else {
+		return MNL_CB_ERROR;
+	}
+
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
+	family = nftnl_device_get_s32(nld, NFTNL_DEVICE_FAMILY);
+
+	switch (monh->format) {
+	case NFTNL_OUTPUT_DEFAULT:
+		nft_mon_print(monh, "%s device %s %s %s %s hook %s { %s }",
+			      cmd, obj, family2str(family),
+			      nftnl_device_get_str(nld, NFTNL_DEVICE_TABLE),
+			      nftnl_device_get_str(nld, objattr),
+			      nftnl_device_get_str(nld, NFTNL_DEVICE_SPEC),
+			      nftnl_device_get_str(nld, NFTNL_DEVICE_NAME));
+		nft_mon_print(monh, "\n");
+		break;
+	case NFTNL_OUTPUT_JSON:
+		monitor_print_device_json(monh, cmd, nld);
+		if (!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
+		break;
+	}
+
+	nftnl_device_free(nld);
+	return MNL_CB_OK;
+}
+
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
 	if (!set_is_anonymous(s->flags))
@@ -921,6 +979,8 @@ static const char *const nftnl_msg_types[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWGEN]	= "NFT_MSG_NEWGEN",
 	[NFT_MSG_NEWOBJ]	= "NFT_MSG_NEWOBJ",
 	[NFT_MSG_DELOBJ]	= "NFT_MSG_DELOBJ",
+	[NFT_MSG_NEWDEV]	= "NFT_MSG_NEWDEV",
+	[NFT_MSG_DELDEV]	= "NFT_MSG_DELDEV",
 };
 
 static const char *nftnl_msgtype2str(uint16_t type)
@@ -1026,6 +1086,10 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_NEWGEN:
 		ret = netlink_events_newgen_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWDEV:
+	case NFT_MSG_DELDEV:
+		ret = netlink_events_dev_cb(nlh, type, monh);
+		break;
 	}
 
 	return ret;
diff --git a/tests/monitor/testcases/chain-netdev.t b/tests/monitor/testcases/chain-netdev.t
new file mode 100644
index 0000000000000..3c004af0cd855
--- /dev/null
+++ b/tests/monitor/testcases/chain-netdev.t
@@ -0,0 +1,66 @@
+# setup first
+I add table netdev t
+I add chain netdev t c { type filter hook ingress devices = { lo } priority 0; policy accept; }
+O -
+J {"add": {"table": {"family": "netdev", "name": "t", "handle": 0}}}
+J {"add": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": "lo", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I delete chain netdev t c
+O delete chain netdev t c { type filter hook ingress devices = { lo } priority 0; policy accept; }
+J {"delete": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": "lo", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I add chain netdev t c { type filter hook ingress devices = { eth1337, lo } priority 0; policy accept; }
+O -
+J {"add": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": ["eth1337", "lo"], "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+@ ip link add eth1337 type dummy
+O add device chain netdev t c hook eth1337 { eth1337 }
+J {"add": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "eth1337", "spec": "eth1337"}}}
+
+@ ip link del eth1337
+O delete device chain netdev t c hook eth1337 { eth1337 }
+J {"delete": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "eth1337", "spec": "eth1337"}}}
+
+I delete chain netdev t c
+O delete chain netdev t c { type filter hook ingress devices = { eth1337, lo } priority 0; policy accept; }
+J {"delete": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": ["eth1337", "lo"], "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I add chain netdev t c { type filter hook ingress devices = { wild* } priority 0; }
+@ ip link add wild23 type dummy
+@ ip link add wild42 type dummy
+@ ip link del wild23
+I delete chain netdev t c
+O add chain netdev t c { type filter hook ingress devices = { wild* } priority 0; policy accept; }
+O add device chain netdev t c hook wild* { wild23 }
+O add device chain netdev t c hook wild* { wild42 }
+O delete device chain netdev t c hook wild* { wild23 }
+O delete chain netdev t c { type filter hook ingress devices = { wild* } priority 0; policy accept; }
+J {"add": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": "wild*", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+J {"add": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "wild23", "spec": "wild*"}}}
+J {"add": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "wild42", "spec": "wild*"}}}
+J {"delete": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "wild23", "spec": "wild*"}}}
+J {"delete": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": "wild*", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I add chain netdev t c { type filter hook ingress devices = { wild* } priority 0; }
+I add chain netdev t c2 { type filter hook ingress devices = { wald* } priority 0; }
+@ ip link add wild23 type dummy
+@ ip link set wild42 name wald42
+@ ip link del wild23
+I delete chain netdev t c
+I delete chain netdev t c2
+O add chain netdev t c { type filter hook ingress devices = { wild* } priority 0; policy accept; }
+O add chain netdev t c2 { type filter hook ingress devices = { wald* } priority 0; policy accept; }
+O add device chain netdev t c hook wild* { wild23 }
+O add device chain netdev t c2 hook wald* { wald42 }
+O delete device chain netdev t c hook wild* { wald42 }
+O delete device chain netdev t c hook wild* { wild23 }
+O delete chain netdev t c { type filter hook ingress devices = { wild* } priority 0; policy accept; }
+O delete chain netdev t c2 { type filter hook ingress devices = { wald* } priority 0; policy accept; }
+J {"add": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": "wild*", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+J {"add": {"chain": {"family": "netdev", "table": "t", "name": "c2", "handle": 0, "dev": "wald*", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+J {"add": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "wild23", "spec": "wild*"}}}
+J {"add": {"device": {"family": "netdev", "table": "t", "chain": "c2", "name": "wald42", "spec": "wald*"}}}
+J {"delete": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "wald42", "spec": "wild*"}}}
+J {"delete": {"device": {"family": "netdev", "table": "t", "chain": "c", "name": "wild23", "spec": "wild*"}}}
+J {"delete": {"chain": {"family": "netdev", "table": "t", "name": "c", "handle": 0, "dev": "wild*", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+J {"delete": {"chain": {"family": "netdev", "table": "t", "name": "c2", "handle": 0, "dev": "wald*", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
diff --git a/tests/monitor/testcases/flowtable-simple.t b/tests/monitor/testcases/flowtable-simple.t
index df8eccbd91e0a..113b15f20d1dc 100644
--- a/tests/monitor/testcases/flowtable-simple.t
+++ b/tests/monitor/testcases/flowtable-simple.t
@@ -8,3 +8,59 @@ J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0
 I delete flowtable ip t ft
 O -
 J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "lo"}}}
+
+I add flowtable ip t ft { hook ingress priority 0; devices = { eth1337, lo }; }
+O -
+J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": ["eth1337", "lo"]}}}
+
+@ ip link add eth1337 type dummy
+O add device flowtable ip t ft hook eth1337 { eth1337 }
+J {"add": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "eth1337", "spec": "eth1337"}}}
+
+@ ip link del eth1337
+O delete device flowtable ip t ft hook eth1337 { eth1337 }
+J {"delete": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "eth1337", "spec": "eth1337"}}}
+
+I delete flowtable ip t ft
+O -
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": ["eth1337", "lo"]}}}
+
+I add flowtable ip t ft { hook ingress priority 0; devices = { wild* }; }
+@ ip link add wild23 type dummy
+@ ip link add wild42 type dummy
+@ ip link del wild23
+I delete flowtable ip t ft
+O add flowtable ip t ft { hook ingress priority 0; devices = { wild* }; }
+O add device flowtable ip t ft hook wild* { wild23 }
+O add device flowtable ip t ft hook wild* { wild42 }
+O delete device flowtable ip t ft hook wild* { wild23 }
+O delete flowtable ip t ft
+J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "wild*"}}}
+J {"add": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "wild23", "spec": "wild*"}}}
+J {"add": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "wild42", "spec": "wild*"}}}
+J {"delete": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "wild23", "spec": "wild*"}}}
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "wild*"}}}
+
+I add flowtable ip t ft { hook ingress priority 0; devices = { wild* }; }
+I add flowtable ip t ft2 { hook ingress priority 0; devices = { wald* }; }
+@ ip link add wild23 type dummy
+@ ip link set wild42 name wald42
+@ ip link del wild23
+I delete flowtable ip t ft
+I delete flowtable ip t ft2
+O add flowtable ip t ft { hook ingress priority 0; devices = { wild* }; }
+O add flowtable ip t ft2 { hook ingress priority 0; devices = { wald* }; }
+O add device flowtable ip t ft hook wild* { wild23 }
+O add device flowtable ip t ft2 hook wald* { wald42 }
+O delete device flowtable ip t ft hook wild* { wald42 }
+O delete device flowtable ip t ft hook wild* { wild23 }
+O delete flowtable ip t ft
+O delete flowtable ip t ft2
+J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "wild*"}}}
+J {"add": {"flowtable": {"family": "ip", "name": "ft2", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "wald*"}}}
+J {"add": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "wild23", "spec": "wild*"}}}
+J {"add": {"device": {"family": "ip", "table": "t", "flowtable": "ft2", "name": "wald42", "spec": "wald*"}}}
+J {"delete": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "wald42", "spec": "wild*"}}}
+J {"delete": {"device": {"family": "ip", "table": "t", "flowtable": "ft", "name": "wild23", "spec": "wild*"}}}
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "wild*"}}}
+J {"delete": {"flowtable": {"family": "ip", "name": "ft2", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "wald*"}}}
-- 
2.43.0

