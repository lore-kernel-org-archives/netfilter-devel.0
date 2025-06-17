Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2311E8322;
	Tue, 17 Jun 2025 07:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143626; cv=none; b=PXvfME9BJgtjQCvOc0lrdpQSDk1tc/jKYN7H+X6f1PVOisIdx9AoCeI6h6qCTH/ZDv8LpqeBe4Ta8aGG2TG624BddICdpip1FixuZ7wSO6pakdxLQmFOpFZnZlpyLr+ubZ/8fBeuCKc4kXKSHlpJX4Zu22itpyP1Lz/mZV3mO3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143626; c=relaxed/simple;
	bh=GgIVo1nD4TG0O4tTWjSY+fcqitMiaAubqSw6YfqQ2j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsmpEdZMJdO4nspDfdqt93HdilV2MT3pAhh3lfRiCq8vQmXOwUwPKXNLFHLQWMEeluRbAauZ64DED1IbkRg2NSfcLh1a7lypMCk5UDZ81gcWv+h8qqL9KRWzLHNWou0G0Jnom1OQhsSo3rfHI9a1idALVYBoldXT5z6IVQskJwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MbZbusxn; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MbZbusxn"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad572ba1347so844353666b.1;
        Tue, 17 Jun 2025 00:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143623; x=1750748423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJRORfRXkkUtMsnwXh6nyj2XyvWjwStNze15fucEUvY=;
        b=MbZbusxnbIkzcWDvXdcFID9zpn6wY2lGQFo/Wro8qdX8xPcGxJ+SK73LgD9LdL9haJ
         EOT/T3RmTMH9o3xCIthAJ8VI1sTnKw5+IlVJ6QmNNXH75pElttTG+viN0LLkl6TFJEOu
         81VU8b8+08yf6iYwjYyTKGkmEPTf/FW0cgcaUqspkYOQecr88LvYLI4Rw9g30P89Kp3B
         ioRcueE0u8dz7fNvO3xgZWvftQ2C652kWMY9gcJ2BuCZU+jG9JsVXvGbbO6xUKAFJEA+
         TdcAzCwszI/gtTe8HphFGSrnbATERUEBCSNJOcXjaXfIIEy4oWGLYDrd+DDRone4/EHn
         dntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143623; x=1750748423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJRORfRXkkUtMsnwXh6nyj2XyvWjwStNze15fucEUvY=;
        b=jPnfXXIFqBi3HoeveEFGNntKzRnyz0DTjDkfi1ZWWU/MApfEv176ryyieV2TBuM4C5
         2elCrTxs2XZ5CAjZX2w5roYYUvN7Gc08/Ap1FNt1m3kjC4FkYPaWT1jKdMClR/bbKs2h
         7sCSnB9qH+fCZ6eN4uGFwiyMlszShdmtKjFSs2chzyQiu+W8rWoN+XDj0JIaMWu5Ts8c
         typU7cp+5qG/e47SCaVoCKAFbAfmPp1BdqrFtlgjrnyLnYs1E3YN8iEFhb7aBb/5j5WC
         HPXFAQfbGOOSd/pkX/1hGt6IDDahoOLMe/g2TEZHmbKJT6VaCBzO53VXgO4SO0Us2kh2
         h+4w==
X-Forwarded-Encrypted: i=1; AJvYcCUhvWn6w3Vqk3w0FZAboie8Oyd+aIf0QOzf1v4ehI0whYLZCub6MqLjVPxY+8LRUkwSkBpKcv4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yycj61OIw3Uvvo5OLXpn4hhieTnUWvbaI54nP842fk4Res+Bip/
	1wpGOa+W+4rA6bXB5Mv6ZQ7k7uKz+r0BS28Jt4wqbciTMyZwdXWUXOVg
X-Gm-Gg: ASbGncsnKHFCNXWrV8g+ex/Nom4O9uP/Ezx75orSrGWQjNuJenx70JqowqTdSrspUH1
	fNzxZS6g5WkVHAyAN61uqO8LyOhv59Buiu3MAfhTF8UtJeZl8SUvPsP2QNdIPqIvaY9zBd2MUTs
	ZRwrN3Y8yIrU4mPpNh3FPN/ZI/6RBXg8Nn2yIRZoNZvbTT/Uoi0Jfj8e7T5M+gGP5zmiaphcZvL
	Dtagu8zoI41ecymPpQ8+vnLbHF8CLsIB2hhvMcftGeUY2h0bQBbxjOHZeK18Bfiz/J4WHwdbEcf
	pthz3/++ECZNvPjtkUO4EGFyP41DtV48PQlSLVTfxThVG5puVmsSLPZ1181FZDLqyWMJFuFDPz/
	JPdTWzIpqNv3gZbGWDDwUd4TuKkjJi+pvHr5d7NBbl6rmOjQD4e4N+QwkswKSLK2HfotZlrlYfU
	g+tL6s
X-Google-Smtp-Source: AGHT+IHm6iZ9iPrS7J4tmuC7YMkuzIo2n/wkI+M5X7ooz8/kP6BQ7sZGkqBFm1o9dBrjViHPXVWqGA==
X-Received: by 2002:a17:907:2d06:b0:ade:433c:6405 with SMTP id a640c23a62f3a-adfad354a32mr1213579066b.21.1750143622504;
        Tue, 17 Jun 2025 00:00:22 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8158d4dsm800843066b.28.2025.06.17.00.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 00:00:22 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v3 nf-next 2/3] netfilter: nf_flow_table_core: teardown direct xmit when destination changed
Date: Tue, 17 Jun 2025 09:00:06 +0200
Message-ID: <20250617070007.23812-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250617070007.23812-1-ericwouds@gmail.com>
References: <20250617070007.23812-1-ericwouds@gmail.com>
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
index 992958db4a19..61f03907d103 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/switchdev.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -745,6 +746,63 @@ void nf_flow_table_cleanup(struct net_device *dev)
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
+static struct notifier_block nf_flow_table_switchdev_nb __read_mostly = {
+	.notifier_call = nf_flow_table_switchdev_event,
+};
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -818,6 +876,10 @@ static int __init nf_flow_table_module_init(void)
 	if (ret)
 		goto out_offload;
 
+	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
+	if (ret < 0)
+		goto out_sw_noti;
+
 	ret = nf_flow_register_bpf();
 	if (ret)
 		goto out_bpf;
@@ -825,6 +887,8 @@ static int __init nf_flow_table_module_init(void)
 	return 0;
 
 out_bpf:
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
+out_sw_noti:
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
@@ -833,6 +897,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.47.1

