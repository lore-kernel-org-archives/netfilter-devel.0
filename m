Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468C841D635
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786970722; cv=none; b=HJwvS+BonmKiUvVOaLyfkipRGTxbZZ+026diHzidOVcJMCiZRVXnmVZBouEQoqlOcLF615dsLMVWm5cKzCXL6BBsb8L7XPardAn+FiUr+oUe5lqlGr7YG63zZ84BnVfMjYgfYQavG3ws+KGyYwNeA5itwlHz2yog1S8swIPK2rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786970722; c=relaxed/simple;
	bh=fBabX5meckEq8fL21CxOjBQqAsM/jWn6a0BhCkp5qEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDDFSNVULVTdMpi8oUDWXYiFozndsmG4Fs3lG3TDd6e5yByOM6ztSGPzmyeFJ7JzRKyQddc2//y9JrGe41sxrG/St4XUBo1cVSLNmF3IvvdynF6+jA//Ko/B0QL5rCQQdxNCz+SX9HIqiF5dHshP6EK+YH7tLxXM48ASOfDVd/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so2363785a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 05:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970721; x=1787575521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kmn0yAsEsWp7+3rafXIVl0ZxZi3a/cQcUQRJXW5huY0=;
        b=HzKfUXrf8wMP5TIuCZRp6QSWHQuRBfaoPTfb5AaidqtGRhH146z/3bmGrazvTyOcb1
         mAeZXW3Unugk1sfuD6Ya3qEXuRnC7vHGo8yvJn9rMaGaacvuds0Uv5hPArzmBc5okJ51
         wL2U4M7ZuTgYtpOkJBIin4pWzlHpxJ28AY6ofJNuiS4y6kAMW8C7PsAyjFXCLKUnNbW3
         ngmViQRvqk0d3PjYotOaD80D9wRqo1Ujplrpk2/ow+P/8aTCI/4xDtxlij36xJuIgCHp
         33nV8S6UhB+9NbNQmU8/zSVchf7oeKrHhQ/ToyG3WS1sVhlS1QB5ievvIcg307tj7Zhe
         2MBw==
X-Gm-Message-State: AOJu0YwTuIJdM5LeHmGNjPLQ5a183sqMLsWGYbIBKX83mvU6jwjnAlWK
	jQhPKfqtaKoPGE6IsTb8Dy5UaQmLHtfpIfW+xXuE0GmnpJITFrRn8X9a7oSEsuJlVHryebQ0+Bz
	Z11SYjnxmNRSRqA==
X-Gm-Gg: AR+sD13LowBLY1OAixTqbww0SJ08mj7dq5hIZmmOTSpQQCZJbPtdSldCqCANH58GoAq
	jeQz6vRFChK8vH2Mrm2QY9rMWOfNyjdCh9s0/tQjniudzRrTIAiBXWNtO7EHcnZbWk3w+AMhoTo
	V7SgjGkCHsyoSRwUFWVcAW6XhHA/s7eJ2ndzstL98RLe/dwefv5O/HkNpMijuGQQmkEB20tTJJr
	iNWeQz2M35V9K4t4bk6NR0B/n+xyZbo673QLNqBWKwJS0j01J56wwZswjHzAEWkktE9+qV78rUC
	VLyCHLnj0YrDUAsMqWjF9P/v65EPtVhQeOjfykfBihBNglPGNlVEorcMqiCGoHgeGn+v9i4b6a7
	lDA4f9YXPr/KeoP60t2dKpWeHtrPJDb6qsT1E/AivtB5ECYuX0R9x6+3xw67TniCSDfgnQvaywj
	27p7huvm+GkYExsZx1eLqNJ+7KI9AXJdx6PmfyuBKW5N5ngyeV09MZ930nHiN9D1+ffAz0mFlV+
	q7ubOjOi/4b
X-Received: by 2002:a05:6a00:300e:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84fde11bbb8mr27878428b3a.2.1786970720297;
        Mon, 17 Aug 2026 05:45:20 -0700 (PDT)
Received: from Roxy.localdomain (n220246089185.netvigator.com. [220.246.89.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b404a4d2sm507548b3a.16.2026.08.17.05.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:45:19 -0700 (PDT)
From: Zhiling Zou zhilinz@nebusec.ai
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: xt_string: account textsearch configs
Date: Mon, 17 Aug 2026 20:44:55 +0800
Message-ID: <9b7e9680b6908b65318a6f68b4228845eec38553.1786970189.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786970189.git.zhilinz@nebusec.ai>
References: <cover.1786970189.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

string_mt_check() creates a textsearch configuration for every string
match with GFP_KERNEL. Algorithm-private data, including Boyer-Moore
tables, remains allocated for as long as the rule is installed.

The xtables table blob is memcg accounted, but the textsearch
configuration is not. A user with CAP_NET_ADMIN in a user and network
namespace can therefore retain kernel memory outside its memory limit
by installing many string matches.

Use GFP_KERNEL_ACCOUNT for the textsearch configuration so it is
charged with the rest of the rule state.

Fixes: 7567662ba896 ("[NETFILTER]: Add string match")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/netfilter/xt_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 8ce25bc9b2775..52c1deb02cdc6 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -54,7 +54,7 @@ static int string_mt_check(const struct xt_mtchk_param *par)
 	if (conf->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
 		flags |= TS_IGNORECASE;
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
-				     GFP_KERNEL, flags);
+				     GFP_KERNEL_ACCOUNT, flags);
 	if (IS_ERR(ts_conf))
 		return PTR_ERR(ts_conf);
 
-- 
2.43.0

