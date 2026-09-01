Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C76426435;
	Tue,  1 Sep 2026 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283968; cv=none; b=PHqVlh1mZcarVX6GkbZqUTVaoFXzGBI0gTaKavnqBIv51/SN1zKqX1egubNEZC1V/FKOQ75O1JNpQpVBzYehKoFU2XZvqQ9KsVUM1pDLatT7HnIx07Td9S53Iu4lFMm3tXZC79DGIL+PBnoE2GAX13n48UPJH6ErEDBzBkjsaAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283968; c=relaxed/simple;
	bh=Rr9DcnzGfDniKnZu6uk7mKcWGKvoO3lnrvTegD8f/CI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sgE0zrBSKKpBrOHVL1kr3ejkDQci6rEFM6h9XzLGeqIaLvniVwAKitIB224Fb2Z8eKFhrksk9j4L1yjMmHHTKQE+vFPa64xkIXy7eWOGOcSF5d6mBNGC7Va019D0fkvRMmzWrJnCYws2q/PJVq7C1ZvOhBZYep/YcoSP7o+o6dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8deQ515; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8deQ515"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BE31F000E9;
	Tue,  1 Sep 2026 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788283967;
	bh=XoQplwBUo06+4jP2MEzgMvoeNOiIgnXEwceMs0KQWlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W8deQ515tV42TIWvnAqfpAs96P3VW2gXrOcbXv0Q6pbPqf6oeFXSiI2ZS+0vP06JM
	 e2EnOhNgJeMyLN8hTP/p0E0qxrHlqIZSEMGP9dQwkawCce5YDaEPC2Zthk4plcW58G
	 G98+BPggJbSN/NKesSKo8AefkhJNXvbRYgTRal5NXvVmMVUehaVnx0UwFY4YZrKd86
	 JHEMM94tyVzoxe82SwV9BgtgNvCVDmcNJOpl9P8CAW+zQDeC/7Nv4z1x4XWpc4NA5P
	 ePDBvtbE2Pa4qx8EWafNKDQvzLyakSerpD7+2C9ARXDBYORhzL1jukMagmpgvT9RdB
	 9EEcdO3tTJJkg==
Message-ID: <3d8ef804-efc1-46c7-bbb4-f1a6c26fed8b@kernel.org>
Date: Tue, 1 Sep 2026 19:32:34 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/ipv6: don't route packets with unknown source
 address
Content-Language: fr
To: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@riseup.net>,
 David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Neal Cardwell <ncardwell@google.com>, Ido Schimmel <idosch@nvidia.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
 Phil Sutter <phil@nwl.cc>, Daniel Borkmann <daniel@iogearbox.net>,
 Fernando Fernandez Mancera <fmancera@suse.de>,
 Alexei Starovoitov <ast@kernel.org>, Junseo Lim <zirajs7@gmail.com>,
 Leon Hwang <leon.hwang@linux.dev>, Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
 Willem de Bruijn <willemb@google.com>, Kees Cook <kees@kernel.org>,
 Qi Tang <tpluszz77@gmail.com>, Jeff Layton <jlayton@kernel.org>,
 Joe Damato <joe@dama.to>, Breno Leitao <leitao@debian.org>,
 Li RongQing <lirongqing@baidu.com>, "open list:VRF"
 <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
 "open list:NETFILTER" <coreteam@netfilter.org>,
 "open list:BPF [MISC] :Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>
References: <20260901115021.50057-1-ihuguet@riseup.net>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260901115021.50057-1-ihuguet@riseup.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Íñigo,

On 01/09/2026 13:50, Íñigo Huguet wrote:
> Don't allow routing packets with a source address that is not configured
> in the host. Allow it only in certain cases like when using a
> transparent socket, by setting the ANYSRC flag in flowi_flags.
> 
> Until now, it was possible to send such a packet if a route can be found
> in the routing table for it. For example:
> 1. Configure an address 1:2::3:4/64 and a static route 1:2::/64
> 2. Establish a TCP connection to 1:2::3:4
> 3. Remove the address from the interface, but keep the route.
> 4. Packets are still sent out by the TCP connection because of
>    the static route. No incoming packets are accepted, though.
> 
> This patch prevents the outgoing packets to be sent in normal
> circumnstances.
> 
> This aligns the behaviour with the IPv4 stack. To determine the places
> where the ANYSRC needs to be set, I set the flag in the same places as
> the IPv4 stack does.
> 
> Apart from consolidating the behaviour of both stacks, there is a more
> important reason why this is needed. RFC 4862 states that "an invalid
> address MUST NOT be used as the source address of outbound packets".
> Therefore, sending packets with a source address considered "invalid",
> like an expired address, is disallowed.

Thank you for looking at this, but I think your patch is causing
multiple KASAN warnings, e.g.

https://netdev-ctrl.bots.linux.dev/logs/vmksft/net-extra-dbg/results/804584/24-connect-deny-ipv6/stderr

And a few more, see:

https://netdev.bots.linux.dev/branch_deltas/net-next-2026-09-01--15-01.html

Cheers,
Matt
-- 
pw-bot: cr

