Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764C128C5B8
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757024853; cv=none; b=YKRxDinVZ0L3JLbWUVkCnzrFzJWF37DSEj23iiNHmEYYtPld9lcK4o/CpsJ1sOQ4eQO8LrpBEBMWtKXZSUSvp7rjOd9vjYCA6YJXpzsCJ3kXK5vjvQ7uvhNaLqsVHX4FNq3/mLvYVjwCtr6MLkMT/zi8huUqhsYfiNPWYzCjudE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757024853; c=relaxed/simple;
	bh=n90NC5l5Dmz0hStJpQy1Fq5/IXdHxasu/yrsy0ejBcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFCqaWJqOMWubtc2YpbP6yuwNlr76Uw6wTcCOAZMY50Ks9xOdapb3IpFoFDYm38Vs6+6KhuBStygRr51kXWLwCThn/IXbE5/qOeodEbNvvNlLf3Y8iSA8OQW2atcAZk8DG5ItfVF/PFdXIuu4NtTtlnFiphmiWKaZe/o+go+TiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=O3yEaaX/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="O3yEaaX/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e7n1060pzxnH3kYvgLupyOKy6d0OQ+XiQjxLddIUUOc=; b=O3yEaaX/eyB7628ldZJmClwjAX
	ckvh/JwdD1TZaJW+GyfNcIDiZcHqMxht8+8frjNYieHwciCDzhHq5qyK8dhZnVNyi++4G9VlHTN+/
	p4gWFt3HtVglGqFIgp4yRqe/ef1OMr3CEGbnas8Evaj+1SUFtC3PYdTAtR3iGRzxnbUeB9PAHJA7V
	jIXAtYOwrwbMQEbLU5vfO29xUpjFyG/noaRFvjPE4HSQ7crCTRRpDMzfRSqaT4bT8wvJB0+BC6tsx
	9LxjkenZKeZi9893yX5Kyz1xyZzukcli/ts46GqeKRcvogAdLO7qvRuc7XzeGJREDvt/udVyNsccG
	/N41pJ+Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuIQS-000000003da-0pNG;
	Fri, 05 Sep 2025 00:27:28 +0200
Date: Fri, 5 Sep 2025 00:27:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v5 1/3] mnl: Support simple wildcards in netdev hooks
Message-ID: <aLoSUDgiZxbaulty@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250731222945.27611-1-phil@nwl.cc>
 <20250731222945.27611-2-phil@nwl.cc>
 <aLmtQ47BLcj5AC11@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmtQ47BLcj5AC11@calendula>

On Thu, Sep 04, 2025 at 05:16:19PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> NFTA_DEVICE_PREFIX is now available in net.git, let's pick up on this.
> 
> On Fri, Aug 01, 2025 at 12:29:43AM +0200, Phil Sutter wrote:
> > When building NFTA_{FLOWTABLE_,}HOOK_DEVS attributes, detect trailing
> > asterisks in interface names and transmit the leading part in a
> > NFTA_DEVICE_PREFIX attribute.
> > 
> > Deserialization (i.e., appending asterisk to interface prefixes returned
> > in NFTA_DEVICE_PREFIX atributes happens in libnftnl.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v4:
> > - Introduce and use NFTA_DEVICE_PREFIX which contains a NUL-terminated
> >   string as well but signals the kernel to interpret it as a prefix to
> >   match interfaces on.
> > - Do not send wildcards in NFTA_HOOK_DEV: On one hand, the kernel can't
> >   detect them anymore since they are NUL-terminated as well. On the
> >   other, it would defeat the purpose of having NFTA_DEVICE_PREFIX, which
> >   is to not crash old user space.
> > 
> > Changes since v3:
> > - Use uint16_t for 'attr' parameter and size_t for 'len' variable
> > - Use mnl_nft_ prefix for the helper function
> > 
> > Changes since v2:
> > - Introduce mnl_attr_put_ifname() to perform the conditional
> >   mnl_attr_put() parameter adjustment
> > - Sanity-check array index in above function to avoid out-of-bounds
> >   access
> > ---
> >  include/linux/netfilter/nf_tables.h |  2 ++
> >  src/mnl.c                           | 26 +++++++++++++++++++++++---
> >  2 files changed, 25 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> > index f57963e89fd16..b38d4780ae8c8 100644
> > --- a/include/linux/netfilter/nf_tables.h
> > +++ b/include/linux/netfilter/nf_tables.h
> > @@ -1774,10 +1774,12 @@ enum nft_synproxy_attributes {
> >   * enum nft_device_attributes - nf_tables device netlink attributes
> >   *
> >   * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
> > + * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
> >   */
> >  enum nft_devices_attributes {
> >  	NFTA_DEVICE_UNSPEC,
> >  	NFTA_DEVICE_NAME,
> > +	NFTA_DEVICE_PREFIX,
> >  	__NFTA_DEVICE_MAX
> >  };
> >  #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 43229f2498e55..b532b8ff00c1e 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -795,6 +795,26 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
> >  	free_const(dev_array);
> >  }
> >  
> > +static bool is_wildcard_str(const char *str)
> > +{
> > +	size_t len = strlen(str);
> > +
> > +	if (len < 1 || str[len - 1] != '*')
> > +		return false;
> > +	if (len < 2 || str[len - 2] != '\\')
> > +		return true;
> > +	/* XXX: ignore backslash escaping for now */
> 
> Is this comment here still valid?

Yes, sadly. The above covers for eth* and eth\* but not for eth\\* since
a proper solution didn't quickly come to mind which avoids playing
whack-a-mole. (E.g., does eth\\\\\\* escape the wildcard or not?)

Guess I could just count the number of backslashes immediately preceding
the asterisk and return true if the sum is odd?

Cheers, Phil
