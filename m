Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE7E224AE0;
	Tue,  4 Feb 2025 19:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698678; cv=none; b=Y5RRiaDTccy8zPQfmcPx782jtXhyfksor1NccW8q9mVkSpNk/+FOM7UZPeJimE64IDAC+cRJrURDKYoj/tOtdyYwAQyu4BdeJ/im9jgOzDGZvsJv7sjPK6fpcUx9PXrZ85UFSUWsMSiyRTILmZN4N5fAVgjnMEV7ehXNYEqM+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698678; c=relaxed/simple;
	bh=2PoSot17IPgvGrwZQaLK7OB047ZHzlEQm5SMVbwJSC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWUQBEgzgg6uD8oyadomEF+2EEbdlt7qPq2P034JaPFyIo/lDCGbpNEDnGkA9PD0ut+e+qvCa0IoRLrsyGrTv2SJFXxqB/dMe4VZRQsY/OUUkzjBK5i1hYF7L9F3lMTejE3nHhJgNGS2FxnWBS8x7MaRsVL1DdVrjc5kpTEQ9sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhSBazyO; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhSBazyO"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5dc7eba78e6so11473618a12.3;
        Tue, 04 Feb 2025 11:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698673; x=1739303473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x3zGgQftF1kIqFcOzW0oJY2LAeldvT+ZF1lgB5sAD0U=;
        b=hhSBazyOqacEijGUxAe0LCr3W0LKITkxiNlQcSfU7e9PMoNXu+nIXpkiXpRH4xiufT
         Wr4Nl1gKmG4BszZ3lnr95YCW8s3WFg65rzRp+/YQYWfy1ic94WxJMwkE0R0PnzywwVEN
         40lOdaIY+IUbSbkIXPhcHt2sH4t2c5A1iOWIn6yBHULDm/Y3KWzstaKbqfSz9dEIaPRP
         CuxbYIydiud2nVte59j6agVOpx2ORRyQIuB2Z+Tbp7/80R5GKjVkcbhgUcUCv5h1dNQs
         u9iLiL9qDCHAzRV7nbhYYzG9sPFg9daKNdUSQBj/QBL0P8sb14cmzVhSOtHOiQI7CzYm
         1RBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698673; x=1739303473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x3zGgQftF1kIqFcOzW0oJY2LAeldvT+ZF1lgB5sAD0U=;
        b=Rm0xpYsPcOY7Gu/zGYxjobJQc1eAWSLvtqOWMUknIq1u47q4o6oM4wPhJn/J94HDoQ
         PYdUWV4yH2GN5O8938wYPwyzMzpepxHkOR93f0C70c8WU2dysi1xGFpPnmO1TG5ngJ8O
         /3Ni9KBUpBcQVs1gt16+OG56WjK5bdbXw2qnMqJJ0tdzXCTj5WCfYW49OTphSnZhaf9b
         4v6bhSNO0Jpd7vufzfAON9peQvZaf4qjh0bkQxh/8RrZAl6VxAFGrrwOZJxeLml9VAum
         X/Pdbf+drPSB1h4DOfS5/J68NqURPT9vc89+9fXJKssG/3yj9+9c8mBc+IR/S/yHWuoI
         uZeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsAaX1Mir3cZzEBd4mIIek8rNMTP1gpNJwnyWl8Ms+18o26NcT79/DuE8q5rZXVChgfhQnGYzq@vger.kernel.org, AJvYcCXtkV4BToMuvkzSMymtoFT8VQfH+RDzGN2R8OiSecd2Dnn24BpQwOLMZxsH6dR4blJIBPGqZBfUIkADVCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YygWjprDd65WvRqMrlhhxQP/ibg+f9uGEQ5VXpsOeidhdq1jGYW
	drj7YeV3Ef6luHYh3hB5frJdrReaoSfmclOmxm274cbOIHKrR4ta
X-Gm-Gg: ASbGncs3ueRImFZ1mz4VXz533ID9/7OcQLm0674zVFmrOEs9EULTQajuNs5omS3vCET
	Y9HGsrB3nkgeeFU4M3Mh7fp6lXL/algqxW04iCgDoOwWgIYtd4B6oaGWzvQU5ucvs/MNrtNt9ZJ
	akmKSUpiE8rErhs/yYM6LR3GGuAZLEcuIWJGV+IxWTcM7zI60uUTwy/T2NMCDibH6XufiQ2c814
	PenKP0wyjUcsmGMBNqBHqzmBLOkNrNgUSrhn0soN4o6rpVXWNR1vXzw4LMEANhoxoTL7xJK+Wte
	Cca5VFOpIuhdlOeNivL+dF2n8llY3YJbg/NzY2i2kwysYDCfxYOLSmSTtp+t1diUCLiNRio0jDo
	vfkJVhvNKSuu0QKr0iLf+9Y3JihItU0rK
X-Google-Smtp-Source: AGHT+IE1cdz3QZi6aI+tu6CPKVmHIyjStvTV0f6+YD4twlTG6cziZ2eM+8EllzapzGBoL/nwwCR35w==
X-Received: by 2002:a05:6402:234d:b0:5dc:4f4:74c3 with SMTP id 4fb4d7f45d1cf-5dcdb71ff84mr262477a12.4.1738698673469;
        Tue, 04 Feb 2025 11:51:13 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc724d9de2sm10074894a12.81.2025.02.04.11.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:51:13 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [RFC PATCH v1 net-next 3/3] netfilter: nf_flow_table_ip: don't follow fastpath when marked teardown
Date: Tue,  4 Feb 2025 20:50:30 +0100
Message-ID: <20250204195030.46765-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204195030.46765-1-ericwouds@gmail.com>
References: <20250204195030.46765-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a flow is marked for teardown, because the destination is not valid
any more, the software fastpath may still be in effect and traffic is
still send to the wrong destination. Change the ip/ipv6 hooks to not use
the software fastpath for a flow that is marked to be teared down and let
the packet continue along the normal path.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b9292eb40907..84a8fe7b7b5d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -543,6 +543,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return NF_ACCEPT;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -841,6 +844,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return NF_ACCEPT;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-- 
2.47.1

