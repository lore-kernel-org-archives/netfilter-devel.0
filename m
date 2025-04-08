Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E303F2236F3;
	Tue,  8 Apr 2025 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122547; cv=none; b=loGax9zSH4zmM9pdz/tIIbbruKiSpBLhdO/dQFPwnqSXO69KrMFCxsgWjFY5YBr6TmKZzuyUgpM0k7dqUPHLHGlZzCSzn8rr+PZteWdmZjxVFYoCDABaPrsA6UTwQG0+KDcTXAbonp90Yusn4M7861hdJZRH9ul2wu0787vUrSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122547; c=relaxed/simple;
	bh=JBpLJGuxU07j5NJjZdH6O3GPhLESu77ZgquelvdzfUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzNZXgd2MKiPF85ZilWGGZCBqpiGjVtZtNzEubngTWnbLjD/DdVZNVK2Ww9rBgkuZM2RY2nJPYeKucUhhivK6WuCPW6mIZu8Fjb7J5VSnU1cNHJNg/a1C5VUlCmDFkgwPiWaGTBttSINA9DAdgyyBDypjfb1YxnEg3bd02b4Wfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0fIsUZ5; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0fIsUZ5"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac34257295dso1140113066b.2;
        Tue, 08 Apr 2025 07:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122544; x=1744727344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4J1csOCax1zfAj9jzQrD/5+wocmkYHv0msjeS3hJe0=;
        b=K0fIsUZ58yuUz2ZaJSZAOFdgqAMpC2onoLhsksRslnq77EcF/F45AwibPkg4wD1A0u
         9QCXdyWwQxB3mFg0vijyqb38p6qX6fFiH3XFiI5h2MYyL5x2Jjmrka3T8uh8lkUGnm4W
         y7ebJedC3dVDXL6wctvuVbT2Yqzm5E0kHTeGPjWzXLwsBrTIsoyrB/OiP2vjH/WqgSGZ
         qEEmfoc/1Im+YH0h1rfBZnzfgC+NUhC5/JptvuCRaiDkxLzdXYZKhgDSVjpA3/GWpnFM
         w+q98YYKXfoHINT0Hy+sA1z70HsJ4FaCRXYWsjiWan1mWMqgEQmgv8lDv9jVb6a2acqW
         w+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122544; x=1744727344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b4J1csOCax1zfAj9jzQrD/5+wocmkYHv0msjeS3hJe0=;
        b=de3TSjK6V7LhngSd9pFVYUECctRwKta3s52/Y0F6PttfgyUM84vo0i1SfPx7KM2QWD
         AIznubnGZOKAaqJkdWcWw3IIU9uFI1qKB4GiWKv2D5rLnBaHghrRpLYRxtPPuE/B5YVc
         Qin2z5G5CTvqjH87E7/RXiQOcufb4Tre4O7DlCrotH2tZ8jUkjE7UUtnpwT/nIc3bqEm
         xWiDtYHEyeC/9fn+ztRBAjGH0TG1XyEuxWY/X0mDKqadH1FQFxgk0d2TucEkpCR7kSaP
         AOieHZp9kyiPLZUI6lgYQ3fMDZH1lKetT5BCoU1tDGtC0Vj2yACk7gik6NCnGEHFcPRM
         VUaw==
X-Forwarded-Encrypted: i=1; AJvYcCV6mBwi1sJwxdK1AGKDJ1DTb7XdteZXlh1d/Y1u7M7abJcEN8rtdlzNKg7033PJfkpGIFH5jcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNtudJnD6HbmojKikBa44WixLasCgXHhVNuZFfMiNDOQlgvEOH
	QbIu/wkXiZLoyZYVgsE/Pv47q2hQ8+RzHaur9hrusq6ga20fmNiC
X-Gm-Gg: ASbGncu5N7UUtSRQszDFoNjO+yY80rT5dIQzH8KzAixVKL/OU8DTXI4MjyJHcyOqAdG
	P9eY75uG9EeJItX6dDpzqHkWPozi59j2geiLiMMcvHtpv/08t9xuSEBdIrszQ0umlrEtagsu1uL
	AJGZ3fj+898KDHG/bHjhdEphaCiNFsLug5qn5OA3TKI5P5nh6jSwg4Ao+qOg86WtPqJExCkjb9N
	NcJY9Xehj9jbsGS5ohiZG0X9G+T1P2Zxurqah7R6ryxYViCY+7k7Fv8+W4WqKY9u0IElngAA8V/
	UVDjffDRNFO5DVDHR/G4R0uOV+FMRNsr79XJDVDXNmNE34dxe3wM/qlqgGbKG8UriBZXF5ws1lr
	F8CRs5J13cUCBFzeBkARTEHL7g1o6CrC43SCsySQ3CVF4ADq2L8VSPnUiB+S5XmE=
X-Google-Smtp-Source: AGHT+IEgWOMtHjJUwIOqOHllsSQd636c0mzHfpdazhx6qCFHx+FHk/JedEb1lPwfk3zoA0lPKN3ZvA==
X-Received: by 2002:a17:907:1c25:b0:ac7:150e:8013 with SMTP id a640c23a62f3a-ac7d6d03dd3mr1437939766b.15.1744122544104;
        Tue, 08 Apr 2025 07:29:04 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01c2c13sm910586466b.182.2025.04.08.07.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:29:02 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v2 nf-next 2/3] netfilter: nf_flow_table_core: teardown direct xmit when destination changed
Date: Tue,  8 Apr 2025 16:28:47 +0200
Message-ID: <20250408142848.96281-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142848.96281-1-ericwouds@gmail.com>
References: <20250408142848.96281-1-ericwouds@gmail.com>
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
index f6a30fc14fec..d687f3029fbd 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/switchdev.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -743,6 +744,63 @@ void nf_flow_table_cleanup(struct net_device *dev)
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
@@ -816,6 +874,10 @@ static int __init nf_flow_table_module_init(void)
 	if (ret)
 		goto out_offload;
 
+	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
+	if (ret < 0)
+		goto out_sw_noti;
+
 	ret = nf_flow_register_bpf();
 	if (ret)
 		goto out_bpf;
@@ -823,6 +885,8 @@ static int __init nf_flow_table_module_init(void)
 	return 0;
 
 out_bpf:
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
+out_sw_noti:
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
@@ -831,6 +895,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.47.1

