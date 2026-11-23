Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795457030;
	b=GlXRRu6bMAUOZTL35UCP982fGs2QSE9uxgfM6QSeku/T9rjrowMSrFvvRk0eTA1BtN1h
	 cZ5uxohDLR4Dynkbrf/LQidAuqm5C9zcR+wb6wwgkDxNxtHzD2Cfz7lciPJ9FBNSyQhEf
	 b5GF8HqTDgmn4PPmkkFiws9D69P6KQK8wBaOM75J+I8A2OwoRk3ATbj3hjeRBc+3R15Dz
	 UOkrQovVIfMhNtXd0+Je419B533yBeMgxn3S/cULb6sWEMzt4iI1qn/1QDq+RyoAHqshP
	 XQCPHbYcrf5pa/RIW0mL8jFAJH7c8tHIE6+9lgEFI2LqjBEnAcYHXUlaVDWLJfgiIuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795457030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3JAUMkrQNjsPSpyYGkmU8ofJIJcYhHp8Ga0Yrr/wUZQ=;
	b=mA58j+RgcQ/Y0YEkwbPZM5foE0WxGDx75YlalGrFPLirZDHeLguqtcE8WeqFD4nkThFf
	 kFwrCr2LN+gdRCsYGcDnshlnxrnAfFaY6hB8K/eOcByu/hjRAsIUf7xOCEMg37jAuysbj
	 O7ddYPuKzNknnzJdTgJeWFOiwR7lP0I7hR+yV6B2YkU8tHitUCp+IZsQhSTweb20XVKhE
	 kEr2q2SoTc2MXTl3sHkcLGKrKG5JmjvEuOCFn5Bcjyhvo61F1Q8FYibN2YQkvFm5GMzP3
	 KvF1cbYwRavpj0t3gp+YsQ4TVr3nzISc3ZieIB+uBas6FIVghaLeEVA68VU7P+oAetw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NyCGulR2;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C902606A31A
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 18:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C902606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NyCGulR2
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49a92144733so1750429f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 10:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795457028; x=1796061828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3JAUMkrQNjsPSpyYGkmU8ofJIJcYhHp8Ga0Yrr/wUZQ=;
        b=NyCGulR2d23VBpnfKdauqCgGOf2wSNomlFOUmEhciccwrfkbPW5Md2IE9oX59Mu85g
         EJzQTjU5cPSc4LeD6JIq6VkFFsuvsuwW8f9Sc/O3VjvzjMa2UgBlS2vw4JY3haMqrurs
         GFnpEK+xE/LlqTyaorXmZ+7l1UAwcFMZBKUumwAXlJmk30/JXfBB7Rl7untljTtIBDPo
         eJeG6me5k38aHsL5wJf3eJD1uCfet9Ks/uyhkRiBa3DCsqfNwZV0sFGG07+NCHAdNneq
         O0++Jxx2RNhch8SUti3jdmIJsadjFbJUDXqEy1t1MLtwDWyW6EwMvC7C/iYH7Up+t0/g
         HCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457028; x=1796061828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3JAUMkrQNjsPSpyYGkmU8ofJIJcYhHp8Ga0Yrr/wUZQ=;
        b=JWbf7gAXTZLT0puNfWm3ZqLg8qwEBCH3N6zPg/58Y9JQxbeLWzbNkRJUTVhZVgnXPN
         s3bGaDzGB54iCYHILLf6ILSKwkI0wAMe4kqauGbEWryyyxXbSZYeRo+BkUqVKz4y7YQD
         65RlfhXcpwY8bVT9DE2byMsOajpCeWUQAGLhxaIQVg031PSQD1mnnLAad+sX4r/OxEzG
         dfw6weaTbYqRQFFvDJx3AzLAs4uEeFGxv/H2xwP47rFeMepLkeflMnxBMmPcNUHSFtoB
         yDRKjAWuoXQxwgpbtud4m/vCZ6BjK/iOtl4+HUUftWqO1CZYXZz647eTAjR7127Jk8rT
         brdQ==
X-Gm-Message-State: APuU4Z9obAlsWzA52NAhC1IdIKKR8J7fNEbSp+eAw/iiojLbUlTo0XRR
	yZzTP9iuxNXxifJsn40x7HAJqwUFONvEN4vXVc9veyHHNu4qRcNQ10hwiNWmjw==
X-Gm-Gg: AZFdTZe+jmNZui+nlR/8fGXvaHxRPiX3/f4JOvMhE0QC7IJ87N96nsk33LPmcPTMaMB
	BzO4fN96bem8Ww6sKL9p2dKlBvHJzo9uAvRXgFE9ztD2lwVOfGWa5NtS1+RnB84IPw30idRMlJV
	uaRlO+GeV4cDRuLuw3kTdkH+FrkeYHYxbSf5/VPdg2YK7GTIstYf4C224grFgZD0tCa0JPH7jUL
	OwPXIy5tJ3vTkINOhsuJYcSmOx0CeuKQHnmlmTCdkvtTy7b5htx39yOE2bcY+lAk305wohWLL3a
	9XM2+e6dXEL5ggbbwTHIC6Uyd2eL63OifHpLRRYMNQrKBY+1dwkF1t4HV12RP4rHtNlUwb0x8Ie
	Yo0ukbBhfiE3nnT4OBawOxsNMVk7MHsYB32YHRYNjgWIrWvZTag9KC8sxk6iLVSS6Bn8rxpN/s0
	ATyN8WLGG3g7ovYEKdE9GGXrbsAspbf+01dlSTEJqs7kExeYa5p+djpDOby9F/qWmiAXfaPbzTV
	bxXkz7R9csLfFnClP0A3N7uV+NUjPX0i6weyEYYegHoVrzAkunFZgIKaaB1SJuF1509H4vRIvQG
	WTOgKdbmxgHDIozFs9Rn/aDXTPJ/p8/nUWyrMPlW1t+UcJRGxWs=
X-Received: by 2002:a05:6000:2085:b0:49c:192f:cf20 with SMTP id ffacd0b85a97d-4abacfea524mr23539928f8f.6.1795457028480;
        Mon, 23 Nov 2026 10:03:48 -0800 (PST)
Received: from serv08250.test.local ([2a00:801:4aa:f0d2:a00:27ff:fed3:de1f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf61e8sm24945066f8f.11.2026.11.23.10.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 10:03:48 -0800 (PST)
From: Rohit Geetha Bal <rohitgbal@gmail.com>
X-Google-Original-From: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
To: netfilter-devel@vger.kernel.org
Cc: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
Subject: [nft PATCH] trace: fix ICMP code output
Date: Mon, 23 Nov 2026 18:03:18 +0000
Message-ID: <20261123180318.1964-1-rohit.geetha-bal@telenor.se>
X-Mailer: git-send-email 2.43.0
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

Fix incorrect ICMP code representation in packet trace
output.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=222272
Signed-off-by: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
---
 src/datatype.c | 1 +
 src/trace.c    | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/src/datatype.c b/src/datatype.c
index 5025b276..6ac91c2e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1130,6 +1130,7 @@ const struct datatype icmp_code_type = {
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
 	.parse		= icmp_code_parse,
+	.sym_tbl	= &icmp_code_tbl,
 };
 
 /* Backward compatible parser for the reject statement. */
diff --git a/src/trace.c b/src/trace.c
index 051cc12d..ec7f9e5b 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -12,6 +12,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
 
+#include <netinet/ip_icmp.h>
 #include <nftables.h>
 #include <mnl.h>
 #include <parser.h>
@@ -232,6 +233,10 @@ next:
 			payload_dependency_kill(pctx, lhs, ctx->family);
 		if (lhs->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(pctx, stmt, b);
+		if (desc == &proto_icmp &&
+		    payload_hdr_field(lhs) == ICMPHDR_CODE &&
+		    pctx->icmp_type == ICMP_ECHO)
+			expr_set_type(rel->right, &integer_type, lhs->byteorder);
 
 		goto next;
 	}
-- 
2.43.0

