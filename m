Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16772282FC
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 16:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724344539; cv=none; b=Pkm5JNLWnyU/wfRIemsmD84rxPdcOtV42RXfdDT4xmr3Fa8hkDgmfmYMCCckcHGOb8ZWilWk3s7deKpUAm1j5cpHidNQ1QOFDyEkEuYdLmWUTlRjAdYdmMIYIbbqEuIxwUheZv1Ej7gFipkj0MPPf2DFGC20jSEupx6XUkw+PhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724344539; c=relaxed/simple;
	bh=FBYKVMJL+SqEiUBoH4C+35D/h/f4ouG+veDm2SQ35+A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=emPsPGuSSHqIfs67TED3Z5qp0Tv+xTITcCRgVCAYmZbNZUS4zPN7N0307X21IB4PVkzZNNjx0EzbvE8H+MsizLeLbzbogXbREq5ATRfN/mS7NMZwF4wQEsmb0O1+JBJJivahR3tmR5uUYN8twULjwyI0D7YlM7E+s+C96UyS8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U4cnfugh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U4cnfugh"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-428e0d184b4so7336505e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724344536; x=1724949336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sXhc31SegQW1u27Vkqy2Da0iA0P0HOdns6Pieyn3XAk=;
        b=U4cnfughsPsBzp8TA4l3K46xhBSPzMRbX0EW0rIBBuVowgBViLzHEIcMqosrVaw3In
         wnJMt2b5AJs/Q7sMFeGgcGOmIZgb3b3asqG1oQ3YBZr5BlOWM8ipN4mGMK5uPMqqnEXm
         zy2kqarXmP10CYpBXC1497fAii/IPESX2TgFqG+HIO35QNpdv6W+ysVK4YD4Up97jcOv
         phz9ZKC/SWq2xqjAEdF9vnZq2zaAscj7AoZDFX2eHxLSelg40fetkNKNp06DwatTlDqH
         dBlxdcn3iXYQ4hdPKC6LxdGeEG38dtI71lYAemsYwglHXnJ2X1bgVbLn46rT789Fx/Py
         Ku1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724344536; x=1724949336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sXhc31SegQW1u27Vkqy2Da0iA0P0HOdns6Pieyn3XAk=;
        b=RqBAfpmGV3fD75rblcaC2ljF03RPTr4PIWF0ZMZdFNgYEfglnEI1h1Lq30iA7XK/z4
         HqBBtKMRTu3uINCvyqMpsJTAJPOzHQbEtmnbiXGvtRFIeJl0DtodgXZezR09lwc5oDsn
         AqW5fnNinR4YjSx7iuaI+o6EqjLlPmNxPbR4xXJCUV7AEdiZb7LpA0WOsB0X7QKo4VVC
         v9A4+2H1HYacvtm/a88dhKxqggJ5reSyLRRBd/ynw7MxgFs6LJgLu8GhjKe/ZanlI6/n
         bAl+Uvxf07XCg/AS0b6Wz+4hT0VkaXRYzN4S1ei2+ahOAzk2m8nwNwOSaEQ8/cDNUuYm
         kn/Q==
X-Gm-Message-State: AOJu0Yw6z25CcVjZVRSim0cckUQsSCHvm+7wpgi/eKGdwROOQSZ1NWq4
	emVkEgJ8m2sdqTJi10KqxOJUWptYPM7UbVfy9VECgQRI5fQvR4Svh5Mz9bDW
X-Google-Smtp-Source: AGHT+IFWCjQ+sPbLrNLwSi+EfZ9kJedOc/icbMZbcCn2W1NH0c6z5gXLeKPM40nYBiBr7eAZAXhd2Q==
X-Received: by 2002:a05:600c:4e41:b0:428:ea8e:b4a0 with SMTP id 5b1f17b1804b1-42ac55d9b1cmr17493145e9.14.1724344536156;
        Thu, 22 Aug 2024 09:35:36 -0700 (PDT)
Received: from jorge-PC.. ([45.157.58.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ac5180106sm30186045e9.41.2024.08.22.09.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 09:35:35 -0700 (PDT)
From: Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	jorge.ortiz.escribano@gmail.com,
	jortiz@teldat.com
Subject: [kernel PATCH] nf_tables_ipv4: fix transport header offset comparison
Date: Thu, 22 Aug 2024 18:35:32 +0200
Message-ID: <20240822163532.12244-1-jorge.ortiz.escribano@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I have reproduced an issue affecting some nftables meta expressions on the egress hook.
With the following example ruleset:

table netdev test_ndev {
      chain out {
            type filter hook egress device "eth0" priority -190; policy accept;
            meta l4proto udp log prefix "OUT__"
      }
}

When small UDP packets (< 4 bytes payload) are sent from eth0, `meta l4proto udp` condition is not met because `NFT_PKTINFO_L4PROTO` is not set.
This happens because there is a comparison that checks if the transport header offset exceeds the total length.
This comparison does not take into account the fact that the skb network offset might be non-zero in egress mode (e.g., 14 bytes for Ethernet header).

Signed-off-by: Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
---
 include/net/netfilter/nf_tables_ipv4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 60a7d0ce3080..0f11568eaba6 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -33,7 +33,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	thoff = skb_network_offset(pkt->skb) + (iph->ihl * 4);
 	if (pkt->skb->len < len)
 		return -1;
-	else if (len < thoff)
+	else if (len + skb_network_offset(pkt->skb) < thoff)
 		return -1;
 	else if (thoff < sizeof(*iph))
 		return -1;
-- 
2.43.0

