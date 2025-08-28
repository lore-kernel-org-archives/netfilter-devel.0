Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE43C222575
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756384258; cv=none; b=a/avW0Hc1iqRxAiXPqK4OYMrUvGexo1EOol/f3+LJy9WXNMjdUBdJGbeNgZfB6gba7ZqsUkrA9HTrbxOoKoaRtGPsxv6zKIwqjzFK2ypBgGVDXmRsTN6s2eyLTpgC+45ePY9GwtStwGhf4iIHunV4eNr3rtHn5AWV48puvySj3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756384258; c=relaxed/simple;
	bh=wZQSCn6gUwGt05fcY8u/XdsVYipKtHIvS3T/9CF1TBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhUX/fKB/AX9nn+zYSZXV3hKrbDmCZdBE70nveZqrTAkCta2j/1ZgWyDNYyOw7l0daw8aHz5qLsCpJS5X/BxKv3fRZDTAZUqMpl1RaOkLdzhOkwxIl12EOsaGuJODZtkOAhx9T4KC5btIfQ6hVZz+NssgLB5LJjR0V/edn+MfOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CXwkek3P; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CXwkek3P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W0uzPgTGTcoX2ADv9txEk21hcn6DyMg++gE7smhYiYQ=; b=CXwkek3Pr70wLKD5NpblyRQGVC
	na7eOlo7K+2MIjz2w02iZn8j+XDMFCSmxwFm++ini/m/c2gbMtUv/Go6Sz3s4bJk7kzJU+MCChgOA
	HAa2mk0FRiPrxIlw2x2m5gtHm/omC2u5kt90Crc8+uHbjZh/NtSyPElyV9aVFuL9ZgkWO81cbx9O6
	qvlJeD5P+0ISGS80jtvwXOBaCKYnkTpsPQ6gNV5C3PfRq3a+pmOdInpqcOujfSUw/T4iHRyKmSrvN
	kAkWyYOggK+s2ftVKIWajkLEMWnoxh/m2FlvxvkSP5apE5uznZNri9TvX7ZYkGDrolcbgoEyDRslK
	Ojmg9fnA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urbmH-000000006z7-2jWS;
	Thu, 28 Aug 2025 14:30:53 +0200
Date: Thu, 28 Aug 2025 14:30:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Yi Chen <yiche@redhat.com>, netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: Re: [conntrack-tools PATCH] nfct: helper: Extend error message for
 EEXIST
Message-ID: <aLBL_W7eNXTTePwb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Yi Chen <yiche@redhat.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20250815155750.21583-1-phil@nwl.cc>
 <CAJsUoE2zCJYSvm9_=784BtH26GsRDJGBTn8930wW4ZSU8nTjYA@mail.gmail.com>
 <aK-H5xydGbsYIvBU@calendula>
 <aLA3pp6yXJjdEjjl@orbyte.nwl.cc>
 <aLBD_Ur0qeT9yLbz@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLBD_Ur0qeT9yLbz@calendula>

On Thu, Aug 28, 2025 at 01:56:45PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 28, 2025 at 01:04:06PM +0200, Phil Sutter wrote:
> > On Thu, Aug 28, 2025 at 12:34:15AM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Aug 18, 2025 at 11:47:08AM +0800, Yi Chen wrote:
> > > > This patch adds a hint when:
> > > > 
> > > > # modprobe nf_conntrack_ftp
> > > > # nfct helper del ftp inet tcp
> > > > # nfct helper add ftp inet tcp
> > > > *nfct v1.4.8: netlink error: File exists*
> > > > 
> > > > or other type of helper.
> > > 
> > > This patch changes EEXIST by EBUSY:
> > > 
> > >   https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250818112220.26641-1-phil@nwl.cc/
> > > 
> > > This userspace patch is not very useful after this.
> > 
> > Oh! I missed that nfnl_cthelper_create() also just passes through the
> > return code from nf_conntrack_helper_register().
> > 
> > > So maybe a follow up fix to retain EEXIST for nfnetlink_cthelper in
> > > the kernel is needed?
> > > 
> > > I mean, return EEXIST in nfnetlink_cthelper but EBUSY in case of
> > > insmod, ie. add a bool insmod flag to the helper register/unregister
> > > functions to return EBUSY for insmod and EEXIST for
> > > nfnetlink_cthelper.
> > 
> > Do we need to retain the old return code?
> 
> I have change return codes in the past myself, when I considered error
> reported to userspace was misleading, but I heard once it is a good
> practise not to change them as a general rule.
> 
> > I would just update the patch to print the message for EBUSY instead
> > of EEXIST.
> 
> It is OK, I could not find any code in conntrackd running in helper
> mode than relies on this error code. The only case that I can think of
> is combining old kernel with new userspace defeats the purpose of this
> patch.

Yes, with old kernels new user space behaviour is same as old user space
(so at least not a degradation).

> Maybe it is not worth the effort to bother about this, judge yourself.

The EBUSY return is consistent with insmod/modprobe return code, so I'd
keep it like this.

Thanks, Phil
