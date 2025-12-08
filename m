Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63A63A1CD;
	Mon,  8 Dec 2025 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765205302; cv=none; b=ULTboHWRtZZGp4/V3KBHWs8JBTVkMOs3OHrSCGcpZcimDdgnmrcMyaJR2ADS0ry9Mu/RnhG1h/O+hjalFq/6oww4S+7lAjPHdRTLXmusWQUFvljbUToIXxvkQ7W5dV2NE69c/AHfu6NR0oZaFW8/vLAJCenvSvCApucwCHsSBJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765205302; c=relaxed/simple;
	bh=ZBJqfP2yTwPlOGYe65iyaFAYEfFJxH0tU+M856wi8Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMCy1gaM+TOUyyETLYGAkaXzFXxSUJXRfESdDa3wBMRRPJWg+zWHrxD6H1Fd/r2EL/Xf79uJOIbLTmrDqE4H5yt8hvLWLph0zvngcbjw/MF9Swgq32Umepqz8MKs2dsCuMKTqFiXjN9xGbNIoF8V543meDZdj2moeEBfxPRiP4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A96CE60336; Mon, 08 Dec 2025 15:48:18 +0100 (CET)
Date: Mon, 8 Dec 2025 15:48:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TEST] conntrack_reverse_clash.sh flakes
Message-ID: <aTblMlbPfxuac2eg@strlen.de>
References: <20251206175135.4a56591b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206175135.4a56591b@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> We have a new faster NIPA setup, and now on non-debug builds we see 
> a few (4 a week to be exact) flakes in conntrack_reverse_clash.sh
> 
> List of flakes from the last 100 runs:
> https://netdev.bots.linux.dev/contest.html?pass=0&test=conntrack-reverse-clash-sh
> 
> Example:
> 
> # selftests: net/netfilter: conntrack_reverse_clash.sh
> # Port number changed, wanted 56789 got 5950
> # ERROR: SNAT performed without any matching snat rule
> # kill: sending signal to 16051 failed: No such process
> not ok 1 selftests: net/netfilter: conntrack_reverse_clash.sh # exit=1
> 
> Looks like the test also occasionally flaked on the old setup ("remote"
> column with "metal" instead of "virt") which is now shut down:
> 
> # selftests: net/netfilter: conntrack_reverse_clash.sh
> # Port number changed, wanted 56789 got 54630
> # Port number changed, wanted 56790 got 25814
> # ERROR: SNAT performed without any matching snat rule
> not ok 1 selftests: net/netfilter: conntrack_reverse_clash.sh # exit=1
> 
> so this isn't new, just more likely now..
> 
> Could you TAL when you have spare cycles? (BTW the new setup is owned 
> by netdev foundation so I can give you access if that helps).

No need, I can reproduce this:
# selftests: conntrack_reverse_clash.sh
# Port number changed, wanted 56790 got 64562 from 127.0.0.12
# ERROR: SNAT performed without any matching snat rule
# udp      17 30 src=127.0.0.11 dst=127.0.0.12 sport=56789 dport=56790 [UNREPLIED] src=127.0.0.12 dst=127.0.0.11 sport=56790 dport=56789 mark=0 use=1
# conntrack v1.4.8 (conntrack-tools): 1 flow entries have been shown.
# cpu=0         found=0 invalid=0 insert=0 insert_failed=0 drop=0 early_drop=0 error=0 search_restart=0 clash_resolve=0 chaintoolong=0
...

Looks like an actual bug to me, will need some time to investigate this.
If its too annoying consider disabling this particular test for now.

Thanks for reporting.
