Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793521064;
	b=vBI3kn81KczPhYuEyV8FQ64eo7WfXvFNzP9V1Mr1rn8MgtXJEJX3SSrWnQ96p+K7vry9
	 geUnCZqm1p+amDCOpbyzX7/StImzRGihg8/21gAJ2ILj+MhcQSls9HdWv8qzfvrRuuLj2
	 r5LJw68dqP0qhi9m08ZrkTQOewDT7usvtnYgOZaO2abfnsmWHnWO4UsbgP4J3MXRu+VOu
	 XfyuvjwLh6DO/kz8hk/RQbyJCm/ZNH2jY2jsvOTu+X8n7BtbfwslD/YrJaU9VMC6pCjTN
	 N8VlNZWUj+J5Meofitx+9rqvg9PYUtTMVido96Y7rGyV3h5F+xCRXz3LxfGnuxfH2tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793521064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OTjm1dRowZIe2r6H1xJ9iOraQ4+BG5KAu0AE6tkBlgs=;
	b=crd4j0KESOKWZhNph47I9MF7PyQm7rGuTZcEJyyjKHnxK8QyAwA47nwm2ozZvjllmwqr
	 PA11QLtQKg9p/KSZTEyz5ge4FaPeT53YefZ8fSn3WOpzGiOycP5m3z/SJCfZKAb8+iy1C
	 b51QcMGhT/6fGzUqLU7/jMBjEBziT+viNzCY3UY0Vbx8/erM0jjaHQDtfk9NLSj0yL9Gl
	 Q5srBGyxCNJmeZoEOSBvjVxFWU8bzWakNt7z5uGu6t2wj+B9Cxqt9gDH/v9E0tPRFaxsd
	 pnZi+MXXHG285UaXWS0hOETFYsje5siE6FRFdorwiZ4i05mQ7P4OVXHmYR5nCrcNlUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LfQN93U8;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5909A606A325
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 08:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5909A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LfQN93U8
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ada8bc2380so901791a91.3
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 01:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793521064; x=1794125864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OTjm1dRowZIe2r6H1xJ9iOraQ4+BG5KAu0AE6tkBlgs=;
        b=LfQN93U8rZAbvzHs7ZZZcu1MeQd4rZwIEKoFakEJDMEbmdhjfcAfSF1dFYdBcwiSHm
         10i8xSIZoedMZdK8awfK+xM+ziKF2tZkuTMlS8D5Fc37yw5rn9f6obMhu3dUca+g1FY3
         DKkB400y7DJjfsIFWgP54EVaYa5SVVbsAfE4RqQDc3UjfVBcXE8pCrMhpC9qP5pVRI+4
         y6Kng6pEnFZtYQlpnAEeHzFpAhyXlG3hFp2QrB3tQqgA4wpfutlLYapR/Z7p38/blgqi
         KWv1iXY9DBZvByKSBgUnicpD4musrNDMey1kXtq2/AmE3aEY36pWAD+vHhEUHwhkKiPz
         3hEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793521064; x=1794125864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OTjm1dRowZIe2r6H1xJ9iOraQ4+BG5KAu0AE6tkBlgs=;
        b=Vj14eS0apygYjiMlYdIGj1shqH46wRAmznHkyp4ktuYHMs9F/8g7ZJ+dZaN/1HlVUk
         1d9SsVipIyh2vjdBwIcWAVJ9tCIML+sm0VsBeotxjhOiGqg6AGXnI8wK6Zc5ofdHbVOA
         PZiR/rtqAMVEFWftnz/r13CaMLLSrdwIvHBNlAWQQRNrYPXERlFvXF9WiHk7CyPib3sJ
         lAuObBoNVarkMxfVbohYsMrVfXxKg5Qq+H6k33Je1YUJP7FguvpDaa374ZL4iGaI78Ln
         mcNmKQGS4CJKSF/i3M3gcpbzlc2dQORKrLZMYVx0XkYu5+UT3QJ/qso5JNx9DrUlXnsh
         EEIw==
X-Forwarded-Encrypted: i=1; AKwUvBzH0fBhTOJsqT3mCGUB/TvM2jZndeAYXhkJPKR2caR9Wd7ItDtSJ40l5fHLtUjn863hkRaenfzEr10UvMu/O3g=@vger.kernel.org
X-Gm-Message-State: APuU4Z/4awykXseKqbYCcCU6cddsLRqSfy0ZDBxRa+zB6/VOw4v2rkr/
	srMSzJ5SzyfkLUjhQa9bTaM8DKIg5vJ0gOrHjqkaMYt7o127+d9GDR32
X-Gm-Gg: AYBFou3kLTYOYfmveIcl0FSV8020xJEg37ux5tSf69m6LLCb57kLgVoERZlyRhYkewe
	vruvf8P9A2fo5K2dOWuidmaKhujM4bbuzHoQFc1YcIB58mYh+g2Ikv3690NrpWlF7NpG69X5o/y
	2Jd6cAdS3N+bGJvetVag+9rywldpSHFGQq+f3J27J9bCyvadiJZ0SCK0+3zS4k3jP9mMQJXk8Ci
	pb+P1Fo4axaYZANxaIsCwLj7Q3fAWwtxlQviiJgbYT27snGj4dV4JyrxcuwIjDB118eK8rpkwBW
	WFVjEWYKW6Mc7PrI0LRTVzNN+ej5amCZ2KtJ164F2rGL1sJiC68Jkn74Sbp6KM/ZUEcf6on/51s
	R+7sy+vCTXgebLaPyCRVBmsNBh99xb7EJAcpXeIa6fgg2UMnokGHIkAVaC1rGRRAb9LPNZjn+NG
	WV58SdI44t8fRR5YBJHAIrmayQZwlcLv3w54zoqGprLM4aAOwTOIQnYC3Y1dXWUzsdXRSseFqDh
	pWwIlN/ZUIJiDkUVzw+Yqp/H4I7YyWHoCrIYdGolpZw6F9H98/nP2rFbdvITRrLfO0kkWnxzOTw
	Qjn3IO9OcBfuh5M9Js6z2ab24oLDXdUDFVQRsnfSiRw92Ay69aN3tbjB4+RwyzEI4u2G43liDdY
	UOj/TIaeFcYzqvMJV9oDOyfY=
X-Received: by 2002:a17:90b:5886:b0:3a8:a98c:ea07 with SMTP id 98e67ed59e1d1-3ae896f8551mr5236140a91.13.1793521063450;
        Sun, 01 Nov 2026 01:17:43 -0700 (PDT)
Received: from LDYT9Q2G2M ([2a09:bac5:cad2:3228::4ff:28])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae84596e3bsm10011455a91.9.2026.11.01.01.17.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 01:17:43 -0700 (PDT)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Finke Lennart <lfinke@student.ethz.ch>,
	netfilter-devel@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org
Subject: [PATCH v2 0/2] lib/ts_fsm: preserve patterns across tc dump and restore
Date: Sun,  1 Nov 2026 16:17:34 +0800
Message-ID: <20261101081736.51803-1-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
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

Dumping and restoring a tc text ematch configured with the FSM algorithm
can change its packet matching behaviour or fail with EINVAL. This series
preserves the public token types returned by textsearch_get_pattern() and
adds regression coverage for exporting and recreating an FSM configuration.

Changes since v1:
- Describe the tc userspace impact in the fix's commit message.
- Split the production fix and KUnit tests; mark the fix for stable.
- Add KUNIT_EXPECT_MEMEQ for the exported representation, as Andrew suggested.
- Add tc maintainers and netdev to the recipients.
- Add actual loopback packet classification and performance measurements.
The production code change is identical to v1.

Validation on base 2a500a04d6f969318c05f46aedb6e73fc1963a00:
- The same updated KUnit test and ARM64 GCC configuration fail 13 of 15
  tests before the fix and pass all 15 after it. ARM32 GCC and ARM64 Clang
  also pass 15/15. Compilers: GCC 13.3 and Clang 18.1.3; QEMU 8.2.2.
- In an isolated ARM64 QEMU guest, a tc basic filter matches the four-byte
  UDP payload "7777" and rejects "AAAA". Recreating its DIGIT/MULTI text
  ematch from the rtnetlink dump makes both payloads match before the fix;
  after the fix the restored rule still rejects "AAAA". Every probe is
  observed in the classifier's evaluated/matched counters. Restoring a
  PRINT/MULTI rule returns EINVAL before the fix and succeeds after it.
- The guests have no external NIC. These tests use direct rtnetlink,
  rather than claiming coverage of a particular tc save/restore utility.
- W=1 reports no warnings for changed objects. Sparse has no diagnostics
  for them; an unchanged ARM64 vDSO object has a declaration diagnostic.

A native ARM64 userspace microbenchmark of the mechanically extracted FSM
matcher (GCC 13.3, 64 paired samples per case) measured median paired
slowdowns of about 1-5% for the tested long character-class scans and
about 13% for a one-byte rejection case with appreciable variability.
These results do not establish in-kernel or network throughput. The extra
lookup trades matching cost for avoiding a second stored pattern copy.

Mainline cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a, linux-next and
mm-nonmm-unstable still have the affected code. The series applies to all
three checked heads; they were not built or booted for this revision.
No x86, big-endian, sanitizer, module-load or stable-branch runtime testing
was performed. The packet test measures matching, not dropping actions or
network throughput.

I identified the issue and reviewed, built and tested the v1 fix. OpenAI
Codex drafted the fix, tests and changelogs and drove the additional v2
validation. The added assertion and revised messages are AI-assisted.

v1: https://lore.kernel.org/all/20261031052307.23533-1-zhiqizhangg@gmail.com/
Review: https://lore.kernel.org/all/20261031202211.22f18bca7819dbe2d107d17d@linux-foundation.org/

Zhiqi Zhang (2):
  lib/ts_fsm: preserve token types when exporting patterns
  lib/ts_fsm: add KUnit coverage for exported patterns

 lib/Kconfig.debug                |  14 ++++
 lib/tests/Makefile               |   1 +
 lib/tests/textsearch_fsm_kunit.c | 138 +++++++++++++++++++++++++++++++
 lib/ts_fsm.c                     |   7 +-
 4 files changed, 154 insertions(+), 6 deletions(-)
 create mode 100644 lib/tests/textsearch_fsm_kunit.c


base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
-- 
2.54.0 (Apple Git-157)

