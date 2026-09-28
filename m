Received: from out-2uec-a100.jellyfish.systems (out-2uec-a100.jellyfish.systems [63.250.43.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C18230BD5
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601254; cv=none; b=qI2/xN1VvJqPDAjh7eyh4U418FwKL9I4aG9qx0U1PUfzfExJm+7IJ/gRJkefzpZo8q9RC+/vWd6/dJXRAcDMrtPCrSAjd30PV2jMJImIBxAbCoCCpmq8+Ds+CIDj8LPYdp1c7DAqxvXQPbL0hDvpXi2HK+XxqXqr7sS5AYmiliQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601254; c=relaxed/simple;
	bh=ub6BAbpXiL1ZoeUR+ejAJEY38scD30xRSuDJxZ7+GHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws+P23T61pgAUXNIuxOwTUqPSspdcs7lnZ7qIGaCIvAkLTz6m5mDsdBm7tmBAGqLEL4sqFYE8kiyUVWUnelsQ6B3NPHhLByNz9o8kgRUZ5HRmDL4mPprCGcLZv92qOYF+AF1kvwmXS/nbKApdrx9fRR06nx7OykQNil0ZTYIBpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=Xz1BSSJD reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="Xz1BSSJD"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hthb114mCz2xCd;
	Mon, 28 Sep 2026 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790601230;
	bh=3J2HsVBsKjQanNhI8ou7bXYyo/JhJ2weMLjaaoQCn7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xz1BSSJDkOF7IKg8pUpQq3xCnYkQw52LZRbhJxWM/1AJj7VVe8DOnpMKz/ze2dgbO
	 z6h+v64VQmGiqrlTwvp8Stegazi5+HSzBU3OLLi+1oB3EqZ30W2gyjc/N9tcan35io
	 ++v+aOg65eWcy9LY1N/rsmeEtNmTEWOEvkqh3zLANizbd63qw91rVz0LtzajP2ooIv
	 z/oYEVkr6EYGX19YLXa/cDyEi2faU9n/8WR/XDDNzq939qMCd/CNsFiYC+A++FoeMG
	 YFoEDRRX6ILMLbOxXSziXrckge4hr39qW8x3HucSJFIjU5Rp1XMus3Xf3V0NHQ6bRc
	 6KwGt6Bz5bIbQ==
From: Rahul Chandelkar <rc@rexion.ai>
To: netdev-bot+sashiko@kernel.org
Cc: Rahul Chandelkar <rc@rexion.ai>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v4 4/4] netfilter: nf_conntrack_sip: use shared helper parsers
Date: Mon, 28 Sep 2026 13:13:48 +0000
Message-ID: <20260928131348.4160994-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179053062534.2160803.18214039590923264255@kernel.org>
References: <20260923171501.3254823-1-rc@rexion.ai> <179053062534.2160803.18214039590923264255@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

On Sun, 27 Sep 2026 17:37:05 +0000, netdev-bot+sashiko@kernel.org wrote:
> Should the old limit be kept, for example by rejecting end - dptr > 5?

Yes, v4 did change behaviour here: the old loop rejected zero-padded
ports such as :0005060 and v4 accepts them.  In v5
nf_ct_helper_parse_port() will reject digit runs longer than five
characters, which restores the old behaviour.  The old and new
sip_parse_port() give identical results on three million random inputs
in a userspace harness built from the kernel source.

Thanks,
Rahul
