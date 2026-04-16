Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91598379EFE;
	Thu, 16 Apr 2026 07:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776324366; cv=none; b=jcQAoEEjJq6hQhiOyuFWaxfPKWn9J/vM2tGGyJJjvo7eqsw0bk67ZR+vEWV5tm1h/CSv8sqg9nVgAm8isrUKxooRrNfgKmnyMV0HwNneUyHTagMMk/LNXLYljCF0Xm1cHbIfZnmGjC98+lyZoM8pNjzBB18KAL1i9Ct7xrvDgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776324366; c=relaxed/simple;
	bh=8XOGHuG7DL0SKI+wzf4TpVXG791hIIaFSOk5D96MHNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvkpDnf4Fw/uWcSZKS9hhiPu5GX8mDAKncwb4PUsxCmdw9wGZss6uz/j5sWtWXWj+pxu5RHJbp6Vg94+Yej15ByLZFobvFI4MPYCl9kj9QIRJZvZ+iLYxr1NYt1ngVEYhubgl9v8npqXaQDbm7ClzylmTQZl/rib1St9n3b2AXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FvxadmrQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FvxadmrQ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2DCDA60177;
	Thu, 16 Apr 2026 09:26:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776324362;
	bh=iK2gR/+LE4a4ZAYal36ygKmYu5CbrxnT6MXmEhNpe2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FvxadmrQ7iZeKJgVUh/qpqmqdNY2EE9AlvB4RXlUokEFWXtcalLjfCGITmT9DP21b
	 fhG0h5EAzfPeQIGftW/8/SWTAr15Xl28SfZwNAnCVBij/wCjR2DXF+JmPoY3jGydbm
	 t9vVYXnsj9KQ6jQ0lZWS0FhhPv8z4kjBWeXdqn2uuegm4xPUqw2BucBlvPRRe/3mvM
	 lethOs/WwN7YQAwDILs8YowkZ4XdBkj3rmCXMOFvt6urOQ5W+uCwm6/19w4z9jhTTV
	 KfDMcoc3KdcXAbbBpgy1mKAdF8HiECHTmJGPXovL7lSOBxz3i/NXRVuZUB9k2Nm1jI
	 6u2g4neBv818g==
Date: Thu, 16 Apr 2026 09:25:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 00/14] Netfilter/IPVS fixes for net
Message-ID: <aeCPB1_WaFOX-Xos@chamomile>
References: <20260416013101.221555-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416013101.221555-1-pablo@netfilter.org>

Hi,

I am preparing a v2 to address so AI generated comment, I should be
ready in a few hours.

Thanks.

On Thu, Apr 16, 2026 at 03:30:47AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS fixes for net: Mostly
> addressing very old bugs in the SIP conntrack helper string parser,
> unsafe arp_tables match support with legacy IEEE1394, restrict xt_realm
> to IPv4 and incorrect use of RCU lists in nat core and nftables. This
> batch also includes one IPVS MTU fix. The exception is a fix for a
> recent issue related to broken double-tagged vlan in the flowtable.
> 
> 1) Fix possible stack recursion in nft_fwd_netdev from egress path,
>    from Weiming Shi.
> 
> 2) Fix unsafe port parser in SIP helper, from Jenny Guanni Qu.
> 
> 3) Fix arp_tables match with IEEE1394 ARP payload, allowing to
>    reach bytes off the skb boundary, from Weiming Shi.
> 
> 4) Reject unsafe nfnetlink_osf configurations from control plane,
>    this is addressing a possible division by zero, from Xiang Mei.
> 
> 5) nft_osf actually only supports IPv4, restrict it.
> 
> 6) Fix double-tagged-vlan support (again) in the flowtable, from
>    Eric Woudstra.
> 
> 7) Remove unsafe use of sprintf to fix possible buffer overflow
>    in the SIP NAT helper, from Florian Westphal.
> 
> 8) Restrict xt_mac, xt_owner and xt_physdev to inet families only;
>    xt_realm is only for ipv4, otherwise null-pointer-deref is possible.
> 
> 9) Use kfree_rcu() in nat core to release hooks, this can be an issue
>    once nfnetlink_hook gets support to dump NAT hook information,
>    not currently a real issue but better fix it now.
> 
> 10) Fix MTU checks in IPVS, from Yingnan Zhang.
> 
> 11) Use list_del_rcu() in chain and flowtable hook unregistration,
>     concurrent RCU reader could be walking over the hook list,
>     from Florian Westphal.
> 
> 12) Add list_splice_rcu(), this is required to fix unsafe
>     splice to RCU protected hook list. Reviewed by Paul McKenney.
> 
> 13) Use list_splice_rcu() to splice new chain and flowtable hooks.
> 
> 14) Add shim nft_trans_hook object to track chain and flowtable
>     hook deletions and flag them as removed, instead of unsafely
>     moving around hooks in the RCU-protected hook list. This allows
>     to restore the previous state from the abort path.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-16
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 2dddb34dd0d07b01fa770eca89480a4da4f13153:
> 
>   net: ethernet: mtk_eth_soc: initialize PPE per-tag-layer MTU registers (2026-04-12 15:22:58 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-04-16
> 
> for you to fetch changes up to e349f90da812aeddd22c3914a2cc639b51e4eb48:
> 
>   netfilter: nf_tables: add hook transactions for device deletions (2026-04-16 02:47:58 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request 26-04-16
> 
> ----------------------------------------------------------------
> Eric Woudstra (1):
>       netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()
> 
> Florian Westphal (2):
>       netfilter: conntrack: remove sprintf usage
>       netfilter: nf_tables: use list_del_rcu for netlink hooks
> 
> Jenny Guanni Qu (1):
>       netfilter: nf_conntrack_sip: add bounds-checked port parsing helper
> 
> Pablo Neira Ayuso (6):
>       netfilter: nft_osf: restrict it to ipv4
>       netfilter: xtables: restrict several matches to inet family
>       netfilter: nat: use kfree_rcu to release ops
>       rculist: add list_splice_rcu() for private lists
>       netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
>       netfilter: nf_tables: add hook transactions for device deletions
> 
> Weiming Shi (2):
>       netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
>       netfilter: arp_tables: fix IEEE1394 ARP payload parsing in arp_packet_match()
> 
> Xiang Mei (1):
>       netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
> 
> Yingnan Zhang (1):
>       ipvs: fix MTU check for GSO packets in tunnel mode
> 
>  include/linux/rculist.h               |  29 ++++++
>  include/net/netfilter/nf_dup_netdev.h |  13 +++
>  include/net/netfilter/nf_tables.h     |  13 +++
>  net/ipv4/netfilter/arp_tables.c       |  14 ++-
>  net/ipv4/netfilter/iptable_nat.c      |   2 +-
>  net/ipv6/netfilter/ip6table_nat.c     |   2 +-
>  net/netfilter/ipvs/ip_vs_xmit.c       |  19 +++-
>  net/netfilter/nf_conntrack_sip.c      |  80 +++++++++++-----
>  net/netfilter/nf_dup_netdev.c         |  16 ----
>  net/netfilter/nf_flow_table_ip.c      |  25 ++++-
>  net/netfilter/nf_nat_amanda.c         |   2 +-
>  net/netfilter/nf_nat_core.c           |  10 +-
>  net/netfilter/nf_nat_sip.c            |  33 ++++---
>  net/netfilter/nf_tables_api.c         | 168 ++++++++++++++++++++++++----------
>  net/netfilter/nfnetlink_osf.c         |   4 +
>  net/netfilter/nft_fwd_netdev.c        |   7 ++
>  net/netfilter/nft_osf.c               |   6 +-
>  net/netfilter/xt_mac.c                |  34 ++++---
>  net/netfilter/xt_owner.c              |  37 +++++---
>  net/netfilter/xt_physdev.c            |  29 ++++--
>  net/netfilter/xt_realm.c              |   2 +-
>  21 files changed, 393 insertions(+), 152 deletions(-)
> 
