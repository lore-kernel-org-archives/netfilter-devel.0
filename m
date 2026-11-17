Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907662;
	b=lL3Nuc/h4ec1DvsHV9TA/KPofC6phHOtKeCNI7Un2meVa1cyjXb8yTp378uM4G1FRy29
	 11Wk0YjOxSAnVLoT2X+lFsyHsAaXqDDbKWqsHhqGwQm2bBwl8bOzlLEnmY7VDgW1Eyynx
	 HozFJITcy5iwOjPUTTXUV0GTCBCtGd3ngkscdPkKBDVd88f19YJNUSiEFgI6H7QPZAMfr
	 mEfgfjaOUmjW0lJ89/D7ba51j76DlQstEhl9b9o+elBmHzinWiPuYZEC23uquRgCowyd3
	 XrWqgDSZklRzxZGsLomzysilQxn719xGr/yPnYmPQGqV9qRgvXDukkGRP5fmnlllw9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907662;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aDSdHKsmTGGWkDOKCvZtMPEPFRR2Z2wRDeQx9ZQTN3o=;
	b=ktPZLR5BEpkinz9aOx8t745RRhoNeFH40FYCT2T6z+j7xD5rRXv/R5mCft0aFYvy2kSW
	 HAt4FlP78BXQHAdQJD+vUZ+LPrMjpBHg30MQpNGZwCCLgn8Idyts7TbqbIDQZ5vOYxoq0
	 FWw345+fQT1VYi4zqQjT25fr7lHyc1F0nHGB91jcBGQBm96rq0w+eLFCDxLa8Egx1Tssc
	 VjPy80WvTimIoqxyIVyWBanixarydV/1go0xwRceaDzSXspCvQNKopN18EWmfPJMgioNQ
	 tce4phnA4h6feIcU5dVpZO61TbaNY4HVK+5yfIlOgLnvWYEnner6YHFTDjL8oABvxAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="0SeRLO/C";
	arc=none smtp.remote-ip=74.125.229.136
Received: from mail-dl2-f8.google.com (mail-dl2-f8.google.com [74.125.229.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549BB606A32F
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 09:27:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 549BB606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0SeRLO/C
Received: by mail-dl2-f8.google.com with SMTP id a92af1059eb24-170b3a08758so837742c88.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 01:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794907661; x=1795512461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aDSdHKsmTGGWkDOKCvZtMPEPFRR2Z2wRDeQx9ZQTN3o=;
        b=0SeRLO/Cu/Z7fD38T1aAPibopqP6aQGUmhp1Bo9C+KNJ0zCPPS4ridEDVsmduTWVMB
         IcSiChIYc5OtxT7LxawZZwt+I4vRJx+Vqq/qgo8Z8FQoveqYdA9YRJcwE/sXvxSDpMRr
         xicb0QeRwgjZ9gDwefSkUvHASJVJQlsYzMLlQ4EAKa7se1CKQDlqSiZO4Xwi4Wnc/QC2
         VNJwxXOQsdQW6+6QcfmItcKP+zjvb/hOjtnhCrZe6LlBjJf4dHf/HEeX6Tndo67/JG2A
         sGSH6TS8rkRN0Xbzr2uiSUXWh7FLBkPXcSgHu7bfSdxyrlnkvQ/DQ6n04bjGVmj+umb1
         eyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907661; x=1795512461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aDSdHKsmTGGWkDOKCvZtMPEPFRR2Z2wRDeQx9ZQTN3o=;
        b=JjU7UPbvoF1OcF1H5hwOC32Yu0ckjVs044MWqjNh4orF19fU9v4RrIAl6eam7vsarI
         n2ityZJKqFSCZqJzsdoWYzdNMN0IElh7NQzL8xu8CXm4KTFkdzMXaVFuCAQQXZ/BgxBi
         Yw46/s1yLvas1riulu03WZDt8E2hEct+bbefC17ZgOi/K9fd/ihs9+1O8DZd4QRWULnH
         PUVER2R2ugRnwu/2+ASG78iBqXr4+uA85natIViEPV2Q0/pH2c5on5mcYTxPgaaMEvP/
         snU84u38pPRSalBcUe8zXWZy+MvVUeddDLrSlBRfI5bp3RX4kX5fkzgCdzTRQpChyS1e
         gCtA==
X-Forwarded-Encrypted: i=1; AL+hErEuYI4jYxsPiAk6WNQMBxKrWilxXKaDswYO3DXPPOoc6rGzVmhgNRjkss9UJ+tdUnR8v8MbjPYLn6rNjFXt8JM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/56OrdY1+O1Mt9wBMgwgE9YRD3AueOzQSiPWqeIjst3ZkqZMqR
	R/ufPlkmRBwoDHx2AZ4RddhDdVzV1ckvrhMm9PBda27pu9Ca2H0Mh704
X-Gm-Gg: AYBFou3zD2N7pztQlLaXVxhTUq7Txn10BfaTkevc4XJU4DK+ZoVCubtr0dBFuYCfdr2
	d+JjyiAx/cP0C9WsN7jkrIzvsSUb7uj6in8MbkGg2xqW1Kfk3xMWZ9laSjUsU3Z8x1Yf8JSP2kA
	z14IiOp/x5S/cyQA1V8xLOs9i1iMjhny9Rrm5vCVXJyKXoguyhXEO7cdPQoyytAIhctvefVwAFX
	z1a5eQLDybaALXPnvbOwCYFnr4Z5WZJCcbCYHf7VOnWl3/NWlIwY5Yzx7DWLeeLIj3hXl0YSApv
	9D6N4S4zL+QA9p+6AJ3Nj/XgfCeW8lJ+ybWz2J8sMqSe4m3dQ3sZzo3h1r2b2BnG1Vb3X+HV+Ca
	4z8lsX84gB01j1jg6HZgEJMgK/bQsxpcqjfKD+KItDkkd2r9POxccVMpXRN155mDoJ66vmGFswD
	rvVxxeXsOGSpbnNnjJ6tFn/stHd/HJCLj9YLDJogNLeO94PQewnssAzSFPqeHuy1KK0+JeQ7sSl
	JPtK1vn7s2/a30Lft0cM7cDzKgJMY+r/rmSAwiQ6tRTVFtKo5p0nPg+pV2wRefHsoh/6v0WXUpg
	P+vINjpxR2lXH7M224DwwrUqiFNWNwe9g7xX2NB0DCAisJMhJ2sAjMW1ts637pQB4Khav59fLhl
	mrw==
X-Received: by 2002:a05:7022:438e:b0:1b2:539b:496c with SMTP id a92af1059eb24-1b503175d03mr21231997c88.35.1794907661127;
        Tue, 17 Nov 2026 01:27:41 -0800 (PST)
Received: from DESKTOP-GSNRJ5L.tail4a8ad8.ts.net ([104.28.223.11])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50309b27dsm38381531c88.2.2026.11.17.01.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:27:40 -0800 (PST)
From: onLeaf <onleaf322@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	onLeaf <onleaf322@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: ipset: exclude add-path GC during resize
Date: Tue, 17 Nov 2026 18:27:31 +0900
Message-ID: <20261117092731.14656-1-onleaf322@gmail.com>
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

mtype_resize() copies elements to the new table including their extension
pointers. Garbage collection of an expired element in the old table after
the copy therefore frees an extension still referenced by the new table.

Commit cffcf57bf03c ("netfilter: ipset: exclude gc when resize is in
progress") prevents the delayed-work collector from running during resize.
However, mtype_add() also invokes mtype_gc_do() directly when its target
region is full. The packet path can enter this call while a userspace
resize is copying the old table. It then frees the old copy's comment, and
collection of the published copy queues the same object for freeing again.

An unprivileged process can reach packet-side ipset add with CAP_NET_ADMIN
in newly created user and network namespaces. The resulting duplicate free
was reproduced with KASAN on x86-64 and exploited from UID 1000 to UID 0 in
the initial user namespace on a non-KASAN build.

Serialize the direct collector with the same GC lock and honor the pinned
table's resizing flag, just as the delayed-work collector does. The table
remains pinned by uref while the lock is held.

The issue was found through AI-assisted source review. On the fixed kernel,
the same copy/old-GC/publish/new-GC ordering completed without producing a
duplicate object; /etc/passwd remained unchanged and the test ended in
LPE_FAIL.

This change was prepared with assistance from OpenAI Codex.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: onLeaf <onleaf322@gmail.com>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..70f768ba7b44 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1009,8 +1009,12 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	maxelem = t->maxelem;
 	if (elements >= maxelem) {
 		u32 e;
-		if (SET_WITH_TIMEOUT(set))
-			mtype_gc_do(set, h, t, r);
+		if (SET_WITH_TIMEOUT(set)) {
+			spin_lock_bh(&h->gc.lock);
+			if (!t->resizing)
+				mtype_gc_do(set, h, t, r);
+			spin_unlock_bh(&h->gc.lock);
+		}
 		maxelem = h->maxelem;
 		elements = 0;
 		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
-- 
2.43.0

