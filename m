Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9220314B83
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758824853; cv=none; b=cBks7JtGusi0J4kRG4Irf9fSFcnjrba8ZOF7fgL/w60lkn26Qx5sGZeg4wCyBIsbCmXDNh15JHUeStDgjcV9hH+bnMhgqcI5/ElF+kbZU/0e/Txdh78XFKDAdnqPC3MwBG14FQGHclB7xFZx5/MYpK1iWuMrU1ad5XUvuVNgM2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758824853; c=relaxed/simple;
	bh=U1icJ8SStzg8BpV3aw21zI1+M0F8SbGOegKFRq1Yb5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAnMXbSokNL4D3F5KHmGz0s1VwkoA0x/DNjOAqxR6qiTTtkS3dLpVTCrUEPm/Xaw97zwuL2OuJ5rDp5zf5ktxlWVvYyLXvvxq5QcBrwp/IpVb0Semnmy3t5U1s7jHgYAQ62tZuUMM0ZRhuVknOvno45fdej0aeyVS77mWNkkD+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuG2j4ow; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuG2j4ow"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b00a9989633so211195566b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758824850; x=1759429650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VY6AelGWkjM0TaRpoo3FDUkMxghUPtK6XlqdIyRxT5Y=;
        b=SuG2j4ow73j12mC2/lLUuBDVEbkCYeUnYRmIGSncZK9GzAm9mFJ1Y1rc5j8X2TjzFL
         O4Pf6fKmORgBa4+ui45MfXH3m/plR80/XVsTjzNiZPzq0cUAkg4fvaAHlmX6Whfa/miM
         cgn15pzkjcLIed/9hJtWiFnXmk836qrPVfq12bsi5V+gQFxhIhJxHTjTnYTcAK8UFVet
         oiJfB8mmbs7XFNaUYXuedGa+CyW41tLmKHRtqUV6XYR3nevs+oOqQZKHltjYdRJeOJRo
         GFPrMD67X2Twf2BekpRZrosBbJlKaS2Cm0jXZXiPOlPpZfI3hAz0YFvjlucXVnizPO6y
         1zqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758824850; x=1759429650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VY6AelGWkjM0TaRpoo3FDUkMxghUPtK6XlqdIyRxT5Y=;
        b=WYC5RuD/J4+OxNOfqNf2+p3mmBrDNbtVSj0DmvNYC9liOvclxSJuMPleishlCoXL+j
         4gZuhm1AvVu/jJOGJbUAjfpJvObsigu7B9FYUx9/Gexyxka+YU4X5z/leB2riAesjU1H
         FxTVKNRi9IoGyx1Nr21N7skl7bymX2gSduld0rovJue7Cd3kriN6p8PlM/g717NBIvS6
         xz8jg+SAEF7MwBWDQxWtCQXN0Ngjfdacx5jpOUOmtf1E9xQk9/M9cDJBTzcEsvufXWwl
         VZ4J/UMzHXIU90MNTxZFNovIpXnFiz3s5NGyZNHWEXoEVYtiDEIogR+bBA2PPPwELF7d
         Xc9Q==
X-Gm-Message-State: AOJu0Yx1frhD/5g4YZcQ5T+dUuy5Jdf9p8f1o7eiGCe9P/RIpYcsWy/I
	8ZoGHzAIeAJ9rgyXMTsMIizNlxMrXe7XFAk93/boEypxcR2/k1ynokl4wHdefg==
X-Gm-Gg: ASbGncuKwFutFW4iQGhvbYnqNJTjCst9Q0uP3d9gLjIcKesx75HGLge3+OYOe6N2sAz
	jwZKcDDCEE1mfyhvU/KWyL2/KZSanWARSElGDIB0yBhCs3NaVDZcMGrRKHt3svkqeDpc22jl348
	Mcvvggf+gugat1SwyDD+9WYT0+GUyqdH5h0YSk3QBqAv2Kz0+qbD19dn/VnZ0Qw3KvVaQjo5Z9X
	geZHuZ9QD0bWNZz1jxLKIbag3SPeQqki0q/V8OdlQVbfEEchbCcsF4i3n7GVDFxiBpi7a0XJ/m7
	yDwiA+9XP5iAZrRht19BzgWFWvmIZvSjX1lSzDRwooFyHyD7/AbrPitOpPH5al23aDAQtJM0uD3
	bPlQhYAe+U8VzIKVLC5rgKGd45KPCps5l8gQGn2Ulce62IbTI2lPQdp+ERbxsPjOym7mRvQUZCN
	umczkgG/dRmK2WL5oNwg==
X-Google-Smtp-Source: AGHT+IHRmMltB68OY5T7N4tzUAaJGjBvF3u+JX4hLOIH9IjU8kfQ2nQNB23tFmburZMt166S/sVbQw==
X-Received: by 2002:a17:907:1c94:b0:afe:ef8a:a48b with SMTP id a640c23a62f3a-b354e41468amr399650966b.30.1758824849742;
        Thu, 25 Sep 2025 11:27:29 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3650969sm1572902a12.19.2025.09.25.11.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:27:29 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v4 nf-next 2/2] netfilter: nf_flow_table_core: teardown direct xmit when destination changed
Date: Thu, 25 Sep 2025 20:26:23 +0200
Message-ID: <20250925182623.114045-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250925182623.114045-1-ericwouds@gmail.com>
References: <20250925182623.114045-1-ericwouds@gmail.com>
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
 net/netfilter/nf_flow_table_core.c | 88 ++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 992958db4a19..e906f93f4abb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/switchdev.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -745,6 +746,86 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+struct flow_cleanup_data {
+	int ifindex;
+	u16 vid;
+	char addr[ETH_ALEN];
+	bool found;
+};
+
+struct flow_switchdev_event_work {
+	struct work_struct work;
+	struct flow_cleanup_data cud;
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
+static void nf_flow_table_switchdev_event_work(struct work_struct *work)
+{
+	struct flow_switchdev_event_work *switchdev_work =
+		container_of(work, struct flow_switchdev_event_work, work);
+	struct nf_flowtable *flowtable;
+
+	mutex_lock(&flowtable_lock);
+
+	list_for_each_entry(flowtable, &flowtables, list) {
+		switchdev_work->cud.found = false;
+		nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup_addr,
+				      &switchdev_work->cud);
+		if (switchdev_work->cud.found)
+			mod_delayed_work(system_power_efficient_wq,
+					 &flowtable->gc_work, 0);
+	}
+
+	mutex_unlock(&flowtable_lock);
+
+	kfree(switchdev_work);
+}
+
+static int nf_flow_table_switchdev_event(struct notifier_block *unused,
+					 unsigned long event, void *ptr)
+{
+	struct flow_switchdev_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+
+	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE)
+		return NOTIFY_DONE;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (WARN_ON(!switchdev_work))
+		return NOTIFY_BAD;
+
+	INIT_WORK(&switchdev_work->work, nf_flow_table_switchdev_event_work);
+	fdb_info = ptr;
+	switchdev_work->cud.ifindex = fdb_info->info.dev->ifindex;
+	switchdev_work->cud.vid = fdb_info->vid;
+	ether_addr_copy(switchdev_work->cud.addr, fdb_info->addr);
+
+	queue_work(system_long_wq, &switchdev_work->work);
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
@@ -818,6 +899,10 @@ static int __init nf_flow_table_module_init(void)
 	if (ret)
 		goto out_offload;
 
+	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
+	if (ret < 0)
+		goto out_sw_noti;
+
 	ret = nf_flow_register_bpf();
 	if (ret)
 		goto out_bpf;
@@ -825,6 +910,8 @@ static int __init nf_flow_table_module_init(void)
 	return 0;
 
 out_bpf:
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
+out_sw_noti:
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
@@ -833,6 +920,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.50.0

