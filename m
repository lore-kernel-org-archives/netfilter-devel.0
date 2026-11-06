Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975431;
	b=PdThw8SoKRYBUgbK4VbCqvjwSqF7BEm/t5NCUVhROabzMsyy1yiFBYmcufkHU9I/Y5QQ
	 uwuM513nmSrkm1hTgnvUi+Qhwln8toUwreg7kseKJoGwZpYSG9Uvhta31gGOcLxCC3sqE
	 Jgn6tBKBJQHAnBAn5KvZJV+0DXFX6EeNbPd/tdZmrJo/YeAwBlaVqZN9Cu6IAeDCPSSGN
	 KrBmqahp5GN+IoJaG0hO3hz8JX9xfEz+2fyIJcZYzj8rQwVPS2se8uYr/TVLwewbaotrK
	 kAH3szmB2n7poaagjzltyjV5Veh3YiVV3/vXrYBIDtSnsgxKr0jL3v9c3YQxDq/6kbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Icbrb5scngfWY2aFD/U0pe9nOlFPqhkX8KD+VMafQzQ=;
	b=JUJLPxY1BSt+mPFP0rBLJYmRf8RoDTeaUwvUw42+pkvZmEwpnuIQ9Xgkq+GzOg8/JRyz
	 GDSN17u2+iHq2vCARZLlsFHFmN8yJFFvGXG849AB9acwewLMTnytJkSpyYNXfXp6i9Tgf
	 7H5MB/6Bt6Ly0qM7T9NQ9x6gDOc6MK9WG8yQ2HcQl2eppcnALVEIRlzV0lx2McdAmrZah
	 IdGrXDIDB9Te6WS6YcG/MaZtHcrIzJ7JLzGJP3p5CW70D4g3Rsq2yWLPQK0w6tGV5Z4HA
	 wGKVYK5moduxmIN6I2dFPgsRvwsJ7bDT+ndPjgylXg2VbWk8jH8STq6zFkKgcMIGwHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qCB+gXEt;
	arc=none smtp.remote-ip=74.125.227.199
Received: from mail-pi2-f7.google.com (mail-pi2-f7.google.com [74.125.227.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F71606A32D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 14:30:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7F71606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qCB+gXEt
Received: by mail-pi2-f7.google.com with SMTP id 41be03b00d2f7-cd66d7e32baso152033a12.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2026 06:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793975430; x=1794580230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Icbrb5scngfWY2aFD/U0pe9nOlFPqhkX8KD+VMafQzQ=;
        b=qCB+gXEtl/HXLnDDkuxkOBFu8aV6oTrgkxcK6fT9IjAzCKZmg+o3QVBZcV9tU/CXQ4
         l+Xt+SigmsN70fJIExTXEcn46MAwd3R4o9zRI6rmkpZzdNZRJVwGVg/pbUXXxq4rDZzd
         GQRrJW1xtGXXpFHHZ/XaBg4ZBWoXOR1CjzZT6nsGkyRt9asrn+/fkzIZFfshJi4fii1h
         4/qTmfblktYjHQP0EJK+lwlvy7mgES1X32dL8j05SzqaR5UsFj2xTD42nIjyFzQq7HFJ
         TI8LyecU21B6YjRQTHMfdfltO7QAgAGxzMpktecvsBxiL8e730BGMXO9KRTnQ4AYf1Ko
         IKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975430; x=1794580230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Icbrb5scngfWY2aFD/U0pe9nOlFPqhkX8KD+VMafQzQ=;
        b=Y94McADYKJXmdM+q+RH4gDvcmRXv/FZkRMHFGRfPJ9wYVOLHJa+WwPJjKdU0V87KXq
         o5EZ4aKzUzXP/5O48Zrd4wxcXCTScdCXuFpjxoEgEsrTxQJQI8oXOTN54gbQm92SxRVR
         YKruq+rg1snYkKaGgBUGHpqAPZjYHozPGCOmJbG9qlRusczHFWnhqERV59itZKBWMLdy
         tk41u9BpiW/OAPAimP4kKD2Ykje7NiSLN4y0FFLKNhL/t/W5qLMOlBOpwbQXoel7N1AL
         0NA9Kdd6cNcadxgQTanHi2eDwECViUunkZpAnEySEne4vlB/obMvsfo0eHYmVl559LIT
         8KDA==
X-Gm-Message-State: APuU4Z/7qjpxWdOQBL8bIk0IXmAuf1CCPiT8hiS9Q4n+ANKuH7k7R3Op
	EHlcA61DmNFZjKm04jMfq/lLV3KoI3A/0gEuGptYqq4qRDRN6fPxcXgcOITW3m+p7Jw=
X-Gm-Gg: AYBFou3K2ChoIjMYYMbBpg5OmpbaMnZfaH2721frPcZ87ngAGqdklZ32JXKXxjfASdt
	p/qBKf3+lPm7YJfVta1AuaNJ6gR9dH+Y3sNvb8jLTtDcPTZuUkTJpLRf8wL6naoqpafRw4TEyeb
	hzpziwVGh1pcSu7wku0CBbK49+zRQ9xzWQXOu/ErmIdp7X7aNQJgogP7aT1BzeSI1latvG8TF7X
	CTXHVXvthtsPsBwL7gspskkhWpqTD6LaPjjlzjx4suai6DGPlFIYNkDys7X+GExbwtlwO9W5bkC
	SvsK9ZHLB3rtUBbutqL+ZVbu0CvmhXn898xw7R+AGESHslhQC0REmI/tckQkq2DrMKzNtcirp0G
	1/qMW7mwml33ATUYvJDMoZkY8KtXDlRLX+nUdhGfMYTKkE4mzw31WuSBjepISGzuKmUgVU2wuoE
	p6hp6tFJUfX173j8Cqh+y4wLNhM+VO2lBYZ1WlNDmkpNzTbY3rVpKESQusFk4cyuED2LwgdA3eK
	2YmXAQSHn9ubIkqITztf3skltPUFd8EGuJo5U5GquBfc+pKDtvEw4CVkufTMPepqvbLV6OGV+GC
	A7YqQv2DpKG0U0C3OcKXz02TEEKSXwriSZUYvCqJipprVb68BaFE2M7T5YtBug==
X-Received: by 2002:a05:6a21:7016:b0:3e8:b7fd:626c with SMTP id adf61e73a8af0-3ebb29703e1mr3102628637.20.1793975429990;
        Fri, 06 Nov 2026 06:30:29 -0800 (PST)
Received: from localhost.localdomain ([2405:201:e056:a8e3:ff2b:1543:5b95:16e2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b359dc7805sm649845b3a.40.2026.11.06.06.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:30:29 -0800 (PST)
From: Vikash SS <thisisforspotifyvikash@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	linux-doc@vger.kernel.org,
	corbet@lwn.net,
	Vikash SS <thisisforspotifyvikash@gmail.com>
Subject: [PATCH v2] netfilter: conntrack: document sparse hash table eviction
Date: Fri,  6 Nov 2026 14:30:22 +0000
Message-Id: <20261106143022.412406-1-thisisforspotifyvikash@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261106135816.391285-1-thisisforspotifyvikash@gmail.com>
References: <20261106135816.391285-1-thisisforspotifyvikash@gmail.com>
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

When nf_conntrack_max is significantly smaller than
nf_conntrack_buckets, the hash table can become sparsely populated.

The early_drop() path examines at most 8 consecutive hash buckets
when searching for eviction candidates. Under table exhaustion,
this bounded search may fail to find an eligible entry even when
evictable connections exist elsewhere in the table.

Document this limitation to clarify the implications of configuring
nf_conntrack_max significantly below nf_conntrack_buckets.

Signed-off-by: Vikash SS <thisisforspotifyvikash@gmail.com>
---
 Changes in v2:
 - Reword documentation to provide configuration guidance,
   as suggested by Pablo Neira Ayuso.

 Documentation/networking/nf_conntrack-sysctl.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 4426cce2a..c7e9016ac 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -99,6 +99,10 @@ nf_conntrack_max - INTEGER
         the reversed address). This means that with default settings a maxed-out
         table will have a average hash chain length of 2, not 1.
 
+        Make sure nf_conntrack_max is equal to or larger than
+        nf_conntrack_buckets, otherwise early drop may fail to evict
+        entries when it gets full.
+
 nf_conntrack_tcp_be_liberal - BOOLEAN
 	- 0 - disabled (default)
 	- not 0 - enabled
-- 
2.34.1

