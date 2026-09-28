Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8832947ACE2;
	Mon, 28 Sep 2026 08:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584517; cv=none; b=I20kPGCafIlW7XDqOXNz+fZMuDsh79ChzmXBdGgenQnNPeYbYLeqr49FDIcoLMUyRFoQK5tGuotHZtF8cSJGTf3hRuyzM4fA+LLMwMWV7gwjIZrF0rCplOc+Elpq4YT/WiBM8yjFf9tK8jXbaVFtFy2mCAJ01483XdSJ6lC1jFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584517; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YFLWrwO3+oDXksLGB2q6MLQQTf5m7YQ8wv2B6cj0du5NFT3jZpgk5f5deAg4STIfxe6uyZdJp+oLaGph1AxOhZb/n1yc0eeEs8U9VA4jGQxpZ2ZMnZv/fBGNpl6xYYlNUlCtMVLvWkRAUDOxQYSZu37vYpyoqxEACL9XRYpn86A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUXnKujT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUXnKujT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5321F000FF;
	Mon, 28 Sep 2026 08:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790584514;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUXnKujTS1cKtHUGBwHFCP/aJcRbGpldv8k3AhZZSfCAEZpNkUM4MF14K7x+wnczi
	 Pss0TMehthTUTchQ62I/AUWWiWXR3MkEWa4DP3m4PHCu7ibfOzSlkvvkSQ4BAYyTuz
	 zQMZ74yHLXIX+3ojfxYgugKqR0mR7R5Uda1h7LW1NBW2rqcbP9ORfdG+QVVWfbvyZS
	 DPGgK/x4mMyjtMQGby7Tz5Pzx3yUnVlv1yblymhGqxOEi/NKIpgPIsWaBNy3B3bOmw
	 nvnmr0bZvRPjk/jdGEkjQxQE/mln+pqbrJk8nuTljxXQfIMAdeD+b2EBjzbqRKJuCf
	 Nsqt1/UCxvJqA==
From: netdev-bot+sinfo@kernel.org
To: Guo Zihao <guozh23@xiaopeng.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
 Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ebtables: ebt_802_3: drop short frames before
 the match reads LLC
Date: Mon, 28 Sep 2026 08:35:12 +0000
Message-ID: <179058451290.31693.17247712756211358968@kernel.org>
In-Reply-To: <20260928082858.3009191-1-guozh23@xiaopeng.com>
References: <20260928082858.3009191-1-guozh23@xiaopeng.com>
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
