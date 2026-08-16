Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE13BE163
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786893782; cv=none; b=bBfDqKZNwc/OvRNhbKx47UOPdHQgfN2BWLoihU79eu3TQAVWQqGQfCcfop7AxzKahYyrFKCpALQ2+6V3iBfueLkaOgc+wSGl4Mcg8DLyWq9wIy1SX3TdzlvuSE9DLluyOmyfD0YmC/MPG+VBUCBW0MrlViqpPit0LVjIWJGtBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786893782; c=relaxed/simple;
	bh=mQJTq0f6+lqaotU7la+SCTqZYgpv/z4fQK/LUIpysFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ees2jAHKUWUikasfH3wR/G4UVDLYN7NOFhuR67TsxUXvhxRvtlQcZtDcGaYVCLndpI6Jqppr/+8SS5bKKOVWHCnKB1+jo9Ul3kXu+SkcqGBK7tIW9Wf+AA6za7WR9lpJ6Got4wG0G94rEbFCgdzqDm6vxBO05VFtpa2F9kUoKK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=DdBiiXyI; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="DdBiiXyI"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84faf0fa17eso2530150b3a.2
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 08:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1786893781; x=1787498581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fDUCcFtiGS+0AQzyulJldc/gdnA/Tuwf1iE/FWDjOo0=;
        b=DdBiiXyI+wZKid+EQRJbR0nKqRmMD+mJVoqKmWbw0JEUSU4B7bcNqWCy+fxBUq8fNC
         /dVCaQb8wuyupt+cjrxZO5XlrC3sVWdxVAUOPQtGEuRjF3dkc+VjYaPzaaBZWl4MwAdU
         nkxejCU/yNyU1e/F+/gsNHJFjmqsfzERZWyJHJjFa2kXCytk8gCc8lsGvWV+PX/uLaLq
         OUV3MGosFj+sPulcv/ZNjWvVw8fmk/hhUhXAe86g8VMx2IkEzTN+4AOkPxxSwjV0//XH
         1TWjZmlRYiX3PFAygzQKlSt7+HVRMY6v0ccvrXV0FNQYIaFffAXsvewRu8cXXOMV9jZp
         gYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786893781; x=1787498581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fDUCcFtiGS+0AQzyulJldc/gdnA/Tuwf1iE/FWDjOo0=;
        b=IAKB9KExb+/woCWTMqyCRJdSHymuPNoJ0fMGhI6DTUGjA8/wyetU0fZFa+z+q9gqVn
         a8lPT94kXcG+JpBe+XjGeF8aEObTKy8X6mWwrZNopkZ3RQjmG3ghYYf1TWNAIedDzISp
         abKnEdF1/JysRGsxwaM1ogCAySQdSzAkWnAbXS/Zh7Cc0ppg+dnADwlSMf3RE97pcZgm
         Ryo7+CxrnR7SR3unEtHWLVCRTkVIClY1B7SMX9nw0larVw2FYWWwc1WKHDWHM6L9m/n0
         bkrmYzBUtkGA5n0t0tt9pP2AXhBgMQEm0SPAfcWDwm/msrco0jgzIUh1pdCFVB56+/ic
         Sw3A==
X-Forwarded-Encrypted: i=1; AHgh+Roj9Wus4MFzpJiqdxLdSaGjxydZbZxQ71+hA1zi2YouCWhAsiVdsGipeUGm49xRYQzwVii1sIOvZR2jiifZOns=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOs7756bpvf/EbfAxxDgI8PRQzYy60SqY7vmRUtLWPNr243068
	sYuLio/UpDHJn6xgHiKwMYsHem2SX9xEsoIBZSmQrbZNv4064KwoSS2LMZa/TzabptTg
X-Gm-Gg: AR+sD1179eTNP6eJ5QQ8uA8NYxlJGBEBqSY2VZKkY/VOXAK49ry9IvLbwH3pJuBkWAx
	vBm9P4+ACKp0t1vGcQMm5tuhjfFr+7FCnvw0pXFcFv0yLEvhVuwgyA7gx4htymejt8HL19owWVK
	oRhLrwioTVch9Cu6g1+fL1QHeajkkNdJTJdbu0kSTl5K90rZppMkMD6uqqs3fP9JmfWUgJkNkaM
	CbUek4uSma7aPswhvHt7z3sT/zVeUs9dXvOloJXP4ZnJKKOI0q8mIvAIZEBBBjsI264RpSwXJhb
	4As6vHLbibKQkg4KxgQHSzUh22sRuiSZAf0jXIGHCyYw1+5uMp8OKU8Vmh47ybx5t16czqVaKQD
	mYjb6yzJSFwGs2Xc6b8AorO07kgD2PAZIYkhY2RAF7McSLwET6evY9YW0PVKKEK2Iy2RhkshHCP
	jqDG3IX07kfI9quJfymji1fKjjijXSwGBC++e+dYZBCD5ikQwqM6gDNQ5w+uyr7hetSXZo
X-Received: by 2002:a05:6a20:d4c:b0:3bf:8604:9a3c with SMTP id adf61e73a8af0-3cc71e020aamr22812606637.28.1786893780673;
        Sun, 16 Aug 2026 08:23:00 -0700 (PDT)
Received: from Roxy.localdomain ([2602:feda:30:ae86:216:b3ff:fe40:dc4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df03d4sm24352629eec.15.2026.08.16.08.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 08:22:59 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] ipvs: bound LBLCR cache growth
Date: Sun, 16 Aug 2026 23:22:13 +0800
Message-ID: <62790a9f94ac5318f107a1811cff5a1f2fc7e0bf.1786884824.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786884824.git.zhilinz@nebusec.ai>
References: <cover.1786884824.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip_vs_lblcr_new() creates a cache entry for every previously unseen
destination address. The table's max_size only tells the periodic
collector to reclaim entries after the cache has already exceeded the
limit. It does not reclaim entries that the attacker continues to use.

Reject new cache entries at max_size. The scheduler's existing fallback
continues to use the selected destination when cache creation fails, so
new traffic stays serviceable without growing the table.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/netfilter/ipvs/ip_vs_lblcr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index f53f05ceea36f..91fa39edec0b5 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -363,6 +363,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
 
 	en = ip_vs_lblcr_get(af, tbl, daddr);
 	if (!en) {
+		if (atomic_read(&tbl->entries) >= tbl->max_size)
+			return NULL;
+
 		en = kmalloc_obj(*en, GFP_ATOMIC);
 		if (!en)
 			return NULL;
-- 
2.43.0

