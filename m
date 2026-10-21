Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792605933;
	b=1I8ms9EgVA6mRHZ6iObRSf85tT1sQdZmS9IyyLqHq8T3tUXAEHx8ZQKIfefQp7SR3q6b
	 zcERVLopGonomgVuJZ3A85RXYR/AsVdNEfOxt8oD/Z0+g8pfw5UhWHabC4QX6AHri5UIx
	 b3ayN2mtCw+pZ37vzCWlHhVRLch/fdiBT4H+3OmK2MrOxPG58vbXu9zmvDPqJpiOncrKJ
	 dIs+VyTlHE9Aef9DBfvzOqGQwLbU4AyM0EjxrZvyRTr4XFA5uP3F0+zAOp8k86y/wfjl0
	 GRqosWIl1oSsAsyEu1VVKA1aZYja7iagzr48asAGDRHLvtIWNEpbGU2mWs+6jeEj36w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605933;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DS+qpxy2NKuBUhINnKtH+4oZ3tQEN68OVLg0g7A1lmA=;
	b=SYQCr2yrJpd76bn5p1n/Bv93H2vjL88DLKT4LQJuvRFpF4XqI6cmn4Mi08PcQl4EqnaM
	 swRKSiq2ouwy1E6oUILVHPvBUX73wAXrK5kt09fPLuEw+DD/RXxUF9OTTuGpMmj9t/THB
	 IHM7mLN5aC8HfbqO+0gAypRbH8QeatSl4Y8SCNyH63FN3srxKQFYAq7nR8cWq5GgReEiz
	 AdIOnc4qLh4coLvcFeXLye1u7T5EF2wO9/18ijfmQ9nMeZ5AetvGJgdV9LadAUgryub3D
	 UEeOXeNwh/TukJiWzyXlreDxHG4nvDAjHshbjA3kW2YD5+fsV4qK0lmkeXaEchZLC8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ii5B2VWq;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A9C606A332
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 18:05:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4A9C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ii5B2VWq
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so5072735e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792605931; x=1793210731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DS+qpxy2NKuBUhINnKtH+4oZ3tQEN68OVLg0g7A1lmA=;
        b=Ii5B2VWqfwQW5rzOGgccwN0tkdmw/e4rjES1c5Zo92Eo0X5gjyDyp5PY38u63ZPztE
         uVtGhuu47sjcZgNH1Wo/jaIgCeym6Ms8YT9fEnibOKNBnQRdevlo7AO9rtWlYUIJIsqy
         x7i9wy67Yb/MnMKsq9nAG0J+0gIMNOB1eaLKhYtLYHSlrhUXRxA3nZimCsJRByF1QNlY
         RsVQJBPzWToj8ihKGmpCfsecuceIY94Cex4ogp5ahaUKwiHB58wCl9xgJCQz+9Fzp1bC
         Fes9WVUmPxSIFuH27OMYhcrpYJGSU9mA91jOKK6lqOTpzSrK6eb7HK4i+tuWFf9fp5OT
         RGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605931; x=1793210731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DS+qpxy2NKuBUhINnKtH+4oZ3tQEN68OVLg0g7A1lmA=;
        b=aF/YXfwBFuppzWgWrzvJWhsprIdiTQz+vRZeY9uAAJnrf8QYEMq2AkWUirPHeEFNTd
         VjT6o+GKzGGGxK1iudmMplMOgp9apopHjD9C+ua4tOhnIaws8U0MpOxGtg8lV/QXUa63
         VKA5023O4OUheE6ecmuXt+v4mif7+DCncQ3o2H4RaHOUbvh2hazi/aq/gBuXaNnnAt4+
         TDkMEG7Ihym15ni5WlqQyZSWPjGvYQNb/qbRidODMk0HYUCBU+Jqae4bmRK1cyl7q+0H
         99d+NjMEUiR0wo4wvToXG7t93eAHD3Or5Q/lg+sOQhPnfXle20jjCxcAcfjgVSsraKAf
         er4w==
X-Forwarded-Encrypted: i=1; AKwUvBwNbe7fmCLBlFl3RR45Bi5qaii+bAjc7/feWKZTC13mUO7JE0t/qzcqE0EX/NcC7ZDAiU958wdkaIGGyiEcOj4=@vger.kernel.org
X-Gm-Message-State: AFq9FYIvYRK+xVrp05XDXNJ/A64WS/xdZp4/wVmRTqkqhvUHxJ5BSTEI
	VSi3pt/Iw/u808Gg0DCcPRbCfmjC5Om9qR8bweEuY1v2RXqJhlYdjQvQ
X-Gm-Gg: AYBFou277SntUdA0XBEiW+JOILkq6lFhPUmlcu0o7WAMTh1Yoahi9NAMp27AeNV4Rb2
	j3exVH+M9ct0zVR47kOZmHBMNm3yQ1IKk69rrIYnRQ0PuyUikgT3OeB/ht8GGso+IMYvBRG/GgS
	raN61BK6NI9/SU0fzPwQPnbgvpxypz3lqxfgVzSdnzXuHdwfK8dUUeQSIHXuf51XfJB3ARe4y3o
	giF7ZZaoAkuq85oUPjsb1zySS4KI+chpA7oyxwkwtlrmQIIBLrwK4b1VuZ7Qu6A/Ag+F54fukLO
	h/BHgmJugDSxIxWKqYIsyJvw6OpYOReBhEzVcy6+oPR3C9l7Mc7slrX828jLgrjhEfy4jLR7w+E
	TEP44itZUEbnc+K3h3Igf/dFNkz3Zfj16wvUwP2md+1ljqxikWrQW+jG2ax3p2S3IpN5ypP65aq
	e4ttF+twWbuLBKkkmT+z14ssNsgkb6wjtYKFv+k5tqdw7EhmE01g5IIvj32pCjz32IQEGkuILGy
	eMgE1PgWTebEJIg4QwF0vUdQevqHTF0bxij1lvhFTVrEMEfyKqjjOC/e62Hz4csFka0z2VpdU3q
	suryNHjVf6nHwjoWvn0H59xXv1RUasLC2q3E08xQB3UaGgLbeH0Jr55AuDxVL0joX1KYQTscsgb
	YvmK/3cX+dJDlGBcBXhF5qHAmpULmTVd8
X-Received: by 2002:a05:600c:1d0f:b0:49f:faa3:3ca2 with SMTP id 5b1f17b1804b1-4a1fdd14249mr60316635e9.13.1792605930927;
        Wed, 21 Oct 2026 11:05:30 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c6:e6ea:6401:f04a:ac6f:988e:f33d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fcd13891sm47007775e9.2.2026.10.21.11.05.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 11:05:30 -0700 (PDT)
From: Nick Simpson <nick.simo@gmail.com>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Sridhar Samudrala <sri@us.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] xsk: document checksum offload handling in copy mode
Date: Wed, 21 Oct 2026 19:03:28 +0100
Message-ID: <20261021180329.26358-3-nick.simo@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261021180329.26358-1-nick.simo@gmail.com>
References: <20261021180329.26358-1-nick.simo@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In copy mode, XDP_TXMD_FLAGS_CHECKSUM requests are now left to the
device only for the TCP or UDP checksum of an unfragmented IPv4 or IPv6
packet, not IP-in-IP or GRE encapsulated, on an Ethernet device; other
requests are completed in software before transmission. On devices that
take skbs without a linear part (IFF_TX_SKB_NO_LINEAR), every request is
still left to the device. Say so in the description of the flag.

Assisted-by: LLM
Signed-off-by: Nick Simpson <nick.simo@gmail.com>
---
 Documentation/networking/xsk-tx-metadata.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/xsk-tx-metadata.rst b/Documentation/networking/xsk-tx-metadata.rst
index f240930ca1df..028564dba43d 100644
--- a/Documentation/networking/xsk-tx-metadata.rst
+++ b/Documentation/networking/xsk-tx-metadata.rst
@@ -50,7 +50,12 @@ The flags field enables the particular offload:
 - ``XDP_TXMD_FLAGS_CHECKSUM``: requests the device to calculate L4
   checksum. ``request.csum_start`` specifies byte offset of where the
   checksumming should start and ``request.csum_offset`` specifies byte offset
-  where the device should store the computed checksum.
+  where the device should store the computed checksum. In copy mode
+  (``XDP_COPY``), only the TCP or UDP checksum of an unfragmented IPv4 or
+  IPv6 packet, not IP-in-IP or GRE encapsulated, on an Ethernet device is
+  left to the device; other requests are completed in software before the
+  packet is transmitted. On devices that take skbs without a linear part
+  (``IFF_TX_SKB_NO_LINEAR``), every request is still left to the device.
 - ``XDP_TXMD_FLAGS_LAUNCH_TIME``: requests the device to schedule the
   packet for transmission at a pre-determined time called launch time. The
   value of launch time is indicated by ``request.launch_time`` field of
-- 
2.53.0

