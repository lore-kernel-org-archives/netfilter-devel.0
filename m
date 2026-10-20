Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484607;
	b=BZTZlRDWJ6VGP7iE+PdtOZ9vUAnAUd8Pjw4zbYcLVNNfT/izOpqp8iEusblSyaYkJiWW
	 i2fyald//nRFKzXScJuTy78HNSZTLQ9K3RZqpWDNyT8N0fgHWxT5iDZH/k9YsXrEyLMs3
	 GcOKJKGV2H+HHJINih453UoNWYXj/aw4AcgXa9BWfRMX8aVs/aLYfgQc0WxZuRPOU8/45
	 eteucf2KVnbnuXe/LxDEnD2CHJMVvHjFr0VR8nPyKtwNJJUfuffD9tJtsK+yW5R++pVRN
	 j7nStACfre88k/i+EwJLpz/8ckqCoh38J1aLMevOEHGC8M9PAbRl0XrE/gPaBf4jvrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484607;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=c8b9XjfdKOQjyStjm92ZuKkGIRSFabLgQBgcYtuQkFQ=;
	b=AItPpFzRq+MygGkv4hk2jy93JiQbauyQP3Be8we6Klz8xmm6FTTJfqas/zBOJRksvRe8
	 mzSpAyLCCpd4pOsC/s0psbKmGqw3ZeNlceTpTSrYB8DLLAIt/SJrxDEt/9Ua3SkSy28Lf
	 zAPahNkhkzpFoPsSTbOkhqHXp1mJ2x0sKDB1GcGgjvCl+UsmfHFcOY+LWBzYDzs5q9cD8
	 5JK/RjPx3inbfycIi8aGh/TQNV6F/c6/wyRUb6Ew/kGect/u9VS8BzaljgaGz4pZHgltt
	 G7W2Rd+XK3kB4onZ5V+fEkySIrIrKkZez6f/VT9IeT/gC/hKsYT3e+E7PwwySyC/jjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=lagFGVlb;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E98FC606A31B;
	Tue, 20 Oct 2026 08:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E98FC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=lagFGVlb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792484603;
	bh=c8b9XjfdKOQjyStjm92ZuKkGIRSFabLgQBgcYtuQkFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lagFGVlbecSfkqNHV7xGW7o5dHNBXRP3s/pexhLgj3U0OaPplUGA17J6QLlPWhlfs
	 n81RxixYjZUeMhs5AbRyHQlHHoGlk+WPOoMZxKQ31UjAaLMG25/pte3je6OvHtYFMk
	 h04k4Wqr8mU6HVMTDJKd+nW+TecRkBKMWunlRbRioLyLFDGGq4oAm1/osfxK2uDDBf
	 0ZnDrMlXcxptKj58zBDzTkGjh3UokarQsDpoDhEqPax7KbJvdZ+yIGd7KFp1NZoBcm
	 xMGRZb063xHjA+5ltNt4PrLbXLvTLjOT2Wd22Te67YZnPz8uvUoKwF+ypJbe64zNQk
	 BiNfrSRpLUkMg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 66F7360056;
	Tue, 20 Oct 2026 10:23:23 +0200 (CEST)
Date: Tue, 20 Oct 2026 10:23:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] netfilter: bridge: refragment packets with a vlan
 tag moved by the bridge
Message-ID: <atck-NoWvemxIsF6@chamomile>
References: <20261020000308.37362-1-laveeshb@laveeshbansal.com>
 <20261020005403.38212-1-laveeshb@laveeshbansal.com>
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
In-Reply-To: <20261020005403.38212-1-laveeshb@laveeshbansal.com>

On Mon, Oct 19, 2026 at 05:54:03PM -0700, Laveesh Bansal wrote:
> With vlan_filtering enabled, br_allowed_ingress() moves the vlan tag back
> into the packet when its protocol differs from the bridge's vlan_protocol,
> an 802.1Q tag on an 802.1ad bridge for instance, and sets skb->protocol to
> the vlan ethertype. That happens after the NF_BR_PRE_ROUTING hooks.
> 
> Bridge conntrack has already defragmented the packet by then, based on the
> original protocol. In postrouting nf_ct_bridge_refrag() finds a vlan
> ethertype it cannot fragment, warns and drops the packet:
> 
>  WARNING: net/bridge/netfilter/nf_conntrack_bridge.c:361 at nf_ct_bridge_post
>  Call trace:
>   nf_ct_bridge_post
>   nf_hook_slow
>   br_forward_finish
>   __br_forward
>   deliver_clone
>   br_flood
>   br_handle_frame_finish
>   br_handle_frame
> 
> The warning is the smaller problem. Every fragmented IPv4 or IPv6 packet
> that crosses such a bridge is dropped while unfragmented traffic is fine,
> so it looks like an MTU issue. And anyone who can send fragments into a
> port of such a bridge can trigger the warning, which takes the machine
> down with panic_on_warn.
> 
> Look past the vlan tag in nf_ct_bridge_refrag(): remember it, pull it,
> fragment as before and push it back onto each fragment in
> nf_ct_bridge_frag_restore(), together with the outer protocol, so that
> br_dev_queue_push_xmit() sees the fragments like any other tagged frame.
> The protocol behind the tag comes from the packet, so check it against the
> header before fragmenting.
> 
> Removing the WARN_ON_ONCE() would only hide the problem, the packets would
> still be dropped. Not tracking these frames in nf_ct_bridge_pre() instead
> would change what is tracked today for unfragmented traffic, and would have
> to duplicate the decision that br_allowed_ingress() makes later.

Yes, but let's just fix this by turning this into a
DEBUG_NET_WARN_ON_ONCE(1) and let the packet be dropped.

Then, we can follow up to fill the gap for this feature in in nf-next.
