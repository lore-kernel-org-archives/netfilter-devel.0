Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264CA287504
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104761; cv=none; b=B9uEBltdgtcmvt60JTSRvCEF0ASog9hAX5GOneMxuQu0uB1vRZEPTd9ANFo70In3YjGByLl7GPQOvKC9ptHSu/SmUwBm/Z5GxupyHOxwhYRIP40mswW3MvaiP8RNpBjjoK2GYtcAnUn58cKzFBR0jOLA6AkIaq0okxmLmnO8mUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104761; c=relaxed/simple;
	bh=JezUmEibfeIS1cIyP5v9FK3vZ0+xo9Rd8uTlu/ROLKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnB20GoYSf4fzxj3gzT5ilJ8uY5Al6HDa6traUnpC10uVD/pFblwyZnHTFzleFOYJZLZUspNSHVLUzBLeBuZhCgmO+gsej5vahdxjj7e3PJ6LGOCTNqbrvvArm30vbxDNea3xeZ0MTy9y5xMcZzSy7QGv1n+DJhDlcpGtTWZlBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=keUBcy6K; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="keUBcy6K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sRCWwWGZa2a4ZcruYurSMXX0kJgxV3bSGwc695qAP0w=; b=keUBcy6KCNyUFNhWsiFaIf2cwj
	W9uUDD65eV0m8Zk0mlRpzvKTU++vNF7bPJ7VNg8fNydyVq5fyVREGm4LFqcWeOxksBX0ix1Pl9h3x
	4+T5ebyC7O7ZYn7QoBgsCUZH/slC0nh0o93TBqMXOUg+O/0W4wD6HmDL4NL/jT38/A8FNYtW+bxn8
	TXtqhyWGBYn9KQ38CAh1pYETgEXUTkXOilxQeDq/pAcvbyCG8PPovpGXdczws9IooHjEsgUmSK1Pp
	EXVv+Vsc+hU2L0GXee9uaSw49PrBRuYHtxR9ljjueWBugRgit4byOynHBtuKFD1M4Zz6S9XdO98UH
	4r02JbRQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvG-000000003nu-21kn;
	Wed, 13 Aug 2025 19:05:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 04/14] tests: py: Drop duplicate test from inet/geneve.t
Date: Wed, 13 Aug 2025 19:05:39 +0200
Message-ID: <20250813170549.27880-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test was duplicate since day 1. The duplicate JSON equivalent was
added later (semi-automated), remove it as well.

Fixes: 2b9143bc7ab81 ("tests: py: add geneve tests")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/geneve.t      |  1 -
 tests/py/inet/geneve.t.json | 29 -----------------------------
 2 files changed, 30 deletions(-)

diff --git a/tests/py/inet/geneve.t b/tests/py/inet/geneve.t
index 101f6dfcdb7e8..ad46272091ad2 100644
--- a/tests/py/inet/geneve.t
+++ b/tests/py/inet/geneve.t
@@ -17,7 +17,6 @@ udp dport 6081 geneve icmp type echo-reply;ok
 udp dport 6081 geneve ether saddr 62:87:4d:d6:19:05;ok
 udp dport 6081 geneve vlan id 10;ok
 udp dport 6081 geneve ip dscp 0x02;ok
-udp dport 6081 geneve ip dscp 0x02;ok
 udp dport 6081 geneve ip saddr . geneve ip daddr { 1.2.3.4 . 4.3.2.1 };ok
 
 udp dport 6081 geneve ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/geneve.t.json b/tests/py/inet/geneve.t.json
index a299fcd2d0545..15899180dea36 100644
--- a/tests/py/inet/geneve.t.json
+++ b/tests/py/inet/geneve.t.json
@@ -264,35 +264,6 @@
     }
 ]
 
-# udp dport 6081 geneve ip dscp 0x02
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "udp"
-                }
-            },
-            "op": "==",
-            "right": 6081
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dscp",
-                    "protocol": "ip",
-                    "tunnel": "geneve"
-                }
-            },
-            "op": "==",
-            "right": 2
-        }
-    }
-]
-
 # udp dport 6081 geneve ip saddr . geneve ip daddr { 1.2.3.4 . 4.3.2.1 }
 [
     {
-- 
2.49.0

