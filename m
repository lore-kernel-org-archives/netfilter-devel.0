Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793661336;
	b=tn5RS6fQtDWbCGxjFIEY85tZs/qSxIWMyGCKe+W0xg8kBqxEmGWldSKlC1GzW/75ZPB8
	 4qUSjDGYGzWsheDcBAYR4pkvt5Kv+umUp8q7/7PJ0bSf9LD1nNtHJCi+eKpTVwTdtnQvi
	 251mTOQmU3qbx4mjd9pH7Fi/BslVePRGVbhOY6V50/Nb+ReAkr9hVRqIcME+RKZoelO9a
	 1flCVT3LaEBkIQWGwpbdIZ5godeFHrBuc9gneln9ZVoAkrcdbo77C4XCqTx0w7+gwzT03
	 NYyFlisJmTtSQ3/JO5doqPIFTuaZ2KylDn4GzpkcKztaAw0NOQs1V+Rw1vNwi46sLog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793661336;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=EMxNL/UewMVZwW9XoJ8tizSZ2fZWJjDE9DftmkLnki8=;
	b=RNSQicuW6LQnQ8Ew2yJoz2v4YXICHvs+x1Lc7n0atgpN6le9h99Lerr9BAgg7eqIKKwL
	 YFtquzCpZo8N9612bR7zdGGJ/ZP7pIAMpahmPJFBrZuMmrrRjiVcd6QMEOLRklLZUcsqv
	 gSwTsh2d6eiF6HaMh29ywYkqfwA6CffUpITpZMdZSNCo/jfkXf4AD9HB6tTEhZloO8Jlw
	 Al78teryyxdgcy4t81cCZITJQZnXyB3RAii85Y2r6DzR+t3IjkmuWQeZOVGXaJSeHUWm9
	 jV4Lj9ZOUjh0OQUL/1YDJ7RH/uuB9kIaa+oe/Z84ZV0Sb8MiJLJb/qw/MFzALdrz0IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tAU0LVUI;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9B9C2606A329;
	Mon,  2 Nov 2026 23:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B9C2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tAU0LVUI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793661327;
	bh=EMxNL/UewMVZwW9XoJ8tizSZ2fZWJjDE9DftmkLnki8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tAU0LVUInlbUZb946+TbPw74xpnHYjx80ryp1pK+lTs59T0wtv4c7BwEbcdYnkfXL
	 tCW8E9h9TS1yKChcCzUpMoCjCwHs7dyGy14/zzlEO9PVr6A1+nEJaCvtri9ojxDH2s
	 Xhsb+i7ybVRpU4715Gty80L+4guaYbDzR+P1sYkavuwq6LjPdoXKMzvuPkMhiBVix9
	 s3AxkTbr5hKm8NKkvquzmbjP4d0AvebYRZ7iD/LAQQe3mweGawlbDFd/EzW7BNo1BM
	 z9Bp2MPDQB/KsHvFXgbTrPKlXKuBZ9IsL8+5U4+ly4k7J1zIbKJgN0lkuVd7AX3SND
	 li5RLBKTMnMbA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id ADD5460054;
	Tue,  3 Nov 2026 00:15:27 +0100 (CET)
Date: Tue, 3 Nov 2026 00:15:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/15] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Message-ID: <aukZjB-Jt_UhRCFb@chamomile>
References: <20261102005654.532438-1-pablo@netfilter.org>
 <20261102005654.532438-2-pablo@netfilter.org>
 <179358116673.3286.17229865634602635672@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179358116673.3286.17229865634602635672@kernel.org>

On Mon, Nov 02, 2026 at 12:59:26AM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

Regarding the automated request, this series was primarily identified
through LLM-assisted analysis.

A summary of the discovery and triggering status follows:

Issues triggered and verified: Several issues were actively triggered
and confirmed via automated testing. This includes KASAN reports for
use-after-free and out-of-bounds access (patches 3, 4, 11), syzbot
reports for warnings and panics (patches 8 and 10), and a confirmed
sleeping function call in an atomic context (patch 14). Patch 12 was
identified via LLM and subsequently verified using a userspace ASan
harness.

Issues identified via LLM (Preventative):
The remaining patches were identified via LLM-assisted review. These
address edge cases to prevent future issues such as unbounded recursion
(patch 1), infinite loops (patch 2), stale connection growth (commit
5), chain depth exhaustion (patch 6), guard loss during reinjection
(patch 7), NULL pointer dereferences (patch 9), memory leaks (patch 13),
and uninitialized stack data (patch 15).

This is a LLM answer to this automated message.
