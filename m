Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DFB15B13D;
	Sun, 13 Oct 2024 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845748; cv=none; b=prQq1YxguN19qxqMsE9ePD19ig6SVoSx3bDOipxhSHpglGts/m19ASRw01zgI5yra3kldvq+HhmS9lXQg4M8/ZeAFlJZTSKlrnJDJjAeNkSX4DpC/VfM5XHJ8qwIXb2RZkNgMPVjgYREZDYpPvYD+9lKa2kY9G5MltK7Y6D8gL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845748; c=relaxed/simple;
	bh=LbQq3WarvL86qr5fxHFaZ7pGgCWpQpMufczHVKCXtSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjx09XzkDopk0/a5IBJbka1JDBymwisy755JQkh4SB/ymO0M7FTGnCuC+gThZi0DYccVU/dF7OIVWZRWpevTzc4j0nfV7MJJSXg1D0+GVUAjImCdBmdte+Q5vpJNusy0mGMRr1hi/tCjQFQGVnhbOn4/Zt1WsgF3DNqMRpwyGUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZddH/vFZ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZddH/vFZ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a0474e70eso97733066b.0;
        Sun, 13 Oct 2024 11:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845746; x=1729450546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DH9O06Lp64TibMF8pahG9IPkhLX3XCOl3DriGpuFd0=;
        b=ZddH/vFZElhyHdCkMdYs+yW7NIdfsHPxhZiqBbPPbz9fakSggT0e8OY+ziqaTogsaa
         aUKP6iuJPZmlgHoYpLmc4YVZomMZZIEuR9D+f79aUNaiXOhX/JvubnIpdv6WHD7ydTue
         McbjJ717fI1kpi4ELgJdlDjwASQeUuBds1/SfzjPTq3xV8UqbYb+ACSAt2axxWuLV/+O
         1834huoSIeJ0LjRNLOPAemAIA7ICf0Qbq6yC0TcwEcnBRx24ccPa7WmWFDtPI4UxAPxO
         EXpDhU9hqdOACTmiUPCSrxcPKkq/FLh+d1vCjsj3BqFGBmn2klsor2E9VcZF1HFvnJ/U
         3iYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845746; x=1729450546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9DH9O06Lp64TibMF8pahG9IPkhLX3XCOl3DriGpuFd0=;
        b=W674XgttgJ6K6zK8wSMNHZtIcD77htch4JZdAf46Ym/jTQDS6Z98u6Sz2JDRQYKofb
         I4zDfaxNQ/0S3mJMh7cv7GOoSIXX3q9PFKItc7UlcMgcpE9J1g5FPDxVu2C73rSTKor5
         6J1rpmk5xPJrjdayT8LZ1DR/htJoCtvgtIlUdvnIE17cEXCgXqTFZ8ZPN2KEUy9V1eGY
         +K3nXKg2aD2osJvWXUAqvPHSXjD2aZ0EvIvj9ZD3ao3XPhgrm5jZV6dkGFTyOtyHljLx
         Ysyma/b+eUzWbYQpcucawdrflAN0MhMNiCPvqe+rlYP6klnVg5OgPmo0GCgkQBRTCwwY
         hU7w==
X-Forwarded-Encrypted: i=1; AJvYcCUg3zGxmYVgx5AHtdjwVA8srcyxGvCVbjutHNdpMqXSFplUOdV6beRLWgBODA3sdEpVxuZTT7SjD43v0x7u0/fU@vger.kernel.org, AJvYcCV6vaUtI986Io/qz7BUnId7BmoykCPeZAW4K5sOyY6hLFcWFggH4LXpvkYrFIPaVQcJJARsCaTTE5/Orb0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9iPREsqJHXmtXfdwXGBf2j2VRcXI8DPVTSN7Kh1qru1xfnr9V
	7zx8uoLy2y6uGCE5JX+4RgHHamOoWEIVAT1ibBUmFUG3nqKxTW3n
X-Google-Smtp-Source: AGHT+IF3e958cm6WfptQrjYwvw+8nY6U3EWzISV9aoZ2s8HNdWFDat+7mlGlek7WSgxj3fgwgQWR5g==
X-Received: by 2002:a17:907:7f12:b0:a99:f945:8776 with SMTP id a640c23a62f3a-a99f94588c4mr336725266b.24.1728845745513;
        Sun, 13 Oct 2024 11:55:45 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:45 -0700 (PDT)
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
Subject: [PATCH RFC v1 net-next 10/12] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Sun, 13 Oct 2024 20:55:06 +0200
Message-ID: <20241013185509.4430-11-ericwouds@gmail.com>
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
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 6719a810e9b5..2923286d475e 100644
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
@@ -114,7 +115,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 
 			if (path->type == DEV_PATH_ETHERNET)
 				break;
-			if (path->type == DEV_PATH_DSA) {
+			if (path->type == DEV_PATH_DSA || path->type == DEV_PATH_MTK_WDMA) {
 				i = stack->num_paths;
 				break;
 			}
-- 
2.45.2

