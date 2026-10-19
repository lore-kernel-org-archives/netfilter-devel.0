Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6164D0CF0;
	Mon, 19 Oct 2026 10:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792405149; cv=none; b=md+avOpsdOLVNqUlnbu1ot+63l7he6kpnvt5VVBYnWCM5Prd6a7MTqmUOfZuZ7FzQv+rbBpfmj3DK+6KXKRWXolbe0cY0I58mc9bS+i1BKrhNTC1D5jv6zDXeerACGHf3ynbFyCnvI+wkk8Oi4sfpdxvx41QXuRl8O48HrPrm5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792405149; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jWwbvTqMGMQMxl0Q/dTze2IryKUYkNUKcUDH89PhXdMKCke43H0sAy8wHAqEQ5sdqFmiIBx0HHIlCXtZHhuaBbRZFHWXZvm7XYvEqOs+r4elSvtUZfenJvx05wYZgrPgCvLoIAewXQguVn4Y/USnxG5xD4ENh+zGHNT6afOR3Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDqtJOa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDqtJOa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979071F000C4;
	Mon, 19 Oct 2026 10:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792405148;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDqtJOa40huUfpKtl741HXiQB77syEjAPzxtCeTX0E5vm95hGkrlBUuQb/O8iC9Je
	 PU1RToah0r3Gl3nHu3REveLZss+xI1lD+gYtY/fOYxC97Lu3mamy4yNdKz/n9TmHRl
	 50JhYQwU2WtMApg7tG4jCPZ2s6zGhuNp84Nmyf3BRwkc8fUH4AhSvQROkK7FRuomp6
	 4/NDQdOwCsHzus8G8x25beg+xLN9lombEc3E1im1f6psc0oQHjFo374xA06mu0Kzfu
	 s9WQRQA0tRGmSAMgRofJzWAOgLGAkBG2t9FC12PAOOf5V9jCP6DdHsgbAoGswkepSA
	 lR1W256OU6WSQ==
From: netdev-bot+sinfo@kernel.org
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Lorenzo Bianconi <lorenzo@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: fix pmtu discovery in
 nf_flow_tunnel_ip6ip6_push()
Date: Mon, 19 Oct 2026 10:19:07 +0000
Message-ID: <179240514712.3290.6021443998153366667@kernel.org>
In-Reply-To: =?utf-8?q?=3C20261019-nf=5Fflow=5Ftunnel=5Fip6ip6=5Fpush-fix-pm?=
 =?utf-8?q?tu-v1-1-324979b15484=40oss=2Equalcomm=2Ecom=3E?=
References: =?utf-8?q?=3C20261019-nf=5Fflow=5Ftunnel=5Fip6ip6=5Fpush-fix-pmt?=
 =?utf-8?q?u-v1-1-324979b15484=40oss=2Equalcomm=2Ecom=3E?=
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
