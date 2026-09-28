Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6998D4F96DF;
	Mon, 28 Sep 2026 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790628963; cv=none; b=Ao7JUPD8Q1p8mpaQ3lAAQqmjLiWaQx/oDquDRPA+m9bczRmMQb1QB6+LVGXd0y68zyJpuQdSmMam08f9e7W0DGK6cSyeKtNZo7I7kxzgoWLCV3Rb77GXFsATowLMk5gkn76nJFZC4PSEFDamDn2S0p/MSxYr7h4nmebfGskjGa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790628963; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TWppzjGekOV+xKt5A+KQp3W2ZJYopjutBTmG1JduZ1e7rRhh5ipPluZRCXGo7StYsEAdLGX8Fxkgifdpr1MSVXsYz3jIjfNgUDHja6F9r0iX5CgoIQ3qPCRA33WJnTpMB3Vs07q2dp7kEhExWCM2ReLAeLKTpC5SKUoC2dnG82U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4TfXChe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4TfXChe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DF41F000FF;
	Mon, 28 Sep 2026 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790628961;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4TfXCheWb3CWkwq2JY/X/FDmzeuqKmsheBHQ/8+l3b9hK27LgqhMvng0tb7IrEeq
	 9MXHvkt/1HTkdsEL8+d05seA2dbwrfmhoKEyAY7eotAi4L9QcDgTLwprFu5oNSpZAI
	 uC4+93NhZhh/AxwMCjhSb2gB/JQKTaZD+oZSHAoYZLVIzv14nn5n/Cw9tcs/1SG57Q
	 akWjf+xZsYsgPSBx4kznLPR4+K4mqt+JaXndsTScG12efjvrnThdGM+lEyrzy9HMFW
	 7qEYrgC/SbLgOfuUwUBjm/gjlZlB03QefKjWblg3bVOMVdZtz+i5dlk/uIL5POPz8a
	 NQutiyl+f2Uww==
From: netdev-bot+sinfo@kernel.org
To: Rahul Chandelkar <rc@rexion.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/4] netfilter: conntrack: shared port parser
 for helpers
Date: Mon, 28 Sep 2026 20:56:00 +0000
Message-ID: <179062896069.31693.871473945227845464@kernel.org>
In-Reply-To: <cover.1790596690.git.rc@rexion.ai>
References: <cover.1790596690.git.rc@rexion.ai>
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
