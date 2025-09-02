Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829EC2F532E;
	Tue,  2 Sep 2025 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756810443; cv=none; b=YiasggoD5gw/UaWk+VlHAqKW8aJEZgSNioKmqEn3pavKqTdeqtZKO8UweXTYKYxFvesOIPomOycC9IsB+Xs76GWRnJoBa0iAmH/CB7hvWI9n/fjjsfeY08weIHmrJ65bYzGwpBph0n+1mruowgRVaSo0A7aciBXkvv1A3r51djU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756810443; c=relaxed/simple;
	bh=4/vikKvdgd7eTjjeRQiOGUprXV9G2onUs3UuoX29Uzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MoBuapvq7kTbE8msFTK3WR7fnN3Pv6dL7GYx7EaD60GANQm9h/3odeuPXbNsl4RFQanJ1rk/05B9RQQAVAp0YbmzIBugaCIIdB1CDagUeq4HTG2M170etjqEMSoZPL6QRqV8pefSUgNc2sfZfaiwXLOmXZydEZmBpmo+F/yjRM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1DD8B6046B; Tue,  2 Sep 2025 12:53:58 +0200 (CEST)
Date: Tue, 2 Sep 2025 12:53:57 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 0/8] netfilter: updates for net-next
Message-ID: <aLbMxUF4J2BrFqR5@strlen.de>
References: <20250901080843.1468-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901080843.1468-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> The following patchset contains Netfilter fixes for *net-next*:
> 
> 1) prefer vmalloc_array in ebtables, from  Qianfeng Rong.
> 2) Use csum_replace4 instead of open-coding it, from Christophe Leroy.
> 3+4) Get rid of GFP_ATOMIC in transaction object allocations, those
>      cause silly failures with large sets under memory pressure, from
>      myself.
> 5) Introduce new NFTA_DEVICE_PREFIX attribute in nftables netlink api,
>    re-using old NFTA_DEVICE_NAME led to confusion with different
>    kernel/userspace versions.  This refines the wildcard interface
>    support added in 6.16 release.  From Phil Sutter.

As per discussion I'll route patch 5 via net tree instead, so:

pw-bot: changes-requested

A new nf-next -> net-next MR will follow.
