Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C3D1F03F3
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 21:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759266405; cv=none; b=RBrWPp8dvPqzyVk5aL/G32KrDlm9wrvGi4zQdhUrYRhovLTv8vrbkmpaHIt+14MIdu4XLSUBtyP7kfOWv6hmK9w+/u+m/OhnUSWgzZjrdBOpE7kX5bPRd/n84qO6tduaZN2tienvk6DlWz9RjmNSu/372BKewK6TW+8IpzytVoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759266405; c=relaxed/simple;
	bh=G9UinRJEUT7F6HTN7VnY4pUpxTx50sL1eNU/EvFZboo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bqb2FNF7Fl9rZrRa5xinPvwCr8zBE3sTDrXw8luMQ5nVTZ1jM7XVcFdDFF6JL1zYWSpqsTkwNSz3br0o7QTNdwPXUOfdShmF2d7mw0v6zCZZIwxd8/MFBdtIaVLln//jsQbJsROY2ypYcjeyQYjiQ9lztfWVjWeuYHn+IspS3C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=j4sbgIU6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="j4sbgIU6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+LT9KVlI37ej7cQkHWiGKqkWsrBuMN7kjL0BaHF8p64=; b=j4sbgIU6+i09vHkJhImT6TvMvA
	IsVEv7uKlAVVhx2qzFBeVb5nc7PaGpTt6VR3hvCtpKDn67kw92Xiizc2YgMOIJPKynsaOnib3d+vB
	ag8p1zxD1OG39hG61LgLhSn+3iz/I+2EMLkT6Oe6wWKkGQ2p0dsFIR+QVj8fSIsmnoC4W3nfR0Xn7
	EhlD4Hlj4R0KjUbFoyAB0oBCa9/g+JvwaZ4HEOrmSaZAFdQVpP+pUtsaxf+IIGk+P/uRvvbA7vf3d
	W9omNgDxxPM3sl7D+CgBpQdgOZoJ4rV1ExLbUyN3roRwolxibWGhCMj9QpPzO8N2KRRiU1SYqmJrH
	ii/hDPUA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v3hYX-000000000Xs-0bd2;
	Tue, 30 Sep 2025 23:06:41 +0200
Date: Tue, 30 Sep 2025 23:06:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v5 1/3] mnl: Support simple wildcards in netdev hooks
Message-ID: <aNxGYRf9K9Lqkrch@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250731222945.27611-1-phil@nwl.cc>
 <20250731222945.27611-2-phil@nwl.cc>
 <aLmtQ47BLcj5AC11@calendula>
 <aLoSUDgiZxbaulty@orbyte.nwl.cc>
 <aLrHkcJzyPxcbxBw@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLrHkcJzyPxcbxBw@calendula>

On Fri, Sep 05, 2025 at 01:20:49PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 05, 2025 at 12:27:28AM +0200, Phil Sutter wrote:
> > On Thu, Sep 04, 2025 at 05:16:19PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > NFTA_DEVICE_PREFIX is now available in net.git, let's pick up on this.
> > > 
> > > On Fri, Aug 01, 2025 at 12:29:43AM +0200, Phil Sutter wrote:
> > > > When building NFTA_{FLOWTABLE_,}HOOK_DEVS attributes, detect trailing
> > > > asterisks in interface names and transmit the leading part in a
> > > > NFTA_DEVICE_PREFIX attribute.
> > > > 
> > > > Deserialization (i.e., appending asterisk to interface prefixes returned
> > > > in NFTA_DEVICE_PREFIX atributes happens in libnftnl.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > > Changes since v4:
> > > > - Introduce and use NFTA_DEVICE_PREFIX which contains a NUL-terminated
> > > >   string as well but signals the kernel to interpret it as a prefix to
> > > >   match interfaces on.
> > > > - Do not send wildcards in NFTA_HOOK_DEV: On one hand, the kernel can't
> > > >   detect them anymore since they are NUL-terminated as well. On the
> > > >   other, it would defeat the purpose of having NFTA_DEVICE_PREFIX, which
> > > >   is to not crash old user space.
> > > > 
> > > > Changes since v3:
> > > > - Use uint16_t for 'attr' parameter and size_t for 'len' variable
> > > > - Use mnl_nft_ prefix for the helper function
> > > > 
> > > > Changes since v2:
> > > > - Introduce mnl_attr_put_ifname() to perform the conditional
> > > >   mnl_attr_put() parameter adjustment
> > > > - Sanity-check array index in above function to avoid out-of-bounds
> > > >   access
> > > > ---
> > > >  include/linux/netfilter/nf_tables.h |  2 ++
> > > >  src/mnl.c                           | 26 +++++++++++++++++++++++---
> > > >  2 files changed, 25 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> > > > index f57963e89fd16..b38d4780ae8c8 100644
> > > > --- a/include/linux/netfilter/nf_tables.h
> > > > +++ b/include/linux/netfilter/nf_tables.h
> > > > @@ -1774,10 +1774,12 @@ enum nft_synproxy_attributes {
> > > >   * enum nft_device_attributes - nf_tables device netlink attributes
> > > >   *
> > > >   * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
> > > > + * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
> > > >   */
> > > >  enum nft_devices_attributes {
> > > >  	NFTA_DEVICE_UNSPEC,
> > > >  	NFTA_DEVICE_NAME,
> > > > +	NFTA_DEVICE_PREFIX,
> > > >  	__NFTA_DEVICE_MAX
> > > >  };
> > > >  #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
> > > > diff --git a/src/mnl.c b/src/mnl.c
> > > > index 43229f2498e55..b532b8ff00c1e 100644
> > > > --- a/src/mnl.c
> > > > +++ b/src/mnl.c
> > > > @@ -795,6 +795,26 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
> > > >  	free_const(dev_array);
> > > >  }
> > > >  
> > > > +static bool is_wildcard_str(const char *str)
> > > > +{
> > > > +	size_t len = strlen(str);
> > > > +
> > > > +	if (len < 1 || str[len - 1] != '*')
> > > > +		return false;
> > > > +	if (len < 2 || str[len - 2] != '\\')
> > > > +		return true;
> > > > +	/* XXX: ignore backslash escaping for now */
> > > 
> > > Is this comment here still valid?
> > 
> > Yes, sadly. The above covers for eth* and eth\* but not for eth\\* since
> > a proper solution didn't quickly come to mind which avoids playing
> > whack-a-mole. (E.g., does eth\\\\\\* escape the wildcard or not?)
> > 
> > Guess I could just count the number of backslashes immediately preceding
> > the asterisk and return true if the sum is odd?
> 
> Thanks for explaining the comment, this supports eth* and eth\* which
> is sufficient at this stage.
> 
> For this series:
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Series applied, thanks!
