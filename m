Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EED7223E9D;
	Tue, 10 Dec 2024 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823984; cv=none; b=fRRYeOYXlBppgltN9H3QgWjWQC5uhme7KZu2MXL8xFhEZcDr0aGvAOWuwts3PkdbYArcGh0OX/eR/KJerQuHJ5pwxuYTi0rNqNVHszBbh/Ad4ujW+bY6J9NP9HBgKz2P65n3VT7d/OunWqxFWm2fEAJSUe79Imr+831TxRD4FME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823984; c=relaxed/simple;
	bh=BvqBAh9vpYpaQZe3zOQxhCXX2RDxLCUEfBQIamImBGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBw4+cJEjNvcUbvobdfgfDGzERUbxnRy0dCcdALyC1gc8Ne90GhkDwNLD/+Q37+3muVrlBkehl/vvs/obCCTE2Uzrw81bwc4AwGWbqY8ze3y+BBw85YwyD5A4JOh5ppLXi2bGGsPixUxYz7af1bTPK08sQxHIwZk6AXsrX8bZlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dv/sQd9G; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dv/sQd9G"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3cf094768so5869348a12.0;
        Tue, 10 Dec 2024 01:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823981; x=1734428781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IPV+/btLneRoSo5HiyXyxa4AsB3fEttv56AKWcCbic=;
        b=Dv/sQd9Gu11k1gjKOTyC/HO5DoB94W8WMnexylqqEkgTK3QNx5SBamkAb4y0gjMAy3
         hvKCwarHEyi6qbkuuIuD0A9gzTPwvUKMZVyDRFp741Ovgb37zIly/Gi7fJmd2f8XQ9MS
         g4hPhBxwT6LtnPfcOcCKnGLq1TbZ1u3wgi1Pn0FUG/EKG5OhOs4NGgszQXevP6PIrK0M
         06YaCIJvdI4EuKt12IOqrNJNx8PmZm3biMzlYXU7giLxp1ilppjLhPwwyxG3oXbcl+jt
         k+jFAaZMbAE2V1YcO7gF3xR44PWp4kGCFtmt1/TMQOPjrDS8ccePlwHv+0/5Ejx5KQEN
         Ed/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823981; x=1734428781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IPV+/btLneRoSo5HiyXyxa4AsB3fEttv56AKWcCbic=;
        b=adv4FIBMlO2MdrLRmfcfpV273ycN7QT8aUMnE5KbVJybNil0RB5UMwoc6nC7++1q1c
         UC3XO8pbUnvo5KMCdWvg3LQCJXcXq01OIOG5qnDEnXkMhw7J95i70XM7yG0YeruaKM97
         2InP8iuhl+IWGOvUjKd2i76OG3hH0tpnqJFKx5nDkB5mQO9+Bd9e7r4HzKXYj/EalFVj
         dIzLm+wnO4JJyhVWY2wn3EaKKHzUNGcwpPT1K70hCJUL1Ev+OE3TMqnGxGBZy4nP8Oeg
         BYoOVQB07OOEE7bsIttKi14yWRYOLuflNKQKXyrG3Zf5Wm28o61ZKapwtYOik66NrpYm
         VtHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwr1FQamRASHjb2hkIxAN6pwEFKjecn9u0nIZvyGxqY0xywYNrbpX2t912QJ3ENBcnkEanPGY+4vPWEqs=@vger.kernel.org, AJvYcCXjlnHE4pl7Y59If2gjkHc9+UAInAy5cITujKH680webmC0iYYSRH4KU/wsbQSKKV0kdORVHbzS1BuJTosf/zjg@vger.kernel.org
X-Gm-Message-State: AOJu0YyEL/KIvPVEO8kgo5MTQWf8MUB+qxYBtMh75FykdL+MnlXP83Na
	amSHTXJikY+vylBn+uu2RHEHewq3REMeneTO7xKflC/eM0jbuL3U
X-Gm-Gg: ASbGncsBORwIz2cbNchaWplTdPekN/iNrYindkwm4oGQh728qI62s4PgoRm+wwGdysu
	61A5zyQtEgovy9oBzp2HRbdiUpkASUsKzDBX+dLvyVNOOL4T9PzXfGMS67oGIxsJGsL1wZtoEFH
	aCdHxx56UpRXzBVSpPXr64vyItZ+P2qvEDMvrGrxENC7HFQfVG4Zjjvq98VpsFfCV65q+OJR1vB
	78kOdVylONQbCCywML/mVPVIm6NsBs9+SzJaaiJ60/6xVeQHvjruU2/ia+5L3KIBb1P7EmHDeO4
	8O6M/WJJoG/Hh0E2UOKwbFDPRu9JJsemodkB8xDd3V7nc27WUASstTGLvA4vgVaexE+L3u0=
X-Google-Smtp-Source: AGHT+IFjT0LuXJIh1LnKJhzqy9wN2HFcOfLo9WVivfUzaooRucqnpDZPHXE4LF68gVbRTOO3lAb8JA==
X-Received: by 2002:a05:6402:42ca:b0:5cf:c97c:8206 with SMTP id 4fb4d7f45d1cf-5d4185f8686mr4106270a12.25.1733823980513;
        Tue, 10 Dec 2024 01:46:20 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:20 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH RFC v3 net-next 06/13] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Tue, 10 Dec 2024 10:44:54 +0100
Message-ID: <20241210094501.3069-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
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
2.47.1

