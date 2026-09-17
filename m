Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30FE449B0C;
	Thu, 17 Sep 2026 07:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630077; cv=none; b=q0y4strGj9u0qhd8m4sYUjwdrrorou67DCP+DzUT7zht4Dba96XTT1ZHjjM5HzS+Y3w1XMAhLwo785S9pmjjcnVL6TLWjVqC/6qU51C9GGnH6vB4qCr+z19STF5K5bmZGml8KN4dlOZTikjGPVT99FZRStF3wvqbd/jrc25LIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630077; c=relaxed/simple;
	bh=l+DsCJ3T1KRdbZy3ij0OEan65fgafxGAy6ltOw4ZVUc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H99/NqQg4P2EBNim6NJPfFeo5RG6PDeeOG/E3IGboTVHyMYQB8C/Btm3dqTUua41XjSKpvUbGg/q7RAKr8Hlxw5wTEqJ43C8sn+eO8G92yzZw0Qt86VNjUyvNgAMd2YoXvN6NSePEZSSoHGvxKHBfcaKkWMxDH4BIme7bwDbSqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQERxJwD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQERxJwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFD11F00893;
	Thu, 17 Sep 2026 07:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630075;
	bh=EC2k41/aCfeV1gmXCrX3dM1Y9a0O3T99/CzK6B96lDg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SQERxJwDAiVbiAUXBlOfXiwNn3fiq4LtAl7Alo/Mmn03o5ciNX7P4253RT4luA1qU
	 w7Jcgn5S/j+E4H7tCufDNp4WDUWJRPXRo0H4zNbMgxB2cbwWsIPPJQVMe6ay+8uBAu
	 +3sMoZJsS7RCRMbkx8UGfuHhvSjoaoJAunIrvumyDbt1g/6TWJE4b9l9ZSSai7WMgB
	 ih53pEnkxK+/xLgF3sgbeaaKBnHY8D5vkDXxmu0uCCgRKohnQgnu3G7uOAcMt22IdC
	 uCC/v+/VUUVEqQxWH/ESJJYWoZIdT4DX4oxTjBmLCARLF98GjQG7j4/ZqytCm7m+wT
	 GcE63vbj6zCMA==
Subject: Re: [PATCH nf-next v5 3/3] selftests: netfilter: nft_flowtable.sh:
 roam a host between two bridge ports
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 kadlec@netfilter.org, phil@nwl.cc, horms@kernel.org, davem@davemloft.net,
 razor@blackwall.org, ericwouds@gmail.com, dqfext@gmail.com,
 netdev@vger.kernel.org, coreteam@netfilter.org,
 linux-kselftest@vger.kernel.org, kuba@kernel.org
Date: Thu, 17 Sep 2026 07:27:54 +0000
Message-ID: <178963007419.22033.4559516105068933263@kernel.org>
In-Reply-To: <20260914072541.897040-4-julius@bairaktaris.de>
References: <20260914072541.897040-4-julius@bairaktaris.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 1

- [Medium] In test_bridge_roam() the two readiness barriers are decision
  points whose failure is ignored: `busywait 1000 roam_listener_ready`…
- [Medium] Both offload assertions in test_bridge_roam() are one-sided
  upper bounds on the reply-direction forward-chain counter (`[…
- [Low] The listener socat started in $rns2 (nft_flowtable.sh:944-945) is
  backgrounded but its PID is never captured, so no exit path of…

--

selftests: netfilter: nft_flowtable.sh: roam a host between two bridge ports

This adds test_bridge_roam() to nft_flowtable.sh, which moves a host
bridge between two ports of a router bridge while a tcp flow is
offloaded, and checks that the transfer resumes and stays on the fast
path.  It is run twice, once with plain veth bridge ports and once with
vlan devices, and it adds CONFIG_NET_SWITCHDEV to the netfilter config.

A few questions about the new test below.

> diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
> index 449c518bd947..0d9f7d771fac 100755
> --- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
> @@ -851,6 +851,146 @@ test_ipip
>  
>  test_bridge
>  
> +# Roam a host between two ports of a bridge on the router while its flow is
> +# offloaded, as a station moving between two access points attached to ports
> +# of one bridge. The host keeps its address and mac on a bridge of its own
> +# and roams by moving that bridge's port, so only the fdb changes. With a vid
> +# the bridge ports are vlan devices, whose ifindex differs from the device
> +# the flow transmits on. A flow that stays on the fast path leaves no more
> +# than a few packets in the forward chain, the counter tells offloaded from
> +# slow path.
> +test_bridge_roam()
> +{

[ ... namespace, veth, vlan, bridge and ruleset setup snipped ... ]

> +	# the host discards what it receives, its socket byte counter is read
> +	rx_bytes() { ip netns exec "$rns1" ss -tin "dst 10.9.2.99" 2>/dev/null |
> +		grep -o 'bytes_received:[0-9]*' | head -1 | cut -d: -f2; }
> +	rx_started() { local n; n=$(rx_bytes); [ "${n:-0}" -gt 0 ]; }
> +	# forward chain packets of the reply direction since the last call
> +	slow_pkts() { ip netns exec "$rnsr" nft reset counter inet filter roam_repl |
> +		grep -o 'packets [0-9]*' | cut -d' ' -f2; }
> +	roam_listener_ready() { ss -N "$rns2" -lnt -o "sport = :12345" | grep -q 12345; }
> +
> +	timeout "$SOCAT_TIMEOUT" ip netns exec "$rns2" socat -u \
> +		OPEN:/dev/zero TCP-LISTEN:12345,reuseaddr &

[Severity: Low]
The listener socat in $rns2 is backgrounded but its pid is not saved, so
no exit path of test_bridge_roam() can stop it.  Only the client pid is
kept in $cpid, and neither child is ever waited for.  Elsewhere in this
same file the listener pid is captured and reaped:

	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsb" socat ... &
	lpid=$!
	...
	wait $lpid

Would it be worth following that pattern here?

The leftover process does get reclaimed, since cleanup_ns() in
tools/testing/selftests/net/lib.sh does

	ip netns pids "${ns}" 2> /dev/null | xargs -r kill || true

and that runs both from setup_ns() when the second call test_bridge_roam 100
reuses the names, and from the EXIT trap via cleanup_all_ns().  Each socat
is also bounded by timeout "$SOCAT_TIMEOUT".  So this is hygiene rather
than a leak.

> +	busywait 1000 roam_listener_ready
> +	timeout "$SOCAT_TIMEOUT" ip netns exec "$rns1" socat -u \
> +		TCP:10.9.2.99:12345 OPEN:/dev/null &
> +	cpid=$!
> +
> +	busywait "$BUSYWAIT_TIMEOUT" rx_started

[Severity: Medium]
Can a setup failure here be reported as a flowtable regression?  The exit
status of both readiness barriers is discarded.

busywait() in tools/testing/selftests/net/lib.sh does return the status of
loopy_wait():

	busywait()
	{
		local timeout_ms=$1; shift

		loopy_wait : "$timeout_ms" "$@"
	}

If the listener is not bound within the hard-coded 1000 ms, the client
socat is started anyway and exits immediately on ECONNREFUSED with no
retry.  busywait "$BUSYWAIT_TIMEOUT" rx_started then also times out
unnoticed, and the test continues to measure a connection that never
existed.

With no traffic at all, slow_pkts() returns 0, so the pre-roam check
[ "${slow:-0}" -gt 100 ] is false and control falls through to the roam.
Afterwards old=$(rx_bytes) and new=$(rx_bytes) are both the empty string,
so [ "${new:-0}" -le "${old:-0}" ] evaluates 0 -le 0 and the script sets
ret=1 with "FAIL: ... transfer stalled after the roam".

Would it be better to check these two busywait calls and report an error
or a skip when the stream never comes up, rather than letting a broken
precondition turn into a fail attributed to the roam path?

> +	sleep 2
> +	slow_pkts > /dev/null
> +	sleep 2
> +	slow=$(slow_pkts)
> +	if [ "${slow:-0}" -gt 100 ]; then
> +		echo "FAIL: $what: $slow forward chain packets before the roam" 1>&2
> +		ret=1
> +		kill "$cpid" 2>/dev/null
> +		return
> +	fi
> +
> +	# roam: move the host bridge to the other port and send on it
> +	ip -net "$rns1" link set "$p0" nomaster
> +	ip -net "$rns1" link set "$p1" master stbr
> +	ip netns exec "$rns1" ping -c 2 -W 1 -q 10.9.1.1 >/dev/null 2>&1
> +
> +	# the bytes in flight at the roam drain within the first seconds; a
> +	# stale flow delivers nothing after that, a torn down one resumes and
> +	# is offloaded again.
> +	sleep 4
> +	old=$(rx_bytes)
> +	sleep 4
> +	new=$(rx_bytes)
> +	slow_pkts > /dev/null
> +	sleep 2
> +	slow=$(slow_pkts)
> +	kill "$cpid" 2>/dev/null
> +
> +	if [ "${new:-0}" -le "${old:-0}" ]; then
> +		echo "FAIL: $what: transfer stalled after the roam" 1>&2
> +		ret=1
> +	elif [ "${slow:-0}" -gt 100 ]; then
> +		echo "FAIL: $what: $slow forward chain packets after the roam" 1>&2
> +		ret=1
> +	else
> +		echo "PASS: flow offload for $what"
> +	fi

[Severity: Medium]
Both offload assertions in test_bridge_roam() are one-sided upper bounds
on the reply-direction counter, [ "${slow:-0}" -gt 100 ], with nothing
tying them to traffic actually having been observed.  A reading of 0
packets is accepted as evidence of offload.

slow_pkts() is a pipeline and the script does not set pipefail:

	slow_pkts() { ip netns exec "$rnsr" nft reset counter inet filter roam_repl |
		grep -o 'packets [0-9]*' | cut -d' ' -f2; }

so a failing nft reset counter, or a grep that matches nothing, yields an
empty string which ${slow:-0} silently turns into 0.

The progress check is similarly weak: [ "${new:-0}" -le "${old:-0}" ] is
satisfied by a single byte of advance over the eight seconds around the
roam.

The commit message says the test "checks that the flow was offloaded
before the roam".  Since that check passes when no flow exists and when
the counter read fails, could a lower bound be added, for example
requiring that the pre-roam byte counter advanced by a meaningful amount
and that the counter read succeeded, before concluding the flow was on the
fast path?

> +}
> +
> +test_bridge_roam ""
> +test_bridge_roam 100

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914072541.897040-1-julius%40bairaktaris.de
