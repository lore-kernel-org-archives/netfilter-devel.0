Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77C1E2858
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 22:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754002479; cv=none; b=spxheMllHJ//I/fuMgZmv+4SaJeveSehBPR4eepGjL2kYrejBih9sBmz0bWYI1lYXC45ZzajDT8CyydtvzxSIt05mJfd+xxfX4qm8AvgDmBe6Aw06nYdQo9uzvAg2A2iDacqRZeJTGlHHWXuyjvwpOHHHuhTSQYXnLkyOmwb/DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754002479; c=relaxed/simple;
	bh=DyxPOMTFkPzGm2J3s73iW2hpHyl3Sdo4kR6MVxPwyl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/7vCMLAuo2SkDR448S3xJizfQXSgUuDFLQBh81k53Meo/97h2xxjuJb9CJNOVCagLlBwrnMy78IV3L1MwJB6RV6+CxT2XTm2IFRBecNApZA92aZEBlyB1wdne3f2ltWeOaxmJsgNN5+1Xdan+nLWtCb9J+CdRgZsf/S60jZ8DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PfmjshRI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PfmjshRI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xaZEU3NynuraRejHCrs3F2mEMeV6FF9T1eLntBDMQMM=; b=PfmjshRIfj7STE8yx5h5CVVuO6
	A++iGKCBgLtIotfP162kfD5KycpTUorXPCkUX3ro+OdGjhY5BjR2kjB8CUHNzzRcKGg32YPGTF7Rj
	/2SedMl/mrKlsRYLeKP4G8HwHT0sJTgGyvkaGd2+OXsYIroGqiMwi1w/Zk7bZoLogqyQzcxEIYkpc
	rC3Fv6atRP+EuEIw30bN8yDwAM+dZDaH1x0vz77F8ggBxWSdGj8iuDHcFgBRw8RVhcNRFRH/ddr+1
	MWbNhnaPH8OGsXgv1Ray3xGoq3O358QZ8agFEgEzy3ocM+H9WEv+wFktp2o1K3POMIB1S9uVmeEc/
	0AI5Utyw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhcAT-000000005N2-1L0r;
	Fri, 01 Aug 2025 00:54:33 +0200
Date: Fri, 1 Aug 2025 00:54:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Introduce
 NFTA_DEVICE_WILDCARD
Message-ID: <aIv0KVmxfpX5QQoy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250724221150.10502-1-phil@nwl.cc>
 <aIOe6gUjXTXwR2Nv@calendula>
 <aIP8UIYPzLokNbWq@orbyte.nwl.cc>
 <aIgWKhR0RQwKMK3p@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIgWKhR0RQwKMK3p@calendula>

On Tue, Jul 29, 2025 at 02:30:54AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Jul 25, 2025 at 11:51:12PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, Jul 25, 2025 at 05:12:42PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Jul 25, 2025 at 12:00:31AM +0200, Phil Sutter wrote:
> > > > On netlink receive side, this attribute is just another name for
> > > > NFTA_DEVICE_NAME and handled equally. It enables user space to detect
> > > > lack of wildcard interface spec support as older kernels will reject it.
> > > > 
> > > > On netlink send side, it is used for wildcard interface specs to avoid
> > > > confusing or even crashing old user space with non NUL-terminated
> > > > strings in attributes which are expected to be NUL-terminated.
> > > 
> > > This looks good to me.
> > > 
> > > > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > > While this works, I wonder if it should be named NFTA_DEVICE_PREFIX
> > > > instead and contain NUL-terminated strings just like NFTA_DEVICE_NAME.
> > > > Kernel-internally I would continue using strncmp() and hook->ifnamelen,
> > > > but handling in user space might be simpler.
> > > 
> > > Pick the name you like.
> > 
> > Ah, it's not just about the name. The initial version using
> > NFTA_DEVICE_NAME for both, distinction of wildcards from regular
> > names came from missing '\0' terminator. With distinct attribute types,
> > this is not needed anymore. I guess it's more user (space) friendly to
> > include the NUL-char in wildcards as well, right?
> 
> Yes. In practise, you can put anything over netlink (someone decided
> to sending strings, not even TLVs)...
> 
> But two different types provides clear semantics, no need to peek on
> the value to know what to do.

ACK.

> > > > A downside of this approach is that we mix NFTA_DEVICE_NAME and
> > > > NFTA_DEVICE_WILDCARD attributes in NFTA_FLOWTABLE_HOOK_DEVS and
> > > > NFTA_HOOK_DEVS nested attributes, even though old user space will reject
> > > > the whole thing and not just take the known attributes and ignore the
> > > > rest.
> > > 
> > > Old userspace is just ignoring the unknown attribute?
> > 
> > Attribute parser in libnftnl will abort if it finds an attribute with
> > type other than NFTA_DEVICE_NAME nested in NFTA_HOOK_DEVS (or the
> > flowtable equivalent). So old userspace will refuse to parse the data,
> > but not crash at least.
> 
> Please, fix it so we can do better in the future.
> 
> > > I think upside is good enough to follow this approach: new userspace
> > > version with old kernel bails out with EINVAL, so it is easy to see
> > > that feature is unsupported.
> > 
> > ACK, it is definitely much more sane than before!
> 
> OK.
> 
> I suggest you formally submit this for nf.git including userspace
> patches? Then, request it to be included in -stable. We probably have
> to skip including this userspace code in the next 1.1.4 release.
> Unless anyone have a better proposal to handle this. I'm sorry I did
> not bring up this issue sooner.

The Fixes: tag will suffice for -stable, correct?

I don't see why we have to hold back user space. There was no support
for these wildcards in nft tool yet, so probably nothing relies upon the
old (i.e., non-NUL-terminated strings in NFTA_DEVICE_NAME) behaviour
yet. Even if something does, the kernel (with my patch applied) will
treat it sanely as non-wildcard.

Updated user space facing a kernel prior to my patch will detect lack of
wildcard support, even if the kernel would support it (via
non-NUL-terminated string in NFTA_DEVICE_NAME).

Am I missing your point?

> > > As for netlink attributes coming from the kernel, we can just review
> > > the existing userspace parsing side and see what we can do better in
> > > that regard.
> > 
> > We could introduce a "NFTA_DEVICE_NAME_NEW" which may hold wildcards or
> > a regular name (thereby keeping the NUL-char distinction mentioned
> > above) and at some point drop NFTA_DEVICE_NAME. Basically a merge
> > strategy to upgrade NFTA_DEVICE_NAME to support also wildcards, but I'm
> > not sure how long this transition period will take. At least it would
> > never crash old user space, but "merely" become incompatible to it at
> > some point.
> 
> I don't think it is worth, as for old user space, IMO the only
> reasonable thing we can do is:
> 
> - do not crash.

With NFTA_DEVICE_PREFIX, old user space will stop parsing the netlink
message (nftnl_{chain,flowtable}_nlmsg_parse() will return -1). Given
the limited control, this is almost ideal behaviour.

> - highlight that old user space is skipping unknown stuff.

I sent an RFC implementing Florian's suggested solution to detect
potential problems a few months ago but didn't get a reply:

Subject: [nft RFC] table: Embed creating nft version into userdata
Message-ID: <20250512210321.29032-1-phil@nwl.cc>

Maybe putting "PATCH" in the prefix would have provoked feedback? :D
Could you please have a look? I think it is quite unintrusive and
probably the most reliable way of letting users know something may be
odd in the output they're seeing.

> Other than that, we would have to explore a generic way to print raw
> attributes, then extend the parser to allow this, which I am not
> convinced yet it is worth the effort.

This may work for error reporting/debug output in libnftnl, but I doubt
exposing the opaque data in nft output to make it survive a
save'n'restore is doable.

Maybe we could add versions to netlink messages so user space knows if
it will understand all content or not. This could even allow users to
specify a max version to use on command line and nft would reject any
input requiring a larger version. Of course this means tracking "version
requirements" of expressions and other features.

Cheers, Phil
