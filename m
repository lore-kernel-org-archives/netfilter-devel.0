Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EED3AA510
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791286116; cv=none; b=RsoG2QbWXj9G2rLS7Mi4IoHzHKHjpImWMx95h0s2t72BZOvauptQJcS0S6EDDdoKdovmYOLghXh9/hQWH2Xc4mFClcb2vY2KbaE0xOLWlRBDdJqavs8L+M3OPQLdZNJ/2831YywLusFdCtoJ1HQfrYtjtEDNQwnbYSfZ70r2rLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791286116; c=relaxed/simple;
	bh=xG5n+FmLcKN/MpfraMVvmbU0gWh/3p5s7DE+Lce4IEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6gO/oXziQZaBRHPi7YS0k8gB6g3v7gvvtyar0uoXSSEayGCHzoAvMGZt/zOrv3kGw8oJZ2rfHT18Y6Ie/4JVos/FoV8Kxc0vah0GuNrZAs49SOPrtHFoVBM5PIUn4cv02p+by9JJKIrTmRj/9lI/imHX4yP5dDech8WTA6L5uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vp+Z4YKI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vp+Z4YKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791286110;
	bh=wRYuuYJTzTNfmuADW3V3md6iIbJFNoJpX7CFlzl6Ajw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vp+Z4YKIwYbZLs9DVGYUBHaJpU8DFBB1i63Zg9gUwDlLMf+IGMIzCpAUbkNRYpfZp
	 rFrJU48/rxwNFnBa3cPCFK9a3tNmv39V6/1X+DtmvOU/wJoBaA1WD1fOiAl9sGObQU
	 +SqnN84n/YjtnJRLT14F5iIuLDD7uwN1dzbdLTXOrvQcL6+a071ZSTZKMnQm0cN5mX
	 G24ROG7rhJbiO0ff3mP9ec8K2Z5UE6VQw4fRqiMPQyli5EcJ0jWN7If71YuG7E0q+A
	 a62jUTKcAg+UljsMqztkSAveemC/tgv2fwoo+YKUeTwshJhZsaCr58iWCHUVo6i5bJ
	 EBbifKzyLIKPg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3557260057;
	Tue,  6 Oct 2026 13:28:30 +0200 (CEST)
Date: Tue, 6 Oct 2026 13:28:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Martino Dell'Ambrogio <tillo@tillo.ch>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: hardware flows are left behind when a flowtable is deleted
 (nf_tables unbinds the offload block at commit time)
Message-ID: <asTbWsJFJjPMlSud@chamomile>
References: <20261005134810.312747-1-tillo@tillo.ch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261005134810.312747-1-tillo@tillo.ch>

Hi,

On Mon, Oct 05, 2026 at 01:48:10PM +0200, Martino Dell'Ambrogio wrote:
> Deleting a flowtable leaves the flows its devices offloaded behind in the
> hardware. Reported against stable v6.12.108 on a Banana Pi R4 (MT7988,
> mtk_eth_soc PPE) running OpenWrt, and reproduced there; the analysis below is
> from that source and from net.git main, where the function is identical.

I have restored my Pi R64 testbed with OpenWrt.

Let me reproduce this issue and review all pending fixes for -stable
kernels too for the flowtable hardware offload.

I will get back to you with updates, thanks for reporting.

> Symptom
> 
> After the flowtable is deleted, the offloaded flows stay BND in the PPE and
> keep forwarding. Their conntrack entries are not released either: they stop
> being refreshed and expire (60 s for UDP), after which the device is
> forwarding flows that exist in hardware only and that conntrack no longer
> knows about. On the router this is visible as entries in
> /sys/kernel/debug/ppe{1,2}/bind with no matching entry in `conntrack -L`.
> 
> OpenWrt's fw4 deletes and recreates its flowtable in one transaction on every
> firewall reload, so this happens on every reload rather than in some rare
> teardown path.
> 
> Why
> 
>   - Deleting a flowtable moves FLOW_BLOCK_UNBIND to commit time.
>     __nft_unregister_flowtable_net_hooks() asks the driver to unbind, and
>     nf_flow_table_block_setup() frees the driver callback there.
>   - The flowtable itself is freed later, from the transaction destroy work
>     after synchronize_rcu(): nft_commit_release() ->
>     nf_tables_flowtable_destroy() -> type->free() -> nf_flow_table_free().
>     That last step tears the remaining flows down and queues
>     FLOW_CLS_DESTROY for each one.
>   - nf_flow_offload_tuple() delivers those commands by walking
>     flowtable->flow_block.cb_list, which has been empty since the commit. It
>     reports no error for an empty list, so nothing notices.
> 
> This is not a race between the last GC run and the unbind: the unbind always
> happens first, at commit time, so the hardware entries are never removed.
> 
> It is a regression from 13210fc63f35 ("netfilter: nf_tables: imbalance in
> flowtable binding"). That commit removed the late FLOW_BLOCK_UNBIND from the
> flowtable destroy path, which 5acab91458ce ("netfilter: nf_tables: unbind
> callbacks from flowtable destroy path") had placed after
> nf_flow_table_free() on purpose:
> 
>     Callback unbinding needs to be done after nf_flow_table_free(),
>     otherwise entries are not removed from the hardware.
> 
> 13210fc63f35's thread only checked BIND/UNBIND balance; nothing there is
> about hardware entries left behind. It is in 6.12.y as 2e87c203b72f.
> 
> All of the above is read from the sources rather than instrumented at run
> time: nothing here traces cb_list directly. What the reproducer below shows
> is the consequence, and that part is measured.
> 
> Reproducer (~2 minutes, one host)
> 
>   1. Drive a busy UDP flow (~100 pps) through the flowtable so it binds in
>      hardware: confirm a BND entry in /sys/kernel/debug/ppe*/bind and
>      [HW_OFFLOAD] in `conntrack -L`.
>   2. Delete the flowtable (on OpenWrt: `fw4 reload`, which deletes and
>      recreates it).
>   3. Keep the same socket sending, at a low rate, for longer than the
>      conntrack timeout. The window has to exceed it: a stranded flow still has
>      a conntrack entry until that expires, so a shorter window shows nothing.
> 
>   Unpatched: the tuple stays BND and keeps forwarding while conntrack has no
>   entry for it any more.
>   The discriminator has to be per tuple -- bound in hardware AND absent from
>   conntrack. An aggregate "no conntrack entries left" test never fires, because
>   other hosts on the LAN are talking to the same destination.
> 
> Scope
> 
> Drivers that offload through TC_SETUP_FT and rely on FLOW_CLS_DESTROY to
> release hardware state look affected by inspection: mtk_eth_soc (measured),
> mtk_wed, airoha, mt76 npu, mlx5 representor FT. Drivers that flush their own
> entries when they remove their callback (mlx5 tc_ct, nfp, sfc) are not. Only
> mtk_eth_soc was tested.
> 
> A possible fix, and what I measured
> 
> Remove the flows using the device before the block is unbound:
> nf_flow_table_offload_setup() on FLOW_BLOCK_UNBIND could call
> nf_flow_table_gc_cleanup(flowtable, dev) first, so the FLOW_CLS_DESTROY is
> delivered while the callback is still on cb_list. That is what the kernel
> already does for indirect devices (nf_flow_table_indr_cleanup()) and on
> NETDEV_DOWN, and one site covers the commit, update, netdev-event and abort
> paths. I am aware that "generalize pending status bit" reworks this area.
> 
> I have not sent a patch, but I have built that change and run it on the
> hardware: two images differing by that one hunk and nothing else, the same
> reproducer on each.
> 
>   - Unmodified kernel: the reproducer strands the flows. All 4 flows stay
>     bound in the PPE, in 26 of 26 samples taken after the reload -- first
>     sustained 22.7 s in and still true at 167 s, past both the 20 s and the
>     60 s UDP timeouts.
>   - With the change: no flow is left bound with no conntrack entry behind
>     it -- 0 of 4, clean in all 25 samples, and the flows re-bind under the
>     new flowtable.
> 
> An orphan check on the patched image (every bound entry cross-referenced
> against conntrack, with a synthetic control entry injected to show the check
> can fire) found none at +10 minutes or +1 hour. The change is carried as a
> downstream patch in OpenWrt.
> 
>   - Martino Dell'Ambrogio <tillo@tillo.ch>
> 
> Assisted-by: LLM
> 
