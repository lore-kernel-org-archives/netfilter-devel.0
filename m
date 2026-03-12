Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026BC387347;
	Thu, 12 Mar 2026 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355362; cv=none; b=JlqGGE9TG2i1K7Ryk4Qrog6pFv50mthFd4qUJDBqAWxNC2TTrVsC7u842otI1rShp8TCXMG6hLSDhUxwntqQUO6APhlX0hQfSSSW3K7Hpg1rLOsxyRg39TcvuaNOa9hbRwtT01G5T2fGbp+o6mgUYoLmJrGnra1kqtZdMEZlELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355362; c=relaxed/simple;
	bh=AnJagQrTLnBNlmaDDh5sry0hmrqIAgeRC5Do35XCdcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXh63G0VUKfYe/77PCmpou9HgxZzI3hjHmN4ybXiO6WLAjd3GjNCuV6THDr439r6IoET53oA5JoX3n1XsrAdG2iL0ATRfou/gC1j+QqyghS2yXKCY3VNW4/UDYHm/Kj8uPlPLxJBYDS30Jf9cFzDRIbB3ZkHPUg+D44w4Ht2aMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sJVQXf86; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sJVQXf86"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 218AF60278;
	Thu, 12 Mar 2026 23:42:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773355359;
	bh=Dm6Zx3wtYWTGilXG/dW4Y9m4SwWvkRH5uWCQU1sVNoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sJVQXf86D/3OYkyMOgrXcxGd+3zAHdlq6yEkMJ6DGgGiysr3Emw11MRRlYY2VgJeq
	 Bj28sSh3wEt9E/z2ZvZE7XqfFqssF0i1Cz0L0lpNwWgyoIb+YVGFfz+W6fTJUc2qNN
	 muTLXiBJ2lybLvEr0GhnG8czPwBdtte3ILPVDNXOwZDGyV2iBygX+1F9qDW5RXvUSU
	 njXumO3ooaJkD+/9ibnVhXF8owtlugK/A/TFQUJoVMpwlbNYZww0FS0uDG2F3emeeW
	 aoEQx8XoO+VETt4v3ODh/Fg4v5DtWshL62S5+4p/2Oqnyxn9jZNlfc/FOyv38omAoj
	 twxmuGrsxJFwQ==
Date: Thu, 12 Mar 2026 23:42:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Prasanna Panchamukhi <panchamukhi@arista.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
Message-ID: <abNBXCgi4x5WLkBa@chamomile>
References: <20260311194058.13860-1-panchamukhi@arista.com>
 <abKzWIhVz_SeiSOa@strlen.de>
 <CACqWiXD2_O32K4NhmNBZrAUG7U9-N93LTFjJHG6Tq=4vuafNuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqWiXD2_O32K4NhmNBZrAUG7U9-N93LTFjJHG6Tq=4vuafNuA@mail.gmail.com>

Hi Prasanna,

On Thu, Mar 12, 2026 at 03:31:06PM -0700, Prasanna Panchamukhi wrote:
> On Thu, Mar 12, 2026 at 5:36 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Prasanna S Panchamukhi <panchamukhi@arista.com> wrote:
> > > The conntrack garbage collection worker uses an adaptive algorithm that
> > > adjusts the scan interval based on the average timeout of tracked
> > > entries.  The upper bound of this interval is hardcoded as
> > > GC_SCAN_INTERVAL_MAX (60 seconds).
> > >
> > > Expose the upper bound as a new sysctl,
> > > net.netfilter.nf_conntrack_gc_scan_interval_max, so it can be tuned at
> > > runtime without rebuilding the kernel.  The default remains 60 seconds
> > > to preserve existing behavior.  The sysctl is global and read-only in
> > > non-init network namespaces, consistent with nf_conntrack_max and
> > > nf_conntrack_buckets.
> >
> > This was proposed before, see:
> >
> > https://lore.kernel.org/netfilter-devel/aO-id5W6Tr7frdHN@strlen.de/
> > https://lore.kernel.org/netfilter-devel/aRsuU57juCvsMBKE@strlen.de/
> >
> > I did not hear back wrt. the horizon cache.
> >
> > I'm not 100% opposed to this, but I do wonder if we really can't do
> > better than the current avg strategy.
> 
> Hi Florian,
> 
> Our primary goal is to cap the maximum time taken by the GC to clean
> up expired entries. We rely on user-space notifications to clean up
> these entries from the hardware, so ensuring a predictable upper bound
> is important for our use case.

Is there any reason why you decide not to use instead the existing
hardware offload infrastructure for this purpose?
