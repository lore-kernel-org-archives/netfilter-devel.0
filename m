Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46C132C17;
	Wed, 24 Jan 2024 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706126546; cv=none; b=Mz+JC+X0XimluoHKlp2it4BTCCmUyNgO6HeIQZrivah2aoZW1qV1mmYqcnB+Whm8rQbHmv8/IsEDe1C2MELKNwXEgNQfjgRombWsslSwOqxVl8hTMWbMooDeUBksP9GCD7HPNeeuidPLyN20kp6tjaLxfySbI/lTcNlaTsfHkZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706126546; c=relaxed/simple;
	bh=oHZrPKgflqZHcFzLCguwTgM1i5UR1gcjmguUMn7qk6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTUy6kLlY/+bXJhyvjDVfp/F7Q5ha80LMU8xAhz3MElVNIkOJDxV+Zm1fpyZmFma7uCwh7GCAToNG58fHKXv65bgktartg0Bn8cdWl4nHCd+mSnETebcAv2UjEWc3NxN/YWKY3o1A1715nd1XOfJi6efvSbVaW/DC4eSYgckYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=54500 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rSjRx-006oWf-Mk; Wed, 24 Jan 2024 21:02:20 +0100
Date: Wed, 24 Jan 2024 21:02:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	David Ahern <dsahern@kernel.org>, coreteam@netfilter.org,
	"netdev-driver-reviewers@vger.kernel.org" <netdev-driver-reviewers@vger.kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <ZbFsyEfMRt8S+ef1@calendula>
References: <20240122091612.3f1a3e3d@kernel.org>
 <Za98C_rCH8iO_yaK@Laptop-X1>
 <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
 <ZbFiF2HzyWHAyH00@calendula>
 <20240124114057.1ca95198@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240124114057.1ca95198@kernel.org>
X-Spam-Score: -1.9 (-)

On Wed, Jan 24, 2024 at 11:40:57AM -0800, Jakub Kicinski wrote:
> On Wed, 24 Jan 2024 20:16:39 +0100 Pablo Neira Ayuso wrote:
> > > Ah, BTW, a major source of failures seems to be that iptables is
> > > mapping to nftables on the executor. And either nftables doesn't
> > > support the functionality the tests expect or we're missing configs :(
> > > E.g. the TTL module.  
> > 
> > I could only find in the listing above this:
> 
> Thanks for taking a look!
> 
> > https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435141/37-ip-defrag-sh/stdout
> > 
> > which shows:
> > 
> >  ip6tables v1.8.8 (nf_tables): Couldn't load match `conntrack':No such file or directory
> > 
> > which seems like setup is broken, ie. it could not find libxt_conntrack.so
> 
> Hm, odd, it's there:
> 
> $ ls /lib64/xtables/libxt_conntrack.so
> /lib64/xtables/libxt_conntrack.so
>
> but I set a custom LD_LIBRARY_PATH, let me make sure that /lib64 
> is in it (normal loaded always scans system paths)!

Could you also check your ./configure output for iptables? It shows
the directory where the .so file are search and found:

  ...
  Xtables extension directory:          /usr/lib/xtables

> > What is the issue?
> 
> A lot of the tests print warning messages like the ones below.
> Some of them pass some of them fail. Tweaking the kernel config
> to make sure the right CONFIG_IP_NF_TARGET_* and CONFIG_IP_NF_MATCH_*
> are included seem to have made no difference, which I concluded was
> because iptables CLI uses nf_tables here by default..

Please, check if the symlink refers to -legacy or -nft via:

$ ls -la /usr/sbin/iptables

> [435321]$ grep -nrI "Warning: Extension" .
> ./6-fib-tests-sh/stdout:305:# Warning: Extension MARK revision 0 not supported, missing kernel module?

This could come from either legacy or nftables:

libxtables/xtables.c:                                   "Warning: Extension %s revision 0 not supported, missing kernel module?\n",
iptables/nft.c:                         "Warning: Extension %s revision 0 not supported, missing kernel module?\n",

both have the same error.

if that is the nftables backend, it might be also that .config is
missing CONFIG_NF_TABLES and CONFIG_NFT_COMPAT there, among other
options.
