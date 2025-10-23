Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20529BDB8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236084; cv=none; b=LMTBb7S36E/JkCcQ0iFh1M+i5rMrA5P+/T9P+wVDeiKjsQtwjgN58dnunss3p8728NzhWLP2KGYt3EA+6PNCsF9FqW8GLR9TgqCHhnXjDcnNxeXDAB0Cm79xINlzvzfeahs5lOQ0F2KUOoqPjddB10EkjO9k2shtphXCAkWfU0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236084; c=relaxed/simple;
	bh=UUSL2diwk6QMfkaAzLsq3kwSBUIIzcOYfGS6IEgz9Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOhMxaAHKboa7JFMHYyPVpfju+TLjAS0CmPp+vmg8vvIF0mPgUDPgsf5yNLpaLB6UkB99lzo9esmnY9yqka8puu7Ovulkghygwk0NZ4FxxssQLxG6OV9Dj4nlvaXMxKneIxEXoaD63ejMTQ02FStXsZjT+FbHo0Npwkosb/6l1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z0qN8ULp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z0qN8ULp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=92Se07np6qptvHZgEzvnl8787AYiBr7YLhe1M83iAdY=; b=Z0qN8ULpoEQIpFXAsshful/LI2
	8d8tUjBN8ZArPfb9uk3nSJ2suVfQOg9XfIq2K5Di2gHJOTztsq6cwU13s0uDh7B5RhOCOY/qhJvdh
	iJIZXT5895kY5qQ25e4B2oFtKTDRLICbOc71J+3PJoYRIZ06mYqCUu91AIL8uzQwtWQw1JSeVg5rb
	hWf/PhO/mqDs3AnLNizN7u7CsK99mC3IuKRO2N95sJRUsoem3hFs/BQWiYdVAxb2mEue8R30z7b6y
	/OsxdVcLM37VAE/gYKzPZasA+gAM1/vbcg3FL2nR8uDqPSx0gxhXe3qO+Y+UW2alaE1Dzdlu2CBV4
	aVaCn3SQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxW-00000000062-3o0H;
	Thu, 23 Oct 2025 18:14:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 04/28] tests: py: any/ct.t.json.output: Drop leftover entry
Date: Thu, 23 Oct 2025 18:13:53 +0200
Message-ID: <20251023161417.13228-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rule with single element anonymous set was replaced, drop this
leftover.

Fixes: 27f6a4c68b4fd ("tests: replace single element sets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t.json.output | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/tests/py/any/ct.t.json.output b/tests/py/any/ct.t.json.output
index 70ade7e38987a..82634c2da6720 100644
--- a/tests/py/any/ct.t.json.output
+++ b/tests/py/any/ct.t.json.output
@@ -471,39 +471,6 @@
     }
 ]
 
-# ct state . ct mark { new . 0x12345678}
-[
-    {
-        "match": {
-            "left": {
-                "concat": [
-                    {
-                        "ct": {
-                            "key": "state"
-                        }
-                    },
-                    {
-                        "ct": {
-                            "key": "mark"
-                        }
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "concat": [
-                            "new",
-                            305419896
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634}
 [
     {
-- 
2.51.0

