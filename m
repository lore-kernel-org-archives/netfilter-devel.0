Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B656B6AA0
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 04:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FbzsVM2g"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6ddf05b1922so227043a34.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jan 2024 20:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704861105; x=1705465905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PfkQizZpqzaTGfzq1I3a6ujDMYZM6y4+QqIBc2s7r0Q=;
        b=FbzsVM2gQxd+XA/Qc8hN33bBD6S6IeXkx874q6GBqrCKni/acHmet/0ACdDzI314pX
         muTmPT+BYlrPJtCuTdWQhmIz91eBgPe1jSZQRaH4pVkow0VfdThpEq2rUHZIYca8jh1W
         ZXx9YjC9Lab44JTOPU+JHlryz+MQQldLNGTVh2LgYWRi6uj4R4VQ4OxYAiOTCJmk4ule
         IhGTh+338pLSzcEeSAHJ2AMxkbnKfBSRgYTtVXnO9/bMKKYY8p2HchVwjGFgvdwxWGqM
         sC4H7e4x5oiU3n+ICZKA0ca53HjwVxvK8/+eOIIS/Ls/bpu+w/qehYXHWZu05eCZL0xY
         fYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704861105; x=1705465905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfkQizZpqzaTGfzq1I3a6ujDMYZM6y4+QqIBc2s7r0Q=;
        b=PsZGpepWLxTqicn3bF5dF5NQNdxaNHiijarmyhhjXUZJBPLlSFIsJSn6j4KcTnBIVM
         FtY5MJz/3UjlaRdKhXhSTqSCG6MmQgk89TxwGiCSOo9X7Hcm29rHUZuBS6X7/x936XXq
         Zwf+HP8lVP+6YPRP04Pj/+zMGlCe0L7K1+QN/Lr3288G5BVHXH13GuJ6unvpLS5bRWId
         Ma03ne2uqZyK6SItoWgZyoLGDmtjEG5ZdShF5zQdopLdPIyTM3u2ZhO6ZuexAsFO7fsx
         f5UtJ3zuNYehj/btVVGE3oByGNMWIzv5GhQseW5lb4v7TTJElSp8fEqUdQ2+lbR1JwhW
         arkw==
X-Gm-Message-State: AOJu0Yyow1rbxiIJFJ4BMFl0MrIYKqkPBEihTQCoquefQVl6QJDsFfjJ
	q4v7Tvl4RlehFT/19MSaFG1VotAH9QShpg4+X0A=
X-Google-Smtp-Source: AGHT+IGHd7xtuKYL9eSlZOxMuvVHwShWklNCKgbdM5b8BRs2I86i64FAaOAZ5qLIU3TXPyz9eGrq0A==
X-Received: by 2002:a05:6830:168d:b0:6dc:6fe8:45d9 with SMTP id k13-20020a056830168d00b006dc6fe845d9mr152578otr.17.1704861104871;
        Tue, 09 Jan 2024 20:31:44 -0800 (PST)
Received: from bm02.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id o8-20020a056a001b4800b006d977f70cd5sm2470068pfv.23.2024.01.09.20.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jan 2024 20:31:44 -0800 (PST)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Quan Tian <tianquan23@gmail.com>,
	Dan Winship <danwinship@redhat.com>
Subject: [PATCH nftables] doc: clarify reject is supported at prerouting stage
Date: Wed, 10 Jan 2024 04:30:59 +0000
Message-ID: <20240110043059.2977387-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's supported since kernel commit f53b9b0bdc59 ("netfilter: introduce
support for reject at prerouting stage").

Reported-by: Dan Winship <danwinship@redhat.com>
Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 doc/statements.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 19672805..ae6442b0 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -180,7 +180,7 @@ ____
 A reject statement is used to send back an error packet in response to the
 matched packet otherwise it is equivalent to drop so it is a terminating
 statement, ending rule traversal. This statement is only valid in base chains
-using the *input*,
+using the *prerouting*, *input*,
 *forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
-- 
2.38.0

