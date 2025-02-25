Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E95216E19;
	Tue, 25 Feb 2025 20:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514601; cv=none; b=XRh+mWWQ477nmrGjmCd6CpeqWciOWE28qCm5Uf/2FUa6jn2eNW+WLBFvc4IPB3vVRuS+N+ipTVxT0WPdEJWSsbF4uIN8S9/AOlUGg6mIgdlxhR0DA9LXMJdG81J5ExvAINrEAe5+kTMqC6ghXkGlNmfmJY5z1Vef0nNyXjg+mw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514601; c=relaxed/simple;
	bh=8dcYAV0MonhKL6O5x+ptHAAw+fbiOOhKssEKku03mBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOPX083GIbswfNpXOemS4WyonKS9EXgdDOckprl8RPTatgHCpSXPPcbnY6W5tRk+7RYHagrVsMUjgIEc1gPu/ejog/hjlyT5TJsh/q8ccCv/Anoe9KFkJBJvQhslkz5Uqst3koglV2kRrkV1xnMZV6Yh5T7bNAfGGIxnMlRmLg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3K+Lcfz; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3K+Lcfz"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abb7f539c35so1171754166b.1;
        Tue, 25 Feb 2025 12:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514598; x=1741119398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVAkTZii1Gy4XRugZsnKaWDIV+1UdUIxS1E1wVQkwnU=;
        b=T3K+Lcfzq+mAH1mKU3oTt/XVqp6whIVz00Mlv0eU3f8xkYIH6zpQSCxHEGhD9jVy2D
         sXpIQeRQ+v0YKBrlER0eWbYOhdGklOJSl++lOQopRQRcAzPoRs80RZaOAZBPQOmXXh8P
         aBPqQSaERhIls3X2AJBaeptKldkQyM7qm0DCgqHgO8GRo2wVgAJrgZFyvCl6h1Gni5IN
         hqLs151iz8DDoD9B58hRnKyISNocbfOdwWk74lRVz5q/fuMoJCyqZhu53b+LizEVOtvT
         ABtHow/XZUA3PeZE7KGB9x8PINaZFEKcRtzxpv7kf/mT7fSafZfk/x1+6ruXSOhao5hE
         vZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514598; x=1741119398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVAkTZii1Gy4XRugZsnKaWDIV+1UdUIxS1E1wVQkwnU=;
        b=kRcV6glHqQxXVI2N6jTIWaA9KDRt6xJ5rw8P5uv+684zOhcUwzmb175ZBw5f4uq8tP
         FEtDOhukXyQnXxyYtd68Ma8s4yfVI3cJXxMmamBu5ydWlJ+eDPr/SSa2ck8HfAg9H5UE
         dbjBl234bXbvBV/a+8QKbLSiqVyj5YDt9W/tsIkpu3twSQlu0vvEZj9GxGATxnmsTxVG
         IMURPU7gYMH6GFdPeUNj21s/ACBJMEhCR1Jwam8yZpQjdmFg6nDQvjU2DNNE3GHHaHrs
         7kQGWS/Q0RK5Wpd5DRHrQfgtsIEgo608ZQYfaLj4N33mGmnrwK8bUwbREc442c6I4XJ+
         FWbg==
X-Forwarded-Encrypted: i=1; AJvYcCVNLjL1fJRhhEHsZl2KheQo9y8zGVYjnQGDjKmn+0al5pGsm2tJqVhxIyNgqgiVMhxGxTFyQcG0Y3ZW6OjZ5Hwu@vger.kernel.org, AJvYcCW9cpj/KKL4X8mE9vEy/aYpEEvFFV6PyKxbR6qIjYGxwZjycyWSH/dgNqg5RgCFcHfaCG4Hc1+Rkbu8o3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNRxAvtGNkBkK1SwmjGTIhiL/68RHyjFLBzreZ7AFoNKpm76KE
	0aJyoJQXIVsB0rlJQ62zZ9afFoLdeZvRyi35g+TJZGrzg7ljYejC
X-Gm-Gg: ASbGncuN0ISWQYAEX+Op0ISjKbYDMa/RJMzQl6LcAfVd2Nd8u8p3jG2mOBRXXK8O7fy
	RceQikOMd+Md2t6SeKbhqh/xJy2BPWMpilKKxjNAYIJ0/G3JLZPj9Fv/pIL8bOayqN3+hnryqAH
	IMPBF6AI/F7GCumr5BDYyhDlSoPrQagDPZsjdwkq4uxZxdW3MqWGPbouf5kLUJ3v9kByiGiDTuI
	K3eIUctYrmmElx6YR+1r0oJS1zI6zZegdt4VEfKj+gHk/xvuOtEtOCkMZm6uUhbydbKpoF+NX4+
	qtrMcCQLQgLyHyVBQ8XEt0n2AINjHdHMEZDDXVbCnmRpNpfhLnmBdxwgI6smNElNpdXf2lCH11f
	f+I0a9nZFRb2S7sOJhPl7rwp93pKU3R3cW0gtMe4RgzM=
X-Google-Smtp-Source: AGHT+IFK/xb0AH8q2XIcdgGFCG2/1S/vlx3qUjtu2T+2XCeJrxRROpGepkKKWsPoi8GIWtQoo7ZUrw==
X-Received: by 2002:a17:906:a952:b0:abe:eebf:ae54 with SMTP id a640c23a62f3a-abeeebfc352mr51844866b.20.1740514598236;
        Tue, 25 Feb 2025 12:16:38 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:37 -0800 (PST)
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
Subject: [PATCH v7 net-next 11/14] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Tue, 25 Feb 2025 21:16:13 +0100
Message-ID: <20250225201616.21114-12-ericwouds@gmail.com>
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

The bitfield info->ingress_vlans and corresponding vlan encap are used for
a switchdev user port. However, they should not be set for a dsa user port.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
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

