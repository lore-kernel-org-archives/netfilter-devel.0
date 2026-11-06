Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=83.166.143.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992754;
	b=rupsQh4UUlmiFpt2Q/2NfVB36KuyuOw/xqp5bkonEFpvFO3oCrG/LmXLy9vDYMFIAt9C
	 MzBgrx6bEFcmojbcMeWy9S8ALPh+1wAqEqQJlwWrXZ6QED8cU/MlsBz6Qg6oBW3bG6xVO
	 yj5RntGyU/unZ6Kipx5xqPFqrFcrjHolYk0gYOl/X7FFa5U7t7te1yOp2Xv0Zn9fuf2Z7
	 /SzpF5za25euA/EDLLoZyHQbKF5IXFDYjZDPrEuyKpCtQ/hmf2LDeXcamBsgaExIueVAE
	 YPMU4O9D/gMgZde+6EDIc6ygFLZTUg+zCqWLyucNTB0A9+CLv0ZydaiE4oMQQwgfZ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992754;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=HxmHfyMSwn6PhQMK4EppFIclDbwrTkrpc+VBBe29gOA=;
	b=5lO1ambcOkhBEcfb/C/UPbeTseEdwJRAHj7qtWscEyFiofFvPb3yXDP8RVSHcRntSLxA
	 4E/ZzuoOUgbtnq8U7sXfjHbqOP/Wd6Qhg7X0qTwl5kfPVQCR84jnPYWlWGKwSSmm4mDh1
	 prCREVdwNVVtkLhn+InKSEHpmyLh+Bemz8FXp0JaKwM21W6K7g3NtSLZjoNNZdUCWE7xB
	 jDkggLjmGilEbKmqjylXYbcqztggdlr1kgYOWC+7TXyZP3FSaO69KlvPTN2ijFvjKEkkT
	 xDfVrPIdMzxfStBKPgpVchWq3h1pvpfYSQ27YP2a8F3l0D74ceNaq0dznvxsvCo+rvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=sazyEw5i;
	arc=none smtp.remote-ip=83.166.143.175
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [83.166.143.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBE3606A337
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 19:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BBE3606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=sazyEw5i
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jLprV2kKZzTLp;
	Fri,  6 Nov 2026 20:19:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1793992746;
	bh=HxmHfyMSwn6PhQMK4EppFIclDbwrTkrpc+VBBe29gOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sazyEw5iqCpiXOVNG8aXZc2AFQE6Vh4c9lfwI32Ag3uIKT/kT7a5MHkPFFwKnXDlU
	 ipY/ANRRGXho/IrMrdeO2qxqadgFrREhn43XfyL8CAYYv5CQOzuq3H9WgAVM4rZokn
	 oKyTohF7R2HWSet3lOWe0+PofFwXDygVSAiTrow5Y70ITkNmj6Ko2bSKeVdyIKnmTU
	 UEiiRh7GBk1nRcGSMwo/Vel9ak2zImR6B9Uw2ubM0KzZpzx9vmq4HH0im48MvK62i1
	 lo1WN1hvxWy+KbJWBZeKVjNhskhfGwCwDR2cHXIYNTagrWBLD0XOny6nmNDc9o98gc
	 zD+nUVf/LRwoA==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jLprT459HzRyt;
	Fri,  6 Nov 2026 20:19:05 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl 5/5] callback: avoid signed overflow on INT_MIN error code
Date: Fri,  6 Nov 2026 20:18:40 +0100
Message-ID: <20261106191841.1645-6-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261106191841.1645-1-florian.stosse@harvester.fr>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

mnl_cb_error() negates the error field of an NLMSG_ERROR message to get
a positive errno. For INT_MIN the negation overflows, which is undefined
behaviour. No errno has that value, so report the message as malformed
with EBADMSG instead.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---
 src/callback.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/callback.c b/src/callback.c
index 703ae80..660c90a 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -8,6 +8,7 @@
  */
 
 #include <errno.h>
+#include <limits.h>
 #include <libmnl/libmnl.h>
 #include "internal.h"
 
@@ -25,7 +26,9 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
 		return MNL_CB_ERROR;
 	}
 	/* Netlink subsystems returns the errno value with different signess */
-	if (err->error < 0)
+	if (err->error == INT_MIN)
+		errno = EBADMSG;
+	else if (err->error < 0)
 		errno = -err->error;
 	else
 		errno = err->error;
-- 
2.56.0.windows.4

