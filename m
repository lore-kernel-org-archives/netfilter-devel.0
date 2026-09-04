Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409D03F8257;
	Fri,  4 Sep 2026 10:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517333; cv=none; b=djjaBvCU+RGHxBvEDmkRDIU0Le3SU9OoRq2ZPT0b6Of1ht5Nd0F5IOodmNXE7DKvUDOluk1e6akorEZXWFEEx/jLImsydj9Ge784x93rjwiHJWuMxnddhcj7/ip9Z4n/LNW6JwH0pA0+u+3lxmA3Br60NJVOr9PpIEZnlr2FJKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517333; c=relaxed/simple;
	bh=BmOz+dUmMCLlNCERmSKkkwGqOWCoQ4fU1Camdms7s9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tfne1wZf4vCPfoOGultwtHa1CUEwYIlzkZ08ZdcVx1HeRAbgi8sibwG01vjkYjr/lqiNDYZSotUvk/E1E8crs3pUziJSZR0BfV65khB3bghafWUp1i9wNcPPauk2ELAMEqE405AFr+rxG2Hl7CvUCRNdE8wECOOdbDclLDp6qRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNwSA7Dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNwSA7Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FC31F00A3D;
	Fri,  4 Sep 2026 10:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788517322;
	bh=oG2Mwepo6HLYoctiN80CCoKCdLGynO4Z+fuELH+22yY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lNwSA7Dmcia+2TGdAqlh4p1GG9/WLwayfT8CdfOKZKOwTnTvPZqaxkL/lRnbSAOuY
	 xU1HLQP9RHnm9+b5Ern0pVO0mqUOJxh+4ELJHN+uZz/00U7ldde6KN45hXp6tadzUl
	 rpbaGkJMRpqAd2bmkn+aDFsnruUa51sKxq/EUfEPItTtJ1xEvGkRzsEP1ccJ6UD4uN
	 0/SEJluzUIPRtAx1hO1cgI/2gtTuJiIsPr+PyVxlQSYD5bRoi4BG2U6WTZ1Wf1XeCC
	 zD7DxSfL+KFgo7rd50SnA9hoIyc5hOFP5VPlsjxfd2qGwWY+KSOSV0fjS72q4qsF9h
	 jLJ8TM/ZV70eg==
Message-ID: <2946842d-09bb-454d-9eae-4c343c3bb0d8@kernel.org>
Date: Fri, 4 Sep 2026 12:21:50 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net v2] net/ipv6: don't route packets with unknown source
 address
Content-Language: fr
To: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@riseup.net>
Cc: Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Neal Cardwell <ncardwell@google.com>,
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, dcaratti@redhat.com,
 ihuguet@redhat.com, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@google.com>, Phil Sutter <phil@nwl.cc>,
 Daniel Borkmann <daniel@iogearbox.net>, Junseo Lim <zirajs7@gmail.com>,
 Martin KaFai Lau <martin.lau@kernel.org>,
 Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
 Fernando Fernandez Mancera <fmancera@suse.de>,
 Leon Hwang <leon.hwang@linux.dev>, Willem de Bruijn <willemb@google.com>,
 Kees Cook <kees@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Qi Tang <tpluszz77@gmail.com>,
 Joe Damato <joe@dama.to>, Breno Leitao <leitao@debian.org>,
 Li RongQing <lirongqing@baidu.com>, "open list:VRF"
 <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
 "open list:NETFILTER" <coreteam@netfilter.org>,
 "open list:BPF [MISC] :Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>
References: <20260903121057.80006-1-ihuguet@riseup.net>
 <20260903153848.20b90f77@kernel.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260903153848.20b90f77@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Íñigo,

On 04/09/2026 00:38, Jakub Kicinski wrote:
> On Thu,  3 Sep 2026 14:10:40 +0200 Íñigo Huguet wrote:
>> Don't allow routing packets with a source address that is not configured
>> in the host. Allow it only in certain cases like when using a
>> transparent socket, by setting the ANYSRC flag in flowi_flags.
> 
> breaks a bunch of selftests, too, FWIW
> Please make sure to mend those if you want to forge ahead as a non-fix
> 
>   - selftests/net/xfrm_state.sh:
>       "IPv6 unreachable from IPsec gateway s2" [FAIL]
>       "IPv6 MTU exceeded from IPsec gateway s2" [FAIL]
>     (the equivalent IPv4 cases still pass)
> 
>   - selftests/net/vrf_route_leaking.sh:
>       "VRF ICMP local IPv6" [FAIL]
>       "VRF tcp local connection IPv6" [FAIL]
>       "VRF udp local connection IPv6" [FAIL]
> 
>   - selftests/net/srv6_encap_lookup_l3vpn_test.sh:
>       "IPv6 connectivity: rt-1 -> rt-2 (tenant 100/200)" [FAIL]
>       "IPv6 connectivity: rt-2 -> rt-1 (tenant 100/200)" [FAIL]
>     (again, the IPv4 variants of the same tests pass)
> ...

Just in case, do not hesitate to look at the new countainers that might
help you running those tests locally:

 https://lore.kernel.org/9c66a2b4-2787-4421-bc9b-627de2f708bd@kernel.org

 https://github.com/linux-netdev/nipa/wiki/Running-Netdev-CI-tests-locally

Cheers,
Matt
