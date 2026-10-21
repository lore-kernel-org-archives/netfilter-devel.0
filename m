Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609797;
	b=ZEPTWWV1iJLUggIwhScRqVubJRlPFLD7RGTjT95uLIGeE/HOZuasuhiBilfTInqoaCDC
	 F2uT6WBnAGdxezrBGE2sjq42nUZtSqzU4WKrpiQORgFsvoJiVolhv4t3apCriLwM+2UWB
	 rzpyOwf8CHI4a/tedHxcoa0SMCIpU2UdYxAcPvcnEbe1cQyAt8P94RtpXw1VgE4bpNJw+
	 iJQRE/sI/D/iFVDKfRUuLPN1bMAUqjUAbrCA9UsBcL67qEZRfqnp6Hor6PvmwhR4/0MZ5
	 uyFSD7Pv4x/Y3aF3QdoujH+gXp7k01Lce4FcRXg55Q8eZ3XeZJOTAqET5h25shR/NFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609797;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7r8OZlJJWPg9CSRQkQY3zGgyDdsDrGgM/dRRwM2C7ys=;
	b=C6w/ZQVjcNuECZtaBPMLgy2QA0vZbIeaqxItmT98/Prl1RE4opXtPMcaxKP1vnNiSb62
	 6iNV7vbpmCeXcLl45vRx2CSYBdWiTBzyG3xSqpyDxF23t+1DVR7xkAeODSHvxzIJL3mgU
	 E79ujjSa9li/AHprwZQup6js3cKOS0eYelyJZZQTvu4O1FG6J/hfar3QFT5yvcOX3w/56
	 RxdHpqUP8Aw3jrfu6GSzmcLadVSk6eFJPy+lx2II7uR9dES0bNgnnwjZPVG70TFHy1N0V
	 yc7qLRC2OOijLZDYVRMi1mJQskWedS0olIcWZjCm1sPnrjJrNmrHMbeGvm5PuBP8S8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=b8VaqWq7;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BDA606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80BDA606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=b8VaqWq7
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so106647a91.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792609797; x=1793214597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7r8OZlJJWPg9CSRQkQY3zGgyDdsDrGgM/dRRwM2C7ys=;
        b=b8VaqWq7L2M6w1dpG9SxoL7UIBYSc6bCMHoEuhX5U/gS2nqPMZherqf3NCYBNVePDH
         D6mtj7Paip82mmuqhHdmvTAoJdzUaSvQeqGJmKphWTxwWX7WsuCHmh1lJ4XT24bWPnq2
         0rDf70bo14UaOqqwM8gfUF8Z04l37zabdD9PguDLrC+wEOKujHpYh+A/cvds1GO9dsr8
         G7FQtAxo33m0a1DGdZXRQgvG+lwdmt5TSjyn3Nadn2FclBII8/nna8xJke5ZrtG3q7Zc
         T2NWV+2rOPvWj+hxZZuDdKNX7mZy/AaIDKgzf5SHjgkntdrOgvk9Jw7xg7hVbT+Y5EPB
         72Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792609797; x=1793214597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7r8OZlJJWPg9CSRQkQY3zGgyDdsDrGgM/dRRwM2C7ys=;
        b=bHalBctZeu4mWXIYYbQ6p/LZQ6j9xyf5cDY9xd0MQVP/lgtHxKJ3viwGwFiAy9ybXf
         ZjHnZk5JSAnSbd40/eOnorrJT+xi15OpNBRwk8xE6pdrfrT2PAB0+oxdf7OI6VvLXABA
         bGDSVqvwhPNxn4KUN8yz8VFGWrBBVV/V3HDWira3gfYD4N3RfMWvfk4bER+PuGoqu003
         n8otNDlE/KfOvU5CfA5XXmWsWsYmbhyUE1/IlFedglaLDK1NKcs+hPwlvnGJejhaoW5A
         zmz1bDDiSl8u9saNzztL+0QUmtiPtuAPo4NjkDXY8oy9qVhKXF/CoFBQI2yu+V7yx5gQ
         bWYg==
X-Gm-Message-State: AFq9FYJIoiplOatibai1sAORQ+akUCLi7klkSCOOoe8DfZMzC2Fd/8u+
	B8EumcwWUJLoeL4rcF2ISgJXM6Qt0PWhq+YQ1qYJrpzrWbEwIzRiCG4b95a/nbKcgC/c8Wi0sY4
	FPRegig==
X-Gm-Gg: AYBFou3sm8QkQq4mcqdxdlx4p83+jlFGRKf03JHn9b+TUSYhpC6fNx/x5NOnq7SLXAK
	N3MF77/iZFuDFsi2nk6JQvHYSLhdv/axciWoxUXhbhvdEDYLcBca4wZepHsEv+ZfUjBWBxXp8Nm
	PA83xjWMMC3My5fRs6Q78v3az/epcDJA8ibfuYaaPwbWE/HsIfcejibdsPHASPKf/BXHoZ0T7nM
	M1/GIoTarq1T5hchS0Q9SDXOQKmxOKaub8Tp7x6hwOqxmNvMIMYHS/Bn8NaxyD6br+Yjn3glG7L
	awo9OcboOYti9TIezcS//JDc2a9oscwZitnCOBJy02n+V4drDzlGCPsgz4sXj6MIVLKmBSwqVM2
	wAhCr58jB2xMA6ZA1OjAI6W7VDfxnuaEKbd9eG9acrN8y3xHPOhFK+U5Va7C82MSAmmFJ+tZqSz
	s8z9XV5lGKfV2v8bVmI90GJl2vdX7RMGMN6B4bG0XMSAcIdVuujKgerV9gY2YoZ4wn+FmUh86K6
	qbtC5I6f9b8NsQ67D9gZ5cXv8svRWUULR67uPEhzeqFyArf2e4aOz1aYFWBZ25SJtIXCZY=
X-Received: by 2002:a17:90b:5403:b0:3a7:a3c8:8f4a with SMTP id 98e67ed59e1d1-3ada6c7e603mr141949a91.18.1792609796784;
        Wed, 21 Oct 2026 12:09:56 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([203.175.14.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed719sm706599a91.5.2026.10.21.12.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 12:09:56 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kadlec@netfilter.org,
	zhilinz@nebusec.ai,
	oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa,
	vega@nebusec.ai
Subject: [PATCH nf 1/1] ipset: ignore port ranges for portless protocols
Date: Thu, 22 Oct 2026 03:09:42 +0800
Message-ID: <ab8bb46b65a7666885cd5fe0fccdb0e39e279674.1792609477.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792609477.git.zhilinz@nebusec.ai>
References: <cover.1792609477.git.zhilinz@nebusec.ai>
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

hash_netportnet4_uadt() canonicalizes the port to zero for protocols
without ports and clears with_ports. The range path nevertheless reads
IPSET_ATTR_PORT_TO and iterates the supplied port range. A request with
an address range and a portless protocol can therefore add keys that
packet-side matching never generates, consuming maxelem or evicting
valid entries when forceadd is enabled.

Only expand the port dimension when the protocol supports ports. Address
ranges continue to be processed with the canonical zero port.

Fixes: 7c3ad056ef79 ("netfilter: ipset: Add hash:net,port,net module to kernel.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Link: https://bugtracker.nebusec.ai/f/12359
Assisted-by: LLM
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 61af1ce271279..dd6cf8c36ba07 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -278,7 +278,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 
 	port_to = port = ntohs(e.port);
-	if (tb[IPSET_ATTR_PORT_TO]) {
+	if (with_ports) {
 		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
 		if (port > port_to)
 			swap(port, port_to);
