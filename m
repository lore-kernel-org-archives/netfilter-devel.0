Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58781CAA6C;
	Mon, 19 Oct 2026 07:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792396742; cv=none; b=bXQaJXeydlLlJPM09l0ITAVAln8Gu1CHcyHVnuJ0QBtqhtxiBkVVYCAO6Qjm1APUM5zfdcC7WJbP0qL/arMw+aUhntFQQxkiz52gBVNV110bXkS+6Le14RAObRtt7XTnEtOrwAVait3baPAqGTGYWHp+dCOhqrn6VNMb9TQRv9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792396742; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NtlOGHDUe4eiaco5uFSs6qgJRkAkD3Fjrwg/TjTfcM+Lxh57orn7kTKPlI1qRiG3J5BIMJ/D5lmIgdVMRFICnOZK8C06VAUFSoSr9XXx0MbUQXx/sIihnNzYrplNFtAR8bd2VcX+nixoR0DTlBfvV5fjZEuh2PxQdfY4+eT+fpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gq0saU0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gq0saU0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD371F000C4;
	Mon, 19 Oct 2026 07:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792396741;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gq0saU0pIoL4KTV33TAeq9DDh2uRydcrBtbVGKZ9Pglh25gUni7DRNV7nA5LbqC8O
	 XGbRljel3cW8OPC3gbLpHyq46E6f5awKQVaD+O39t7o9eER8YKUSK2YpE6+3eO+rKE
	 A0GZDyaOHvn5KGs+d/Q8Nk0YZEJZbbzLZtOUtMsqpZlH0mOyKl5cZyoNhBI7rfXpyM
	 rCZaRFLqekEw/zL2G0gf9KMyTgilMWiq1jVOTjuoytXXmFHWCfmjZOYhvDCD9RuJ3+
	 aeljaGGFepfvnWkH5zdbqZ4AM5JO01ubdjbU9BbmOtYWSFpxElfkk2SD3lHyHNPET9
	 jDwyUVyukcwFQ==
From: netdev-bot+sinfo@kernel.org
To: liuc63 <liuc63@xiaopeng.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Florent Fourcot <florent.fourcot@wifirst.fr>,
 Romain Bellan <romain.bellan@wifirst.fr>, Weibin Liu <liuwb@xiaopeng.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, stable@vger.kernel.org
Subject: 
 Re: [PATCH] netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter
Date: Mon, 19 Oct 2026 07:58:59 +0000
Message-ID: <179239673974.3290.15179488596973318438@kernel.org>
In-Reply-To: <20261019075629.2091511-1-liuc63@xiaopeng.com>
References: <20261019075629.2091511-1-liuc63@xiaopeng.com>
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
