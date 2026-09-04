Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7FF3546C8
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 11:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522347; cv=none; b=JW/o1gfd04lAZC9FHAR4F2wYN3RDub4QJNGfLaA2+XcQWFtefVfhywSQaB3kDcKeMWJh8Tob5r/LksrEMppKlVPaHum3joW2MloehPTYli26V5nHj80ZtFospSZHrHz1q7yk8XDzspQLTcjnJ/UPJdyaVsG0E3Kej4Gtd1fGbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522347; c=relaxed/simple;
	bh=4DYiEOsZKjx/4f4PSXfRJejITB67NJXF4cNdrqZROfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XwLK7UqhPaiyG/Qdq31UnsyigYRO+tNAcyfrcHWdXYKsubWl8Y82knQlh3fp1U7j3ioO3n1DbfSiSMUD+2nI2HdVeq4JMd2fucCZ5UQP2K/U8/ggjdZ4kYEppIMw8jt2dqChvT4TBgyvkXzQ8cxgf1l52PC1GkSOJnOBs+OzE8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=glMIBwnc; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="glMIBwnc"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so1180374a91.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 04:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788522345; x=1789127145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ypdm6ycnQEZOWN8WJPUUE2HwMGTgKp4dCj8wtNt7vJI=;
        b=glMIBwncTttwvAe5mGxgfuLlNw2tGMxm8GK/vE00V2EV+D5nQR4OM6pDKnTCDJrarr
         VRIIWrSu6Be0a4wwUH4gjT8BU5fH1e37niqC+ldAEXYVqls70gcwILPRRkzbx7xiHlwo
         J1qS6IFF5XtXKY5Rf9gUlzA2eHQRg9qSOWhVh/M2Q/KayChmZdJnhnjGVCfLMD2Gx3qh
         qg6L6OBBKVIizJqTTuMEq6xrsiI95TFv0ww/I0nj3vRANAIJEwlWuWQ0w+elFtwMZxRN
         EGjA5Q8W5qjTrdOW4B0X1q3TpCr/6qsCZ1PLme9zvwwwKlzwtNqiVV3+IRDknIlfRDYA
         KJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788522345; x=1789127145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ypdm6ycnQEZOWN8WJPUUE2HwMGTgKp4dCj8wtNt7vJI=;
        b=o43iWmnp7V2hWhc9r73w8jer2uhi/aBQpz7OFPiTFAA5hk+AmOMWLoGjZYR0kK7qCz
         jCofz0Yn5dS0Ry7LEyG7PFfSZU3Tr8BMldAMwehHgvB37InErzEnPjLxZt/MLYug3LzE
         AYi11GM0yrQSdj9hVVI0UJtRlocF+C7sT0lXBFCxwGS8quWMyrwC+K3QoGC19u+fXrqJ
         rtHDDihH0ysTi2zJEQAQM4TyIzpVPUDe5oZtFWPNoZsekKMVofnuN+VaiU/16IwEZZQj
         uVD84qvtdhrUnwODKDfNLPPpiVfmt9JAPSbH8HvOEKWu8KECVa89rqTGHBvA2n1oOfWd
         bHAg==
X-Forwarded-Encrypted: i=1; AKwUvBwJCCF5lvB+CFsQMtuKaY78747cTORL0lBNRI15r97FYtDmEWGtvOCXILS1rIMEnlDh7JiPFk1d/u4BUf2RwA0=@vger.kernel.org
X-Gm-Message-State: AFuF++nBtFAUOVdJHNYWLW1a9IHzv9bRn1WtK8VkhjNgGOTMNZLEYx1y
	tJdT2dJxj7TgVroStpIl5HAqI3XkpWYCvfq85RIq7fsbaLRJxEIX9tBj
X-Gm-Gg: AYBFou0jElYzJ14Ne8/Iy4yCDv5M+Gps56Sc5PMJXi0uNhl7eW81dUoF4TZ5vmIkZ3S
	0WDsezZZ7NNIdHtU9t2cQjUPlJY69usBgGJj7Q2vwC+YNE0QWyCUot34Xxhboeofhsm6Zm/jYZh
	NiRzEeUnR+PjrCDptPmE06vbwpqVyobjJe8InM61KZF5XNT4Bwou+U4DonsexjlaUTrAdJrb7U6
	QKG+T/Rqks5rpvoPMjhCMDpEKm6pHaEOAaWm9pcHE+CcuS2YdkaiH0R4D3IKE2M6U2fjYYXbwy7
	YxhUS5S+PT3Xx+kROJDU7AShcSEOAux3EFqoEmvjgJUO4JuCS5qaQm8Z+cNmPmkJPorG2UuFqsg
	RHKOFxwDOkH3pdrrK2hyFfVTJxoaiil4iLoYuRBSJpkWVjUYn7702+3+G0yabUOWareAQRVofRm
	L0Xd7nCXF9OUAKV8dROgcqNWJVZKjWzX+UPP4wOUv806W8PcMMDo0Gedt7HfL56phLm0z1S2rFn
	kZ5jflRm9hi6h1WJqPDzjcuMA==
X-Received: by 2002:a17:90a:e7c2:b0:398:9be8:ea66 with SMTP id 98e67ed59e1d1-39b261da126mr7004862a91.19.1788522344797;
        Fri, 04 Sep 2026 04:45:44 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339885ca07sm7148372eec.1.2026.09.04.04.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:45:44 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH] net: netfilter: fix typo "specifiy" in comment
Date: Fri,  4 Sep 2026 17:15:36 +0530
Message-ID: <20260904114537.29953-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "specifiy" to "Specify", reported by scripts/checkpatch.pl using
the misspelling list in scripts/spelling.txt.  Only touches comments, no
code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index ea5fdd4f4ce7..5ddde3ab2e59 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1344,7 +1344,7 @@ static void set_mcast_pmtudisc(struct sock *sk, int val)
 }
 
 /*
- *      Specifiy default interface for outgoing multicasts
+ *      Specify default interface for outgoing multicasts
  */
 static int set_mcast_if(struct sock *sk, struct net_device *dev)
 {
-- 
2.48.1

