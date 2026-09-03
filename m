Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3588B3672A0;
	Thu,  3 Sep 2026 22:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788475131; cv=none; b=ceHfE+nr0cUVmxGaK4kq5iTF1H97fSm75XrjR0YQVKDyM3zBkod7fyPFyYJ3jEzseNPSlA0NNQNERZROa5RTPRUTMnAOyTyiBFMmNnSCSsSPnP+uGU0haOc3BuM6lceZI0UPgGaEoIoAvkOET0Rt5zTKX6f1KYoAqiHBurzj/MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788475131; c=relaxed/simple;
	bh=sAj/ZS4rKZLVdCOrvFUXxc8QGX2v3BUL121uNDdOn2s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TGTCt7d20lB4pmqIRNQpYe9IJW7XQTjn1I9CE13kCQBY0mXIlC8q901pRcyfXhU13PlEJpZatnCTvUGv+hJWLGIglcvsH3Le8G3MTwAuImPB5cNS7TAdtFttGhcjVk90p9E3GITfp92BCfgfNbxhHtqwsOexZSAxESHmJ4zNmkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPifHQ5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPifHQ5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F101F000E9;
	Thu,  3 Sep 2026 22:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788475129;
	bh=W+Kesxd/6+UM7OT4+5QmDjgPKogkomsffHalxmd8hlo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SPifHQ5mqoYpzXtNW4Pv61MYw0Bb7mnESq3ZmZAlormMyrXvCE3QQw86jnOgSSwAJ
	 Y7XdG1ic0KYLIu0k3tXV9tcXF39Y5W7HaPnj0wGghLdafAR0PwNaxOO9SrGduPNfv4
	 25Tcyg67XTeARdmPI1u7VguZbaVKQFKzvVglSBymhfvUsHUT+II0sdf9xBqZh7jf31
	 JjdluJX7TdoE8O0ejwyijHnS1Nw4ZlLxwMx5oD8A+//m5vHLyaq6I1Qbc5H9pZy0UG
	 kY2qaLx0yGvbbGiFYb/aZHVlRREtUJUvQmzI26Wm1jiHU4yB0ePeHGCjCh+MRC88Nk
	 Q7L2AkE8/TlJg==
Date: Thu, 3 Sep 2026 15:38:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@riseup.net>
Cc: David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Neal Cardwell
 <ncardwell@google.com>, Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, dcaratti@redhat.com, ihuguet@redhat.com,
 Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
 Phil Sutter <phil@nwl.cc>, Daniel Borkmann <daniel@iogearbox.net>, Junseo
 Lim <zirajs7@gmail.com>, Martin KaFai Lau <martin.lau@kernel.org>,
 Xuanqiang Luo <luoxuanqiang@kylinos.cn>, Fernando Fernandez Mancera
 <fmancera@suse.de>, Leon Hwang <leon.hwang@linux.dev>, Willem de Bruijn
 <willemb@google.com>, Kees Cook <kees@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, Qi Tang
 <tpluszz77@gmail.com>, Joe Damato <joe@dama.to>, Breno Leitao
 <leitao@debian.org>, Li RongQing <lirongqing@baidu.com>,
 netdev@vger.kernel.org (open list:VRF), linux-kernel@vger.kernel.org (open
 list), netfilter-devel@vger.kernel.org (open list:NETFILTER),
 coreteam@netfilter.org (open list:NETFILTER), bpf@vger.kernel.org (open
 list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_))
Subject: Re: [PATCH net v2] net/ipv6: don't route packets with unknown
 source address
Message-ID: <20260903153848.20b90f77@kernel.org>
In-Reply-To: <20260903121057.80006-1-ihuguet@riseup.net>
References: <20260903121057.80006-1-ihuguet@riseup.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  3 Sep 2026 14:10:40 +0200 =C3=8D=C3=B1igo Huguet wrote:
> Don't allow routing packets with a source address that is not configured
> in the host. Allow it only in certain cases like when using a
> transparent socket, by setting the ANYSRC flag in flowi_flags.

breaks a bunch of selftests, too, FWIW
Please make sure to mend those if you want to forge ahead as a non-fix

  - selftests/net/xfrm_state.sh:
      "IPv6 unreachable from IPsec gateway s2" [FAIL]
      "IPv6 MTU exceeded from IPsec gateway s2" [FAIL]
    (the equivalent IPv4 cases still pass)

  - selftests/net/vrf_route_leaking.sh:
      "VRF ICMP local IPv6" [FAIL]
      "VRF tcp local connection IPv6" [FAIL]
      "VRF udp local connection IPv6" [FAIL]

  - selftests/net/srv6_encap_lookup_l3vpn_test.sh:
      "IPv6 connectivity: rt-1 -> rt-2 (tenant 100/200)" [FAIL]
      "IPv6 connectivity: rt-2 -> rt-1 (tenant 100/200)" [FAIL]
    (again, the IPv4 variants of the same tests pass)
...
