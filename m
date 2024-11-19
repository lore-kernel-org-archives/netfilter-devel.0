Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2524A1C3F26;
	Tue, 19 Nov 2024 10:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011567; cv=none; b=bfx3wyjj8pdwhIC4BGQ+hVdltpYUYyxmZRwrYT7GoXn6G1PAmWPA0+fIwdIzP7G442LN3OlTVIKPiCkFsX3CMbDDyD56YXH82pKL5pWUgCCAcZg/6AtWdRJ+UjSfn3L1+ouJsMl1hY0qmIFr0lvwKfKHMGuoWQP47J+yWyRSo5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011567; c=relaxed/simple;
	bh=A+ii9hUcM8wU9eVI2sIlc9PYLGj/teoItXOMkBbxNzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ff1dFUn0Ej/7ie2BZdKRgDEC2N0nHu5N5vhnXcbGt6mdWaFFTniaHLNewZpK+dHrNs08dPueGTViMFelCF0muoSyl/eCjdcQJG2MHq4aANZKvXiXpwMd2u7sUmmQ0SQfuL/Ln5MsICBQdl0fcfK4+kxp7dO6uuaE1OXTqG1GwaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDP/9psz; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDP/9psz"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2feeb1e8edfso39290401fa.1;
        Tue, 19 Nov 2024 02:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011564; x=1732616364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNtMqpfiZ8j9VP8YeMgt8jDUBPMHbCQx5OGfeubdb70=;
        b=CDP/9pszOYe+KA+oTe5dBDEwWJD25NiC26+IT6YMgjmksIJ2IL/ydIKIJ3YWVCBB9t
         PjYq/6Cg6s0b0IqfKIOOThrDlLAgTgva962vs/YKBIzwHkZ0KyTFw+7wwbygu/F6SPHc
         TruEjzbzgPRylZptg3AEk8qHG/Y6XDBRuWsSKCLs64nR482Khk3N9Yi/ndDMVE0Dt9zo
         AEz75UpboX3+BpCyCP0aODSlxo92PRidqJ+adFoQtTyN3BoCfAEvq5TPdXh2P9a2vSsc
         kR6UikCLcIvnSbw450h5rY2h8YaL2BXwrJu7l/RPh9E3/NU/1cMEKd7Cj6DceDltQbPj
         ingA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011564; x=1732616364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNtMqpfiZ8j9VP8YeMgt8jDUBPMHbCQx5OGfeubdb70=;
        b=p2YC2Z4J+lH7xIfeoNmrEMKUlsHxtWJR2IAG/I/ZlEj++9Oyav01eolfcwNmRJqBOp
         MQhg0yAe3jd92BUAZoKvF0h8YI50igWaxk3GlRXep6/Svc8GhE98kRo6NQ0FkqKP5rMe
         SiHhwVk7TAVF/02gKYG+a6UNUYFkYqXVrg1pM3Jy9Hv25acbgj1lhR1IMPVDnkR7qF7I
         dXD3OT3JqjGas6KlU/ER5LW1NrKr7zYkj0dPiP4v9j2rDIiysFWSB0UvE55sfr16nCGR
         Oh733PkiGzyqEOAZNhZKb0SktlgVmLg8wLqkfETag2KEJoivIEMZ9SZYpD9c6xL2oqB0
         AjVw==
X-Forwarded-Encrypted: i=1; AJvYcCWCo7grrIFvcR1iCmKLCT2HQ2Gma9y6qFo+X4laYEj50+KT3NKz7kX3QryB5EcVxOcr7BNlNI3kdNnQg40DyCff@vger.kernel.org, AJvYcCXw/uorQ7foDiaHvgci3Dq/FscnvYDc9Err1UWOrhecnI6FiwmFauMvfQrpFstXvpUjNvwMzEh6YhOPOL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT8P8xXjRAvCx2cXjdOOOhz4/M8k5wV2+rfZ7NVwdiypJjFO63
	dMoNsfWbqueIQMnhVccS6ZBN3Tk17WQTSsnVlWLx1NMEWYDC71KS
X-Google-Smtp-Source: AGHT+IHPphanLQvn1smAWqmqpsVVY1N5Pj6CCsoY8pRu0n0GdFTRRvOQ87pUfg0ubCpmZuXrqQ7tJQ==
X-Received: by 2002:a2e:a9a9:0:b0:2fa:c0c2:d311 with SMTP id 38308e7fff4ca-2ff60610642mr89237351fa.5.1732011563899;
        Tue, 19 Nov 2024 02:19:23 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:23 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 04/14] bridge: br_vlan_fill_forward_path_pvid: Add port to port
Date: Tue, 19 Nov 2024 11:18:56 +0100
Message-ID: <20241119101906.862680-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119101906.862680-1-ericwouds@gmail.com>
References: <20241119101906.862680-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lookup vlan group from bridge port, if it is passed as argument.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/br_private.h | 2 ++
 net/bridge/br_vlan.c    | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9853cfbb9d14..046d7b04771f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1581,6 +1581,7 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_bridge_port *p,
 				    struct net_device_path_ctx *ctx,
 				    struct net_device_path *path);
 int br_vlan_fill_forward_path_mode(struct net_bridge *br,
@@ -1750,6 +1751,7 @@ static inline int nbp_get_num_vlan_infos(struct net_bridge_port *p,
 }
 
 static inline void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+						  struct net_bridge_port *p,
 						  struct net_device_path_ctx *ctx,
 						  struct net_device_path *path)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 89f51ea4cabe..2ea1e2ff4676 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1441,6 +1441,7 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_bridge_port *p,
 				    struct net_device_path_ctx *ctx,
 				    struct net_device_path *path)
 {
@@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
 		return;
 
-	vg = br_vlan_group(br);
+	if (p)
+		vg = nbp_vlan_group(p);
+	else
+		vg = br_vlan_group(br);
 
 	if (idx >= 0 &&
 	    ctx->vlan[idx].proto == br->vlan_proto) {
-- 
2.45.2

