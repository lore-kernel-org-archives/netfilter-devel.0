Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75593EED8
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 07:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775633749; cv=none; b=ASV3qo2OWeyYQb+lgD122+kCFaDp663rlyUeVZm5hAHxsTWtRJzIxT2k6T7AQrp7XjsU9/bcrQzK6RKqcGqJ7lKcbTC8vI051OghSuEPxh5xEapJtdb+g0CXxEmW8UD9YbLSr7fYFOlG0CkqXM9VbatMNDin2kvEL5dfBEcGxhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775633749; c=relaxed/simple;
	bh=R7PA/g6K4REX21a1EZN0dOR2dm5+usLDZ0alII/Z+OM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cjVh0ye2dLy7kZ2zMle1xVumnBx0+nuA4BP16d+u+ubOuggKoMzx+3jNqw6/J3OjQ5l8ePG9E9CRFxLP9aW8zmlf50easy28QbIwvq6vDL9R78DbqnVFMrGw416kjWkRvdszN/QBAd9R4IuUdcXsMO7ZDDHuPl97TgpeWWsNygw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dxoi6Qpo; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxoi6Qpo"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so3739389a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Apr 2026 00:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775633748; x=1776238548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h3bM1X10xUppCtHTO+2IL4JdoVmrCaHQpNjU1IvmstQ=;
        b=dxoi6QpoDyeuiYCxMCzajRbf3uxydcZbn6q7ZnXbu2f8PbeFQeng5VhVbK3MAciHhA
         jGUKr9KNhm7CA9hqmKTdFUsc+LdcwEivZn6zmoHcQXsz58msejenVbwp9AbAaSqWeX4v
         /E0WQJ2xpLIhDtHrACr8ZUDZXSY1vL3w9c2B1xCYuelV7XQO5D1oIcIoNKRuKLcv1Io9
         y5uiNERWz7xYiXLIn+aaGZYORUknZM/fhiAvdEj5JKKD5gL9tYPWRk09XHPNd99iYBHK
         +V3W3PM9ECnxgzOojcHe//GBE7+eO9cSoYyqwooIAd3WAdrNAm4zso4k/3jUmEbHNSiW
         pOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775633748; x=1776238548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3bM1X10xUppCtHTO+2IL4JdoVmrCaHQpNjU1IvmstQ=;
        b=Zoac9NSpCP+U4IunSE6w3G4XcS1iC+CM2gtALlYaTKWkQ04TQx7u9IUNOjVhDRjepW
         ymFVAUIOt3m7/wueBiKad8ycmEClNG/x6SxBX+DgrcHfFdP7o5XB/JpcKatpOD0JIQXY
         aK4papPYHosjVR/qlrGb2WzkDR700BxlJK3KVK8yX4VsFELTpT+UXYmzf0CSH/J1D/uh
         iwixvOjPN88xBkE5VubwKQO9MxOfGe33IXHysFIYIe3NuR6VEwPa2sx57PTV3X7nEE3I
         Us0VdO7FsTApejTsPqf+KDQHGP3ZUlIztuqmlRWYf7m3Ihk/Dv7K9PlFwJT4fTYL1y0k
         JxSg==
X-Forwarded-Encrypted: i=1; AJvYcCUmuWuC17053mewL0V7NADqSSy/PQ9jBuYY4LLoD3AAnq9iUgU8B5a1ysA8dXidW+oRnG38vtLp29q22j0w018=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2y/zcEM1JDDHyUh0pzgOHktgFhy6hCXuuIJbzf2PNIO186L5w
	rFNMRgv4bIS54Q+LVe5rMoLXg2o4/r5moHytdJ3KOnmhrOtypAbv5pt3
X-Gm-Gg: AeBDieuNJvsPf8B3r8a2+jSroa/58ACCScUiRj5QNy989hlGDIS5WF4oUapvNzsf1/2
	Pyvylq+O465adBJqA6i78QuNHU1P6WCGxOv/NZQwtRsMp24rNLoKyuFEj3OUkIOcHV4iu7IA1ef
	UDRsL/z1dLCH5az2WH0QVtE1NpVcV4CckkKkhyfE4RDoUutCCgoGAUOQkz0uGLL4VvahBG0HGXr
	6Z6XIdeoPqs/lRfFgJ7J1dwRLca0h+478YfbYYvgRqhOgZ/0CIp8rVviqq8UxP5pJFRC/t31m3X
	Ow8IEsZ8cbr5FsUaVw/F5vB496Yc1xBxF/fd6hIu7+6ubXoLG2abjjF9Cmis4enT/KWeUL8hDWm
	ieQDMMKSbXnyGfXE2ipLTw92ipL4w768vI+fPto8HtLNSWKugnkvWw/hWqE3s6UZoB8SXFdL1gY
	k2AT3O+ARCK4lTpZZD2SgkmcUr5XH0ivgB76R1HXeGbClMffG6l3rAp71/m5q7MA8UJTSmTvNC4
	cbU8kKYarO4
X-Received: by 2002:a17:90b:2e0d:b0:35d:982d:96c7 with SMTP id 98e67ed59e1d1-35de6980b71mr21542963a91.27.1775633747539;
        Wed, 08 Apr 2026 00:35:47 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e2734c88asm1311610a91.2.2026.04.08.00.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 00:35:46 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: arp_tables: fix IEEE1394 ARP payload parsing in arp_packet_match()
Date: Wed,  8 Apr 2026 15:35:16 +0800
Message-ID: <20260408073515.79296-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arp_packet_match() unconditionally parses the ARP payload assuming two
hardware addresses are present (source and target). However,
IPv4-over-IEEE1394 ARP (RFC 2734) omits the target hardware address
field, and arp_hdr_len() already accounts for this by returning a
shorter length for ARPHRD_IEEE1394 devices.

As a result, on IEEE1394 interfaces arp_packet_match() advances past a
nonexistent target hardware address and reads the wrong bytes for both
the target device address comparison and the target IP address. This
causes arptables rules to match against garbage data, leading to
incorrect filtering decisions: packets that should be accepted may be
dropped and vice versa.

The ARP stack in net/ipv4/arp.c (arp_create and arp_process) already
handles this correctly by skipping the target hardware address for
ARPHRD_IEEE1394. Apply the same pattern to arp_packet_match().

Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/ipv4/netfilter/arp_tables.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2da..4b2392bdcd0a6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -86,7 +86,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 				   const struct arpt_arp *arpinfo)
 {
 	const char *arpptr = (char *)(arphdr + 1);
-	const char *src_devaddr, *tgt_devaddr;
+	const char *src_devaddr, *tgt_devaddr = NULL;
 	__be32 src_ipaddr, tgt_ipaddr;
 	long ret;
 
@@ -110,13 +110,23 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	arpptr += dev->addr_len;
 	memcpy(&src_ipaddr, arpptr, sizeof(u32));
 	arpptr += sizeof(u32);
-	tgt_devaddr = arpptr;
-	arpptr += dev->addr_len;
+	switch (dev->type) {
+#if IS_ENABLED(CONFIG_FIREWIRE_NET)
+	case ARPHRD_IEEE1394:
+		break;
+#endif
+	default:
+		tgt_devaddr = arpptr;
+		arpptr += dev->addr_len;
+		break;
+	}
 	memcpy(&tgt_ipaddr, arpptr, sizeof(u32));
 
 	if (NF_INVF(arpinfo, ARPT_INV_SRCDEVADDR,
 		    arp_devaddr_compare(&arpinfo->src_devaddr, src_devaddr,
-					dev->addr_len)) ||
+					dev->addr_len)))
+		return 0;
+	if (tgt_devaddr &&
 	    NF_INVF(arpinfo, ARPT_INV_TGTDEVADDR,
 		    arp_devaddr_compare(&arpinfo->tgt_devaddr, tgt_devaddr,
 					dev->addr_len)))
-- 
2.43.0

