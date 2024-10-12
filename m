Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811922083
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774202; cv=none; b=Q6u9qr5ERsZAsjVMxOhxYT+3xJcFaxjInFa68fb0r1D/arnLkRGtu/TqT15Vr+NuQ+Lzxg+VmXkPCScjXxLsE1rMq+R+AWASRO0Mu+dLmWgUVeOhFfMJDv8JhZqQSJoYeJzwivF03uim1jCOhzquzJaJ/NjrxZ6pY1c6dlCPxgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774202; c=relaxed/simple;
	bh=Ce2IcxodL2cCoJJ1KAO460H04uZiCgfmb3eyqECTbD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kgr+zzANUsdt//c45lyASKVb+kDxg+k32Jyc9yRH9ETuYBzIfM2mTkDgHiPkdojVLvsJqid3jFHLvxq9gHpqZvqQ7lc0eqZ8o9H6z7/7tydKzUNGXVK9kGYO3r++pJt8Vk099CMkZCUwP+6GxVhtcTbq7L9z72AycjowTdgI6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m2+N/W1G; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m2+N/W1G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RYPVenVnb1Oo62b+YjrgQ+qmxuLo/Y17x5O5VUW93Pc=; b=m2+N/W1Gqv87pFQxehBRqmu5Z5
	TXlnxv5iXETdq81IFQFGmdFFzHPuBzDcGh0vz2XjoB0gyZkONfQrSX23tmxXFPnoHF5EY7xYeMXnf
	bM9Li9yPJeaGfMbdl1yIxWPBl5Ecy5xdQFNf7bxtOy+EdE3rIdG0mNqGOMHb/Ibr1phG/3Vt7hILI
	alYOCdffXKQVlPwy7P6vw7znUVpGREpUDcnC/gpSlMlBcNJXjglLbbEiB2Ywr+ii9MwH9OM9O8a96
	dilHEpZFNSI4T0UxlCBWTdpfNQl5iHYOqP57nuNs0IvUiWEI7oYP6HcjuMDbYBQDjsOgu3qz+8Tiz
	gvUOmgqQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1szl8n-000000004H5-3hPb;
	Sun, 13 Oct 2024 01:03:17 +0200
Date: Sun, 13 Oct 2024 01:03:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <ZwsANQhOyYrEGTip@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwrT3JOmxLigw9gC@orbyte.nwl.cc>
 <ZwrpiAv1PHEp1rwY@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwrpiAv1PHEp1rwY@calendula>

On Sat, Oct 12, 2024 at 11:26:32PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Oct 12, 2024 at 09:54:04PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Sat, Oct 12, 2024 at 07:15:21PM +0200, Pablo Neira Ayuso wrote:
> > > Make it option, after this update it is still possible to build the
> > > documentation on demand via:
> > > 
> > >  cd doxygen
> > >  make
> > 
> > This is rather unelegant in an autotools-project. You probably did
> > consider setting 'with_doxygen=no' in configure.ac line 48, why did you
> > choose this way?
> 
> --with-doxygen=no would do try trick, yes.

Not sure if it was clear, but I meant to change the default in
configure.ac, so users will have to pass --with-doxygen=yes if they
want to build these docs. I guess that's the most intuitive way for
users.

Cheers, Phil
