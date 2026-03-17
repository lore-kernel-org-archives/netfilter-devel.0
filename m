Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BF837418F
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773791354; cv=none; b=HkB0OxMlUNm89s5+Mf+We9x0zErs7LEk/6yYCa1l+0mGhOMNpIHvjAkPr3EDI/qsBvG11K/clZxKB/DYoIkIOFsYQ+7QxUTUE3MzWMErSfvQXgyif81XMQWqcLDFo6phXS9pCNgzLdY7+Y3vs/Yw2C5GYGJLiqjwKsAv3qxImlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773791354; c=relaxed/simple;
	bh=mhZLdgPv0AOrvzsAowsgsKql1IibQ/eZ9KKbTpXInPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7WrPc79L1AGucrgIZNcPFQgPYIYVfAzZtSxvcPD14WNfrIwHPDmpMYiYV31KOBuYuc+W27EPOOHzMUvBhwKx3wNSc39+NSsx7mo/YGA/oqqi3VAchObbGU3pme3tuEN7e0PeSrTze2lHdklwAqqicy0sgJBojWJFLkg4KzYcus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TbG97JL5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TbG97JL5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4853f2826f7so65279735e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 16:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773791351; x=1774396151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5xWrxB4QyPLcPNl2mqQEN8z4jAQkq48jEe/HhbLuYs=;
        b=TbG97JL5plFY1XpEECm2fL0szJ7zvK1tMrOnvd9UKg46JvG0idfXKajtaHf84jDA/W
         eIunvO9xlwpE5/XHbj3s6fewHL6Z8jKcCRSaqnYqCkhz4nHCVZ91yiNcspCviLNaDoYY
         mDwOKB3iIR6eVnLcbGjG+2STInI/UzyhbBi4odz9MAOz6aN35bWsAacBgIQ0oGUIOFaa
         TcGdH3L+8Ogmx4JdoDXDN7qSdQgKePGRtMA80DGyzDUIKLD7UCLL8dy08ANk0bT6GfCl
         7wLvxzPL5+2o8k2c6SYUJoV1KFsYsntjADET8hs1uidb51BTuGPNjGe/LAjH8QZmR5Ta
         T/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773791351; x=1774396151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v5xWrxB4QyPLcPNl2mqQEN8z4jAQkq48jEe/HhbLuYs=;
        b=FZ9FoIz8cKof2IMqbSwdM7ECNqkJS8qudJTghBB+5nXSgJN8TBBZLUKrNX2ER5fZv0
         fweGy6sRzN6uiG7pdSxtSOjcTfqjAuvxecz1nv5iaNCnjAptOEsIXgGqr50fvAolVvt3
         LKbwzNDeo/fq47uDEZzrY5Ui+N8UBvQTkAvQvxdEDy0D6uQgkK3aAH+4cjh97AlIoDUM
         +NTx6DJa3DYRKaHBKepKAJZ9TjCelsWQ0uujEZc+FioIewb6RcJiNBc3kK8w5eb0XMS1
         3kHfME02p+XSdI7aNiuOOMkA/rhudtgkPqJoaQIKmk57v+jJCiufzoSCujyDO+ayPY/c
         bqEA==
X-Gm-Message-State: AOJu0YxQiPrvWIHiNVkSd0sEKa0JzDze67Xoj/4UAAXQ/UMaJbrK6MoR
	rXlcCgIQykyAD7ndrVAg2bewgLNZuTCHN/GdWLmYBuH1cPIXWJRoXHs52orXOYbzM0Mlkw==
X-Gm-Gg: ATEYQzxUw4FCPI5zYyChCTLyYWht1kvevAslgS6QBKxvvvM1pvQbfu0HUNEIz6NclNA
	DYut59+vDyv3XXEjLvwKaPhZ14iq9guKJbRoEXIh6AcvRAw59MTE6etg5OAIWaurlBQ7nPX7jNw
	hQR6jcImnS3x9aLg9k6SwpDJQVebWhhlwhCjnrogMuN7glbCXwBEVJB3JfJAhgzY1rTdV32z/aM
	2gaq2sCxHZuiIAojTH66hUE3faXIZUB4HbdMauO3KsF2yPDIhOf/Q0Kf7lEGNjlGTyrsFTUOI+F
	Q0iCHyPAt9q1PQX+4NaaeNK7EZjY90twRt9WEGyK57STmkhFSLCak5f1hL7I0gM9WmwYG7CGT+C
	52kAxTk65wT4LFof9dJHIaI5Oe7707BvjYiuoLyCBO/qG9K4dtgPLn9VHiSprFlwpMgUD4zpIPC
	Cr6/2wQ+fdF6AIkizbHjLO
X-Received: by 2002:a05:6000:2681:b0:439:cb79:ab05 with SMTP id ffacd0b85a97d-43b527c8a0amr1983736f8f.36.1773791351261;
        Tue, 17 Mar 2026 16:49:11 -0700 (PDT)
Received: from azaki-desk1.. ([41.234.201.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b518a3d78sm3279810f8f.34.2026.03.17.16.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 16:49:10 -0700 (PDT)
From: Ahmed Zaki <anzaki@gmail.com>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: flowtable: update netdev stats with HW_OFFLOAD flows
Date: Tue, 17 Mar 2026 17:48:51 -0600
Message-ID: <20260317234851.234466-3-anzaki@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317234851.234466-1-anzaki@gmail.com>
References: <20260317234851.234466-1-anzaki@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SNMP-based network monitoring systems (and maybe other tools) rely on
netdev stats to report the network traffic. We currently do not update
the netdev stats with the offloaded flows stats which creates
discrepancies in the stats with some of these devices inside a bigger
network.

Update the nedev stats with the hardware offloaded flows' stats. The
stats are updated periodically in flow_offload_work_stats() and also
once in flow_offload_work_del() before the flow is deleted. For this,
flow_offload_work_del() had to be moved below flow_offload_tuple_stats()

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 59 ++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b2e4fb6fa011..fb325d4a1131 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -925,13 +925,41 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 	nf_flow_offload_destroy(flow_rule);
 }
 
-static void flow_offload_work_del(struct flow_offload_work *offload)
+static void flow_offload_netdev_update(struct flow_offload_work *offload,
+				       struct flow_stats *stats)
 {
-	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
-		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+	const struct flow_offload_tuple *tuple;
+	struct net_device *indev, *outdev;
+	struct net *net;
+
+	rcu_read_lock();
+	net = read_pnet(&offload->flowtable->net);
+	if (stats[0].pkts) {
+		tuple = &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
+		indev  = dev_get_by_index_rcu(net, tuple->iifidx);
+		if (indev)
+			dev_sw_netstats_rx_add(indev,
+					       stats[0].pkts, stats[0].bytes);
+
+		outdev = dev_get_by_index_rcu(net, tuple->out.ifidx);
+		if (outdev)
+			dev_sw_netstats_tx_add(outdev,
+					       stats[0].pkts, stats[0].bytes);
+	}
+
+	if (stats[1].pkts) {
+		tuple = &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple;
+		indev  = dev_get_by_index_rcu(net, tuple->iifidx);
+		if (indev)
+			dev_sw_netstats_rx_add(indev,
+					       stats[1].pkts, stats[1].bytes);
+
+		outdev = dev_get_by_index_rcu(net, tuple->out.ifidx);
+		if (outdev)
+			dev_sw_netstats_tx_add(outdev,
+					       stats[1].pkts, stats[1].bytes);
+	}
+	rcu_read_unlock();
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -968,6 +996,25 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 				       FLOW_OFFLOAD_DIR_REPLY,
 				       stats[1].pkts, stats[1].bytes);
 	}
+
+	flow_offload_netdev_update(offload, stats);
+}
+
+static void flow_offload_work_del(struct flow_offload_work *offload)
+{
+	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
+
+	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
+					 &stats[1]);
+	flow_offload_netdev_update(offload, stats);
+
+	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_work_handler(struct work_struct *work)
-- 
2.43.0

