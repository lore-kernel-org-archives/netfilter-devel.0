Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714904;
	b=SY3DeYI60PP9zJlMvw/kOojXfszat/LGv9sewVcgwPR9jCnD/4pS24Nhgrn05eBnIt7u
	 1xKds2JeeA8F47WqZMUDwhZ89qOBjYF/oiCUl0+3XWPiWW9b0Js0egeTeKPrAVqTV8GJv
	 pIdNsnRkJRHQiPQFWNl7qiYs6kP8MbWkB+JeLeltWSyzexmP/7RN7RQFNGnkt3WlxZSfl
	 uI/EW3jCvnwTf/V+SajQXzqLZF2HGxPdHwxM2yycwWXabJ6P563XLqd5UxVBSvsMT9jsi
	 lRqr3hmvaadQTFi/HooMAXSXUJbfzoplzLg47e2pdM3fbhdRIDQgvWWH3TWipiYzWzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=mz2z/I7Ew4mK9fAhYmoWA9TpaISBVKhaQLcNKHAlCdWbEDy704+vBirlJRF6UVnbxpEL
	 hJAZyl/ezZIWRFlgRc8MQnE9a47srtD45/HqK62XJlzVg2zQ/IaszLU4oKoe3YgY4AQVO
	 Z6kK6kHagDXYPys85eEND3kuhxUaV7sNO9UeHRCTwf+Lq/3VF7LhfYNHSTaNZ8n7EB4Vx
	 YD59ljiIuPeT/toehfeIrPvnP3FFlt3BsSeDKJW9ni1Z2doy+7z0W8TwZcHvJBLQM5gDU
	 6tstUxX/FWq4ccn5nwc9OdNXxj24C4peD8GDrQC8anzDgJxuFYuX2X/26W5SR/Jb8/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifPok1Rn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2A606A324;
	Tue,  3 Nov 2026 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifPok1Rn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7BA1F00919;
	Tue,  3 Nov 2026 14:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714903;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifPok1RnYt/lCsMsF9vkawyAJOQtr67a3VGkfAGkyNf6Tfrq1Dm5sh0UeaYW8BY1Q
	 MZKZBTFxLQJHNsMEm1nk4/fQzOu9ZuTlfPlp30rR/whrzWmMhrxyjFMOfakrWozUIM
	 s8QS8Gyo4uc1pcARrkiawkAn27o0tA1rB7R0qjal698oD7DZaKFQBKYwj0r/RRbJKH
	 L4KhfbwNxFx7uzeHKAOwhEvcgfrrmznP8MKfRN3+0jOGWhR29x7x+7BKKaST1uN21G
	 fsxQMK/MMzpqZqwE733lHftMXc4yLsZOYc8jXzcRL9FYgkRiLzn2Lp/qeQ2cT46W4K
	 yiNG2yXcG45QA==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/15] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Date: Tue, 03 Nov 2026 14:08:22 +0000
Message-ID: <179371490251.488859.10524309340047922861@kernel.org>
In-Reply-To: <20261103140308.591690-3-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
 <20261103140308.591690-3-pablo@netfilter.org>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
