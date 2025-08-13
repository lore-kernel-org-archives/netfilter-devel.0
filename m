Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BBA2BD02A
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104763; cv=none; b=QyxsPgV9xMrvQ8DT627R5Are21/zxnlaOFv+zBEnt/5qVqXALwDLVWJiMYh+6cY0cwIdoQG5HgArcSaglI+V2ZgyvvMfq7bC7t18pwVzRaPyiYEEC/FCIfVe2QnXcjQUTStzLYu0IFSfqVH9JOgJxVmzBrqne0z9JelnD1s6OAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104763; c=relaxed/simple;
	bh=J+v426oHQgDH6P4su54QP/+U2M5dXRsZbCQB+DBTPmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiCruP7+uFm1ZflDR8FlKH6tPA3sQFYMWXADEAT4GjAj3ATVEkrkZbLmSIzOrFwZlPr4tTb8troC0rcRj3ii8MYYVO3H93IhUqtsheflJb5zaS97B0ptdE6HinUeNY7DluKtm/lyrLQNkTXlRGuSBosrcc8emX2T7aLc61yaqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=L5/JCjfq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="L5/JCjfq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eCoAaxfa2AxR3+8LjQCVhl0LTQkGiOLq1o4rxqoZIZg=; b=L5/JCjfq6nzmQs+luh5lh1Kh+U
	vyqgniXA8lHUg+2kaz/52pXN5TXtHGIsWwOroy6nEO4HRJkBb6on5MSbdGUQk0NDSSpGycThdVmgv
	ew5hDJILcUuPXMAw0OJI9YuLMsLhMl/0AbuwBSpnRzGOCHNIxcDrlzazlG+CcbexSzkAvWvDwm99M
	D6w69SkalnLKdIFMI3FmY58GRTRFg9JXm9vPD142bfdb0eglopUrfkyGnsRc15RHi/bslAuiUK2R4
	viY0MvzRVJB5WSWQAKc9fMjaLCqpQ9HIaaaNKulNQ5O6k3Zp0R1uPwBgF8gBgWsuc6aQ27vy7T7k3
	kkLw2TzA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvH-000000003o6-3z5r;
	Wed, 13 Aug 2025 19:06:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 10/14] tests: py: Drop stale entry from ip/snat.t.json
Date: Wed, 13 Aug 2025 19:05:45 +0200
Message-ID: <20250813170549.27880-11-phil@nwl.cc>
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

The test syntax was changed, but the respective JSON equivalent remained
in place.

Fixes: 9b169bfc650eb ("src: remove STMT_NAT_F_INTERVAL flags and interval keyword")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip/snat.t.json | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/tests/py/ip/snat.t.json b/tests/py/ip/snat.t.json
index 967560e636a97..60bd0932f3c09 100644
--- a/tests/py/ip/snat.t.json
+++ b/tests/py/ip/snat.t.json
@@ -283,39 +283,6 @@
     }
 ]
 
-# snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
-[
-    {
-        "snat": {
-            "addr": {
-                "map": {
-                    "data": {
-                        "set": [
-                            [
-                                "10.141.11.4",
-                                {
-                                    "range": [
-                                        "192.168.2.2",
-                                        "192.168.2.4"
-                                    ]
-                                }
-                            ]
-                        ]
-                    },
-                    "key": {
-                        "payload": {
-                            "field": "saddr",
-                            "protocol": "ip"
-                        }
-                    }
-                }
-            },
-            "family": "ip",
-            "type_flags": "interval"
-        }
-    }
-]
-
 # snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
 [
     {
-- 
2.49.0

