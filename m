Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914352206A4;
	Tue,  4 Feb 2025 19:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698608; cv=none; b=LRPxSR5Og4fqs3GapggZQw1IaTVb3PUaBxOKk9Zhg8T1go8TQrZUxQhvA0JJ5fnx48pEuO/hFst+yGDq4CB8x8zpoM/BQZaqg3rmn9a3BRTJyJrJmzcKPGQifsV56Z0t3DrlnFhsQNmlqb5R4rSYE01TUTx7GaNzBYiQC8Ju+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698608; c=relaxed/simple;
	bh=wW6RAS7gIB9YtaeLFy71mruTN24ozacnHEEpdyTAFDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJJMCs5D/4IwJB8mDzEReE8GBTS/ohlT1lhzZpN1hY1J7LRA4oe2iPkujmW7b5jezvwLduw/vUFkZ2lwPq8Tddprzb9u4BwwIZfng15woB/UHtLKERDXhu+jD7m3kvqBRiVUmqfTVytC7DpgdB7nwvDUJNPraGEjAJOqgh3GuV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=inuDbSWj; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="inuDbSWj"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaf57c2e0beso1216213366b.3;
        Tue, 04 Feb 2025 11:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698605; x=1739303405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kADY7+7zs3VYeS9qt3VMln59cnXFpf9BaZ+2EYseZ2I=;
        b=inuDbSWjy9lxV9vfmh8BZoqkoSKR2grZk2fucUjEtEhI7IsPXMWH1TJYFDJcZfHuPe
         BheG7rTpE4YmRnhZ967ZXpwqirCnlcO+ey1dnV8ONmD9J2Qy/5lzpdO9K4kMB8aq/HX6
         sqNjX2jV/oJ9laVBoi3Ew8kpZPddTSQgt+01eRYihugN48CDEnBzo8sJ5oxXRMNQvKqs
         rTqz3VgDYzuWy294p5pvj6FRmnEZNkEwI+GcMi2FDAimpHfcl6J6n3t2ed13XlTNYPoV
         F9vIHBjwDM88GihnGhvcMEFw6JuC6h/+vhiD0rXhqLLz/KWFZpG21QESxEpO/bfmaKpY
         HmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698605; x=1739303405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kADY7+7zs3VYeS9qt3VMln59cnXFpf9BaZ+2EYseZ2I=;
        b=uAN/YXCvlEEv0PMFTziab1okjgslqeItCOOJLvUutPwAiNQlbxGI/hgOzifNayXq6Z
         j2pqck+tEuJpa+5iZlb06bQt2mqvkpU+NhFXOOZxiGK7oIB1jJhtK8NyFpWhGLUvAKrN
         wFSNsll7eCoTTjp/BlFhc3MF3uauUKBGjf9jvFOknSH9xGAZRauGRvdtOvdDCLvBzlXz
         Wk/YRu1BaxgUxBEPM+dfXMLU/pZwhVwpqFLcac2+L3f8SQ/7PXgkX5GBP2T4f4xKxUw7
         FlQLjkvrCh1ZTuu9WWS83/xXHJJfbhX3Y4aI7xSYCGMWLsfyryUAX+kamhwRgrUKzobd
         +/Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWyfBM6TmjmoKDnM+SYDclLqm1L5lasEmqDsvNFzgJ5l0UiSPxZrJcNX+T+1hslM7cUSde3ghqBH3lWZe8=@vger.kernel.org, AJvYcCX7eWrkO6NBuRGIHGrBuOK8J1OU6C4V2tJNLu6orO+miTtjnBPeX3apq9ZvuzfQW/PlEwdgBUCImipWi9Qz8kFp@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ1p2wY2PK+JyjIBJ4k6aBamz+XVOIxkaXd/9815DWwOu6/Bkh
	DSqoCmh1RHAPqqjosBEfJHSsO+ISaxtbE/stqGcppvon+rMzdDMy
X-Gm-Gg: ASbGncupQcYabIgrWX/12Cac7ub5hkBzHK2wqcIvgyf25d+R/durz4B12ytrPAxQwRS
	XMsuARSswz1vhkVY7hx77RHllmRGIdG1+q4qZcvFmGrA+1n+UhEGOudbYlZrtqQGGXpq/Ft/xiI
	7wknpgaga86gPl5yHoi9wX9E07AV+Bf6EB3kiShrqDXa5S5sb3d3Cjz6InLGE9LflP/UY6M3mna
	aR3ozmoLqomr11DoFXBmWbEmXZ5mKLvq9qTHo5hTa8Coqpj1cC0cV19aOSUBj3BG1YOvfyczLqu
	V/mnVPM+PETaZSYDYOudxF8lfDhtAUS8e1WTwxcCBkof507Ji/ivap80opDMDAiBDSxPzhsytDj
	sDrQ1Ym2yuu08FXxBRSK+vczGhL2AVNXB
X-Google-Smtp-Source: AGHT+IH3HgcqoQXvsnACIc49AeekhK/1g6HjbR0l0xWDGPW12A6kFCC7xX3W36OSBC5BU9r+MqXOrg==
X-Received: by 2002:a17:907:2d8b:b0:ab6:621a:f87e with SMTP id a640c23a62f3a-ab6cfda41e1mr3469521966b.41.1738698604888;
        Tue, 04 Feb 2025 11:50:04 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:50:04 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v5 net-next 11/14] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Tue,  4 Feb 2025 20:49:18 +0100
Message-ID: <20250204194921.46692-12-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bitfield info->ingress_vlans and correcponding vlan encap are used for
a switchdev user port. However, they should not be set for a dsa user port.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index b9e6d9e6df66..c95fad495460 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -116,6 +116,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			if (path->type == DEV_PATH_DSA) {
 				i = stack->num_paths;
+				if (!info->num_encaps ||
+				    !(info->ingress_vlans & BIT(info->num_encaps - 1)))
+					break;
+				info->num_encaps--;
+				info->ingress_vlans &= ~BIT(info->num_encaps - 1);
 				break;
 			}
 			if (path->type == DEV_PATH_MTK_WDMA) {
-- 
2.47.1

