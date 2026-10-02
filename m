Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A749B5AE;
	Fri,  2 Oct 2026 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790960302; cv=none; b=nvYhfYOj5G/hE1DlmvAbyjpL+tSCISHUXAmAAPemld9yBybLvmNMzRg9WTzFmuxI1O71/9A0nJREpUWF3MEF1OijFRKZ5sqoqjjKJ3bpANGhP9en3Y5REHqPYnrPX0Ed4mbexhxo15dq0781TD1XCnB9XvscvQL6EKDr+i+V5uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790960302; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T4fZ8RWZGiM3Kwbd2+mWWkM1hS2y9ER9c+bEhLkUAqzWF4kXDgWjeW5ej32KIvfn+gpwddVt5nSky3DnOE+Pp3yNGGlHmZRZKLiWIl5g4/X45lc1CLM3mdZEHFhTD5Tq1wM2s8HErTGBPazSd3l3qgPypDUE++49+9gCzDYMhjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhHy0AIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhHy0AIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23511F000FF;
	Fri,  2 Oct 2026 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790960301;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhHy0AIk68LgeKarkc8VvXo0O/mgV7oVLPwrCYlD5NnxS6A7dDKCr2zog9+v+m0S7
	 k0NsJH/FhSY1ztcMfpLjKdA6Tr9RxoWZInFcbyfwGZVGKWLmdYC42102a4fRcmr9IA
	 b+/VhzZCdqtXfgub0e1UiRtdVrd5Twtvq87Rn+h+SjgVqEhd7YvuERnAPrzbMD7+Kq
	 UQsyeU8ZtOVpaxwyp/KmNXRypUR7zLLi28BaEKv9IeQqvpTwnp1t052r9L0ZFOKQ10
	 q9cLvsmwqQPgQL/DKy3rm+M6+kVjsZalJofDkX9J0hgWTQJBgwGPCp19hdNLxCMbxg
	 l6NHk+jFs+OeQ==
From: netdev-bot+sinfo@kernel.org
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 net] netfilter: conntrack: reject nested ctnetlink
 master chains
Date: Fri, 02 Oct 2026 16:58:20 +0000
Message-ID: <179096030049.1402591.385400063757168849@kernel.org>
In-Reply-To: <20261002165601.1754467-1-4ncienth@gmail.com>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
 <20261002165601.1754467-1-4ncienth@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
