Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E0019341F;
	Fri, 25 Apr 2025 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745597937; cv=none; b=QCXzU3+y/NvZWAkblM20lmRRxen1xD88LH0D5v2bJeedIdFVBzZJYxMaqImFkIyEOL+NJvBrYIu74Bs3/L3s/yRnab6+mNU8oLP3dU9QvFYIEA7Hse/0XxiQf7PuWfdYb+NW91WK0StJCWVBvLndQVXKwgDYpa6uDeo6/gFadGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745597937; c=relaxed/simple;
	bh=NsLNzfkxX6Y7DEZfVl7qnYNxiIiLTtz5SgYM8hN0cdk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FykDS0bIiLJx4Lilq2pXSkGkNO6lu4OsrrwfWcfdWlp0Kvm8k4GryArL5SMg0XUivuI4zTog/ZX0MKQ7qvyBCOUmbVqyonQNu0S1IbC2LTO3cjJ3UxsJLw/EKIhiLcOAQh3Xl6RrFP3Pe3OXJoS7B/tRQei0KIW6wKnADI49NnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbko/nMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbko/nMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DEEC4CEE4;
	Fri, 25 Apr 2025 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745597935;
	bh=NsLNzfkxX6Y7DEZfVl7qnYNxiIiLTtz5SgYM8hN0cdk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lbko/nMkJPT+o8Nmo8PQjNWKW1SIcZJMiheOu+00SJjCgfnvOGM6QOhbf2GNtMGSu
	 3CLkxDwQP978hJM7B8IgF9fbAlDr6FtCqbmoRsYIzQOsVW/ug0vP9cCr79OohVrABZ
	 wX2Kn6JaFfxZQxdKJu17W02hSoCfsqLRa0e9wCVNg084B1taVmzOnSu1enyDUkR4sw
	 QTT5QRlkZa+QmBvMzRmG9Xd+MYbmc3A8PzfNeyaBSRkki6Sf+KolZ9kJLIfQzTutYh
	 f4sZH6Qex3UDg4WmztfeVCC+35eRHMa8PEM1uupQEqmW1jyvNdwhbusSPOzDjSWf8r
	 u+P2AhXO7QW9A==
Date: Fri, 25 Apr 2025 09:18:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org
Subject: Re: [PATCH net-next,v2 0/7] Netfilter updates for net-next
Message-ID: <20250425091854.4b5964fd@kernel.org>
In-Reply-To: <20250424211455.242482-1-pablo@netfilter.org>
References: <20250424211455.242482-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Apr 2025 23:14:48 +0200 Pablo Neira Ayuso wrote:
> v2: including fixes from Florian to address selftest issues
>     and a fix for set element count and type.

Thanks, appreciated! All our networking tests now pass, but there
seems to still be some breakage on the BPF side, so
tools/testing/selftests/bpf/config needs touching up.

I suppose while addressing the RT problem you're trying to move
straggles off from the legacy stuff to nft? Which I'm entirely
sympathetic to. But I'm worried that not everybody will be, and 
there's plenty of defconfigs which include iptables:

$ git grep CONFIG_IP_NF_IPTABLES= | wc -l
54

At the end of the day it's up to you, but maybe sleep on it? :)
And the BPF side needs fixing for sure, they will notice..

Error: #25 bpf_nf
Error: #25/1 bpf_nf/xdp-ct
  Error: #25/1 bpf_nf/xdp-ct
  test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
  test_bpf_nf_ct:FAIL:iptables-legacy -t raw -A PREROUTING -j CONNMARK --set-mark 42/0 unexpected error: 768 (errno 0)
Error: #25/2 bpf_nf/tc-bpf-ct
  Error: #25/2 bpf_nf/tc-bpf-ct
  test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
  test_bpf_nf_ct:FAIL:iptables-legacy -t raw -A PREROUTING -j CONNMARK --set-mark 42/0 unexpected error: 768 (errno 0)
Error: #621 xdp_synproxy
Error: #621/1 xdp_synproxy/xdp
  Error: #621/1 xdp_synproxy/xdp
  test_synproxy:PASS:ip netns add synproxy 0 nsec
  test_synproxy:PASS:ip link add tmp0 type veth peer name tmp1 0 nsec
  test_synproxy:PASS:ip link set tmp1 netns synproxy 0 nsec
  test_synproxy:PASS:ip link set tmp0 up 0 nsec
  test_synproxy:PASS:ip addr replace 198.18.0.1/24 dev tmp0 0 nsec
  test_synproxy:PASS:ethtool -K tmp0 tx off 0 nsec
  test_synproxy:PASS:ip link set tmp0 xdp object xdp_dummy.bpf.o section xdp 2> /dev/null 0 nsec
  test_synproxy:PASS:setns 0 nsec
  test_synproxy:PASS:ip link set lo up 0 nsec
  test_synproxy:PASS:ip link set tmp1 up 0 nsec
  test_synproxy:PASS:ip addr replace 198.18.0.2/24 dev tmp1 0 nsec
  test_synproxy:PASS:sysctl -w net.ipv4.tcp_syncookies=2 0 nsec
  test_synproxy:PASS:sysctl -w net.ipv4.tcp_timestamps=1 0 nsec
  test_synproxy:PASS:sysctl -w net.netfilter.nf_conntrack_tcp_loose=0 0 nsec
  test_synproxy:FAIL:iptables-legacy -t raw -I PREROUTING 	    -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 768 (errno 95)
Error: #621/2 xdp_synproxy/tc
  Error: #621/2 xdp_synproxy/tc
  test_synproxy:PASS:ip netns add synproxy 0 nsec
  test_synproxy:PASS:ip link add tmp0 type veth peer name tmp1 0 nsec
  test_synproxy:PASS:ip link set tmp1 netns synproxy 0 nsec
  test_synproxy:PASS:ip link set tmp0 up 0 nsec
  test_synproxy:PASS:ip addr replace 198.18.0.1/24 dev tmp0 0 nsec
  test_synproxy:PASS:ethtool -K tmp0 tx off 0 nsec
  test_synproxy:PASS:setns 0 nsec
  test_synproxy:PASS:ip link set lo up 0 nsec
  test_synproxy:PASS:ip link set tmp1 up 0 nsec
  test_synproxy:PASS:ip addr replace 198.18.0.2/24 dev tmp1 0 nsec
  test_synproxy:PASS:sysctl -w net.ipv4.tcp_syncookies=2 0 nsec
  test_synproxy:PASS:sysctl -w net.ipv4.tcp_timestamps=1 0 nsec
  test_synproxy:PASS:sysctl -w net.netfilter.nf_conntrack_tcp_loose=0 0 nsec
  test_synproxy:FAIL:iptables-legacy -t raw -I PREROUTING 	    -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 768 (errno 95)

https://github.com/kernel-patches/bpf/actions/runs/14667575264/job/41166480606
