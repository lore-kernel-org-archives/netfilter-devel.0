Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1B1E1C1A;
	Tue,  7 Jan 2025 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240778; cv=none; b=uZiGaxRDpzSplTxLhoeVYBb8diVEYMXf6Wb7+5VbgGaPp88BWLIbpN9lJvcAXcrM17bu3K8VQkikw6GSME+sI9PB/EVTsMT3oi+NLxaM5lrpqgXddT+gpocuL82TIzCdylRW9kUmFCQghLyF1VefxNVqy59l05ri2fwH3Z1ACXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240778; c=relaxed/simple;
	bh=maNLh6FFLEFZWq9gMrHdXn5flUbXY1gxWqNWlBJHOOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa7wUbg8JSVsOOtAIwECDUQQzMd2awwGeKqIQvjqCKpUTNrW4Qh5XTt+rBKdM1X4FqmWPivBfFMpBFR32d9X3vIyGhsGdB8U4QOJ7ALycOjR3sEfBN0n2lDOvmjrG8Tb7q98X5f2T+ZJLCzle/Eg2EUz1nQJkDbY4otnnTxmwGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PW48o7e5; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PW48o7e5"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3e6274015so27119048a12.0;
        Tue, 07 Jan 2025 01:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240775; x=1736845575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtgyJTf0nGEQy8dIgfNuKn9dKl89pMTFI5gYmniF26o=;
        b=PW48o7e5OtMp2yraKDrotdDc4dJ33gzVqJtqb+Z2hyzZSWTJWaOW4fzhc4P6DGfw8t
         GwFrFVeXWqC1KUb7mbN6asLrwFQqD45vaJU6U71KwwkwZeUp6osZJKZ0QkHGJg82qIoq
         03oyFbcL1S8e0B+I0zY3/IydNrqbfjCsMah7UjmOGHgd7kXRFTgol1mCIrLGdOIMg7TC
         p94oYbiM/U5jBMgHUPn578O5fajKM0VcYd6PSPArfMyWy7kt7rU3s1QgobUxldJ8NPB6
         otjnMZBFh7Oz4Q1z8rV1FXLD9njpMsNFhdNW7cw34/gmIHD70hjT+rzVIMfoNhOZ9YV3
         Th6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240775; x=1736845575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtgyJTf0nGEQy8dIgfNuKn9dKl89pMTFI5gYmniF26o=;
        b=efW/mrOHb90JGip5LT696F1A8woqPYiriob6QZovbQCwuYOT48/ntXy3IDN3V2yDVT
         iSc0vu2g/jmyqXKOmu/LzLkwHVYqthMnAkb+dw5CNRK3gHkJ2uPKaoWX7W9wdYpVu/sc
         vehVBnSdXQiNkzyCidayAlpwE+mR32EC5+tnhDhLMa1GhF6lmw1AQwqpFaExPLjDJ6i5
         ar+BzzoO2Qw8nQnDN4NyqRO7nFlIL00dtTEF4ji2weqecxjqNddcVTOjs5HdoJdcZbYm
         gM0J9YlmRBgG1zCaYmSlrWD11Siy9tASnxEAp1FexQ6k1eDO/5u1E/NjYVRJTqUh276R
         Ml9A==
X-Forwarded-Encrypted: i=1; AJvYcCVK3u+DDqA7zuWWz+KqDH0FtrDmKaeR3YCRQa/+gNxs6KFinyI9m83kWadq8R2GvVrhaROCyYqxNxQ0LSd4K3sx@vger.kernel.org, AJvYcCVZvCWdAtyBGIAGUPdZ1YeMq7km92fWQHtPHFSMRXZe8QEla5wkPX/fCK1AxNyuQb7UhmwNBn09sV0sC8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkI77D6dLW67j74JbwglXUqRSc4pNtoRpE2wofngP3/SKe+ARA
	oxvtG1wrQeCkxdu11Ll41uVvioyts77ze7lwjWvWr0SYBIRgZZ6O
X-Gm-Gg: ASbGncu8y9RaVFGRNvlATCtWm66F3IGgeoCHs3kM2iIOYswTZndphr85QA7uiKB0+un
	+r5qRk/Qcv/1vhAGmXxpzzC+5frJ150EWh2NGZ9x/XcXrGNrALx79VqqprmXcAAXmU+ZNZPokKy
	CaSzahQMK0NulOUBstJhM6Bn7wLH9DtV600welgcIDDKz5daBrN+/QwZ989Ij2INE5A58ReFB8+
	55A8tq6GnL6gQFinSD12M1s7jAJfYCbrhfSLEwEB7Eij1OxE1Cxv1FUibTpBFtNTVlD+64HlZf8
	lrUHxYzJfrZtUx/JGJldi7wvAYSuEv1W8fVb5YNFFymVOaNZDui24O/z34Er1LPl6ttrLEtL2A=
	=
X-Google-Smtp-Source: AGHT+IHPxz9+uiCIXoSR9CoE/bJwFf3R4legPNbuUxKWFljvSeICAglSfIzYagTrY05Gf+jTQUtRFg==
X-Received: by 2002:a50:cb8c:0:b0:5d9:a61:e7c9 with SMTP id 4fb4d7f45d1cf-5d90a61e843mr14049402a12.20.1736240774460;
        Tue, 07 Jan 2025 01:06:14 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:14 -0800 (PST)
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
Subject: [PATCH v4 net-next 09/13] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue,  7 Jan 2025 10:05:26 +0100
Message-ID: <20250107090530.5035-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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
2.47.1

