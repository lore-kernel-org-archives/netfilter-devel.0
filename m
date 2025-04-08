Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC591DF99C;
	Tue,  8 Apr 2025 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122285; cv=none; b=FV4PtyBQWMKORxxfdxB2ya+T6qsf0xBjIOAB80/Itr8n06xhrNCNl8Hb+HVzP1txjuCqUOJfxApsrUsbZbNH1xtX8fekhoBYJBbkPXuc/mD+n3Pos67BTUG1ncGcNN/khkuL2BOTYRdittvGziou35OQRS3qpi0dvcnx/qMJzrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122285; c=relaxed/simple;
	bh=xVFuMXsHme978IY/KLHqPnq9Gs5sHCEFkAwHkhU1IlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eXUMcbk29R6l9BN7lqzmFOplKgFlEzuFlMNdAoUfSOgJ07dmCq/s1kBoTa80WHoUwwhjsYhBgrKUhHzW6fK4yRYacbKAC80X1agPZ9YW09Ra9MsM8LBrkP7SqTqQIH+SNMeQMl1Xunz8Te/aOv4O+Kz775i0zrnvM2WrcbFPN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f1vkcoUI; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1vkcoUI"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so859328466b.0;
        Tue, 08 Apr 2025 07:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122282; x=1744727082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fKVAjikSlDmRp89nXnj0WKS+vYgTLsVIQjTDqAQvc3k=;
        b=f1vkcoUIsoWKlGd6OLNWPUMaIdXHHLdtKxnME7TwLaun3XkNHVvcEN46kiz9EM+4Js
         CcRxPZTIkPZdvDFE44bejau8V6aItu8c2tOtEoOkInT/e3ofih+BtTiETRvkwmbC3KNn
         nJGwxjtLiexu4nLSwUuS+BDb1HAQAhnzHm7/x27wsIbT1dNazBTGHqBbLjMZeEfYOTRW
         6n46ZoRuQuT35uoyf8A2PGzpwoxQBAYCO1wsJrcXmVhIlsPXwY9HeGNbthGfGMiw+l38
         BVpWKY1sdteBGUDGxFNiQwjqkJMZlnDV7HG+7IpK9A+i6w6FDkld7/oaqX39BeHVQREQ
         TZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122282; x=1744727082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fKVAjikSlDmRp89nXnj0WKS+vYgTLsVIQjTDqAQvc3k=;
        b=BwEgij/akk0g/SDm7xwMWQr6k48Ees+pggj1DU54CZckwsn78NtBHVitLn6ncyB1Zr
         Fw3eohGhLmVb019B/aFLKnv0F/+yinP1IGOFT9C5KD+9GWN4i4bY6gt7Lu+FBb+CErMh
         q7BeuWSddqWD0HArGYUbowjp8I6CblIyCJeNM1YlGxxeKgEzcdnMB+TzN4vsR9CCKv0v
         f9Jxl5a8J3OpdKfAueMYCbYii8s4iwh2ST/+9InTMwM6OP1XprpjIUr00vsvPZzUJUkO
         JdiM/BMRCM3P9qaaoDklhfOWzthJrE2ro4B7+WClHrz+sROPz9M4Ww2gTwKpGSRzO99f
         rmdw==
X-Forwarded-Encrypted: i=1; AJvYcCXnmcWbjW6aLh+5zCnSGwz6AdQI8AZwnzoavnarhcrEylV7MUK5sj7n4PlXUDr+C+aTKRBespbwdWaJ5ZTVjsCL@vger.kernel.org, AJvYcCXpGTywdMkVq4yRFC1Kq+1dUgMXJEsM6yB5/ysTcus7Egg0KBwWcX4VgRK1s96g4i6k1SMv1JKkl4RHcSTmPzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwVxI4pJRS6N6jrQ3tWdP13vlNtM6bnA+v/OaTFFoBNwC2viP2
	4uqrFPwUxl+3+zKOijf2ZMCAvSD4Qh4Wze0Rjg28z6zBQ5C/R6K9
X-Gm-Gg: ASbGncv+4REHZejI9axuVjN+/x4C6nMPd/7vn5T4nuO//jYUN1cacs9YJxCPE6FZoJf
	RRtCnHKbq96E207iAGDDuS9QS8ByNXzNnzEw25cEJiAO8sUOhRGYvjzrk9kiBe0NE/x1G4I4yaA
	4/2x28wW3/yAlHtHa1AMlOBEuBAEayIc0SqNS8TG66mXADb3tyUoK4Bi2HIbiv/1yanvcUffLYI
	S4YF4PTtCYHmXHhTZd+98QUc3ih2wTCS8/+gWrHAjmiAgtecwzL20xeZ6SMwhJY6ugcoAeIoC2p
	hCjPTfK4I9Ax+LhQqKEetlYcCbrnbHu7AuOXsSmbjmKcIwn2t6upyWVUV16nuSXnmwDwh/Aj73x
	CrmA9aBNKwOSrVyJ88KLrZ2dgI5PGk9RglJW/UmhH3oxPyvyNsGIFPDeU5qAN5SI=
X-Google-Smtp-Source: AGHT+IFlZaybpe/j2Zow/p3HDFGofOuQSMcWsqmHQWMhOGtI9vBund4Q9QWMKTuUyBXPUyMoandRAA==
X-Received: by 2002:a17:907:724f:b0:ac2:cdcb:6a85 with SMTP id a640c23a62f3a-ac7d6d2b3f4mr1401815466b.22.1744122281602;
        Tue, 08 Apr 2025 07:24:41 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c1db6ea1sm928770066b.143.2025.04.08.07.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:24:40 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 0/2] Add nf_flow_encap_push() for xmit direct
Date: Tue,  8 Apr 2025 16:24:23 +0200
Message-ID: <20250408142425.95437-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch to add nf_flow_encap_push(), see patch message.

Added patch to eliminate array of flexible structures warning.

Changed in v11:
- Only push when tuple.out.ifidx == tuple.out.hw_ifidx
- No changes in nft_dev_path_info()

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (2):
  net: pppoe: avoid zero-length arrays in struct pppoe_hdr
  netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
    direct

 drivers/net/ppp/pppoe.c          |  2 +-
 include/uapi/linux/if_pppox.h    |  4 ++
 net/netfilter/nf_flow_table_ip.c | 97 +++++++++++++++++++++++++++++++-
 3 files changed, 100 insertions(+), 3 deletions(-)

-- 
2.47.1

