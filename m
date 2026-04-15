Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E944B3BD64D;
	Wed, 15 Apr 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776272091; cv=none; b=SZTj4uM1wngWwihA75P9AsZqQdTzT+DHnnVAy8Mh9fR3h0wvssWo5+VtC9d7x6PNqftMpVs3NfXuwwRJIDuCulJZ5tUiBGJGn7IDRm1wHdJ/OfIWl8OMqUFPkTDIV0dB6+aIztIDiE/Wio8y/NGvXFFh9RzhTflIGUOsBlhhhbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776272091; c=relaxed/simple;
	bh=6DNTZ0ERM+6asbMeGGsrZ6aDsAY5gnasAF9NXF3KX/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9N30p79KGHe+wCpzCw9Urbm1kE2FowSixPw1TaYIosJv4Guw9Tk+DZJRn6O5q8Sere3jW62caOVF+ZZj13f1Y5z1RfLP/0JLKsChquiBgut/+aBiHSJyHGqWCOLubRf1vFt+FlEf7n1z4TWNY/WOfiZ4x/E6zZUGWtBHkLPygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=USudHZsI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="USudHZsI"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C119E60177;
	Wed, 15 Apr 2026 18:54:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776272087;
	bh=wI1AsDb3z2P6i589haHLZlIIadhnDuo0oWVn9mLJshA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=USudHZsIvGmL8Zp3SEelOosguhygRWXOemwMzscPov6DdONVtsBsjeY3c77AQylZ8
	 KfsyxDDwi0zzTBU+3Jm1P5WKV37IzyT0c+PbxsjM6F02Jgc8LR1+3GWVmOAHNXffY4
	 a8WhGFvPLXh8A3J++H3zCxZrwYUk7yAF9N1Is3ood5khhdsMYzgGCJBSPWy6aOjOUB
	 0qJoCk9c7NgIM/dFOc3y0NngnkHRSGXPH9VbuNJ5+m2bJSmArSLQovJPfXTt1CCENw
	 WyiMIWNoeRHbf7XIMv8o9wLxVGZ3kIFaJrNihkGUvCY8XBLuQeneDLzCOhRHhA7noZ
	 lxdCi1/eg0cig==
Date: Wed, 15 Apr 2026 18:54:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nf_tables: use RCU-safe list primitives
 for basechain hook list
Message-ID: <ad_C1f2cW5-kctHi@chamomile>
References: <20260410101321.915190-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260410101321.915190-2-bestswngs@gmail.com>

On Fri, Apr 10, 2026 at 06:13:22PM +0800, Weiming Shi wrote:
> NFT_MSG_GETCHAIN runs as an NFNL_CB_RCU callback, so chain dumps
> traverse basechain->hook_list under rcu_read_lock() without holding
> commit_mutex. Meanwhile, nft_delchain_hook() mutates that same live
> hook_list with plain list_move() and list_splice(), and the commit/abort
> paths splice hooks back with plain list_splice(). None of these are
> RCU-safe list operations.
> 
> A concurrent GETCHAIN dump can observe partially updated list pointers,
> follow them into stack-local or transaction-private list heads, and
> crash when container_of() produces a bogus struct nft_hook pointer.

For the record, v1 of proposed series to fix this is here:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=499757
