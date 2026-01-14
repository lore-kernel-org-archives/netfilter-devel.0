Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2602E11A6;
	Wed, 14 Jan 2026 02:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768356442; cv=none; b=WEFmEQIzz9Lv7uY1+ACft8XkeiO15OzFpRP+94px7IuO1Vj5n8OoFBd9qD4iHnZy6JHuWP6Ae2qWI2XeRAgIX8lcQP3MieNxNP7PTeTkjxnQ2S9XVa8uIkopysq2zg78TRbS7bBqEeaVP77pa3zbaNUhaXha3m5G9KBndlMKIIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768356442; c=relaxed/simple;
	bh=U4PJWOM7MrOSu3t5JkvaYDE4mgSqgbcDw0KY8LLTEVM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YuFIyf2ze5a5NsL7mIR04Etm6HpQJj+Zl+iPUtN60AP2fIcSdpyRHGrDp+/LWBwkokh2+/y1M99sFW75W2h0nPIIUtAd6vy2EEykFK35bhNb+4dreZnb/RMKvzyA940hv8cyxJgyiG+xSdmhbTRF1PrAwV7XdPZWh+Mx3AVneZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9YwTirb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9YwTirb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E299C116C6;
	Wed, 14 Jan 2026 02:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768356442;
	bh=U4PJWOM7MrOSu3t5JkvaYDE4mgSqgbcDw0KY8LLTEVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=s9YwTirbhPPJFfox7WaBc40fByEsjdKn5itaq6z2YFAPlSI4syHWJO7NiJEwNckkh
	 u8inX4g3He+IIkbDrqzFIek38F7+F6Qtf29V+9iiyeB2eiAlqDmSIdODzVMWozqLWd
	 W3pjLRsQV9oret5/2hfTIKx3SR7FU+FJql2e5zFAVOoXNYBxLAQIbqQlC5pSNbqy49
	 zJwbN1sT9VU8CHRdkGRSa4NTAMWl1nOVi96x9Sr1mQPocSCAkfU3a+OL8sMnqSPL4T
	 M6qWFiyUyP1W9Hsj0yd0fSCF67tjc/ij1FH/sDQKxhDee/xUNMNxlB/dyffm5PY1Pk
	 +roM5FA32hnhA==
Date: Tue, 13 Jan 2026 18:07:20 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, victor@mojatatu.com,
 dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net,
 pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
Message-ID: <20260113180720.08bbf8e1@kernel.org>
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Jan 2026 11:39:41 -0500 Jamal Hadi Salim wrote:
> We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we puti
> together those bits. Patches #2 and patch #5 use these bits.
> I added Fixes tags to patch #1 in case it is useful for backporting.
> Patch #3 and #4 revert William's earlier netem commits. Patch #6 introduces
> tdc test cases.

TC is not the only way one can loop packets in the kernel forever.
Are we now supposed to find and prevent them all?
