Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D596A1E9B1A
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 17:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768671157; cv=none; b=Umr6umAkLJUmcoReGQd4Zr9tEh2GKTqzVuJQK9ro3uLbpBM3IvTQsb1wNVPMIztD7LHy67kPxnHlC7/IaG+mwRL49oz9OJxfyodvaIuEAiIGVAN2HHKqpf+taOCNc9NY8Dg3BJe80wi/8m9GeL01Ao8Hj1hDD3ngPv+5KTN19QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768671157; c=relaxed/simple;
	bh=i1mATf9Ptiw/oQ3Qkv7uYUlssO4aEkJWpF4KIpp8hJs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VxTB1Lbai3RB1sWf9ECQHmAC6EKR4nW0C2ubJ6WXhVIvpnSSvEm5q8XkfRcHMW+5tEFLC7+uTzRlAagIvFpTd/CAZ6KL86GhoBIAmj84ye0LPudgo889nTjIdUUmPys/HxpEfBG2jayXTwsC4o5JXY7GL9TaTeyZb5l/pBIRHA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXlKgjmQ; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXlKgjmQ"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b6bb644e8eso3481454eec.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 09:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768671155; x=1769275955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R6gEaK0aE35YjCrECbEERnEdoE/GiDCyaJrkeJSYjdY=;
        b=PXlKgjmQBhwQNEP5LGSYeo3cikom/7FTyWZSw0GAhzavUYLbA8GMKNwsAhtcAv+vUD
         dAMzonLHyKwETA6Lu7JmfrxEYvpo7ZM2D+k5i+aIeAVeyQVP5VN/QwN+fDuElPTVdG6k
         8YAPZUs7LY0G1AUBzCQyG1QAjfmq2p9sTdwJtNtMCLsau9uA8LM8J5hctU/olHqYcNsK
         lrEAT2NHCwXkqVkti4Z5ViCF8cfH16Xxd0mR00FU1EKFK122S54AmLIAOa0uOLMdFgoM
         acJiYpxywgwOqx0MGjzeufPSsSg6UpoQIuiBNEZcTK7wJVT53wNjHW0qKGuh75KLgeza
         lQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768671155; x=1769275955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6gEaK0aE35YjCrECbEERnEdoE/GiDCyaJrkeJSYjdY=;
        b=uWT+L3VM7QWm2qN4fm02xH9Vsf011EP5z+/1wrojfdk7V2oyumuBpudmba8FlUQ6ok
         gK/vuNKCcdlbKlVSkSIF5FFt9EV4fTV5gXf+J94lMHoencB4RlJoxK0ivipcFIy4Lvtn
         0NbRINpL8RhMvCpPl30D3khahubwxA8OGMzMOv+lGP74PJDoOvY+9exFNB9nxmUa+Hp1
         oDCHkZgETcUtR8+21hWJVkS2/wjpzwpGuxHs5Bm5jdORZOArLYtcY1N8BWwIUcIGAAIE
         rfJaMgkL0s0xZ3nAzDEMtqhibtI8Sj0UZYyjpLqUmQ59VFJIV/1H+5wsMKD4WQXOVBPW
         cj4g==
X-Gm-Message-State: AOJu0Yx8nkVDjFEI5+1YhudJOi/BgvlcBL/iP7JNMf4iS5PLXICDAKkY
	MK6CWIyMlxN3U3nE6f2YPRq9UP0mnqO5hhPR8hZPOCneTZKFdKqem3ojhY2Nzg==
X-Gm-Gg: AY/fxX6fv3FI4//mKooHXaLoIfnvI6OvTZhnUjPQxCyzCRlR0so961G4M1AxDNdSA4D
	A4ErKNhZC0MHMe72arjO7gKIf4/Pz3ZLndPlLKK06fCmwIuHsVwOxz2rlrcM/X4y1SIQhFY6dJr
	lhw2PLv4fArC8WXPnr7A3GLuzLdLsM5e0u9m1wAGinBf9xkXjzfhrIY0QGHC9FyrIZqrqtoebwJ
	3hq2dB2iiwQiJzbgPMHNxrkWF7Y0V3RrP4c4IfYNnM9hb1IF3ZiKeDdpcjtGX0I6lxizZGMWnS1
	ZsEu6UXfv284nlDM4W8FIGD1da9NmzanNaqjpMTs3WEozqrZn2PC2B+hUBa2SKx5eC5bo/Bj6Vr
	etESlqlIYnOphI3ULzwPbr3QiNodbSLeIk8obLU/oh3PlzvY9v2fZpk2CNtgjmqmgEMhrIIXNIp
	vSj7WXA5t10DpoSC5KNFPU5Q==
X-Received: by 2002:a05:7300:5714:b0:2ae:5ddf:e203 with SMTP id 5a478bee46e88-2b6b3f2ffc7mr4284195eec.11.1768671154548;
        Sat, 17 Jan 2026 09:32:34 -0800 (PST)
Received: from mac.com ([136.24.82.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b361f5c9sm6486614eec.22.2026.01.17.09.32.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Jan 2026 09:32:34 -0800 (PST)
From: scott.k.mitch1@gmail.com
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Scott Mitchell <scott.k.mitch1@gmail.com>
Subject: [PATCH v6 0/2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Sat, 17 Jan 2026 09:32:29 -0800
Message-Id: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Scott Mitchell <scott.k.mitch1@gmail.com>

The current implementation uses a linear list to find queued packets by
ID when processing verdicts from userspace. With large queue depths and
out-of-order verdicting, this O(n) lookup becomes a significant
bottleneck, causing userspace verdict processing to dominate CPU time.

Replace the linear search with a hash table for O(1) average-case
packet lookup by ID. The existing list data structure is retained for
operations requiring linear iteration (e.g. flush, device down events).

Patch 1 refactors locking in nfqnl_recv_config() to allow GFP_KERNEL_ACCOUNT
allocation in instance_create(). This unifies the RCU locking pattern and
prepares for hash table initialization which requires sleeping allocation.

Patch 2 implements a manual hash table with automatic resizing. The hash
table grows at 75% load factor and shrinks at 25% load factor (with 60
second minimum between shrinks to prevent resize cycling). Memory is
allocated with GFP_KERNEL_ACCOUNT for proper cgroup attribution. Resize
operations are deferred to a work queue since they require GFP_KERNEL_ACCOUNT
allocation which cannot be done in softirq context.

v5: https://lore.kernel.org/netfilter-devel/20251122003720.16724-1-scott_mitchell@apple.com/

Changes in v6:
- Split into 2-patch series
- Patch 1: Refactor locking to allow GFP_KERNEL_ACCOUNT allocation in
  instance_create() by dropping RCU lock after instance_lookup() and
  peer_portid verification (Florian Westphal)
- Patch 2: Remove UAPI for hash size, automatic resize, attribute
  memory to cgroup.

Changes in v5:
- Use GFP_ATOMIC with kvmalloc_array instead of GFP_KERNEL_ACCOUNT due to
  rcu_read_lock held in nfqnl_recv_config. Add comment explaining that
  GFP_KERNEL_ACCOUNT would require lock refactoring (Florian Westphal)

Changes in v4:
- Fix sleeping while atomic bug: allocate hash table before taking
  spinlock in instance_create() (syzbot)

Changes in v3:
- Simplify hash function to use direct masking (id & mask) instead of
  hash_32() for better cache locality with sequential IDs (Eric Dumazet)

Changes in v2:
- Use kvcalloc/kvfree with GFP_KERNEL_ACCOUNT to support larger hash
  tables with vmalloc fallback (Florian Westphal)
- Remove incorrect comment about concurrent resizes - nfnetlink subsystem
  mutex already serializes config operations (Florian Westphal)
- Fix style: remove unnecessary braces around single-line if (Florian Westphal)

Scott Mitchell (2):
  netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC ->
    GFP_KERNEL_ACCOUNT allocation
  netfilter: nfnetlink_queue: optimize verdict lookup with hash table

 include/net/netfilter/nf_queue.h |   1 +
 net/netfilter/nfnetlink_queue.c  | 304 ++++++++++++++++++++++++++-----
 2 files changed, 258 insertions(+), 47 deletions(-)

--
2.39.5 (Apple Git-154)

