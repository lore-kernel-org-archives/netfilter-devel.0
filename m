Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8331F3ACA4E;
	Fri,  4 Sep 2026 02:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490401; cv=none; b=p88NdO5BvqwDuS0AvExobg28stZ+4VVpRG3yIymB9Uz69xHvddm97n3uN1nLGb+sPGKqF+VZgOYgpc+dNTvjv74qAmnRWluTapbvTC6qNssn+2UaPkkhGTXxWVo4ql/zoBT8cX2+mTBwx61mp4j5YVxH7rw7BHfdFEs7Y5VTyWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490401; c=relaxed/simple;
	bh=Ghj33vG6rgRgdNV5A01xTnLYr+udk2lHyiRe8diRxUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH5KpMEgSbt4fYRGsdeft6Nq497jdl8N6iedbMf/v2AgGQmnEQ5Gp95Fr+kkhm6qUcDiap6a1GBKt/Y1p6fKmaTzkZ3hfIshIfz9K9O4JIJpmeajLQNsLad52GNGBrG1KIk1Az+NRnXz4B/VekC/d+lsmy/BVQagaJ3sicv0qCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvFlU9Oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvFlU9Oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD9C1F000E9;
	Fri,  4 Sep 2026 02:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788490400;
	bh=vneuOFG3DANfv7W5x0iO7QN/BAEO/7HycR3MtC0xk5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvFlU9OyrNNjxV3zwLOSAb1P8dJemG6xO/Sftp8D25g7kyhIgKtlQBQhsa9jipsSS
	 h6s9dQwlzexO9Pa2sRf1UCnw3JFfVBsASZ7GBMylEYCrFiQgLJPQ9PqCmWpsbztGTm
	 g3ixfnqBKv0/bZjt/TCYb6Cyv44nf/4UfeEfHcE938d9z3DLxiwQoS0N9fmMAJN4L9
	 p4Gy+gIItMvwfJZjx+HYmCQ5JXq5oWIZPNmhBTxHFTObQ/J2f8AyKs9BNK9fDjlUeB
	 Mej/B7l+OA4vPxz9pbvGDRQxmEZGWcQ+9NFokon/+CuYJMfnRVcVOhp+DGGebqZ+OE
	 1vecyM08IOs9g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	lvc-project@linuxtesting.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haoze Xie <royenheart@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>
Subject: Re: [PATCH 5.10] netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst
Date: Thu,  3 Sep 2026 22:52:54 -0400
Message-ID: <20260903-daily-reply-0002-re-nf-queue-bridge-pin-5.10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903121758.3660436-1-alexevgmart@gmail.com>
References: <20260903121758.3660436-1-alexevgmart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Fix this by keeping the bridge fake dst model unchanged and pinning the
> bridge master device only while the packet sits in NFQUEUE.

Queued for 5.10, thanks.

-- 
Thanks,
Sasha
