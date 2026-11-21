Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.25.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795271682;
	b=mt1FVbVO8mSpfL6G3E65tU4Y5U+RZSFwq+UeiF9jFrWXAXGzydgY0UYTBTIEF2cbB0F9
	 Nm5xKOpx5C9dw6TOhTaUxNFtvvpEuKneqkFOFzoF2nF3u9VaB5snttc7X+CNscKjhOVh6
	 rwuy0NDLsYOEAFfhdaJNZYn0nc5YJGI/zz3X3Lr6dPKTbrmd5JuWOaCdCf78Fp1/z9BOg
	 EZirNraltXgVw8hY3ei/0vQwuEBLuTXqURIjZ654mFawzYwexNaw8KxXPPTA8z7pGBG2r
	 H0yTtowLhbN23uuG8CR6/bZWXmQJOBz/cC2vxMXn3kvxswBPmPHNpPoI2tg3EZqbSOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795271682;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Infomaniak-Routing;
	bh=OwAlrcqrYc1e+W/MCG7/0gwdwdNzdACpmjSy8co4Gj8=;
	b=A5uQWDcnC1AJolLELZHYG1upEztd1om+PFXF8NpZ6XQMepDzURCOk2JEEEmztDlfjIrO
	 N3z3kSrAVLjQqHrK7AxFalrisefWDfYYF81cYYwUESB/Br4XirUuYoZdf54IdQBWuTfju
	 Yv9cjYv4/Gvn4ALIRANsilB+NPtZIEEIlCWO/Z90LWavvaK0+NleT5QNB5yAVZVOIhsUr
	 e8mtPoBmp/LRxhgssxy0nKpuaCVWaDKB4Sq8lISSKTLx858Uf4dmCf5wdhEZ6l2ZgLuKS
	 IYh3h/k5v0sFp3lioVJxalVrnUCOBZWnABA1x9Mj5DG0aagW0vDMJF1MacbXEt2EWJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=kqg7f1Vl;
	arc=none smtp.remote-ip=185.125.25.11
Received: from smtp-190b.mail.infomaniak.ch (smtp-190b.mail.infomaniak.ch [185.125.25.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B30D606A33C
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 14:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B30D606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=kqg7f1Vl
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jWvqF0pg9zcVN;
	Sat, 21 Nov 2026 15:34:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1795271672;
	bh=OwAlrcqrYc1e+W/MCG7/0gwdwdNzdACpmjSy8co4Gj8=;
	h=From:To:Cc:Subject:Date:From;
	b=kqg7f1Vl3MTZYpnaKMf+VmhmOjs1hb1f+RGfk6hA5efu3TShJQrTvCW1Xe99JVJdd
	 GTCOsGGAsWgeMlCPdQWUySTy60hCKSV97MBqTdIv1JbbmB+rvIPeHamMWNuwXnSJtf
	 cz2l5l0uwhWUYx6/tv5VvmikFr170+IjdAn1v8YlTwgE7dWvMWTD0Wvc7mu0gofb0c
	 f9pn3Ac7FOTAKrkp258Dke8EYbAj8tLPpSdYxOYsD5Pkr1wTS57MCXYsO7RY1TpLRe
	 ON5qQx+rhb+WNbx3xaAxH9KRztIB/L9mhczT1j3Qcydv9nuL4//+sAIVBRm2yEPRyI
	 3cE+YVhvKvvgQ==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jWvqD1kVdz6f5;
	Sat, 21 Nov 2026 15:34:32 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl v2 0/2] fprintf trailing bytes, errno sign workaround
Date: Sat, 21 Nov 2026 15:34:05 +0100
Message-ID: <20261121143407.19426-1-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
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

Hi Pablo,

Thanks for applying patches 1-3. This v2 reworks the other two patches
of the series:
https://lore.kernel.org/netfilter-devel/20261106191841.1645-1-florian.stosse@harvester.fr/

Patch 1 makes mnl_nlmsg_fprintf() print the 1 to 3 bytes left at the
end of an unaligned message on a last row labelled "trailing bytes",
instead of reading past the message. Aligned messages print exactly as
before.

Patch 2 removes the errno sign workaround in mnl_cb_error(), as you
suggested. It removes the branch for positive values and keeps the
negation, because the kernel sends a negative errno. So -INT_MIN can
still be computed for a hand-built NLMSG_ERROR, although the kernel never
sends that value. The note in the patch has the details and a
branch-free alternative, in case you want that case gone too.

Florian Stosse (2):
  nlmsg: do not read past nlmsg_len in mnl_nlmsg_fprintf()
  callback: remove the errno sign workaround in mnl_cb_error()

 src/callback.c |  6 +-----
 src/nlmsg.c    | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 6 deletions(-)

-- 
2.56.0.windows.4

