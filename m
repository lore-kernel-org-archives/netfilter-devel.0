Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A691ACEDD;
	Wed, 23 Apr 2025 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745416804; cv=none; b=FcFXqfH364jsemfeyjPZM+AWgS8hJs4blQzgAjmJ0iDU1ssB6Vz8VxVEWeTsgcKRecdPCqwkw3bYTKvZqEIqVEVa21xad58s7CCsDmjxEy+4oJY9Ir7WdTTNxJkrB0UAM6QFMAPLQ0dMeX+f90WEejxzUcTpbs61jVq7Wh+XsE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745416804; c=relaxed/simple;
	bh=VCLjP3Cs+XnyV91IHowuXw+MyYPzGb1o+HGaUsjXVqY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8D7dzq8WmoH/lBJjQXE3ks93kyoJ3skLD1AEB4q5oSIfqye2UG4VVhDlN+zLz/M77Tn78vEdBFRLyDlQAcVR7ZQLWSQ1LfzjewtKzM3EFDhMRDorpcmeAn2QwtDTjSS7VOjdPtVDDa2ZTX10qE/EbLSMG0eCzQBE2BiZtBbE+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkaM3SCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkaM3SCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F21C4CEE2;
	Wed, 23 Apr 2025 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745416803;
	bh=VCLjP3Cs+XnyV91IHowuXw+MyYPzGb1o+HGaUsjXVqY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FkaM3SClt3GYpDMVLg+Cx9RU1cu3ed7tdRWArd7XRVRUjkXPAygWH/drxOcrnc8eO
	 w0EVtUi1BUUUFUJYPCV2nlo9yiOs5ekSrR5I8sED4dZlk7ZlZKUbKrAnXqhkpbSjBX
	 R7pkWbDML5CHp4zW0zmPWGPs7wYSJTmNvxNK6RfGyVSmleK115jMwmsofSwlatZbL0
	 az6vQ/0RBSCse1jbOoi6Io8RlthET8MZNuMeaE7ff6hSnDZladSyJnW1oDOwnTl7Lz
	 I8EpCWH3wC/8I54bQa2hN78XVgmquegdPDu9BmR9RKyzs2M9Bi6rOWWzV9oJIWZO6s
	 Eg7W4cAo0ckUg==
Date: Wed, 23 Apr 2025 07:00:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 4/7] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
Message-ID: <20250423070002.3dde704e@kernel.org>
In-Reply-To: <20250422202327.271536-5-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
	<20250422202327.271536-5-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 22 Apr 2025 22:23:24 +0200 Pablo Neira Ayuso wrote:
> +config NETFILTER_LEGACY
> +	bool "Netfilter legacy tables support"
> +	depends on NETFILTER && !PREEMPT_RT
> +	help
> +	  Say Y here if you still require support for legacy tables. This is
> +	  required by the legacy tools (iptables-legacy) and is not needed if
> +	  you use iptables over nftables (iptales-nft).
> +	  Legacy support is not limited to IP, it also includes EBTABLES and
> +	  ARPTABLES.

I think you need to adjust a bunch of existing config files.
Or make this somehow default to y when they are selected
instead of having them depend on the LEGACY feature.

All these failures are because netdev CI builds based on relevant
configs in tools/testing/selftests lost the netfilter modules:
https://netdev.bots.linux.dev/contest.html?branch=net-next-2025-04-23--12-00&pw-n=0&pass=0

Not sure if platform configs include netfilter but they may have
similar problem..
-- 
pw-bot: cr
