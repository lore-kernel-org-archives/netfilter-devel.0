Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168702;
	b=ZslDwblwuJO0m0sNkMYLq0hLENxeA49oUieh9LbDPzNbTx7aR8ChC+OzYqoKVrpoxGn1
	 Sr+XRrfVI/DUtuGwAGVzh9odOGgJhSos/nx8VgrEB743PFLjxgYuCFqi5xeCJu7ScYo7e
	 IxhfK7V9Otec6g9/jsijb1eCX4/vOjshue777VG0ATRjXRR9GdX5sNAldwe3YfVMG107e
	 g1XnU6wlUFxM1pCVAJ7LmwvvduJsR8K521BFH5jSaCdXLL+K/cAnNi7pISza7JswA+oi5
	 7fSKv5/p5QeWh3qKOPDSyOuy08C44vc68gUnR6id4PAMkKNc7ELCkIBEfywP/pf3Yaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=s33G7YQjDmxgt2ZOKDJSMHAkFkaI7x9cZpj2zvG9xyFTkLSaNHXLsuvwq4bZMd94UKB2
	 TyWEzS8Y1i1q6M/PJhKNL3Z5Mg4uu76KVPnjo5P884/2m1dDxrZNWVRdaJSUA6YBeMq0V
	 hUB/z+wT+kvlYz/kiAm74R4LnyxK07kUeXwgbZUPxVxve4ekShWf05bvah0gkNR1JyQhW
	 pJhfA5TLLb0YyVcgwNKabLtJVy5/KxcNAKMuz9W58nOkCE5K3E096N8NGxZiS6QwNXI6M
	 0EogQOAgJ4EtnjdDNoKaKY/D8D+rIDj4ic8UfoVIsX5CzoyCpJ5NhfyAsPQ+hnSr6/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84B9606A31A;
	Wed, 28 Oct 2026 06:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66AD1F01825;
	Wed, 28 Oct 2026 06:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168701;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpVvsYsQw4mu6PafqvNZsbs7I5VWot9X+htsD0aGBtqG+7rJmEiL3j88r/eP8tyqG
	 uaYctgoDc775EK/P36N0bX5YHaF89FdVNiNx4sva8ML4IeolAHzdnW2WamJB+5SIdR
	 TKx7r4DPwFshMuAvFL5zVjSy4RWca1zU8BDSoWiQjcNs1Yvtq/KFIE9SoGrYdStpUE
	 t+XINjJ/EKoUbzHlVYPR/QZkocneIkNqsgzuyqtQuLfpBM8sDgixt/RMUKKBnCbX2w
	 fkgeYF0B2/ZhOGGX18/lZmTaelrSrQbME4sd+I2lIpyKsEq+RXHj9x14rId07PWikW
	 7dGmI5SW6i0aQ==
From: netdev-bot+sinfo@kernel.org
To: Xingyuan Mo <hdthky0@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
 "open list:NETFILTER" <coreteam@netfilter.org>,
 "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix flow rule leak in
 nft_delrule() error path
Date: Wed, 28 Oct 2026 06:25:00 +0000
Message-ID: <179316870027.3327.5682101500249650409@kernel.org>
In-Reply-To: <20261028062204.1079089-1-hdthky0@gmail.com>
References: <20261028062204.1079089-1-hdthky0@gmail.com>
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
