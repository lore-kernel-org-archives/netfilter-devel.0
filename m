Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794786419;
	b=HFEu2nLKsLWCbV4fLGVCl0ARbJXfiuQp+Vh9qGAgb3n2hTo0VLq3gd5Z9HbAXBPDWm2t
	 DvtJ7SZJErkFsgmw00ppAWjEugPF+cel/v34bWxxi2lFUVUBiltvJnGTUum6nSqioBfpM
	 uUVI1VfDKEhI0G3wg+0ehiB+LfIvu9PhMl56LuYtM4tqxt94ED6oQ33uypLdXpap7kR+D
	 6uEgvMrsP7dIBxBqg4cEocHcNMJgPVF2SCVtSFRvRQZe1Im7EvbMy/I+fNhBZaA4IE69e
	 Ex409DKmXQSKEA9pWbqyWrfZKfskvpem4jtS0KYAQuoTbtpMMlF/8LEbGIfNHXC6dwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794786419;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=4FXFrfDW68p2ZmuJnmPotANMx0Dmm0w6nypgxRy6L9g=;
	b=o+YxKLXRaC/NTjROnNJ2ggylJqPsG88AfyCtTk08CLYNbJ1GWl44g3Kx7x93ixGTeih5
	 p9a6CVB9GGfLvW9vPh8k88bvufDuwNsFk5xXAhfNhBJ3wXPzPzCnCaZZMaI6yvq9bMGWk
	 JquW/cUABi426eHHu+OsYuuid126dYD7TOsNBK/0Q5zRbAc9y04ZKZJqNMQvKgBzsV2qJ
	 Z6LKRzYmMkXv8bXcI8LUCrkxt0Gj7fwguzdA0kWA2tJrImUnr4DzYexn1ALYw6ddAtVkK
	 p7D20aGgcx0liwyCyapNk6aCP5STgRGd2Qo72ajYBXqiWwV/1kmd/Hb3KlhP/wq1EKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Dd+r1sfD;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 20223606A31F;
	Sun, 15 Nov 2026 23:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20223606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Dd+r1sfD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794786416;
	bh=4FXFrfDW68p2ZmuJnmPotANMx0Dmm0w6nypgxRy6L9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dd+r1sfDT9Sf7+n2u2kjbeYE0ucVdxs4PA62TvV9V3i+WZOz4+h39l4ddHMdViLDS
	 Ekq/lAzR+jgAFpTxNaZlNIBiplt5hLAGKQFllgDmYxs7uMPzcjU5UUsISUY5pbKKE5
	 o93jA1cIcde+WmPBhqM60dhxDWsgNdkoXi/aHzImyU5TkqlTLTVD+ntmVdCp7qkB+G
	 BAQElAIY0wyAjS2l6poF2crezdstjj1ySpYlVeGvC1IooQpuqK0rLJu/cqN7ByJuPb
	 cuB1UwF0mN/iuNV1tnOcfraGEPMaxxK7E6SQUhAWZuS765VNDGWe9EzEaxC+uh0Kvn
	 IvWkCUbnmDzgA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 87B736005D;
	Mon, 16 Nov 2026 00:46:56 +0100 (CET)
Date: Mon, 16 Nov 2026 00:46:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org,
	fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 00/15] Netfilter updates for net-next
Message-ID: <avpEbealnVae3W22@chamomile>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>

Hi,

I'm attaching a quick summary to address the LLM generated reports:

Patch #1 LLM reviewer refers to CLOSING state which is not covered by
this patch, which is aiming at the TEARDOWN state.

Patch #2 still needs to use the dst that is passed via flow_tuple,
ie. use tuple dst_cache.

Patch #3 LLM reviewer refers to a possible different scenario where
stats can get lost, ie. conntrack -D or -F. I don't think that belongs
to this patch, this possibly need a delayed ct event delivery for 

Patch #4 and #5 LLM reviewer provides hints to improve drivers, these
patches only adapted the existing code to fetch stats from the delete
entry command.

Patch #8 LLM reviewer refers to missing update in selftest, which
breaks.

Patch #11 LLM reviewer mentions that the new selftest script does not
cover for all UDP checksum scenarios in the flowtable. I don't see a
review why this cannot be improved in a follow up.

For patches #2 and #8 a version 2 of these PR might be needed.

But for the remaining patches, I think it is not the way to go to
address the issues described in those patches.

I can repost a v2 without patches #2 and #8.

Anything else, LGTM as is.

On Fri, Nov 13, 2026 at 04:12:36AM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter updates for net-next, mostly
> including flowtable fixes and improvements:
> 
> 1) Do not offload flows to hardware from the packet path if they are
>    already being torn down.
> 
> 2) Fix PMTU discovery in nf_flow_tunnel_ip6ip6_push(): update the PMTU
>    before skb_scrub_packet() drops the dst, otherwise the update is
>    silently lost. From Lorenzo Bianconi.
> 
> 3) Fetch hardware stats when a flow is deleted, so the last stats sync
>    with the conntrack entry is no longer missed. Update the mtk_ppe and
>    airoha drivers to use this. From Lorenzo Bianconi and me.
> 
> 4) Fix xt_time monthday computation for dates from 2040 on by using
>    time64_to_tm() instead of the days_since_epoch[] table. This also
>    shrinks the xt_time object by about 23%. From Fernando F. Mancera.
> 
> 5) Do not offload multicast flows from nft_flow_offload, from Koral Ilgun.
> 
> 6) Make the nf_hooks_lwtunnel sysctl read-only in non-init netns so
>    unprivileged users cannot toggle the global static branch.
>    From Pablo Neira Ayuso.
> 
> 7) Purge the remaining flowtable entries directly when the flowtable
>    is destroyed instead of going through the hardware offload
>    workqueue, which may fail to allocate work.
> 
> 8) Remove a no-op loop initializer in the nf_queue selftest to silence
>    a clang -Wunused-value warning. From Sasha Levin.
> 
> 9) Do not scrub the skb as crossing netns in the IPIP flowtable tx
>    path, so the skb mark is preserved.
> 
> 10) Do not let the DEV_PATH_TUN entry set h_source from the tunnel
>     device's dev_addr. Before this patch, fast-path frames went out with
>     part of the tunnel's local IP address as the Ethernet source MAC.
>     This broke offloaded flows on DS-Lite over PPPoE. From Marek
>     Majkowski.
> 
> 11) Clear IPS_OFFLOAD_BIT only once, as part of the one-time teardown
>     transition. Before this patch, a repeated teardown of an expired
>     hardware flow could clear the bit owned by a replacement flow for
>     the same conntrack entry. From João Silva.
> 
> 12) Call skb_ensure_writable() in nfnetlink_queue before writing
>     NFQA_L2HDR over the mac header. Before this patch, the write could
>     corrupt cloned frames that bridge flooding sends to other ports.
>     From Tamaki Yanagawa.
> 
> 13) Add a UDP flowtable offload selftest for IPv4 and IPv6, with and
>     without masquerade. From Jiri Peska.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-13
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 573af801552999954caa8347e4490b04cf4763f0:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-11-12 14:54:47 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-13
> 
> for you to fetch changes up to 4810f60b9f0e9111cd0dcbfd2ca7a7c591a57464:
> 
>   selftests: netfilter: add UDP flowtable offload test (2026-11-13 04:06:51 +0100)
> 
> ----------------------------------------------------------------
> netfilter pull request 26-11-13
> 
> ----------------------------------------------------------------
> Fernando Fernandez Mancera (1):
>       netfilter: xt_time: fix monthday computation for dates past 2039
> 
> Jiri Peska (1):
>       selftests: netfilter: add UDP flowtable offload test
> 
> João Silva (1):
>       netfilter: flowtable: do not clear the offload bit twice
> 
> Koral Ilgun (1):
>       netfilter: nft_flow_offload: do not offload multicast
> 
> Lorenzo Bianconi (2):
>       netfilter: flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()
>       net: airoha: update stats on flow deletion
> 
> Marek Majkowski (1):
>       netfilter: flowtable: tunnel device poisons h_source of fast-path frames
> 
> Pablo Neira Ayuso (6):
>       netfilter: flowtable: do not hw offload flows in teardown state
>       netfilter: flowtable: retrieve stats on flow deletion
>       net: ethernet: mtk_ppe: update stats on flow deletion
>       netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
>       netfilter: flowtable: purge entries immediately when destroying the flowtable
>       netfilter: flowtable: do not scrub as crossing netns
> 
> Sasha Levin (1):
>       selftests: netfilter: nf_queue: drop the no-op loop initializer
> 
> Tamaki Yanagawa (1):
>       netfilter: nfnetlink_queue: make skb writable before writing NFQA_L2HDR
> 
>  drivers/net/ethernet/airoha/airoha_ppe.c           |  31 +--
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  32 ++-
>  include/net/netfilter/nf_flow_table.h              |   3 +-
>  net/netfilter/nf_flow_table_core.c                 |  35 ++-
>  net/netfilter/nf_flow_table_ip.c                   |   4 +-
>  net/netfilter/nf_flow_table_offload.c              |  83 ++++---
>  net/netfilter/nf_flow_table_path.c                 |   7 +-
>  net/netfilter/nf_hooks_lwtunnel.c                  |  12 +-
>  net/netfilter/nfnetlink_queue.c                    |   7 +-
>  net/netfilter/nft_flow_offload.c                   |   5 +
>  net/netfilter/xt_time.c                            |  82 +------
>  tools/testing/selftests/net/netfilter/Makefile     |   1 +
>  tools/testing/selftests/net/netfilter/nf_queue.c   |   2 +-
>  .../selftests/net/netfilter/nft_flowtable_udp.sh   | 238 +++++++++++++++++++++
>  14 files changed, 398 insertions(+), 144 deletions(-)
>  create mode 100755 tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh
> 
