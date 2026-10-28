Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.252.153.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214725;
	b=ckz48ooUWvEenWGCBv0pAcIrOttBZIT5PrPu4C7OhfEHivHXkxzCzBp3s9OHLMGakCJW
	 O0TKzaP96o+4OWY0tEl4Hx5KikUaLFs44dNq7viP1G3iT3rMEbcYVybhccjEogE7pZ0i0
	 uRCeQPhhoCA+k+yxJddUgPvFzOvO+Vl+BZBQOLXYO4QrM3el58LdMoECx7+zXE2rYKzpD
	 hL5ScQM+cae56GiQradrbERFshdfGdlhOMqGYYfnl5n1n06OBPfwmPwczKd5CScc0le/n
	 6j0Rmpxn41NvXE+Jh97i+qcLdV+AiUhzJvT/khiroEYJE5l6YVmmmZz9nyuNOlPcOKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214725;
	h=DMARC-Filter:DKIM-Signature:Received:X-Riseup-User-ID:Received:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5jfLFSb5rkOZeeRJ6bNDFFfzg/eaqfFeembrXBnz8dw=;
	b=34ooYuRMmrAZJK0LW+edIGucWLhQYIgRH4DjiONef9RsBU89oCzj01Jd7mfVsaagFBMC
	 1FuhVukA9kE0R72JoevpRqdI5WhhIj2RxVROC7Fhkz5e2Aocq4OQ1L/mYWW4omebQ1oN2
	 Z3l+bNbym1T0oZQzUw/NpAUxHQNoYzoffFHL4KvrNZ/BHLtVr4jaqtkFSULkyhMWwUI6x
	 PYiMty658WSrY/q5MwF6ryr83gH5QM5s9SEOSloXIxyOfLPqarvaspxBHTqePDN6VuGvF
	 7PG2nKLS6hCAjNYqZ3pisDFcFYDLIzjuULSf/N89xW4AK8GHX4PH9elnh+DsVJTHtfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=riseup.net;
	spf=pass smtp.mailfrom=riseup.net;
	dkim=pass header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=BtlwtGs3;
	arc=none smtp.remote-ip=198.252.153.6
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903FD606AB00;
	Wed, 28 Oct 2026 19:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 903FD606AB00
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=BtlwtGs3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1793214717; bh=5jfLFSb5rkOZeeRJ6bNDFFfzg/eaqfFeembrXBnz8dw=;
	h=From:To:Cc:Subject:Date:From;
	b=BtlwtGs3uTGuD5fwzLJnT3tkyvDzA1IAJWvU/2HikUtU2OQuL1Jt8twHziCEQQs8V
	 mgYz2TmqcXOekJWmSphzTWDhR25n9U8kuNG1X+onPk46PI7tx6MICKVIe9lKuCiojD
	 G44cKbqF6+H2PtCZq7LkdfJj0xsNHVtwQLiE21C4=
Received: from fews04-sea.riseup.net (fews04-sea-pn.riseup.net [10.0.1.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx0.riseup.net (Postfix) with ESMTPS id 4jFH6N1swmz9rwx;
	Wed, 28 Oct 2026 19:11:56 +0000 (UTC)
X-Riseup-User-ID: BAF92B9D2CC73FFBF175A220C2F1BA822621BEA57DEEA305E4C26A286727E6F4
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews04-sea.riseup.net (Postfix) with ESMTPSA id 4jFH672P44z5vSY;
	Wed, 28 Oct 2026 19:11:43 +0000 (UTC)
From: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>
To: Alexei Starovoitov <ast@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>,
	bpf@vger.kernel.org,
	Breno Leitao <leitao@debian.org>,
	coreteam@netfilter.org,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Jeff Layton <jlayton@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Joe Damato <joe@dama.to>,
	John Fastabend <john.fastabend@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Li RongQing <lirongqing@baidu.com>,
	linux-kselftest@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Qi Tang <tpluszz77@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Willem de Bruijn <willemb@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
	Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net v3 0/3] net/ipv6: don't route packets with unknown source address
Date: Wed, 28 Oct 2026 20:10:54 +0100
Message-ID: <20261028191103.623156-1-ihuguet@riseup.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Don't allow routing packets with a source address that is not configured
in the host. Allow it only in certain cases like when using a
transparent socket, by setting the ANYSRC flag in flowi_flags.

Main reasons (see full explanation in the 2nd patch):
- Alignment with IPv4 stack
- Compliance with RFC 4862 (an invalid address MUST NOT be used as the
  source address of outbound packets)
- Meet expectations of stop using an address after removing it or its
  expiration lifetime.

Added selftests covering the patch, and also its IPv4 counterpart which
had no tests covering it. I also added selftests covering 2 features
that were impacted by v2 and discovered at review: anycast and loopback
subnets.

The change in the netfilter's ip6_route_me_harder function is the one
that I'm more unsure about. It was not clear to me the reason why it was
done like this in the IPv4 counterpart. Please review carefully.

Testing: tested with a manual reproducer executing the steps described
in the patch. Tested also with transparent sockets to ensure that the
packets are sent in that case. Also executed the following selftests
to prevent potential regressions: net/*, net/forwarding/* and
net/netfilter/*. I also ran Sashiko locally and applied most of its
change proposals.

I ignored on purpose some review comments from Sashiko saying that
the ANYSRC flag must be set in some additional places. The reasoning
to ignore them is that they are neither set in IPv4. If they were
not needed in IPv4 where the source address check has been in place
for many years, probably they are neither needed in the IPv6
counterpart. These are the functions where I ignored Sashiko's
comments:
- sctp_v6_get_dst
- nat_keepalive_send_ipv6
- rxe_find_route6
- tipc_udp_xmit

Signed-off-by: Íñigo Huguet <ihuguet@riseup.net>

---

v3:
 - Fixed errors in the selftest xfrm_state by setting ANYSRC in
   icmpv6_route_lookup.
 - Fixed errors in the selftest vrf_route_leaking by searching the
   address in the entire namespace, not in a specific L3 domain.
 - Fixed loopback subnets (AnyIP) by adding a fallback to FIB local
   routes if the exact address is not present.
 - Fixed anycast address as source address by using ipv6_chk_acast_addr_src.
 - Fixed TCP responses in timewait sockets by using inet_sk_transparent
   if !sk_fullsock.
 - Added forgotten flag in the IPv6 branch of bpf_skb_set_tunnel_key.
 - Added many selftests:
   - No tests existed for "check source address on ongoing packets",
     neither for IPv4. Added them.
   - No tests existed for anycast and loopback subnets, so I didn't
     detected it in v2. Added tests for both features.
v2: https://lore.kernel.org/netdev/20260903121057.80006-1-ihuguet@riseup.net/
v1: https://lore.kernel.org/netdev/20260901115021.50057-1-ihuguet@riseup.net/

Íñigo Huguet (3):
  net/ipv6: add ipv6_chk_addr_namespace
  net/ipv6: don't route packets with unknown source address
  selftests: net: add tests for saddr, anycast and loopback subnets

 drivers/net/vrf.c                             |   1 +
 include/net/addrconf.h                        |   4 +-
 net/core/filter.c                             |   1 +
 net/core/lwt_bpf.c                            |   1 +
 net/ipv6/addrconf.c                           |  76 ++-
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/anycast.c                            |   2 +-
 net/ipv6/datagram.c                           |   3 +-
 net/ipv6/icmp.c                               |   5 +
 net/ipv6/inet6_connection_sock.c              |   2 +
 net/ipv6/ip6_output.c                         |  38 ++
 net/ipv6/ip6_tunnel.c                         |  10 +-
 net/ipv6/ip6_udp_tunnel.c                     |   1 +
 net/ipv6/ndisc.c                              |   2 +-
 net/ipv6/netfilter.c                          |  11 +-
 net/ipv6/ping.c                               |   1 +
 net/ipv6/raw.c                                |   1 +
 net/ipv6/route.c                              |   4 +-
 net/ipv6/syncookies.c                         |   1 +
 net/ipv6/tcp_ipv6.c                           |   7 +-
 net/ipv6/udp.c                                |   1 +
 net/l2tp/l2tp_ip6.c                           |   2 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   4 +
 tools/testing/selftests/net/ip_saddr.c        | 557 +++++++++++++++++
 tools/testing/selftests/net/ip_saddr.sh       | 575 ++++++++++++++++++
 tools/testing/selftests/net/ipv6_anycast.sh   |  68 +++
 .../testing/selftests/net/loopback_subnet.sh  | 135 ++++
 28 files changed, 1472 insertions(+), 43 deletions(-)
 create mode 100644 tools/testing/selftests/net/ip_saddr.c
 create mode 100755 tools/testing/selftests/net/ip_saddr.sh
 create mode 100755 tools/testing/selftests/net/ipv6_anycast.sh
 create mode 100755 tools/testing/selftests/net/loopback_subnet.sh

-- 
2.54.0

