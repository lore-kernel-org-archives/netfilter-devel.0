Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1DA2DEA89;
	Sun, 18 Oct 2026 01:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285399; cv=none; b=cepVGDBzsxuRLeWKWhxJpu8hLcg6W8/D1Du/9E0JJeDzgJgzcxx2NsjvcekuqpgRu0XtZzKoCm+6k65sWFM1f+tDw84HgdNCkb2eYuF7xa8Hu/PMJgQFEW/KNxbRk/nm16jDVsmc2P1JRQfARZqoTljno9y2E99KN2khW87elMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285399; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qi2QUhGhq0lUTBMsbFo4scY1X9nHl/HBf523myE2/nCi/GE7XAZPv8hncFOaoUZCPKhxivkaXd1utAcEsX4a0gqeYxZ8lB1WiVk1hMv+x5V0Vfypx664m/cH6sH7LnbrMJdsc3s+J/M3QduhbTEAdqMpYd31x10H6YgcbXAprlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iY67tuL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iY67tuL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9531F000C5;
	Sun, 18 Oct 2026 01:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792285398;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY67tuL8Cl16KViBVt9cp7mnzWal93d6WEIKhYvoB28JknMRso1pipcHHjI2W7Tbs
	 kBPdN+3Cv1GZ4nVW1/H651wMgtg6h1CfrBzEXPe6KKSjfJALP8YKUgKxieTqvRCDMO
	 xQPCOlBd8mgwwK8chhMj9Y6pEW1OoCxHnLPEPamsuHJRO518nykhkZ4npdKY35+O1R
	 DB96byy9a4FXa1/0w9LRv3IOxSlKGyM8Coau65Eh4Cijq03VaGY12sMsNYuEHlXGn/
	 s3nn/7mIHys88GvDV0ngdbAaoGzkd0hF4Ej2dW+91o5e6TleW9h0HsSDwc5nQW3mc5
	 MkXtUfkJwLoyw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: 
 Re: [PATCH net-next 01/15] netfilter: disable br_netfilter in user namespaces
Date: Sun, 18 Oct 2026 01:03:17 +0000
Message-ID: <179228539733.3290.12913693558354504063@kernel.org>
In-Reply-To: <20261018005638.1776148-2-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
 <20261018005638.1776148-2-pablo@netfilter.org>
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
