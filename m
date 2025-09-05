Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00C3594B
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757071260; cv=none; b=CbVheR+wWIE7+76V0xSA/ZMwni60zEkoTl4/wulHKgUz8x7V17/iVGieSiNmcz+Ia0BMOBQmJ71mTPRS03HvDNdAMCiioCrULH/usj/Dp4yVTAgqjCxARPQCMgdZ4O1YMxVpK/6kxDhNc9TvH2D7p7BUPSAstYExt6DzEtkfSUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757071260; c=relaxed/simple;
	bh=Wo0nMUVo3GF6wK9yIhDg6GTUUTqmKjcgo+WSMuKwA+A=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9sth5J6ZwOiXQLs+BGSeHnjBmD+YqBTq64tJ/JEJjHYwiJdIReM87+AgaYiQ6JOAcXSSE1AWfdJv03PZeWiXD3NSJ7q8/A8kl5xtQzD3+oTPd0IFX8zsB4233PeTk2Ktd2Tgnmx04s5/xCM5geBcLDY5FFxJ6injZGfRz+af34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KWMrRARN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lSOpC4uj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KWMrRARN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lSOpC4uj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 90734607CE; Fri,  5 Sep 2025 13:20:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757071252;
	bh=w2J8zG5Nha2j2Tenbf9P40UfmdU5WXoaXYpTx75DH+0=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=KWMrRARNr+AotTCeGjss4wvUXel4gtqvL6hiN5EfQE+zjFkQI2fdc7AI9TeOvUJ3C
	 DoSMuxcO1rS/j9GKcl2ifUaB0el98naOFGbdV6XiCzDRTRNN596leFLw+yKSXOU1z5
	 8uaFCBzmgOcbgZ1+VMuUtL/ksQJf18m8GMGtv75WwHDUbzGDX2zCRNrI4EI1ynuXDQ
	 BSFRbxyTyOwdQwZ3PnGr+FN4s55f81v7UmEPB+AJMe2/suFf0h31wklY+z/qCegEn/
	 rXaOltJNGFuNIuPw8XmlXPtuGGNwtmhaQgj2l7bil6bRrIjxCCuvi1JuY07YjU/8Tr
	 u/AjFbRqR8pVg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1C6E607CE;
	Fri,  5 Sep 2025 13:20:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757071251;
	bh=w2J8zG5Nha2j2Tenbf9P40UfmdU5WXoaXYpTx75DH+0=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=lSOpC4ujewwwsIs8MnA+FkBdBUHGljF3NLWkq0uUG24WrVhHYfcdHB29dM8g2NcS+
	 BnwEnRlW9XqUAIzR1j2G+rQllZm1I4Csdp2a9ZSp0dPjbC2D3VNPqe8ra8WXg/3Icd
	 Uq74jo3n5dx4YZ8w8mmZMkQFbY91oyFpGGrwENHWX5QzS8G4z/uMPL8VqjfgBkARbn
	 ENvvVMGmA1UgPh/+ARKQ2A36nZuNtdo4KsTdSj5887n4zsVBvjrMjS21GAv1oO6iV1
	 6UuZUVLFCPiUCnbiLZPyxBwTY7MfcCztWeHm5EXGm9xOtUe3kbkkEzKHuzrph97rZW
	 fcee/4iKW3HHw==
Date: Fri, 5 Sep 2025 13:20:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v5 1/3] mnl: Support simple wildcards in netdev hooks
Message-ID: <aLrHkcJzyPxcbxBw@calendula>
References: <20250731222945.27611-1-phil@nwl.cc>
 <20250731222945.27611-2-phil@nwl.cc>
 <aLmtQ47BLcj5AC11@calendula>
 <aLoSUDgiZxbaulty@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLoSUDgiZxbaulty@orbyte.nwl.cc>

On Fri, Sep 05, 2025 at 12:27:28AM +0200, Phil Sutter wrote:
> On Thu, Sep 04, 2025 at 05:16:19PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > NFTA_DEVICE_PREFIX is now available in net.git, let's pick up on this.
> > 
> > On Fri, Aug 01, 2025 at 12:29:43AM +0200, Phil Sutter wrote:
> > > When building NFTA_{FLOWTABLE_,}HOOK_DEVS attributes, detect trailing
> > > asterisks in interface names and transmit the leading part in a
> > > NFTA_DEVICE_PREFIX attribute.
> > > 
> > > Deserialization (i.e., appending asterisk to interface prefixes returned
> > > in NFTA_DEVICE_PREFIX atributes happens in libnftnl.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Changes since v4:
> > > - Introduce and use NFTA_DEVICE_PREFIX which contains a NUL-terminated
> > >   string as well but signals the kernel to interpret it as a prefix to
> > >   match interfaces on.
> > > - Do not send wildcards in NFTA_HOOK_DEV: On one hand, the kernel can't
> > >   detect them anymore since they are NUL-terminated as well. On the
> > >   other, it would defeat the purpose of having NFTA_DEVICE_PREFIX, which
> > >   is to not crash old user space.
> > > 
> > > Changes since v3:
> > > - Use uint16_t for 'attr' parameter and size_t for 'len' variable
> > > - Use mnl_nft_ prefix for the helper function
> > > 
> > > Changes since v2:
> > > - Introduce mnl_attr_put_ifname() to perform the conditional
> > >   mnl_attr_put() parameter adjustment
> > > - Sanity-check array index in above function to avoid out-of-bounds
> > >   access
> > > ---
> > >  include/linux/netfilter/nf_tables.h |  2 ++
> > >  src/mnl.c                           | 26 +++++++++++++++++++++++---
> > >  2 files changed, 25 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> > > index f57963e89fd16..b38d4780ae8c8 100644
> > > --- a/include/linux/netfilter/nf_tables.h
> > > +++ b/include/linux/netfilter/nf_tables.h
> > > @@ -1774,10 +1774,12 @@ enum nft_synproxy_attributes {
> > >   * enum nft_device_attributes - nf_tables device netlink attributes
> > >   *
> > >   * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
> > > + * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
> > >   */
> > >  enum nft_devices_attributes {
> > >  	NFTA_DEVICE_UNSPEC,
> > >  	NFTA_DEVICE_NAME,
> > > +	NFTA_DEVICE_PREFIX,
> > >  	__NFTA_DEVICE_MAX
> > >  };
> > >  #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
> > > diff --git a/src/mnl.c b/src/mnl.c
> > > index 43229f2498e55..b532b8ff00c1e 100644
> > > --- a/src/mnl.c
> > > +++ b/src/mnl.c
> > > @@ -795,6 +795,26 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
> > >  	free_const(dev_array);
> > >  }
> > >  
> > > +static bool is_wildcard_str(const char *str)
> > > +{
> > > +	size_t len = strlen(str);
> > > +
> > > +	if (len < 1 || str[len - 1] != '*')
> > > +		return false;
> > > +	if (len < 2 || str[len - 2] != '\\')
> > > +		return true;
> > > +	/* XXX: ignore backslash escaping for now */
> > 
> > Is this comment here still valid?
> 
> Yes, sadly. The above covers for eth* and eth\* but not for eth\\* since
> a proper solution didn't quickly come to mind which avoids playing
> whack-a-mole. (E.g., does eth\\\\\\* escape the wildcard or not?)
> 
> Guess I could just count the number of backslashes immediately preceding
> the asterisk and return true if the sum is odd?

Thanks for explaining the comment, this supports eth* and eth\* which
is sufficient at this stage.

For this series:

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
