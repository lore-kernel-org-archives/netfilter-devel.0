Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC031553A7;
	Sun, 13 Oct 2024 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845745; cv=none; b=RtjUAuhHs56qkhDpaREqUDLzU9UcrpgnS+cTholdsA5MF0NjeigOesYqUYtJ1GGXjq+09gd0L/Kdxhjbg9q7+VHQblVElMT1JatOWLSeCKNjCLsNNineMavQ/cQdJoY/7uuERN8za3kScin7jDUIM9Eco9/NCcPnaf/C53ih00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845745; c=relaxed/simple;
	bh=hGsEEgBwVWVwF5UUBIOEi5WjCie3Q/gi9JKsnhC1X8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMZfOqDFdeak2C1yZJga4DCIrCetLqlXc5LPe88Kqtmnh7KiS9xvEDwrFriwNtjKIpLZCeu1lV/yj9jir2Uo0cSQzS9X2LcZE7+ml+lJCJYbRln/dLJgSNYC3n7OL4Zl7DyMladJiEtEWj8vhw1cZ9knu+cWLqMILd4BjVP6lUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KShNYCxi; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KShNYCxi"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a99b1f43aceso472058266b.0;
        Sun, 13 Oct 2024 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845742; x=1729450542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdMZzUqlItAKYCipC8R7CKRW4bj0To7qOhyuRvVgeD0=;
        b=KShNYCxi188E/nMoggdYbvxF609f9BqVUxYUmHrLbs8lZKRDE5HZUS4Z0g7JMD9bu4
         WTgLzOmm740sZ9yMYPkmwnqJaoJ4f9K+NcAtKWPoAdqTiqiQF6R98IEdXI9gaD1jqeNA
         DntNlNKLd/CW5rhr7WhV+Wz3zC9uE5Xq1OhsE1mbNlgX+FHncZ1DSs3D0gmsx9oEFPyV
         D05TmgIIOZIj39wBzk69SycdbCbIVS7QCGIDvwzAFrS4Von3K2uXIT+NYC1bioysElcO
         7d21Z2/luxcoKX71m4l17+3JFia8Cnswqya8k5+Hz8feu6BDWlicFXNrtHXK/yrb+8Nl
         ik0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845742; x=1729450542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdMZzUqlItAKYCipC8R7CKRW4bj0To7qOhyuRvVgeD0=;
        b=luqSAOAnYAp4rhBq4EVudmj+KUZEYe5g6T8ZKtio2/pdyrj+UVxdTIR4n2x5Bq874l
         B+uTX7DQDEgVuh16Xm5t9MjoLVby06nS088Rr1VBwmmOCGKRWixmfbUAv5HIrqT5SXbH
         MOgOn8kRvnl1QnjM+06aJovuDyDzs5vyQUDJMjH/AP+N68CIn7N8QX4bK/C14kW69aKH
         ZAVfxMceptUXH47ZE/IhL28qndqa4CbsEGHoBj7FG7MxWZ7id9p6+bgBDRhL8vNGcPjq
         /hJR8x4LURXbmWIXG2QUPRz6e6gEm1ueBxTWpsfRQt7ovqmtvE5vySkr4CA7UkxgGodv
         +hFA==
X-Forwarded-Encrypted: i=1; AJvYcCWLGk/aCy5xGYKLLL2pMttyVwRHm5hYdOTOzsUO1IZ5519KQEtol6J44yTpGALmIXzCC3qOEy1kXOYTNsGzOfjS@vger.kernel.org, AJvYcCXFZb0b+zxp3+CBTJpDh7D489tNX9/8e4SGbQlUnRAigY+/23Wm4rxbSBYvTxVfNoqRd8AGCxwTfcqvyto=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjt/TOKty4Zr2Pik6gCvoXlohYhGDEFP/OmJL17s64EpHJq4gH
	mbfVTaDZXw1hgBS0URYZUfrQOdXDNCKl1gSsL86iom6HegD/uatm
X-Google-Smtp-Source: AGHT+IFAKa7QLMgLrXfCGsTWPmLzzuX6LnZofD0LKyRsV4PvoJ/AEQnOQ8iMsxyM5aGIRLuo2u2udQ==
X-Received: by 2002:a17:906:c10d:b0:a8d:43c5:9a16 with SMTP id a640c23a62f3a-a99b8775be2mr661651566b.6.1728845741903;
        Sun, 13 Oct 2024 11:55:41 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:41 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 07/12] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Sun, 13 Oct 2024 20:55:03 +0200
Message-ID: <20241013185509.4430-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b63d53bb9dd6..568019a3898a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -341,6 +341,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule);
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe..5543ce03a196 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,6 +679,19 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule)
+{
+	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
+		return -1;
+
+	flow_offload_redirect(net, flow, dir, flow_rule);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_rule_bridge);
+
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
-- 
2.45.2

