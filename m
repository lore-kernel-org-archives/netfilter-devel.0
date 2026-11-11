Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794357384;
	b=w2iaJoKnvZ8sDEjwVpFTq94hVnkWxhwaFSdxTUsuzjTsd1+uUwbkgkPf6aw4mJgOWJ0f
	 mHxOqVe73zonIX+X/ai74RW3DZ92iTqEs2nFM/jGsHxuW/DKJcoDEPfMcqJ4TJJz6LxW0
	 2bHQAADmB4m6lGJFPK5Pl+3LYt5pGQ2qusID4Yik/JdIH4ukDSEdVlpX7BvSZZv1B0fM1
	 Yr6xF3aMMDhhSxe4tHI3FCUynz6lN+GgxBTEmTQgUTJ7f4J50Sxd+Xjc95rq56jzTT0Rn
	 EZOxHvCSYhv5MM8ggb13Jsi5RutDGn9BoanQ7kSY986EhVD2S34QWxfDZ41TVy/Njqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794357384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=0gM0NlP2HWUTUiqNTcf95nrw1Fv6KqCNUkN8itBiM9vcShNNBv4tKVZVuHm2ToSfdZQx
	 tbsPeJlW4yCnYyt754RydIoSnLiJfAesCOn0smi//QtVmNQ/qMBye2Is915943PpD3wcR
	 vjqz0tCnWZX0lWRUHECWo8aJVPfPl1+uzySD7i0yghsY3kV6TAUkTPRBhYDKtXYyVchxN
	 ZM3pVUaWN4d5zq39vw5kWT1ISTDcJQscZ8Hcdofi0JGnsTIrmR/3kJ3RajL0NdjSlp0h/
	 Lrd25EAD7NGPkQMs3Ef3scsuXO6OkSsxSN5GZ24c8wnwhxiRQuFjhcQtGMamgCiWGDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbF4OK5k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A34606A320;
	Wed, 11 Nov 2026 00:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbF4OK5k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777381F0089F;
	Wed, 11 Nov 2026 00:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794357383;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbF4OK5kNcGoYNpstlu81e6BgvOXffr820N19Fup9mMrcYIfQgRXPZJPAUzozhSKu
	 hvD84qbPYxXj4zXHdRUiFkk/rnmxjXuR+ShuEgmYBf8feIeVdZQpbv9U5d0LD6ORrV
	 qWr7eIXPwqVA6ilU8iia9wFyPSYpAWO1Pz212Ub2UyL0R9Q1JuToZHB/6l8h3CH4ed
	 oFPItDRhGMPWP0GIkTiHjsX7NFG9ShdLCO4PCvHq4qan6QtXYdMlhWgEWIdFfWNDYF
	 xEbX3tomUIJmnbDjiK0G27GtLbxE2wIgQHvVf2iNBxMVuR28u/xqL+6LJcuxZri+7C
	 ua+g7fbqGT1iw==
From: netdev-bot+sinfo@kernel.org
To: Todd Freed <toddfreed@meta.com>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Boris Pismenny <borisp@nvidia.com>,
 Sabrina Dubroca <sd@queasysnail.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Daniel Zahka <daniel.zahka@gmail.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 
 Re: [PATCH nf-next 0/2] netfilter: don't send decrypted skbs in clear text
Date: Wed, 11 Nov 2026 00:36:21 +0000
Message-ID: <179435738198.2168702.12439855185550580348@kernel.org>
In-Reply-To: <20261111003111.3826942-1-toddfreed@meta.com>
References: <20261111003111.3826942-1-toddfreed@meta.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
