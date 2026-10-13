Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A099B3B6346;
	Tue, 13 Oct 2026 23:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791933103; cv=none; b=gqktIFPqsfCdB3ukXofk3N8lreRL7bdmRN6C3XGN6gpwbRGMONWzOYZbaEt2iO1Vf+t44+9qCI/oTjNencNzKr02NQEfOtLyjwEsz48uUh/98dA6pStrB5mUxr6DkeCSLCLLLUb9jzMml0E0TVZfpU+BTrclLqwLG6fkYJg8kCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791933103; c=relaxed/simple;
	bh=PMJbZWO64H4fUG8Gw7w4wtx9k3i4Si7AWZYRcaXeV4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9BJ/Kbl6Xe1DFROTw/mo6+LJxG5dj+APj8L/hCc+LnH3ZMuf65X5W4TVjUvPjw0bOrYVh7siMOeO2jFgB/b0EIuSwOl6E0aoz2nmbNTyLfh2gz1d/2W9D+9fDytKG+Ndow8cURqcSQ13XFJul9Q4JgCtBHc6c6xNDPGXUjdVZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LlblebXA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LlblebXA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791933097;
	bh=rg8WGEzEvs2GTblqyE7pwDS8dlotG5DkkCjjlxe5yAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LlblebXAczL4Am7oTD16jr495L/ZI3z9mvyOCaUo+c41h/2avmlCNifD/DRsbmrxs
	 5eZ1Rw+GM5eF960iFrTpxWSd0yqSALeK2jk2rBFC6Y3jmTN3/ULuGvXJwPE/8eJfX6
	 TfaFhfGdN5C3j0u7vh/XJGZMUiYtRZ65ZqfkWyfH1cmCIh5YgYetNYpNRvMlEJsfL+
	 1ibxQJYweTDkRyNu+iBBvrsI94Nu8IubbebZ+Ta0xlQfjvgXL7wJ42LUCuNJTwXQo3
	 xhiaojQfTIFJQCA+UJI6xvP+t09fl+FH4wUrYvGOkW2Dq1nSMgpA5gedXlGz+ZjXyf
	 toGfMgx9ztyhw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E2DD060055;
	Wed, 14 Oct 2026 01:11:36 +0200 (CEST)
Date: Wed, 14 Oct 2026 01:11:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org,
	fw@strlen.de, ja@ssi.bg, lorenzo@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <as66prsWCk1qlQpm@chamomile>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>

Hi,

+Cc: lorenzo@kernel.org

This is a report on sashiko's findings:

https://sashiko.dev/#/patchset/20261011215953.1334630-1-pablo%40netfilter.org

On Sun, Oct 11, 2026 at 11:59:38PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS updates for net-next:
> 
> 1) Disable br_netfilter in userns and schedule it for removal in 2027,
>    from Florian Westphal.
> 
> 2) Prepare the flowtable to support for IPv4 over IPv6 tunneling and
>    vice-versa, this includes 5 patches from Lorenzo Bianconi.

I am afraid this preparation series is enabling more than it should,
sashiko reports type confusion is possible, for example:

  1/5 netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching

this adds the initial pre-processing of IPv6-over-IPv4.

But then, nf_flow_offload_lookup() expects to handle IPv4, not an IPv6
packet.

I will repost this PR keeping them back.

> 3) Update selftest nft_queue.sh to make it more stable on debug
>    kernels, from Jakub Kicinski.
> 
> 4) Fix a overflow in IPVS sync messages which can only happen in very
>    old 2.6 kernels, from Julian Anastasov.
> 
> 5) Flush conntrack gc worker when existing netns to address a unlikely
>    UaF, from Florian Westphal.
> 
> 6) Switch nf_tables chain types to use rcu, otherwise module removal
>    can trigger UaF, also from Florian.
> 
> 7) Add two new helper functions to validate that socket is of inet type,
>    coming in 2 patches from Florian Westphal.

sashiko reports:

"If an IPv4 packet from an AF_INET socket is encapsulated by an IPv6 tunnel,
the tunnel preserves the AF_INET socket in skb->sk while transmitting the
outer IPv6 packet on the LOCAL_OUT path."

This sounds like an unrelated issue, I don't know yet how that can
happen TBH.

> 8) Remove redundant parsing in nft_exthdr for the tcp options case,
>    from Fernando F. Mancera.
> 
> 9) Remove redundant skb_header_pointer() calls in nft_exthdr for tcp
>    options, from Fernando F. Mancera.

Sashiko here reports this now drops malformed packets instead of
NFT_BREAK, which is fine, maybe just extend it to tell about this in
the patch description.

I plan to drop the flowtable preparation patches and resubmit.

> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-11
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit a5e7d8e446af9803e37a3b6a4d416fb41178348f:
> 
>   Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2026-10-05 17:51:32 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-11
> 
> for you to fetch changes up to b4074bbf5c23b05bd34022ade979f3d5f4e86516:
> 
>   netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling (2026-10-11 23:29:26 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request 26-10-11
> 
> ----------------------------------------------------------------
> Fernando Fernandez Mancera (2):
>       netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
>       netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling
> 
> Florian Westphal (5):
>       netfilter: disable br_netfilter in user namespaces
>       netfilter: conntrack: fix unlikely UaF in gc worker
>       netfilter: nf_tables: switch chain_types array to rcu
>       netfilter: add nf_skb_sk helper and use it
>       netfilter: add nf_sk_to_full_sk helper and use it
> 
> Jakub Kicinski (1):
>       selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
> 
> Julian Anastasov (1):
>       ipvs: fix buffer overflow when sending sync messages
> 
> Lorenzo Bianconi (6):
>       netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching
>       netfilter: flowtable: set inner protocol when popping tunnel header
>       netfilter: flowtable: populate tunnel tuple regardless of inner protocol
>       netfilter: flowtable: add encap_proto to flow_offload_tunnel
>       netfilter: flowtable: refactor MTU check for tunnel offload
>       netfilter: flowtable: unify tunnel push for IPv4 and IPv6
> 
>  Documentation/networking/bridge.rst                |   5 +-
>  include/linux/netdevice.h                          |   1 +
>  include/net/netfilter/nf_flow_table.h              |   1 +
>  include/net/netfilter/nf_socket.h                  |  35 ++++
>  net/bridge/br_netfilter_hooks.c                    |  33 +++-
>  net/ipv4/ipip.c                                    |   1 +
>  net/ipv4/netfilter.c                               |   3 +-
>  net/ipv6/ip6_tunnel.c                              |   1 +
>  net/ipv6/netfilter.c                               |   3 +-
>  net/netfilter/ipvs/ip_vs_sync.c                    |  23 ++-
>  net/netfilter/nf_conntrack_core.c                  |   5 +
>  net/netfilter/nf_flow_table_ip.c                   | 215 +++++++++++++--------
>  net/netfilter/nf_flow_table_path.c                 |   2 +
>  net/netfilter/nf_tables_api.c                      |  94 ++++++---
>  net/netfilter/nft_chain_nat.c                      |   1 +
>  net/netfilter/nft_exthdr.c                         |  34 ++--
>  net/netfilter/nft_socket.c                         |  16 +-
>  net/netfilter/xt_socket.c                          |  26 +--
>  tools/testing/selftests/net/netfilter/nft_queue.sh |   2 +-
>  19 files changed, 336 insertions(+), 165 deletions(-)
> 
