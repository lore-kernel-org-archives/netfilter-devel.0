Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABD11A7264
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2026 08:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781944672; cv=none; b=ABqCEKeUVCFYp/Vw0HqMD/+8Lq4BNMA/XfUK/goYB4l6bYTferq3z9eYRo61r4KnGMcabDkkvhf7Q+2Mv5r5E4LgSBJ7284uA5gbGjqRYKT5+vKcQ31O7+VmydgH2IvB4m9CZO8dHLylQo1QZ4E+mb03tUU/5NhXj9AyI+K6D5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781944672; c=relaxed/simple;
	bh=b9wi5XUEcz8pPppRQoUDV2aUCl3X3SYt0gdeWTdFXlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OZQigaEFcZrFHSMla6udCbZvzwshLva+VsOdDEjourpKtpY4bZYvBlsIDjgBEVgYGlbXXZUzw846MeGvV4IMOAUcDQ8NZ7rXKQ+rHqEUDedC3UxuL46LXaaHTLqBNCf9eHRqKS6/klH8i/jCIvfQt9DXZLDDmpkJwFeWt3+QSf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WnBAhr92; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WnBAhr92"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c6ec0af575so17372925ad.1
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2026 01:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781944670; x=1782549470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9e9XvqeK8HuCBoopC3lhM483k5Kob/7qtMAMAdob/Pg=;
        b=WnBAhr92xpxAuoMrEv6HLx2ziSZiW6LaEM5NafchzApsn0uW5ZGETXMmLVYymD+PcV
         DOnki6t7W2A8NT6u7ipQnbEaLcBTk+3H+DGzPQ3S659MNS+cyNhkLFKLYHh8QJRQQ06S
         cndSocyTpO6jN7T7ywO49QmGSPrCtbIkVuHIueIfHiHnU2IHI/YnN4WZ4EsHixz/VkqI
         Mfz+mcGOD6gK8RLLMWmuPNkAjfCMmAXaiOgtExVL3SCiG6/KXim5/SetE7iyAFf8SS6J
         umRStNFEpwdPdYGfW3Z0vCWhNZs9CFmu3bnee+YzEC1ECvRQZ3o6RIT9Ra8zVXQaZ6ds
         K5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781944670; x=1782549470;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9e9XvqeK8HuCBoopC3lhM483k5Kob/7qtMAMAdob/Pg=;
        b=lWkbsmE1UGZeOdB1STCCUwiiiPxquQqsWw1rgpM0FtUFaiI9e8FGCmHkIBUDRTEpM/
         oceJwbMsM+whejKyRFVLgJGU7DhC11yX2RU2zoSuWQv65pDoVHhLngV9KWFBK3dObkHk
         YDMJWOCDtLn5b39ljArm+xg0moyOdExsKRNRW2IHQmIJ2RCgfm86X1EFWCEsK5nHyivy
         KEDOU+v4H3dW5PoGRvtgRwfN1sHJzjXQuR3iQfiACjonMUlDLCQGEVKXcbtX95f/QUzw
         Ltyesa+cSDfJJkXST2G4WyisFramaBPhnJD3TsdGPgUi3opMPVhaahVcn2oHQVG5hgxm
         b6Fg==
X-Gm-Message-State: AOJu0YyqVaRR8K6WGQbP6wasZ5B2h4IjHPyFlP4a7MRL+7q58VAiR1u2
	sU/arRUI3ncEJKxrcYq+z6dQb/11cX7HJe4raoz/Rjt5G8BocdPP3BfZQcz1lCoZ
X-Gm-Gg: AfdE7cmfyBCbq0deAPALa+cACyA0W+jNTaFHL601OL25SjTGDZcM9x4s7CCifqIPwOB
	QPzcQ51NqpjkIrKSPXvpT1aTsZiJ+OSgWtVDSW9lVEWyo0mszaIhYxWpfwwswgYn3vVQ1z/CQze
	6Kj+L6VrtaxOZHSYz7QYG6TW5TvSavYOwJ9ciVJfr4l1/SDBuru4xcDorOmjRUTfoAWNF2AgV6h
	0eEXwDibTC9dxVSRIXN2wNFXZjmobRZBayU7sP0qOCcUO3QFh0+mGCfYumVN6GSGkIjTInrpSEh
	yZllieaY9flwAbF7eKqzMl9bKqGsXCaXeqzhDXzCJmW6EflDpTtiOUZcFshmeBCgnp/ffTo2qJf
	rNm03ER4eLsSTvJ/4XDjPKxtadvek0OQQk0hefMB0U/qplUFuCohq13P26cgCQghIFqEzwVFL0h
	2+uGj+kDBIxj1k5THEG8hrVY/PFymGeMI6uHIMKw==
X-Received: by 2002:a17:902:db0e:b0:2c6:8e82:977c with SMTP id d9443c01a7336-2c718cbdd0bmr71177105ad.15.1781944670203;
        Sat, 20 Jun 2026 01:37:50 -0700 (PDT)
Received: from fedora ([116.73.171.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af57asm18814055ad.13.2026.06.20.01.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 01:37:49 -0700 (PDT)
From: PrittSpadeLord <pritt1999@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: PrittSpadeLord <pritt1999@gmail.com>
Subject: [PATCH] minor spelling and grammar fixes in doc
Date: Sat, 20 Jun 2026 14:07:17 +0530
Message-ID: <20260620083719.115461-1-pritt1999@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: PrittSpadeLord <pritt1999@gmail.com>
---
 doc/nft.txt                | 8 ++++----
 doc/payload-expression.txt | 8 ++++----
 doc/statements.txt         | 2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index cee92c2b..0f37782c 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -592,7 +592,7 @@ This is a summary of how the ruleset is evaluated.
 * For each hook, the attached chains are evaluated in order of their priorities.
   Chains with lower priority values are evaluated before those with higher ones.
   The order of chains with the same priority value is undefined.
-* An *accept* verdict (including an implict one via the base chain’s policy)
+* An *accept* verdict (including an implicit one via the base chain’s policy)
   ends the evaluation of the current base chain.
   It is not relevant if the *accept* verdict is issued in the base chain itself
   or a regular chain called from the base chain.
@@ -601,7 +601,7 @@ This is a summary of how the ruleset is evaluated.
   chain policy issues a *drop* verdict.
   All this applies to verdict-like statements that imply *accept*,
   for example the NAT statements.
-* A *drop* verdict (including an implict one via the base chain’s policy)
+* A *drop* verdict (including an implicit one via the base chain’s policy)
   immediately ends the evaluation of the whole ruleset.
   No further chains of any hook are consulted.
   It is therefore not possible to have a *drop*
@@ -611,7 +611,7 @@ This is a summary of how the ruleset is evaluated.
   Thus, if any base chain uses drop as its policy, the same base chain (or a
   regular chain directly or indirectly called by it) must contain at least one
   matching *accept* rule or the packet will be dropped.
-* Given the semantics of *accept*/*drop* and only with respect to the utlimate
+* Given the semantics of *accept*/*drop* and only with respect to the ultimate
   decision of whether a packet is accepted or dropped, the ordering of the
   various base chains per hook via their priorities matters only in so far, as
   any of them modifies the packet or its meta data and that has an influence on
@@ -767,7 +767,7 @@ Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new
 Equality of a value with a set is given if the value matches exactly one value
 in the set (which for intervals means that it’s contained in any of them).
 See <<BITMASK_TYPE>> for the subtle differences between syntactically similarly
-looking equiality checks of sets and bitmasks.
+looking equality checks of sets and bitmasks.
 
 MAPS
 -----
diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 817b7a3c..ceccfdaa 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -594,7 +594,7 @@ GENEVE HEADER EXPRESSION
 *geneve* *udp* {*sport* | *dport* | *length* | *checksum*}
 
 The geneve expression is used to match on the geneve header fields. The geneve
-header encapsulates a ethernet frame within a *udp* packet. This expression
+header encapsulates an ethernet frame within a *udp* packet. This expression
 requires that you restrict the matching to *udp* packets (usually at
 port 6081 according to IANA-assigned ports).
 
@@ -647,7 +647,7 @@ VXLAN HEADER EXPRESSION
 *vxlan* *udp* {*sport* | *dport* | *length* | *checksum*}
 
 The vxlan expression is used to match on the vxlan header fields. The vxlan
-header encapsulates a ethernet frame within a *udp* packet. This expression
+header encapsulates an ethernet frame within a *udp* packet. This expression
 requires that you restrict the matching to *udp* packets (usually at
 port 4789 according to IANA-assigned ports).
 
@@ -707,7 +707,7 @@ inet filter input meta l4proto {tcp, udp} th dport { 53, 80 }
 it is more convenient, but like the raw expression notation no
 dependencies are created or checked. It is the users responsibility
 to restrict matching to those header types that have a notion of ports.
-Otherwise, rules using raw expressions will errnously match unrelated
+Otherwise, rules using raw expressions will erroneously match unrelated
 packets, e.g. mis-interpreting ESP packets SPI field as a port.
 
 .Rewrite arp packet target hardware address if target protocol address matches a given address
@@ -935,4 +935,4 @@ ct_id|
 --------------------
 nft add set filter ssh_flood '{ type ipv4_addr; flags dynamic; }'
 nft add rule filter input ct state new tcp dport 22 add @ssh_flood '{ ip saddr ct count over 2 }' reject
---------------------
+--------------------
\ No newline at end of file
diff --git a/doc/statements.txt b/doc/statements.txt
index 8f96bf6b..7f7b5e60 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -795,7 +795,7 @@ unsigned integer (16 bit)
 |==================
 |Flag | Description
 |bypass |
-Let packets go through if userspace application cannot back off. Before using
+Let packets go through if the userspace application cannot back off. Before using
 this flag, read libnetfilter_queue documentation for performance tuning recommendations.
 |fanout |
 Distribute packets between several queues.
-- 
2.54.0

