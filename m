Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1220C2D877F
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 20:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756327093; cv=none; b=QwzIGUWKXndqDu2R1LWlcSLEC7YtVsdEngvyDsLMnbtClAOAZrUAWOVN1S7bMtnIZiZ555x/oV+RfOzH11bvkoA2GH8YJY6qEf4ujtvBF8xcuRMM6OZLfOC1cvxw9Eofqj4ER0eDnkTdpbBinv+niCRGqEHyVyA8xYXa7gExe1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756327093; c=relaxed/simple;
	bh=PGoAegLF3qtm//pKcKtPQt/yrGicbkNBqmFzNsxuaEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZM4voehmCpgKe44ECyd5TJ74kSA+93ySwtA0u9F6yBaHKPo3Fd5wy0N5CCN3Ot+3cM17jNuE/AoZPFW3O+Df1tFB2SxJDDg0oVDshcxrOXUnS9grshw7aaEiMjD41w3u9PfGDfeaPMeZSP9Wlu4voZjjDtTdmOPeIO05705y8/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h1pqjBKZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h1pqjBKZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uYAPTTz4tnVzZh1i5Kdil8Ju1XAf/a6c33w6Ave/IsY=; b=h1pqjBKZwK5xbdOZp8DsBoayfB
	jg14xpuAydbE79H+UZMQECM01+vBeb55dSjo1jkPno3FdsHotoFhm8odf7sSL/bsrH4fv54z440G7
	xkGvzyiL7fu+y7yifl8HSxrq5b5hc/A9otxIMpAD+cRM/Q272c3AGuUSl9mqmoEK3iNqR0yI+mlBS
	/wRhXIoqh8oKidGeJnRDd8R/U5KFOMAsfsraQsgkytIAwx7/cH53RW8W6jVljHjLUSPYKehx/6FnZ
	Qd2FLItFkh+y2WXhOtAbIsur0BV/OxrK4hHRS8YplNMXH2tObGiCdc8KO9JHkWZAW0/jNDaQehClq
	1ztW2hcA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urMuG-000000003Vc-0QkN;
	Wed, 27 Aug 2025 22:38:08 +0200
Date: Wed, 27 Aug 2025 22:38:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, jengelh@inai.de
Subject: Re: [PATCH nft] build: disable --with-unitdir by default
Message-ID: <aK9ssAgxZBymBQe1@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, jengelh@inai.de
References: <20250827140214.645245-1-pablo@netfilter.org>
 <aK8aN4h2XsLnTdT6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK8aN4h2XsLnTdT6@calendula>

On Wed, Aug 27, 2025 at 04:46:15PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> Cc'ing Phil, Jan.
> 
> Excuse me my terse proposal description.
> 
> Extension: This is an alternative patch to disable --with-unitdir by
> default, to address distcheck issue.
> 
> I wonder also if this is a more conservative approach, this should
> integrate more seamlessly into existing pipelines while allowing
> distributors to opt-in to use this.
> 
> But maybe I'm worrying too much and it is just fine to change defaults
> for downstream packagers.

I think both is fine, packagers will know what to pass to configure and
what not.

Though I think you should also pass the --with-unitdir=<something>
option during distcheck builds, otherwise this patch inadvertently
disables the sanity check which sparked just this discussion in the
first place. :)

As Jan's patch shows, there is AM_DISTCHECK_CONFIGURE_FLAGS for that.

Thinking about the original issue, I wonder if the pkg-config method of
finding the unit install location is actually problematic: My
development build script calls configure with --prefix="$PWD/install"
and runs 'make install' as regular user. The only reason why I didn't
complain yet is probably because I don't have systemd installed and thus
'pkg-config systemd' fails.

So, I'm tempted to ask a fundamental question: Shouldn't --prefix be
applied to all installed files? I would say yes, but simply prefixing
the pkg-config-returned path by $prefix seems wrong, too as it is
definitely not where the unit file is expected to be. Also, --prefix
defaults to /usr/local and Fedora for instance passes --prefix=/usr when
building SRPMs.

OTOH Fedora (Rawhide) returns /usr/lib/systemd/system when requesting
systemdsystemunitdir. So maybe prefix $prefix only if it doesn't start
with $prefix already? (Seems silly, though.)

Cheers, Phil
