Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367E42D9ECF
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682207; cv=none; b=q//9HmLZi6ERJPMmUm5LxMk1jYy/Lsf4fKX2hXBicriKcicj2frFt0ayTeX5OJgiDy1yLL/vut9At3f4qQ/dJDYK6JYNOCsXlB1aZ0+eQ49+XIjRhG/iOj8ScBuENsxXl12jskBbP3F7+6sqRSxfdaER9pEpZzBEsrGYVbUmdyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682207; c=relaxed/simple;
	bh=SRLNwWKaDWnbIztnciAgtEPisEBR7Ob09DzmHmWCuGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sE5qryoFmbTIJ47gQYVudhtx8n52jfQVlq4DE43rlZIc3PQFBfoTuKJ7taTeWslIDrtFP71KYBa7DtpUWwqqEGxpICBV58I+UFgwsPXzqd+UJEDQM7Mk4so4W7s7ZvwhjOBLEf1P1JFa6fszn97z4cQ0ilPmxB8Kj6R5P1clJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VLOFB2r4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VLOFB2r4"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 933BE60272;
	Fri, 21 Nov 2025 00:43:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763682200;
	bh=x6JgzW7NGKh3ig7wCbDl4tU/3bIrsLyngvYtWrC3ebM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VLOFB2r4+SqZXWW/mR2D0HukYOFq0j3nhvPI+IZO9f8svpUUS2aq2yly4Bu2fShjQ
	 pCHOgMgAX9xYdsNcKQhBXrTPbj6XILdd392K1AWiBBg4a3La3QfpF2tQvSzum++Dfx
	 AvkNWJnk1+ZLoy5XP/nRf+XVaPkPc2VxqTUEb+rCx5MArYRPScbN3b+Ywuj5tjhxCC
	 JIAW//ysns26H02jVMUHF05ave6CClaj+J3pE3mNg5/MD+61vARQZNZqM9889evO3z
	 F4kKD6jmX2S4gWdm+h033t6e65/BKCVmnizYrSyf43cswFCfdJyDYJiu1F7p+HKNZZ
	 NP6qN0SXGSPDg==
Date: Fri, 21 Nov 2025 00:43:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, aconole@redhat.com, echaudro@redhat.com,
	i.maximets@ovn.org
Subject: Re: [PATCH 0/6 nf-next v3] netfilter: rework conncount API to
 receive sk_buff directly
Message-ID: <aR-nlkm8RrHZsCbP@calendula>
References: <20251112114351.3273-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251112114351.3273-2-fmancera@suse.de>

Hi Fernando,

On Wed, Nov 12, 2025 at 12:43:46PM +0100, Fernando Fernandez Mancera wrote:
> This series is fixing two different problems. The first issue is related
> to duplicated entries when used for non-confirmed connections in
> nft_connlimit and xt_connlimit. Now, nf_conncount_add() checks whether
> the connection is confirmed or not. If the connection is confirmed,
> skip the add.
> 
> In order to do that, nf_conncount_count_skb() and nf_conncount_add_skb()
> API has been introduced. They allow the user to pass the sk_buff
> directly. The old API has been removed.
> 
> The second issue this series is fixing is related to
> nft_connlimit/xt_connlimit not updating the list of connection for
> confirmed connections breaking softlimiting use-cases like limiting the
> bandwidth when too many connections are open.
> 
> This has been tested with nftables and iptables both in filter and raw
> priorities. I have stressed the system up to 2000 connections.
> 
> CC'ing openvswitch maintainers as this change on the API required me to
> touch their code. I am not very familiar with the internals of
> openvswitch but I believe this should be fine. If you could provide some
> testing from openvswitch side it would be really helpful.
> 
> Fernando Fernandez Mancera (6):
>   netfilter: nf_conncount: introduce new nf_conncount_count_skb() API
>   netfilter: xt_connlimit: use nf_conncount_count_skb() directly
>   openvswitch: use nf_conncount_count_skb() directly
>   netfilter: nf_conncount: pass the sk_buff down to __nf_conncount_add()

I have collapsed this four patches initial patches (1-4) to see how it
looks:

 include/net/netfilter/nf_conntrack_count.h |   17 ++++-----
 net/netfilter/nf_conncount.c               |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 net/netfilter/nft_connlimit.c              |   21 +----------
 net/netfilter/xt_connlimit.c               |   14 +------
 net/openvswitch/conntrack.c                |   16 ++++----
 5 files changed, 133 insertions(+), 94 deletions(-)

It is a bit large, but I find it easier to understand the goal,
because this patch is pushing down the skb into the conncount core and
adapting callers at the same time, which is what Florian suggested.

Then, another patch to add the special -EINVAL case for already
confirmed conntracks that is in patch 6/6 in this series. This is to
deal with the new use-case of using ct count really for counting, not
just for limiting.

Finally, the gc consolidation.

I pushed it to this branch in nf-next.git,

        https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/log/?h=tentative-conncount-series

NOTE: commit messages would need an adjustment.

Sidenote: Not related, but connlimit does not work for bridge and
netdev families because of nft_pf(). This relates to another topic
that is being discussing about how to handle vlan/pppoe packets.
**No need to address this series**, just mentioning it.
