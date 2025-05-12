Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6480825B666;
	Mon, 12 May 2025 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747042400; cv=none; b=UjYKw1shw3OeyxgefsZaE2G2JxyT3mrZIqV8ePzlbpIy5ALjgaxuxgpERUZxtlRDeZetAsvJEVwoIAJo+HTA+ct8jTktVQ9qHbo6Ai6lOPWMvXYIUPUwNnBMp32vr/elkpvItdtpQNPsBJtzkHPx3U3YSzX1W3GrWGDSFEkcrow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747042400; c=relaxed/simple;
	bh=M19xGDONn5VgKHmn0/EDMvQGS9t5Eg3pnc6Yra/cyx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2oOOqCTbHTttuPkhgmRYteUDLNIOwCX0SgHKCxLccZ1OYi4c31oxLesZjiK3Jlp38SzCrgYOiB/T9E72P3HQVqNpKP0TapnsE5vsQNxm71sxxfYbQbGZ92HxLXB5MbHAVlnDVOBdLSr2jj97dTi93THbQGG8obeNGmf2dtQXIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=luNasOy1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OEB60FWz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="luNasOy1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OEB60FWz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 74E5860277; Mon, 12 May 2025 11:33:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747042390;
	bh=m349sq8Swdk7znjJN0xDNc3cb1P/jVq2JLrl/2lX6Vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luNasOy1FXWHDdpuVTmPLgkmjSJp4bLI/YOatfb0E4jH4FqGtUySpCSFG85zw5et8
	 l5GBlBPFCzGK5JuyKZVwiSSavZxyd/goztB0KM6JmNe0i/aAhMCzEi0maNj2mMrCz8
	 msYSiINLcP6psE6dvuiCaQrbULOfjRaOnZnmg/Qd2kPMoUDuu7XNeTJYJR7MkDZkjh
	 pHv4cc/hERIhhZnh33g+aXm6D7VycQbYRZOsV+iROjepfoZ+Ejhe0mohLoV9x4iSy2
	 jcDZU8oPrEGnWfkdQyapi8Ngm9/F1nHQ9ood3kCR4HOQVMVIF/umM6PjeN8qGNvJ1L
	 /DWadqth6/F1A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8AD1660276;
	Mon, 12 May 2025 11:33:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747042385;
	bh=m349sq8Swdk7znjJN0xDNc3cb1P/jVq2JLrl/2lX6Vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEB60FWz4/aa8eXmlFuPyZUqfushGbITQ9ascBV/pNsaTzjv59qpckbWLzTwJnVOQ
	 hjGzGSTj5Bq4TJ3IjP0lB1TPRWbHkmgUV51NM32Ft1UANFtVIUKOocmG9APGb65fbM
	 YPh+U0tGU7pNpJoKr2Q/MCTsxcHDTeQauK6u9xUwIt0mG0zciz63BUkt1eY6TqnB/o
	 cf6LRh/vDE83MvupymKP8HeSyjHFopBUs9dMMunU/94FDQdQV+YVdWmT+i7T+VxnWP
	 iiVX9+BDt9MPIZIETjWYD4dcbx8zQTPe6ozmJ30MJ3F3miUv4f0evPTTLscNHRddTv
	 GSRn7sHQ92Uig==
Date: Mon, 12 May 2025 11:33:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: jianqi.ren.cn@windriver.com
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 6.1.y] netfilter: nf_tables: fix memleak in map from
 abort path
Message-ID: <aCHATgAjsQS2EMIx@calendula>
References: <20250512030252.3329782-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250512030252.3329782-1-jianqi.ren.cn@windriver.com>

Hi,

NACK.

This patch requires:

  e79b47a8615d ("netfilter: nf_tables: restore set elements when delete set fails")

which you have skipped for some reason.

On Mon, May 12, 2025 at 11:02:52AM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 86a1471d7cde792941109b93b558b5dc078b9ee9 ]
> 
> The delete set command does not rely on the transaction object for
> element removal, therefore, a combination of delete element + delete set
> from the abort path could result in restoring twice the refcount of the
> mapping.
> 
> Check for inactive element in the next generation for the delete element
> command in the abort path, skip restoring state if next generation bit
> has been already cleared. This is similar to the activate logic using
> the set walk iterator.
> 
> [ 6170.286929] ------------[ cut here ]------------
> [ 6170.286939] WARNING: CPU: 6 PID: 790302 at net/netfilter/nf_tables_api.c:2086 nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
> [ 6170.287071] Modules linked in: [...]
> [ 6170.287633] CPU: 6 PID: 790302 Comm: kworker/6:2 Not tainted 6.9.0-rc3+ #365
> [ 6170.287768] RIP: 0010:nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
> [ 6170.287886] Code: df 48 8d 7d 58 e8 69 2e 3b df 48 8b 7d 58 e8 80 1b 37 df 48 8d 7d 68 e8 57 2e 3b df 48 8b 7d 68 e8 6e 1b 37 df 48 89 ef eb c4 <0f> 0b 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 0f
> [ 6170.287895] RSP: 0018:ffff888134b8fd08 EFLAGS: 00010202
> [ 6170.287904] RAX: 0000000000000001 RBX: ffff888125bffb28 RCX: dffffc0000000000
> [ 6170.287912] RDX: 0000000000000003 RSI: ffffffffa20298ab RDI: ffff88811ebe4750
> [ 6170.287919] RBP: ffff88811ebe4700 R08: ffff88838e812650 R09: fffffbfff0623a55
> [ 6170.287926] R10: ffffffff8311d2af R11: 0000000000000001 R12: ffff888125bffb10
> [ 6170.287933] R13: ffff888125bffb10 R14: dead000000000122 R15: dead000000000100
> [ 6170.287940] FS:  0000000000000000(0000) GS:ffff888390b00000(0000) knlGS:0000000000000000
> [ 6170.287948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6170.287955] CR2: 00007fd31fc00710 CR3: 0000000133f60004 CR4: 00000000001706f0
> [ 6170.287962] Call Trace:
> [ 6170.287967]  <TASK>
> [ 6170.287973]  ? __warn+0x9f/0x1a0
> [ 6170.287986]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
> [ 6170.288092]  ? report_bug+0x1b1/0x1e0
> [ 6170.287986]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
> [ 6170.288092]  ? report_bug+0x1b1/0x1e0
> [ 6170.288104]  ? handle_bug+0x3c/0x70
> [ 6170.288112]  ? exc_invalid_op+0x17/0x40
> [ 6170.288120]  ? asm_exc_invalid_op+0x1a/0x20
> [ 6170.288132]  ? nf_tables_chain_destroy+0x2b/0x220 [nf_tables]
> [ 6170.288243]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
> [ 6170.288366]  ? nf_tables_chain_destroy+0x2b/0x220 [nf_tables]
> [ 6170.288483]  nf_tables_trans_destroy_work+0x588/0x590 [nf_tables]
> 
> Fixes: 591054469b3e ("netfilter: nf_tables: revisit chain/object refcounting from elements")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [fixed conflicts due to missing commits
>  0e1ea651c9717ddcd8e0648d8468477a31867b0a ("netfilter: nf_tables: shrink
>  memory consumption of set elements") and
>  9dad402b89e81a0516bad5e0ac009b7a0a80898f ("netfilter: nf_tables: expose
>  opaque set element as struct nft_elem_priv") so we pass the correct types
>  and values to nft_setelem_active_next() + nft_set_elem_ext()]
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> Verified the build test
> ---
>  net/netfilter/nf_tables_api.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 656c4fb76773..1d4d77d21d61 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6772,6 +6772,16 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
>  	}
>  }
>  
> +static int nft_setelem_active_next(const struct net *net,
> +				   const struct nft_set *set,
> +				   struct nft_set_elem *elem)
> +{
> +	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
> +	u8 genmask = nft_genmask_next(net);
> +
> +	return nft_set_elem_active(ext, genmask);
> +}
> +
>  static void nft_setelem_data_activate(const struct net *net,
>  				      const struct nft_set *set,
>  				      struct nft_set_elem *elem)
> @@ -10115,8 +10125,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  		case NFT_MSG_DELSETELEM:
>  			te = (struct nft_trans_elem *)trans->data;
>  
> -			nft_setelem_data_activate(net, te->set, &te->elem);
> -			nft_setelem_activate(net, te->set, &te->elem);
> +			if (!nft_setelem_active_next(net, te->set, &te->elem)) {
> +				nft_setelem_data_activate(net, te->set, &te->elem);
> +				nft_setelem_activate(net, te->set, &te->elem);
> +			}
>  			if (!nft_setelem_is_catchall(te->set, &te->elem))
>  				te->set->ndeact--;
>  
> -- 
> 2.34.1
> 
