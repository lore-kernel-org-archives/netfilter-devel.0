Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E13BFE52
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 07:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867728; cv=none; b=eev41bO/PMmhavksB3Z9qC+ov6ho1jGaV1aPev7gC1oEEr+AIXzGdqdVuMGIjL4rAHKZq0XGZ3Qk5s0Rjc+QztmBVN614zV0gaRuf4m2dayIs31hLWoSyfZvfC0DwLLh9RvVvZpoyQQp9xLdUpHEKxzDwKkKiJdcDmqb86Rs5/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867728; c=relaxed/simple;
	bh=N53eunr/8xkIomMQr8fC79ih0Wwn1NRV4PqIde6D5wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIpeWTZnVps2kCwB++vIxaxYnQTRLWahZa7fn3QGO8tTCKInODa3d6u9dC7ikhwNai04HJwdTtqeEqFXp1dNZ+sg8aCIWu+smn4tsRy5QCkdOUJdutwQdcGAWwy5FAD9XFfUw26Fjd8ZCkEEWBrsl3Jn7GEUEtvKxqxK3j3HB3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 208FE602AB; Wed, 27 May 2026 09:42:04 +0200 (CEST)
Date: Wed, 27 May 2026 09:42:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org,
	idosch@nvidia.com, stephen@networkplumber.org,
	sw@simonwunderlich.de, davem@davemloft.net, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf v2 1/1] bridge: br_netfilter: move fake rtable off
 struct net_bridge
Message-ID: <ahagS3rGl2sG0OVS@strlen.de>
References: <831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
> From: Haoze Xie <royenheart@gmail.com>
> 
> The bridge netfilter fake rtable currently lives inside struct
> net_bridge and is reattached to bridged packets with
> skb_dst_set_noref(). If such a packet is queued to NFQUEUE,
> __nf_queue() upgrades that fake dst with skb_dst_force().
> 
> At that point queued packets can hold a real dst reference even after
> bridge teardown starts freeing the backing struct net_bridge storage.
> When verdict reinjection later drops the skb, dst_release() can hit the
> freed bridge-private fake rtable.
> 
> Fix this by moving the fake rtable out of struct net_bridge and making
> bridge_parent_rtable() hand out a referenced dst. This keeps the queued
> skb path from holding a pointer into struct net_bridge while keeping the
> kludge local to br_netfilter.
> 
> Use rt_dst_alloc() so the fake dst reuses the core IPv4 rtable
> lifecycle, and release the bridge device reference during teardown via
> dst_dev_put() before dropping the bridge-owned dst reference.

I think AI review is mostly correct:
https://sashiko.dev/#/patchset/831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart%40gmail.com

- no need for constant refcount bump
- I don't think the ipv4 specific functions can be used safely here.
