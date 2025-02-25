Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689921578A;
	Tue, 25 Feb 2025 20:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514602; cv=none; b=etggu6ul3CV8mNuWuGA9KZ24wLaCOjoTJOCHRMM598FkWM71SAJCfADmJtqDo8H70IPCBkqJSjq65g2aU+KefOXNpatrFPJDe1kvMFyUVJncZNknd81cbVkuvcv53JH/DAI1D5ptOHUG57Uc5ZlcBNk9f2beFVQ3RMxvI3+HwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514602; c=relaxed/simple;
	bh=Xf5mlATXYp8EYoXU9a3w+XGI157o2p4WZAmB5ikh7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmh4nq1sPX2FjrXJ8ou8gK9KuMxh9wdAvTG5wPvtLLcYDKh7+sAxOPr3H3lwZygRDI9J9I7duFRMecmI9uaxKrPiBhA2y2zLTgFKUvfmP1onF9cxGo+budeFjbufq2yDmd/Z86+jPEUHDTUnpTvIbGBzl8p5uCDau7TlP1T5+j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idCeSiBz; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idCeSiBz"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-abbb12bea54so1038174566b.0;
        Tue, 25 Feb 2025 12:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514597; x=1741119397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=idCeSiBzuzKiqwPiJtOWl5S+b4bRt5HGLA4SzsVFqAGiox5Npa1KPrMMjxBJAe9/WL
         Q6/5d7JKezdYiWo5sMg9m80cAX+4o6EJTzewJJhWa5bKC+63xHPfMohSYfuVuzaTy+Zx
         gnpSvrs1fUHIW28dsKDvHxCOBJShuSYKb7BN+AqcU+j0uNaXGRJ9ZewK7oYNSYBVYiZE
         dpZrbGnGahw+UcsXNj+5iD3q/LbQdvpdgF76QjHp3JmBWcIUxpFvmXpbOk8Q0TRX0WPc
         qfkW6+CMAFB07ihBwfzVJj1XCurV2hFhh+grsPAh6whPx+sUKMtIrnvxXcJy80HbFfrK
         WKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514597; x=1741119397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=ShEwbMqmBPiouQjPcUIAMmkOGsv+t7NAN5fCfC9moZzKKz7cf6aGizi2Bxq1nHnG8M
         aEaFyEwbJ8z7UwI5yLAbspJx5s82MRENrpCdUnpZ8Uqk/iKy77bpDs4OwMBPJMe888xM
         xHWra8XuXFcOIwI7gO2kMFND2tL+F9rr+/6bwR31HXPA5U372WZX3dFGqJx5pWBZknp4
         CL+FgOFMfiIa5/QUPgcms5F459IXO8zlbFJ99ZaQdg2JVJglNuhMTLU4AshyXyONSw0B
         zGbhiv8cSCSGNtDjSpGrbn/iBDsueOb/jEYv5CDU79w4bTn69FK/qx9RhHB+8Ux1vwNc
         /3AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxtahtp6wByESae9iG3kSNdCd4CXEVK4imFaUu0+u35DK5pYfxNsjzX7gJqa47X3sEi9x48UEUb3+/Nv/kV7Zd@vger.kernel.org, AJvYcCX54v8tM8egwVo5yLenSWu0HQhdSGkqvoN0z8CPr/sE6H9HfmCnTQwsiZaQzCAt9ea/lMbFmNsuYj+P6pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0cAtCUTOFdwJPB1+dJU81IwY5DxBmggKUYJvWWnu5de+ZCNDp
	hDwHyWjLrmh3iA72RQAImmYqRZD43jQuafVN7UT7V2iEhUfHgCO2
X-Gm-Gg: ASbGnct/AwbRUlug8hFyARo01qFt3RTwJw3EKsZtzXPMnt147I3gmOhu4ri3xcA6InU
	1yp+8Bro9WA84TXzD3lQRroy9AzSaGlXxmsL/NpwHEBUz7gHTAXCmw84dXXQ2guPRV2KsV+TNfe
	kBq+/iLCu2yOwuwYgHynNLzg5WVy3bC5Hfl20MmEB1u4XA+H8yslvaYaDyTCtuB7V/Dv0x9cucI
	FeoGne6CciCIfbJ17XIXcTuahfujAHkdFuoNT2x5+D66cMwPYzW/3BtXM10rwZ+ghTJrNOvZPoN
	gRKlnWrNItlPhCht9+YXEeBFBow1RkbIUlJGs2u5a2OLxsPnPt9KqcKdBWa72VvAr8EIC5GKFJo
	hRz3u5Bg5KPBWD4ekvqIfMYnuPgHej+wY4NlNBIMvngc=
X-Google-Smtp-Source: AGHT+IGxUdijvIUHSsavOxjOEGtqnGWOKkNqobQSxe06Fq+xOGdhhx0QApPI1c+j5z6WHzO8JVwaLA==
X-Received: by 2002:a17:907:1ca4:b0:ab6:d575:9540 with SMTP id a640c23a62f3a-abed1076c86mr522925566b.50.1740514597100;
        Tue, 25 Feb 2025 12:16:37 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:36 -0800 (PST)
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
Subject: [PATCH v7 net-next 10/14] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue, 25 Feb 2025 21:16:12 +0100
Message-ID: <20250225201616.21114-11-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.
But we want to use it for flow between bridged interfaces.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 323c531c7046..b9e6d9e6df66 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -105,6 +105,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -117,6 +118,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				i = stack->num_paths;
 				break;
 			}
+			if (path->type == DEV_PATH_MTK_WDMA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-- 
2.47.1

