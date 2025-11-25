Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A3145B16;
	Tue, 25 Nov 2025 03:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764041483; cv=none; b=qI95cnErt2uzneU2tRXAZip39UYFDUT/Q2gjkSR+Axpr1dmzXJaMogZQLRNi9sEswcWQJAni26YoOYwbE4XaHmCDxyDdIBSEcFpCNAv+hecdtp5tfldiUchRauSyqvHGu1ewGV+5mQfWm95HmKukaJ+9KHMrpUyWwnGaLYmy9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764041483; c=relaxed/simple;
	bh=rBqBWUyuIniX47sb+x6FnF4GQvj+W/C5v87lmFR3Me0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D9xRYNRx4zKblzrjSOn+FPJ6HmchQZYn4uflFLgAAOOYX6z7KKzwLrLLDNp+m+ac/Po9M1eAtu9K4mYkzshyxk/4t+QSuSflfVY4bsdQfaLrwrnf7gv3pzwYCfy9zPD+fZ2C8DBneYwJPFUx2au0wd+mIbYgnBUO0zCmbmng0cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppLH0y2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppLH0y2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDDDC4CEF1;
	Tue, 25 Nov 2025 03:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764041483;
	bh=rBqBWUyuIniX47sb+x6FnF4GQvj+W/C5v87lmFR3Me0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ppLH0y2cAq0N/bHAtTRxQaiFKjOc09K5nTICxOsfWHGqK0ZRd8WEbrVE9MeETeaBc
	 UOS0yacwMyWypnvzgN+ZTAQhbK5eZdldzgTBlbIfghSfT8LdoTp1+U3RGoucOKFGO9
	 yEtrX2dqzriGn60mUZsJ+vOujkC/l2r3XA1OkHpLmfmCyRkpe88cNyTtDqph0Cq1Ig
	 CZ97qos0AUxbTcnp9tD07odRm+hyoafGbueHmZVwj6fKDClooHSvAnxjhgDt7iM+ia
	 UP+UhkAofxghDbeA2U4jNZFpaIcUlbRM2nnQ+2DwSQjHPhOBufs0hvfqs2xO1oqdvN
	 jGlxQb/WNrg0w==
Date: Mon, 24 Nov 2025 19:31:21 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Shi Hao <i.shihao.999@gmail.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, ncardwell@google.com,
 kuniyu@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ipv4: fix spelling typos in comments
Message-ID: <20251124193121.6f9eab3d@kernel.org>
In-Reply-To: <20251121104425.44527-1-i.shihao.999@gmail.com>
References: <20251121104425.44527-1-i.shihao.999@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 16:14:25 +0530 Shi Hao wrote:
>  net/ipv4/ip_fragment.c          | 2 +-
>  net/ipv4/netfilter/arp_tables.c | 2 +-
>  net/ipv4/syncookies.c           | 2 +-
>  net/ipv4/tcp.c                  | 2 +-
>  net/ipv4/tcp_input.c            | 4 ++--
>  net/ipv4/tcp_output.c           | 2 +-

Please don't add any more files.
But in the files you touch you should fix _all_ the typos.
-- 
pw-bot: cr
