Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794203858;
	b=UrFqL9mOZVTTr1eyDvFgr8AF6AC8i0OCW9TbcDwjyZW4nQ2lNH0SZ7G5ChkrFPbp5H18
	 VbhFtsiyr1dplVJ4xcjQDOS9g9c4bA+IaVJ4+9fQGAAfeE/6D47Y++OQi4Tqi2zme70oY
	 Y6RaszgEd/MJWzdZrDFalNEIPH7JugAvQP1d1G1CyjOuO+n4oAZT8eTeajSdnZbpbUKSR
	 Xc3E4iATs8zBrHq4Yd37lg2lHE3yDDNfV+P9lNVnkyrtTBhkBXDqmmqQb+73IhDwBqkBs
	 Spw1EtLBVJoJDQiorDxqB2uJd0L3ZYt1FDaSQkEmSR6VZi6kwmqDKbsfm/OqZ+h7NQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794203858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=qx9aWHtRKDksa1LYmyxdr/qfWKsVTfaXl6OZkFxlBxLLubE1HKnO7iUziOGEKm4J1Gul
	 tlSQi9V7yrmn11Wroxmjc5e4R2+iHHXT5nTpTL7FX7UhT0lmZ1xe8EkN8ZvISxVW5Amzg
	 gBge6/rdMNVShdgpjFwBnjskF0VzA0LiWijx8D1RrFR57iIU35Utu5wxWDdeLIV/3LoeR
	 lf/55THsaAS5uELU7hz8r79EXM5NfJwmK9eMKz6cg9jGi3E/gYR3gW2dhRiB8o2JOAtdC
	 kMxZ3R5wtKmh1aOte1dMlGp0lDFSXc7jtUlO+gSsm6aQJA+YVph/VVMLpKhoKNWmKKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUzcq5n4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61058606A323;
	Mon,  9 Nov 2026 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUzcq5n4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD6E1F008A4;
	Mon,  9 Nov 2026 05:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794203858;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUzcq5n4Q/JFEV8CHjhcN0NYJ5nQMLbsAaXlM+q706Sn+8Fr4uqU1sqltwlZ8mw04
	 TB/jSL5yn4Tu2DCyHMNbGynjUTotqIlinTDHIMaA77ElnC+ajKFh8YRG79t7/6ScMq
	 EKvdZJH3imxVFYMbXpxXZOb6WwX/oGeU+jPLJcx4tHX20zbZbpeRb85zzOteV6d7nM
	 dbdPoI8nuQ065P6g2ZJlfdcaF+Z+FF9T0mpGnrW7a/lrCvlYJwOzDknsb2KGQST8M6
	 uf/pSX2ot/is1IrnOBYhwR5giywVB+t5AHBxQGc/XAStOoLbXKUmB7vv046Q4FIw6S
	 +piiMzbHP99EQ==
From: netdev-bot+sinfo@kernel.org
To: luoqing <l1138897701@163.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 1/2] netfilter: conntrack: avoid
 secs-to-jiffies overflow in SIP helper
Date: Mon, 09 Nov 2026 05:57:36 +0000
Message-ID: <179420385683.488859.10258396166182419513@kernel.org>
In-Reply-To: <20261109055309.512876-1-l1138897701@163.com>
References: <20261109055309.512876-1-l1138897701@163.com>
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
