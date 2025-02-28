Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9E327CCE8;
	Fri, 28 Feb 2025 20:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773791; cv=none; b=SBjnZ+jlzMt1BEduzLeaE9CujnqN9fLU9OWaMY9s9DPR/QtI4Rq7VMZwm5m2iA0u3MOqdEP2GBsDoeDJfH39jhFPfGe3iFiE36lWsf3a57j4ioduF7Qsy2JXaaTCvIKtNG5sD5C7nMauxYzW5aDsr4An40cg8cQZKBCqV1OYPrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773791; c=relaxed/simple;
	bh=p1IsKiAxwq12F2MM7ABxyO6mLj6RlYFe8Yg33MCLfXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWKU+tDdR90IeBmuQExg4WVzZMc/pQS/Ijhe33AMXZ0JYbWgp4PxEpDgSus1CmeTB3NMPV7eLdVADqkXYEinlkpBZC4UQBIEgB1eb38LaqhU0/TnmNhYzbuEVg4SG6PlPAJUgBtMR/gCQu+ARryq1iFj6LYGaszIZ/VVqMg6aO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UaMCtwWl; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UaMCtwWl"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-abb90f68f8cso484996166b.3;
        Fri, 28 Feb 2025 12:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773788; x=1741378588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=UaMCtwWlH77wG9yFpX0M1Bzyq9KiRmdE4/vE+9QyltAyLSXbE/++CsYkHfHVmL+p02
         i7gcXFudGDu4piCQsfBpgNa8azuPe4jeWOyAk3JoQKKdLlYRz57vie554kTO131A7yz3
         gnN+QXzhFhadgHKwH676GEyvHqM8T0+0pnh2RVyAFnB/TCcKvBpuZu3ngOjB3qm/F8/W
         2x+g5S9t6SmISat7D1tAHMfbunsIZNRsxLuSB3YS7wy4FYgeIYeqYvPpiqwqMe21Ec6x
         E80Vrujk8ocFpRpeZEWT8TxhDLQzPDgYI6TPe+0n780R4fh255WdD2r4lYEUnhpJ7Fr3
         Rl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773788; x=1741378588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=FNayl0y/n5DgmRNMwi2UlFsOjHTrcJ5yJNP10cADO7CqJ0ZSRvoULe+9g3NAfhdqXy
         3k5RaZKHSBWv9dRE4bh/HZm7/xZbQEX/32I6WlmkbpAkn1fN59VEDKFVt+TQycx7lYtn
         s7Db4+8Nlu74vihYZZnRRVsbQ7KGtVN2MHaHf/w9CVuAcAB55iWG3u//xV7ZxC2hhWob
         m63m1yIrQclDaHhf2M0XNIEyJKJWfBgE7GJdX3Qf4i4QIgpEQPvb3n6lXKg98P3k3i3S
         bPP828555BrZ4C17a2AeuYBtUuSwjWuM3MlDcMxvIaILPuV2FKJBfS312jW5r9BvVO8z
         IFOA==
X-Forwarded-Encrypted: i=1; AJvYcCUJqlvBSgKuIlUO5AfAV1uYCsOxubZKzKulmEUoCFLTfitgk4g66UTQli8f2gr4vKPxCKw2tiJNE3JgEnEZz7Z5@vger.kernel.org, AJvYcCVOQCUSxiouyYJFwjjzJCRH33WdELrORV9I3OtQ6tWILP5atH0eamg+xM2CXwKjemSW+4tx+5C2lJ0Cf+giD+c=@vger.kernel.org, AJvYcCWWEiCjhtZYiDuLLit/nbU1BK9nyhln2g7EBt63tG3JeTF0GywUbXcIJGMSFBgYoDjft6PGtyLJT7nswbWX@vger.kernel.org
X-Gm-Message-State: AOJu0YxG0i3nAbC9xdGhXyIoMzA3DZx0AjLF+nV0JdTusWPMt/gJA7j6
	m171KNUTPFTneTdB9GSUw8AnX2rh8hTXwpjR64r7ivmpumj7KPvK
X-Gm-Gg: ASbGnct/TjRtJaaJFVIyAyFcJpRcsx0NKR6rdTLIz/W5DVSTcRfYNxO8BVWZVddPcTF
	8x+li5sBPaGEom6NuWpSfcFaLyP3XLEv6ofvwj7Lf5io7NhA59Xh54bdOlAO0EGg7d0bjeVqbo3
	XthPKROF6zGkGV+BGluCb93+2uzb0cxpuKMC3K61OW3qPs8A6KWozaeo0dfx1MTcp2TT4oi08xi
	aIg/LT3tFX8FgVg3HXtlTaKBPd0wjIP8UaKSYm0dkaoefxAyu3W4HNqlIDM931bKDSpLunlp7x3
	zUdxaINRiBXgCJX2jqAP87xUjptb203HZbUF4Ok42jKM7jfFPfmKERt4dfjniASVVrfX8muj0dJ
	2+DmpKqLWrF4nfsKHrf+kXmrVcpDPGH1HjWvxWGBqRAM=
X-Google-Smtp-Source: AGHT+IF4o1r+k6+nG0zNGywKeKcizMy8Myj40MpWCdBkkMqspA1rSJwU0RPTkMPYXpO+ucJWx86obg==
X-Received: by 2002:a17:907:3e0e:b0:abb:b12b:e103 with SMTP id a640c23a62f3a-abf26218d27mr558296766b.34.1740773787937;
        Fri, 28 Feb 2025 12:16:27 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:27 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
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
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v8 net-next 08/15] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Fri, 28 Feb 2025 21:15:26 +0100
Message-ID: <20250228201533.23836-9-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4ab32fb61865..a7f5d6166088 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -340,6 +340,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
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
index d8f7bfd60ac6..3cc30ebfa6ff 100644
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

