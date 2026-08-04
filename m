Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF643935B;
	Tue,  4 Aug 2026 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785838836; cv=none; b=dQjR3p1j95BldUSwgggviVGySlfkhsiyB5ppsD4/aDJ18azc5Hk2xL53A+0zmfjXfGVtuNtWXBRqJKLy9xgLdjukjyheSQGd7cdL2lwz/8tIApawt7RITn7KRmqkLsPPkcilJIq5KS1GSpHI9Hsu8vvMrh76L4YSk0+ZsWaJleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785838836; c=relaxed/simple;
	bh=qa6RZ1CyeCfBfaNm+r3w4hE/a97zVC8NZciRwgZBTzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMHb5OcVKX5g6vHJASRm6p3vc8OP7Tp6NHrUDFzUYL0xhBB5couUJNixNS37VyqKiIJ9MCijRlpdDplh50uwjCcPCGDnByiDGgu/egECVijGFsOa9eH+OyDWEmq5F4YLWsK5e+uFwE2/T0WI/mCQahuH4BSvw8wJzDlBjG1XrVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LgCRu495; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LgCRu495"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5333D6017D;
	Tue,  4 Aug 2026 12:20:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785838824;
	bh=5u56dKw+cjm3xWH9v3afRoqaeTx8utJFZsCzCsAcqqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LgCRu495PI15zEm2stVvKETXciCdCvsGRnldwkfVwE3KbB9nTJTdzMzNPayE5sE5q
	 1uzLiGf+BxyOWa58brO1dP24jqRDWE0V4SeMexRVKCph/c2zuxi/evwiv8U/MCvs6U
	 lAYwYtGgg2vjHkzl9AhnmUpp60nUJImmZ/LhEvxWNATL6SfalMtGTTZReuCZUzhCMn
	 oljPCgRarEBAymRpDmK2s4mcZRLLINdzHVDyRfEo/uc2nXA0+byOeJLbQLvDLs/P2/
	 SGiimuQ6184ybk9hoBc3WbZF5V7/vYGeXmJDxaf65VOQXremi35igG5zMS0jjuXzJM
	 T3bCFu4+qwYdw==
Date: Tue, 4 Aug 2026 12:20:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com,
	syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Subject: Re: [PATCH net] netfilter: nf_flow_table: drop existing skb dst
 before skb_dst_set_noref()
Message-ID: <anG85QHJ8bjqmuXg@chamomile>
References: <20260804093328.1831847-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260804093328.1831847-1-edumazet@google.com>

On Tue, Aug 04, 2026 at 09:33:28AM +0000, Eric Dumazet wrote:
> Incoming skbs passing through netfilter flowtable offload hooks (or XFRM
> offload path) might already carry a ref-counted dst_entry assigned during
> earlier RX or routing steps.
> 
> Calling skb_dst_set_noref() when skb already holds a ref-counted dst
> overwrites skb->_skb_refdst, leaking the previous dst_entry reference
> count and triggering a DEBUG_NET_WARN_ON_ONCE assertion in
> skb_dst_check_unset():
> 
>   WARNING: at skb_dst_check_unset include/linux/skbuff.h:1170
>   WARNING: at skb_dst_set_noref include/linux/skbuff.h:1234
>   WARNING: at nf_flow_offload_ip_hook+0xf6c/0x2b60 net/netfilter/nf_flow_table_ip.c:864
> 
> Drop any existing dst_entry reference with skb_dst_drop(skb) before
> setting the non-referenced flowtable destination.
> 
> Fixes: 2a79fd3908ac ("netfilter: nf_flow_table: attach dst to skbs")
> Reported-by: syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/netdev/6a71b141.9511d2ce.1fc5b9.033b.GAE@google.com/T/#u
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
