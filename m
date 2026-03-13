Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D7840DFD5;
	Fri, 13 Mar 2026 09:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393335; cv=none; b=W4pWTOLr6xmtvyyGPc83wWmnjUyQcG8UtIrtHxKRiWES97Xudf91+jChmWJJkPds5UgKIdM5X22Mgbj2yU2L/lpZsosOpDecNWcigPRTRZmkY381kv84/aOg0//8OC7NKNkdNWJsCojDNYQUttYlWBROlDixyV1dfwOX4iyqGS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393335; c=relaxed/simple;
	bh=9MRt/Y7RcStLkBJ6M+pZazZqfMDOw1FtgoPEAfrEudI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hvrudl+rpbm2wXn4NTA8Zae8ncHCSZB1YFbRSP6GMpnMRy4hO1MsrlmPPsvWK80Um79VLnStYl/Pq1ePqnf7vTP1DmxObdGqA7ZgERylY+Q5/iLFKJsuioS4Sh8W8OjJG7I0Gr8i1Qjc+tZ2qZODm/FROZvC5kmKlrsxuOpAr10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jQ+TrQH2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jQ+TrQH2"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8C7066017D;
	Fri, 13 Mar 2026 10:15:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773393330;
	bh=yQapFJqhKntzIPlVM1NNvpzDIt8QDz9Eji9CDIS6gMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jQ+TrQH2MuFf2d+qdP0ef24sn+cL2bmu5KY6wu613GeBQdKSJ4M3M15A4TMsAis7b
	 brpfaCfqvVbhp5Ka1Zb/f0SyMMNe3RtiDmP8bpegd3JIqjgwfTFSosrwRBJMGtJEEn
	 a4rheANZNIATNC9Jz6w2OIdOLK4PNMlzHEC9mR9Ex2qItzczteiT2ymxB0HRwqlS0k
	 uZ77KIdS4kDyK0PKNvwlYV3z+HyX7EV+Mr++HmHtpPnbBI5tUvR7L7kYUnxXpyBD8V
	 KK96EJTBJKhAe4RIPyXxvDh1Iar0pIV/xRJ30HWaZ0qEprlTN+JntSRobVF5NPhDjI
	 tydtOfRpO8QnA==
Date: Fri, 13 Mar 2026 10:15:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Prasanna S Panchamukhi <panchamukhi@arista.com>,
	netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next v2] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
Message-ID: <abPVr5RtRmZeyszb@chamomile>
References: <20260312223157.25083-1-panchamukhi@arista.com>
 <abNxz9T_XB-JtBCj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abNxz9T_XB-JtBCj@strlen.de>

On Fri, Mar 13, 2026 at 03:09:19AM +0100, Florian Westphal wrote:
> Prasanna S Panchamukhi <panchamukhi@arista.com> wrote:
> > The conntrack garbage collection worker uses an adaptive algorithm that
> > adjusts the scan interval based on the average timeout of tracked
> > entries.  The upper bound of this interval is hardcoded as
> > GC_SCAN_INTERVAL_MAX (60 seconds).
> 
> I already said that I'm not keen on this approach.
> Its a 'we can't do any better' type "solution".
>
> If anything I'd be more inclined to make a change that allows to
> more easily override the next_run computation via bpf.

It is regrettable that the request for this knob appears to be
intended to enable a potentially proprietary hardware offload
extension, implemented through a userspace daemon and a proprietary
SDK.

It's 2026, there is plenty of infrastructure to offload the connection
tracking upstream, such as act_ct.c and the flowtable.
