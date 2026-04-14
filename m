Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFD620DE3;
	Tue, 14 Apr 2026 11:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165255; cv=none; b=F73oiXm30CFlLiTWSs/uCGl3SvfwKfsfxWCNLJJfe7pDyMnObjDEHO3oxGK+i9Qfd427dUbQ8JORtvz+FvnvjXYXLoriXHSPQxhGDhgyKlq88ncbeP9AwCvfOIQt6XQv/IbNzqn4Qmcrl0rE0N9qVPsp4ul1woPIZVGASD0wDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165255; c=relaxed/simple;
	bh=09uiMZRs7r7SYhGOfTyq/qJWTKsO/uLe3Dd56LS2Js4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4JfR/CtQII0adH0ULXIUO8fj9KR6TMpdUe//GDwDSdBbOAZmJtYjCreTTR1tQV8FVnkF9JbjhOEFDZmiJyVGoyX9b8xFMoRAntENea5uUehAR20jcv11G2biNfiFygQhDIsV3WOUn5rdm7grhobEUBG+mhIEnadQYGnyQN3MqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E1E2360490; Tue, 14 Apr 2026 13:14:11 +0200 (CEST)
Date: Tue, 14 Apr 2026 13:14:11 +0200
From: Florian Westphal <fw@strlen.de>
To: "Kito Xu (veritas501)" <hxzene@gmail.com>
Cc: pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, ffmancera@riseup.net, horms@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, phil@nwl.cc
Subject: Re: [PATCH v2] netfilter: nfnetlink_osf: fix null-ptr-deref in
 nf_osf_ttl
Message-ID: <ad4hg4Wm90sVb1OB@strlen.de>
References: <20260414074556.2512750-1-hxzene@gmail.com>
 <20260414104900.2617863-1-hxzene@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414104900.2617863-1-hxzene@gmail.com>

Kito Xu (veritas501) <hxzene@gmail.com> wrote:
> nf_osf_ttl() calls __in_dev_get_rcu(skb->dev) and passes the result
> to in_dev_for_each_ifa_rcu() without checking for NULL. When the
> receiving device has no IPv4 configuration (ip_ptr is NULL),
> __in_dev_get_rcu() returns NULL and in_dev_for_each_ifa_rcu()
> dereferences it unconditionally, causing a kernel crash.
> 
> This can happen when a packet arrives on a device that has had its
> IPv4 configuration removed (e.g., MTU set below IPV4_MIN_MTU causing
> inetdev_destroy) or on a device that was never assigned an IPv4
> address, while an xt_osf or nft_osf rule with TTL_LESS mode is
> active and the packet TTL exceeds the fingerprint TTL.
> 
> Add a NULL check for in_dev before using it. When in_dev is NULL,
> return 0 (no match) since source-address locality cannot be
> determined without IPv4 addresses on the device.
> 
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> RIP: 0010:nf_osf_match_one+0x204/0xa70
> Call Trace:
>  <IRQ>
>  nf_osf_match+0x2f8/0x780
>  xt_osf_match_packet+0x11c/0x1f0
>  ipt_do_table+0x7fe/0x12b0
>  nf_hook_slow+0xac/0x1e0
>  ip_rcv+0x123/0x370
>  __netif_receive_skb_one_core+0x166/0x1b0
>  process_backlog+0x197/0x590
>  __napi_poll+0xa1/0x540
>  net_rx_action+0x401/0xd80
>  handle_softirqs+0x19f/0x610
>  </IRQ>
> 
> Fixes: a218dc82f0b5 ("netfilter: nft_osf: Add ttl option support")
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Kito Xu (veritas501) <hxzene@gmail.com>

The other __in_dev_get_rcu() callers in netfilter check return value, so:

Reviewed-by: Florian Westphal <fw@strlen.de>
