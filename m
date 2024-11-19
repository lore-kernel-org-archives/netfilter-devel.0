Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F1E1C2333;
	Tue, 19 Nov 2024 10:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011575; cv=none; b=km4VNcnaMiGHfjdX7chGO3dU9sv+ohXHoar75Cy+yX5qkapHEm/mvcLPQL15xg7z/I8M8tHD8/nePLm2Ip93sofTbxca2l2lDKJKyEHqNRVwjj7vCgF/dDV4BI9Z5MF72gArY+h9G0NAwwTH+lw4AgtV8YDlCJs2pC9n90wUNuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011575; c=relaxed/simple;
	bh=5bbk0K1/fjGvxV6GV681ZpzYw97eAPaanPHpn6ynzog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+HgaV2Tt2STIxXyMmblrRF8xP1LvoeBzodskGx6VY+KXKp44S/toUgiWk3WL78t0QQOjc+/kNvdUzSBb/V9hJ8VbeUugLFejkpfKVBA1b0Ak02lE5vezcx5rx8vxBTuK1BQzNsGNayAk7fha960u2nZ6iHtNAzzYk+W6S4M1gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=La4gB6VP; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="La4gB6VP"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa4d257eb68so49136666b.0;
        Tue, 19 Nov 2024 02:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011572; x=1732616372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85S0Wgk4R14tSlRD4buKO5TXxTAg6c1gFU6+LoW44DQ=;
        b=La4gB6VPvcKn2yDNzN2P8QcJ52D6pmNsTkS3Tm4R3e0F3AgYmS4iwVd2SY0fa2KtJo
         IdznXwYJ/C39HV5H9wuigeWbOcM6tnlBhWEHOfpzbQCumP3T6JYjbpi1XSWbsBPeeYCi
         WdLCLPfX+2FNV3miOpmUncQQEMfw7ZijMmMAte0RbiBRs7rQT+nhjf/RDLUP6FYSqvvl
         SY14GBRJqTMUvjFRh9fOQrsZyHUXXvQ6koBypX6RM2sl4Fs1bWyP4oWfxE+cPrTwX4rp
         dqr3svuRPTRybatL/bsvWmECZUOHFIwKHNROxaSiTrYF+VSzy0MKW06tS6bv27QbK8Af
         YvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011572; x=1732616372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85S0Wgk4R14tSlRD4buKO5TXxTAg6c1gFU6+LoW44DQ=;
        b=uIQy6yZQqlKicnszlkaFrzyKDV2ojNjaoswdYxZi748eQdJuZz8htvlfHkuIlHowYk
         P/4Pq/yZ9hmLhxhrns5AZxHBKMKkZJah16S8y/aYU04fS/pPOR5UsDw1z1ckdUQs1Rxt
         7eeJjJPj+iTFVgimJTer+40KS8SYb4lRYI3kZIcOQ3RrMG0njK1KXKdYrmLRE0WkIGm8
         5+F95Bon+nl3gcMAl5iDQEvzIYAeXCJEOHgaQBFcJyI0YW7h/ZWYP2XfLUeFq3LIigHT
         PD/0VwH0w9pLM36zSVvAR3LB7fKh+bI6Um7tTdt9fwJqTUfQwEd+JW/5ATtd2Zt4xVmz
         FU7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVSBlUJgiTbxahIELdkVXq7gFJz6zI4Z2Fl9sPyaZvtxGJEaT5f9UVq9hzO2nsoxDJQWKwmB67TjofbXU0=@vger.kernel.org, AJvYcCXjtSBji6fERyWSwyD4f7NJHPG0XL/azzV/BuBI4+63LObZh7ZJi8NzYVySTNkIHpN9SZ69LvZaGyjb/+HUJFJr@vger.kernel.org
X-Gm-Message-State: AOJu0YyBMSpdWxn/U4bx9yHZT7A9yU+AeBJ0CEzjK7Cf1dT1cS73Pbyj
	mARHyIe98XsJ5aep/wyEqMLgav8eIS7/aPDYCOwPXcUGhc6ysk5U
X-Google-Smtp-Source: AGHT+IGzVDghd+HHCKlijYAqrFFNL9wIfOoTroQPxMyDYa4idVXMvA5nnKPnghWyNvh8dPU7HPTv9w==
X-Received: by 2002:a17:906:dac7:b0:a99:fcbe:c96b with SMTP id a640c23a62f3a-aa4c7f2c8fcmr220655966b.25.1732011571689;
        Tue, 19 Nov 2024 02:19:31 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:31 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 10/14] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue, 19 Nov 2024 11:19:02 +0100
Message-ID: <20241119101906.862680-11-ericwouds@gmail.com>
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
index cce4c5980ed5..f7c2692ff3f2 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -106,6 +106,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -118,6 +119,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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
2.45.2

