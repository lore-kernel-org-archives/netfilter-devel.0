Received: from sphereful.sorra.shikadi.net (sphereful.sorra.shikadi.net [52.63.116.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B1214813
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2025 11:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.63.116.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745492871; cv=none; b=flW5t/LWPdtojmZKtvRNKCG9CjwZ8ogUaQLN6Ai4aBS7zIVUG8K8kFJJ6/LJPu14rARp3C0ftbpO5QM//m4v8LXNfNvnwNV+evU4zfImxgqA3vGms1mLwsQOoSc5VYcl/CL5C7ohQWz64G6bfazEAVngZVF+PIiucVcnT44gk/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745492871; c=relaxed/simple;
	bh=P2DSxtuvKSdNJTHbz1qREgu6B4Vx7u7RvWMcHl7wk00=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwoGClVwYnifPA8FbRLqQKdNsoEogDCmRwnx72sOEyPcqh4XqNEMCzg5rW9k33dxckqH+/VOgR+lnILgrYWvDjFQyWr1koczRyCcdipaUAqEiXr3fC9ymWNRYg7YBz30XyD3HY4RcKzuPxeiZGxtTzuFctQw8ryzHqQNfUut4ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net; spf=pass smtp.mailfrom=shikadi.net; dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b=nyxH/3CO; arc=none smtp.client-ip=52.63.116.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shikadi.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b="nyxH/3CO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=shikadi.net
	; s=since20200425; h=MIME-Version:References:In-Reply-To:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=Beity7pSnNJyIiwrXnPvMeY8fd/yIluJdUYfa/nzJgs=; b=nyxH/3COWY0iCqhv55Y25U31aW
	rIuuC31d+i9yA38WrJ1nYSpq+iFNT2o/UQ6D8xq5po5donnJS0fSQOXDOMvOTPBBle6qN4rm881bu
	FmOf/Jcn8SZHIomiB/k1+EVUAprJFRf4g4mht1R2e2ShvdXIoCqMKR7CQ8y1o4Ld+LQgHLH+fdoKT
	ZwqtxyiqDo7fKFr+bzdgeKVzwypFcMPCkep0/negDoewJS3GrulqJXLnGc1lypEAq+Sn9rl0je6Z0
	/gTT5ae0ThDEnJRIzR41Y9XF5Ry4NtaNiKfEJt+gra3CPRDNpGtm3sPXcAVJsmQL6CK6rqr3d/GE/
	XC4V7GVQ==;
Received: by sphereful.sorra.shikadi.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <a.nielsen@shikadi.net>)
	id 1u7uQe-0002R0-31;
	Thu, 24 Apr 2025 21:07:40 +1000
Date: Thu, 24 Apr 2025 21:07:37 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Accept an option if any given command
 allows it
Message-ID: <20250424210737.265fe989@gnosticus>
In-Reply-To: <aAn1ofkNuxpohhaA@orbyte.nwl.cc>
References: <20250423121929.31250-1-phil@nwl.cc>
	<aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
	<20250424085803.73864094@gnosticus>
	<aAl6WkT9vx1IT1-8@orbyte.nwl.cc>
	<20250424100409.5f9ca598@gnosticus>
	<aAn1ofkNuxpohhaA@orbyte.nwl.cc>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> > Fair enough.  I think the previous release sat in my distro's repos for
> > around 18 months before we got 1.18.11, so I was hoping I wouldn't have
> > to wait that long again before 1.18.12 comes along and gets my
> > bandwidth monitoring scripts working again!  
> 
> Which distribution are you using?

Arch Linux.  They're not particularly open to customising things,
preferring to stick to upstream releases as closely as possible.

> > I'll probably do a custom package with the git version, then I can get
> > things going once more without hassling you for more frequent
> > releases :)  
> 
> Can't you file a ticket in downstream bug tracker and request a
> backport? They probably also want commit 40406dbfaefbc ("nft: fix
> interface comparisons in `-C` commands").

I could but I've tried before and unless it's a serious problem you're
usually out of luck.  They instead prefer to push the maintainers to do
another release so they can just bump the version number in their
package build scripts.

It's not too bad, Arch has a user repository for packages and I have
found that someone has already made a package build script for the git
version of iptables, so I tried installing that and it has fixed the
problem, so my immediate concern is sorted now.

I just have to remember to remove the git version and go back to the
official package when the next version of iptables comes out, as the git
packages don't update automatically.

Thanks again for getting a fix for this done so quickly.

Cheers,
Adam.
