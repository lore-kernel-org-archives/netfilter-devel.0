Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B042BD024
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104763; cv=none; b=CKWE9nVsitWa75M6ehcqp3W9ADn9GD0O+0Mu5UCqnT63ibYbh6/Pgtg+LQeQtatmxcKBSK+N/CaZov9xOd7eXkUtysfLOJ06qb3hRN3tm9Mhq9JjZyk58cv/nf8IIvbVY3hqZBtcg1lpIza6MuCGbwbUdEpPCxEdSvutkVDanJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104763; c=relaxed/simple;
	bh=RqZOsXqZlGAj9k0beS58gwS91ik1kuKX2sll3GwaE0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGkouXTnAyPsBMfe7neGiig6Z5R7MrW2BE50mxQYechSv6lHrpba0zYoGQFc/6I5Gc6lHD7mjk9Ff19JBLxjy5LI9pwagIQgFy4ysld0xMgHWothpYKSupOj+pn9k1dKle7jLwg7GMYGUZcYTqkZlXv+CzVcx4/4OP919r42GYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=L238b4qJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="L238b4qJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ccopDktC4LZuVyErDgIWQoy5ttZsXQoKYGfxiutdPug=; b=L238b4qJW6wO22mBXQEThw5ub/
	v1HY5t9IvYht1AF3eiDsfV624wMO7XjpbWt8h2En9hYQCwMuMiT0RaVKUvIOD6jttI2sdeeYKogwQ
	LtH4mROyHniwxRis44E2wOmSqL//zIJvQDEfZDhjefUiEx7069rZ8Hp5Je6K3Ir3jcH6PQVML5Pwc
	FOzLnmkPZV1FUbQnXRhC5Q6IzhMrs36aRjSFPBeyl+TcUhZKaPmbeddzJmEgEooI2gF92vxi9AaHb
	RsWF+OC6q981UMk4w9p3WmJ9VxEZWnoytPSnvftmMbHd5pBYwSYgMBXFCgIASMVIQ3tNJLZK5OYX+
	FmR7ajrg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvI-000000003oE-202D;
	Wed, 13 Aug 2025 19:06:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 07/14] tests: py: Drop stale entry from inet/tcp.t.json
Date: Wed, 13 Aug 2025 19:05:42 +0200
Message-ID: <20250813170549.27880-8-phil@nwl.cc>
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

The test was changed but JSON equivalents not updated. Commit
c0b685951fabb ("json: fix parse of flagcmp expression") then added an
equivalent matching the changed test, so just drop the old one.

Fixes: c3d57114f119b ("parser_bison: add shortcut syntax for matching flags without binary operations")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/tcp.t.json | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 28dd4341f08b5..88c6c59d19d69 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -910,37 +910,6 @@
     }
 ]
 
-# tcp flags & (syn|fin) == (syn|fin)
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "syn",
-                            "fin"
-                        ]
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "|": [
-                    "syn",
-                    "fin"
-                ]
-            }
-        }
-    }
-]
-
 # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
 [
     {
-- 
2.49.0

