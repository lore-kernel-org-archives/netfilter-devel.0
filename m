Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E40328C877
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104759; cv=none; b=ZPU1apEx7h8cICrEPlvI+GLCKsaUfuG/F4/zGyd/afMJEclpqMBo+fJqrxsrg0oEBFYU5PoQTeS2uYNC+UvH8Zd2YlSuLdo6uwUf0+mPIjdxMfU+c5LHpOHjARB6P72SmdzzPlVwPAluEKsMtYutGCNvAuJ6GE+96g5UIDeFk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104759; c=relaxed/simple;
	bh=ddjgG59DBzT3uukcWszhQWxBl7By1xSEPlKyRZwpXQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evlW0XJTRDaK0AKYQh/lBiT/rLN3rvsE+qozQnBZM+pXWZHriOWXk6SzQfPtyX92LUn1S0SmNrkXJeyyYKThXR9ItPIZxP+wfAG4MmvtcE9FKEB7uxl/FHHe5fuPxySk9T8YF8+j00II42x7hWkmJKgh2StczXlwsWRTANP+2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aY1TmEUa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aY1TmEUa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BCBMcOteFlfOLEdzWu1uzIdZvHHn6n45lUkBn+Co+70=; b=aY1TmEUa6JEoaPGtBi9VshM32i
	o5zKUZvAr1zB/VlLdS4al//uq3vC974Ekmu/APqnUZkLoiool3800gRym1DB80WWBtfNCqaCAMf/v
	r4/MtY6yxDiekdoGFXnC64GtFc6S7QC6RvxyaLJStDjN5lbfECpq+GQ+xSNXz1jMTrcpnrDc6JwyW
	azGWNeXT3Ne44+Bg47JJ1wrweJXGg2krND+uacQk4cv+VzqN+FVwr2hBbKiKeesexmhpMGaXO5xay
	4G0RV2Vx+erSR1wKXCHy4BFoO/WcvgLdDVOA604qg3Kpu1cnELsYu1XKSiBiB6uEAFNBGFbF5scZe
	0FUYizuQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvD-000000003nP-213v;
	Wed, 13 Aug 2025 19:05:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 08/14] tests: py: Drop duplicate test from inet/vxlan.t
Date: Wed, 13 Aug 2025 19:05:43 +0200
Message-ID: <20250813170549.27880-9-phil@nwl.cc>
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

Fixes: df81baa4c2bef ("tests: py: add vxlan tests")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/vxlan.t      |  1 -
 tests/py/inet/vxlan.t.json | 29 -----------------------------
 2 files changed, 30 deletions(-)

diff --git a/tests/py/inet/vxlan.t b/tests/py/inet/vxlan.t
index 10cdb7a44082e..b6db0fe3be8ca 100644
--- a/tests/py/inet/vxlan.t
+++ b/tests/py/inet/vxlan.t
@@ -17,7 +17,6 @@ udp dport 4789 vxlan icmp type echo-reply;ok
 udp dport 4789 vxlan ether saddr 62:87:4d:d6:19:05;ok
 udp dport 4789 vxlan vlan id 10;ok
 udp dport 4789 vxlan ip dscp 0x02;ok
-udp dport 4789 vxlan ip dscp 0x02;ok
 udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 };ok
 
 udp dport 4789 vxlan ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/vxlan.t.json b/tests/py/inet/vxlan.t.json
index 91b3d29458b34..3c147cb36bbcf 100644
--- a/tests/py/inet/vxlan.t.json
+++ b/tests/py/inet/vxlan.t.json
@@ -264,35 +264,6 @@
     }
 ]
 
-# udp dport 4789 vxlan ip dscp 0x02
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
-            "right": 4789
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dscp",
-                    "protocol": "ip",
-                    "tunnel": "vxlan"
-                }
-            },
-            "op": "==",
-            "right": 2
-        }
-    }
-]
-
 # udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 }
 [
     {
-- 
2.49.0

