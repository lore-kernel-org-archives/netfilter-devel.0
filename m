Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795679268;
	b=kgU6lean7+N+K9MiLklQ5XX/Z6iXzt5GDyxmZbNtyyizZvhydn4GKy2S061myM6nZ4uQ
	 6rsGyNHvkmS8h/qRKOZRIDo4ZRz3sSzg+uCukp/PpY1Y6TL9DIH226U8/dfbu+d03T9Es
	 0wBXH/oqYww9FSpFYecUK7xans+U/cY2HtHfACsqClbJxzr2XiHZ10Yx5nS5AQXhbVx3l
	 0gPGhEy1SDkuu96mjgS3KmJOz7MAlZo5asgeYX69NxvxRDt4Kr9JfFF5ujwd7/vPWdMBb
	 gicGhgE21sYqycrFX31I1oQ0ljIA9OQcJjz3AhqX/p/C/kqUlQTTy0kocDA17kPwqGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795679268;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=svC97d9nXvrKFk98bFnGJPyLh/4BeFzvRG8enrXb2Bs=;
	b=4mAmEfEkV/JHr9JPiyyISiOvQDPymbBP+MFKDZDPRiTrO1YEbaSfjRusVfGcbftwwF6l
	 88eznieJ7g838mz+vjInkVfO3tKgCzF0v3w6yhkjhkMPtcNGHq/ZjABfFAjk/jwidTHHO
	 DBcTY3hTtYvTV22WN+OP2fFXC+sH98sbpYLI/sH+vFIYk6EvPPna5eI5D5JrwSfP1F/zv
	 9bYxAvTjj0lJt9ZIv3zF6sP70nF+AB/9RlNM92/YR7vGEW+3VePVHrRWAKBWxzTyUSxy5
	 B8cVgv6xQkzh5zCJA4YTvp1VEQs0do6woPbPKn8RiM+jcahmBa9KrsDuGspYhXJA1fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13018606A31C;
	Thu, 26 Nov 2026 07:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13018606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 97B7860218; Thu, 26 Nov 2026 08:47:44 +0100 (CET)
Date: Thu, 26 Nov 2026 08:47:43 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: theodorlarionov@gmail.com, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	pablo@netfilter.org, phil@nwl.cc, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net v3 1/2] netfilter: nf_dup: do not duplicate packets
 from br_netfilter
Message-ID: <awfkH91UCnwcR2xO@strlen.de>
References: <20261124163358.755345-2-theodorlarionov@gmail.com>
 <179567851468.3135.1445286719198754408@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179567851468.3135.1445286719198754408@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> [Severity: Medium]
> Does this turn off TEE and nft dup completely for any packet that has
> passed through br_netfilter?
> 
> The check runs on the original skb before pskb_copy(). With
> bridge-nf-call-iptables or bridge-nf-call-ip6tables enabled, a rule like
> this one no longer sends any copy:
> 
>   iptables -t mangle -A PREROUTING -m physdev --physdev-in X \
>            -j TEE --gateway G

AI is right BUT I think this 'breakage' is good.
We should absolutely start to break these use cases, little by little.

I intend to remove nfqueue support for br_netfilter, for instance.
I hope we can remove the entire br_netfilter module by summer 2027.
