Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E92BD5B7
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104765; cv=none; b=f4Ltp1e9VyPgvsF4ogY5g8dwwNWO1vCFGtJ0XlkiCI6fDVjV8dDog5dUi0ddGiFFlCMgGa8nEXdsj6Vp6hW3IQWmcT4E8ILpnpfZa/8WzmTjnQm5TsW42nuiXO7BMs9TZJiv+Aj9NXMgevmWOxtqejPy8eA7lIDU5WdDeo2LNVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104765; c=relaxed/simple;
	bh=HUx1L1Rw8ISlysl4Ggsw+Y+yV3oSgbVQQOnkkiCUD6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJjQLBH2rmny2sRuArLa2Q7dDi/zTaB/ieKwruPf1aQGlolRCRq7qtTQJpWs2u9o2bj9qrT+fazDo0L0Xo45Us/hbiA9T33ct7osORUlRAhS8qZpCqwqJEgu9+d0tj2FSSQLwk6f26MBIsfnKqpGqOfxhUKrFczpNNeiQKqqy3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lWGArp9c; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lWGArp9c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=l5e9rPRWYYQB5M0nvSc9sgmyNiAJPlK691YB7hHIq9s=; b=lWGArp9c2CSUsn7WgNDd9H/LAe
	+tyHHOyKdF2o0w4zxNyAdXzLpI3tpdCGTh9QF3Jo7MyDnelR8jpaTODbpAVGQUyQjJ0lJCIfLWKgo
	U7T/ZpZiTO3a4/JVNwIeIjXVfrXe8sYREdMd4h+Rk4pI4NZbNJdlzBRUczi2iN67yZiP41UTD6Hz2
	/6iPaEXbWfiZ18pChDBOvnUEfskJQ04I4CMP9CV5InwdZsVfjBPat0DI6tE6dRM7uEj54dxbp8NrN
	e0710UIvu9rZFL9in4irZVzcvhYfNwTpPINxlhODh0EGQFHuNg54rsQwFm/8ayV7vRP2VEeyDwuFm
	aQtsaxRQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvK-000000003oZ-2B1v;
	Wed, 13 Aug 2025 19:06:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 06/14] tests: py: Drop duplicate test from inet/gretap.t
Date: Wed, 13 Aug 2025 19:05:41 +0200
Message-ID: <20250813170549.27880-7-phil@nwl.cc>
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

Fixes: 39a68d9ffd25c ("tests: py: add gretap tests")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/gretap.t      |  1 -
 tests/py/inet/gretap.t.json | 17 -----------------
 2 files changed, 18 deletions(-)

diff --git a/tests/py/inet/gretap.t b/tests/py/inet/gretap.t
index cd7ee2158edef..f88896fdede7f 100644
--- a/tests/py/inet/gretap.t
+++ b/tests/py/inet/gretap.t
@@ -15,7 +15,6 @@ gretap icmp type echo-reply;ok
 gretap ether saddr 62:87:4d:d6:19:05;ok
 gretap vlan id 10;ok
 gretap ip dscp 0x02;ok
-gretap ip dscp 0x02;ok
 gretap ip saddr . gretap ip daddr { 1.2.3.4 . 4.3.2.1 };ok
 
 gretap ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/gretap.t.json b/tests/py/inet/gretap.t.json
index 36fa97825f9a2..6c16a083b8496 100644
--- a/tests/py/inet/gretap.t.json
+++ b/tests/py/inet/gretap.t.json
@@ -139,23 +139,6 @@
     }
 ]
 
-# gretap ip dscp 0x02
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dscp",
-                    "protocol": "ip",
-                    "tunnel": "gretap"
-                }
-            },
-            "op": "==",
-            "right": 2
-        }
-    }
-]
-
 # gretap ip saddr . gretap ip daddr { 1.2.3.4 . 4.3.2.1 }
 [
     {
-- 
2.49.0

