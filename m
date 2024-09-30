Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC0F26AEC
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 10:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727692094; cv=none; b=SAb1PdnNAyQ92gpERTPiRGfvRrmZ7vIing0b7zT8cJ59xSrlqL3R9acvazLP0nK7j08BRbSnZ4D3CSRRmjc1N7u/EaRMNmzhgptFjJbwDf+JRuF3i3DihoPsPi5eqJJlmQISSr+kCOrUWxD1nop91iP4ZHYIMX4ptsNyruIfTsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727692094; c=relaxed/simple;
	bh=r2dS/lpLqHiAUBiwxfSnmB2Hhd5UP3BM663K3x3w0+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTsvGpz60awiW3bG2sRWn693wUBHWh8W29F7nJ95b/iOfKe/wX9C9G3ExzPjhJbjiaU+kymD2p2o/maTXTgKM0WuQXKeKJtkfnHuPK0z2nJ90GwwPvmC4kOesKJpH5CBViKSwZW1JvdT+CngYwonjGsndiD+2LmBGmodWz8f+Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58858 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svDdO-007yhA-KO; Mon, 30 Sep 2024 12:28:08 +0200
Date: Mon, 30 Sep 2024 12:28:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Danielle Ratson <danieller@nvidia.com>
Cc: Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <Zvp9NShxCERRPDdi@calendula>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
X-Spam-Score: -1.9 (-)

On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:
> Hi,
> 
> Is there a plan to build a new version soon? 
> I am asking since I am planning to use this function in ethtool.

ASAP

> Thanks,
> Danielle
> 
> > -----Original Message-----
> > From: Phil Sutter <phil@nwl.cc>
> > Sent: Wednesday, 31 July 2024 10:15
> > To: Danielle Ratson <danieller@nvidia.com>
> > Cc: netfilter-devel@vger.kernel.org; pablo@netfilter.org; fw@strlen.de; mlxsw
> > <mlxsw@nvidia.com>
> > Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
> > 
> > On Wed, Jul 31, 2024 at 09:35:51AM +0300, Danielle Ratson wrote:
> > > NLA_UINT attributes have a 4-byte payload if possible, and an 8-byte
> > > one if necessary.
> > >
> > > There are some NLA_UINT attributes that lack an appropriate getter
> > function.
> > >
> > > Add a function mnl_attr_get_uint() to cover that extract these. Since
> > > we need to dispatch on length anyway, make the getter truly universal
> > > by supporting also u8 and u16.
> > >
> > > Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> > 
> > Patch applied, thanks!
