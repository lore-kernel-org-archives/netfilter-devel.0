Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E30A212554;
	Wed, 13 Aug 2025 10:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755079306; cv=none; b=c4omN1ixtjR1ETivkNWu1kmRHq1pX2hsKe6lenqblkjb49OFvJD/zu0cg9CIJ0S3NAe+v0LSOgkk+vRIx21swpC1T7SsISphOZ9K3muqGtUA4D+GM1DeACzYOt/FnfHFxo7Ke5PqU0BNSA1wtO+GdrW5YmSjJ9utzlkahnW5Gyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755079306; c=relaxed/simple;
	bh=GxaKAI7BYKuo3rINvK6Gs+xNPXBkQTSmTM5vlA3ySws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0/ohylvC8oBK5EkAramXwm5kEjpEqAFeZ/RJ7W+9Pe6foYxGgtGIroH0Dh5LvXL/HB7pX+k9BPLem5Nrfbnyhi+S6lLS3OTJ9oGNY8teycgZlbT1ISg9T3WpCXTXqlh93hnMPZPSiT3I9FnLMHl1NjsNoQz27d4PyJEvIOcLog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4CBFD605F7; Wed, 13 Aug 2025 12:01:42 +0200 (CEST)
Date: Wed, 13 Aug 2025 12:01:41 +0200
From: Florian Westphal <fw@strlen.de>
To: syzbot ci <syzbot+ci1b726090b21fedf1@syzkaller.appspotmail.com>
Cc: abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com,
	coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev, mhal@rbox.co, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org, sdf@fomichev.me, steffen.klassert@secunet.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: Convert to skb_dst_reset and skb_dst_restore
Message-ID: <aJxihWEdn5cVlP6z@strlen.de>
References: <20250812155245.507012-1-sdf@fomichev.me>
 <689c457b.a70a0220.7865.0049.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689c457b.a70a0220.7865.0049.GAE@google.com>

syzbot ci <syzbot+ci1b726090b21fedf1@syzkaller.appspotmail.com> wrote:
> syzbot ci has tested the following series
> 
> [v1] net: Convert to skb_dst_reset and skb_dst_restore
> https://lore.kernel.org/all/20250812155245.507012-1-sdf@fomichev.me
> * [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
> * [PATCH net-next 2/7] xfrm: Switch to skb_dst_reset to clear dst_entry
> * [PATCH net-next 3/7] netfilter: Switch to skb_dst_reset to clear dst_entry
> * [PATCH net-next 4/7] net: Switch to skb_dst_reset/skb_dst_restore for ip_route_input callers
> * [PATCH net-next 5/7] staging: octeon: Convert to skb_dst_drop
> * [PATCH net-next 6/7] chtls: Convert to skb_dst_reset
> * [PATCH net-next 7/7] net: Add skb_dst_check_unset
> 
> and found the following issue:
> WARNING in nf_reject_fill_skb_dst

Looks like a bug uncovered by this series.

I'll have a look.
