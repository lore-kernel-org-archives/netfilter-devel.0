Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795663980;
	b=3IKetOHlbYwf49wPUsDivjpztR32wj367F0jy8lbatpljJ9UAhiZpQAGnY25iY1Uvd6w
	 vcgiq5MSNViH3lVmHzzdbv1tpenDgnSYeAw/3HpERuJkY4PoRoQtXc55P6SYGCAns+kBZ
	 QpdzA5uSHvi0oge5zNIaeZ3AQiGuoPtNW9d1EncBdgPX5sE0YwYxy2VUkNi5BLIQjl5fr
	 wFBVoWKX+JdBYjyriN9UqdU7Uthclbw86xiZKK3G+HOzJ9We2h5GJP+F3CUbZ6yV764Rk
	 fswlWldZ8ACy3GCnnc3iq0T6JDaTZT6PtRYGyuvoKsoERmW4lAC923K/uWCWoJ/WW8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795663980;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSnKbcmh1AprXZucVEnbdieJWx9lo2C4/MqmRQAV/90=;
	b=Qp+kAmfU2CdoWztI5WdNHhPYx+6RffZkOTp31ajlgGTU5x6vL7NGRPZRHuC7jDacSsMv
	 HryNh5PNgKW6CeN+ETgqR7SpfLcduOt4SIyzdX7Ye3cm7brs2T1QmpbJnuTPIOzJPdZGt
	 +nEe8LKdZsFSqW9+6zfa3PPSEU+wavjIv69064UNHFkapBZvrZa2wAws4qDxxOmWCqD7X
	 ptNzU1CzXRf8FMtfCrM2Q7bIepJ1kSmrz+wBRP+ga3ShoRVxtCP6in6Li1l7UIKdyZHSV
	 FgrHJcIu/ZwNUgp4j7rN44ShDYeRh1sYqXjLtgC0kYWzn0BxvshiYCg/qB7nsamg5og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6456606A691
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 03:32:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6456606A691
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DC5D06055A; Thu, 26 Nov 2026 04:32:51 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 0/2] ipset: more hash:iface test cases
Date: Thu, 26 Nov 2026 04:32:44 +0100
Message-ID: <20261126033246.25717-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
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

1) Add maxelem upper-bound test for hash:net and hash:iface. Verify forceadd
flag behavior.

2) Add tests for hash:net,iface wildcard coverage. Verify that adding an
interface already matched by a wildcard fails with EXIST, and that -exist
refreshes the wildcard entry instead of duplicating it.

Both tests pass on unpatched nf:main.
rhashtable patchset failed the 2nd test.

Florian Westphal (2):
  tests: hash:net,iface: add test for maxelem setting
  tests: hash:net,iface: add of an interface covered by a wildcard

 tests/hash:net,iface.t | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

-- 
2.56.1

