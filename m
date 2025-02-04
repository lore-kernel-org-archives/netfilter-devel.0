Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146B921A457;
	Tue,  4 Feb 2025 19:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698674; cv=none; b=dsin714GEELPV0lxFrQT+rC9nosXgfNG+ElfUJ+m5ByIdGCscJiVW2azxZKYn0W9233PQ7ZVSaU/QH5LJmhaswrTLqRVPz3BzrhiQ3G2yedFIw1K7+g1p01qen+WFp8BkGV1FjDY6C9Ypkydv6cGdtoJlNgrmdyGIlG9lYiuoHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698674; c=relaxed/simple;
	bh=Po6iP+veHPnDAB/Njs0v2uZlGnJXDPs2y4VV8saSxa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGRf8ckGRyby0GvpAHQOnzC9C4KhGW1hPrQMWl/asyjryWYCielBry1LiKys8TpR5w0+9nVGNhv0gtffv3Ig7e9aMBQRtYvYiDkp8+9VntL30pe9u/CALlMzHibHSaLZd/RL/qbUZaPulfBCOl03cezCUumTZP5Y6R7ZsfXzcl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z2OHfXgU; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z2OHfXgU"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3dce16a3dso234660a12.1;
        Tue, 04 Feb 2025 11:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698671; x=1739303471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHOmPw1VaRGY99fZ7k7Bw2a6YnjJYPVBwSJBHZJC01Y=;
        b=Z2OHfXgUPeQBcS0CLS3Z1knmQ28jdSq+XD+uUKyPA1kV6dyRrxJHUzRQp/ukZ1keXy
         jvq/OqDpZBW2HXT5XJaQmTFPC33tZ/ijKxqUFgUTQvXQ10XSVQpwwxovkh4KYLdoPOns
         Cc7VhytstArqtdwaRIeojTj+OVjR9ekkk9JUbKRMCxuk2lmTMeic3dsHFp5yAF998DtB
         EJl8fSufMFDR9fLS3C5AqwQapS9I4jdk6L3qdsvG8Id0+juyl5FFD3oMpSx3Xvd7guwN
         kyn3iE3kiksVzh/ffshVgkp2j68AouWOY8NCQD1/kVGVles2/nmDse3qYFM9GlHnG8jo
         cFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698671; x=1739303471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHOmPw1VaRGY99fZ7k7Bw2a6YnjJYPVBwSJBHZJC01Y=;
        b=usaHBSAGvF39zPQqKjdj28ajeOyGi8YNrd5r8e+GQTfMw/VX3m7/VTm+t5N6h+UVi9
         3N7x1WxbVYTcmGYuPxjvOrmHrJyvHCO10i6Gnos82hK7hUwtfaJCthlgFJATpKQA5AIh
         oBaZdyVTCc2GBrX1CT6puCQPb0MdyAS4/w49S+QkStoT+0C+18bIcWORqWpaEdBzXz6B
         eJiGGmsRqxWytuSAOADF0bplSS+WElI5RmQmxWwzviQqRJq4VJGCOqXNUmLmo/Ntc7iR
         jaNbzvAxoxoqZpbOTWomW4kfuvRF8t7sqKXjdRvM/fhNSKH1PRhACymBSLV0GnBW7aIn
         Nk4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVjXqSfXt058no0s+5ttNgSNylY6UtgD4jYJUjv3sw4gL0gQjz6EPzqt9Fw0xmpTQ9fsTR2ivpD2/Nliks=@vger.kernel.org, AJvYcCX06p9B5oLumJWJYDtfDG26xirzSP3QbdW2GQ/ZK5IO9UvLXjrkRE3rnp/55zYWvoGYtngv16Dn@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy/U6d4OUvv7nmd5iCHyu9b01PSOILrZuvrlDwzQZDWBc7SZ9t
	avOvURAojhSVpNhLQwr0njn+K138nqXAvnscGjehu9oWCEY0h5WD
X-Gm-Gg: ASbGncvON1jThH1Ur5kbqUpsQP+ZTXRElfGGnJMXvOOb6U8DxyyYgUY2qFsjtJTPFn5
	T71ZKsJIQ96cBoQsPXaSs+jF6KMxznub7dhJRnwfW7wRkx2G2s/1eyLMV4uH0GGeEy2FckQ4wrX
	dNqTm2p/v/e2D+pGeN+qbOKEfiXLKZgsKB0ifjTHVExlIrm6NLXpb+fmxWEWBr+XB7B+wQ7BT35
	9wBm2/v5UiwXkKnFJUPbhrf20Oh9nIiEJ9mLMdaevi+KKdYx29n5uHoVCBUyqbx85GMyGHC/tjP
	QP/LfZGBKY5cD/VpBmRiWRtLxNBunzNFg6PQw7Gq2NPf7welPQU3aml/MRriEx/xzjHk/4MnYod
	RxS4bVq9y3mbOAPYhg1b+Mn7A4UDp/R2O
X-Google-Smtp-Source: AGHT+IHlI2P8Jrxi2Qd8b5riJStjB26DGmTpR8pb+RAAGTQrIdMsD2OqcuhAjadW2LWJI+JgvGHJOA==
X-Received: by 2002:a05:6402:4605:b0:5db:7353:2b5c with SMTP id 4fb4d7f45d1cf-5dcdc095742mr254549a12.11.1738698671315;
        Tue, 04 Feb 2025 11:51:11 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc724d9de2sm10074894a12.81.2025.02.04.11.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:51:10 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [RFC PATCH v1 net-next 2/3] netfilter: nf_flow_table_core: teardown direct xmit when destination changed
Date: Tue,  4 Feb 2025 20:50:29 +0100
Message-ID: <20250204195030.46765-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204195030.46765-1-ericwouds@gmail.com>
References: <20250204195030.46765-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
used to create the tuple. In case of roaming at layer 2 level, for example
802.11r, the destination device is changed in the fdb. The destination
device of a direct transmitting tuple is no longer valid and traffic is
send to the wrong destination. Also the hardware offloaded fastpath is not
valid anymore.

In case of roaming, a switchdev notification is send to delete the old fdb
entry. Upon receiving this notification, mark all direct transmitting flows
with the same ifindex, vid and hardware address as the fdb entry to be
teared down. The hardware offloaded fastpath is still in effect, so
minimize the delay of the work queue by setting the delay to zero.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 65 ++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index bcf9435638e2..f7a364492dab 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/switchdev.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -742,6 +743,63 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+struct flow_cleanup_data {
+	const unsigned char *addr;
+	int ifindex;
+	u16 vid;
+	bool found;
+};
+
+static void nf_flow_table_do_cleanup_addr(struct nf_flowtable *flow_table,
+					  struct flow_offload *flow, void *data)
+{
+	struct flow_cleanup_data *cud = data;
+
+	if ((flow->tuplehash[0].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
+	     flow->tuplehash[0].tuple.out.ifidx == cud->ifindex &&
+	     flow->tuplehash[0].tuple.out.bridge_vid == cud->vid &&
+	     ether_addr_equal(flow->tuplehash[0].tuple.out.h_dest, cud->addr)) ||
+	    (flow->tuplehash[1].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
+	     flow->tuplehash[1].tuple.out.ifidx == cud->ifindex &&
+	     flow->tuplehash[1].tuple.out.bridge_vid == cud->vid &&
+	     ether_addr_equal(flow->tuplehash[1].tuple.out.h_dest, cud->addr))) {
+		flow_offload_teardown(flow);
+		cud->found = true;
+	}
+}
+
+static int nf_flow_table_switchdev_event(struct notifier_block *unused,
+					 unsigned long event, void *ptr)
+{
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct nf_flowtable *flowtable;
+	struct flow_cleanup_data cud;
+
+	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE)
+		return NOTIFY_DONE;
+
+	fdb_info = ptr;
+	cud.addr = fdb_info->addr;
+	cud.vid = fdb_info->vid;
+	cud.ifindex = fdb_info->info.dev->ifindex;
+
+	mutex_lock(&flowtable_lock);
+	list_for_each_entry(flowtable, &flowtables, list) {
+		cud.found = false;
+		nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup_addr, &cud);
+		if (cud.found)
+			mod_delayed_work(system_power_efficient_wq,
+					 &flowtable->gc_work, 0);
+	}
+	mutex_unlock(&flowtable_lock);
+
+	return NOTIFY_DONE;
+}
+
+struct notifier_block nf_flow_table_switchdev_nb __read_mostly = {
+	.notifier_call = nf_flow_table_switchdev_event,
+};
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -815,6 +873,10 @@ static int __init nf_flow_table_module_init(void)
 	if (ret)
 		goto out_offload;
 
+	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
+	if (ret < 0)
+		goto out_sw_noti;
+
 	ret = nf_flow_register_bpf();
 	if (ret)
 		goto out_bpf;
@@ -822,6 +884,8 @@ static int __init nf_flow_table_module_init(void)
 	return 0;
 
 out_bpf:
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
+out_sw_noti:
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
@@ -830,6 +894,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.47.1

