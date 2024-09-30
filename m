Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA44194AD1
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715709; cv=none; b=shlKm95otidYRNSC7d7O0dIpK1zbvlTmBW7k4IaoVhbk74D5eEPzvoPeK3920aOym8IUOxNBaowiKvVP3IcgoquMXWD3qxCttMgdUMdE/v6eL5FtpUCphgSDCGmdeCqPPYEOATZqUrFuJuOEEIkf9kS15EB83msUZAW9YKF/1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715709; c=relaxed/simple;
	bh=Zq84b8AnsDyG7r8kXR1hAWw3vhewfvdG570chOh1I0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhsyQZmBOFgJce+38TLB1C4uTJrxmrRCbEfAXwZkx0SNfVWW71fC8hP92v/BpiWuiCvDqWWd4u4qICqr2tyk6VLdV5eUu9xNQ/LlM/O+fYIGjrmRNvjexqYvL6RkfSMeIqwO3cSoMYup9PPpkd4LnJpP74WZq3R93OAS5SOme14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58362 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svJmF-008SWz-Tm; Mon, 30 Sep 2024 19:01:42 +0200
Date: Mon, 30 Sep 2024 19:01:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Petr Machata <petrm@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Danielle Ratson <danieller@nvidia.com>, Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <ZvrZciPsfppMf9dl@calendula>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula>
 <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org>
 <ZvqeEa_37KEmL8li@calendula>
 <87cyklm7i2.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87cyklm7i2.fsf@nvidia.com>
X-Spam-Score: -1.9 (-)

On Mon, Sep 30, 2024 at 06:25:17PM +0200, Petr Machata wrote:
> 
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > On Mon, Sep 30, 2024 at 01:45:09PM +0200, Jakub Kicinski wrote:
> >> On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
> >> > On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
> >> > > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
> >> > > > Hi,
> >> > > > 
> >> > > > Is there a plan to build a new version soon? 
> >> > > > I am asking since I am planning to use this function in ethtool.  
> >> > > 
> >> > > ASAP  
> >> > 
> >> > but one question before... Is this related to NLA_UINT in the kernel?
> >> > 
> >> > /**
> >> >  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
> >> >  * @skb: socket buffer to add attribute to
> >> >  * @attrtype: attribute type
> >> >  * @value: numeric value
> >> >  */
> >> > static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
> >> > {
> >> >         u64 tmp64 = value;
> >> >         u32 tmp32 = value;
> >> > 
> >> >         if (tmp64 == tmp32)
> >> >                 return nla_put_u32(skb, attrtype, tmp32);
> >> >         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
> >> > }
> >> > 
> >> > if I'm correct, it seems kernel always uses either u32 or u64.
> >> > 
> >> > Userspace assumes u8 and u16 are possible though:
> >> > 
> >> > +/**
> >> > + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
> >> > + * \param attr pointer to netlink attribute
> >> > + *
> >> > + * This function returns the 64-bit value of the attribute payload.
> >> > + */
> >> > +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
> >> > +{
> >> > +       switch (mnl_attr_get_payload_len(attr)) {
> >> > +       case sizeof(uint8_t):
> >> > +               return mnl_attr_get_u8(attr);
> >> > +       case sizeof(uint16_t):
> >> > +               return mnl_attr_get_u16(attr);
> >> > +       case sizeof(uint32_t):
> >> > +               return mnl_attr_get_u32(attr);
> >> > +       case sizeof(uint64_t):
> >> > +               return mnl_attr_get_u64(attr);
> >> > +       }
> >> > +
> >> > +       return -1ULL;
> >> > +}
> >> > 
> >> > Or this is an attempt to provide a helper that allows you fetch for
> >> > payload value of 2^3..2^6 bytes?
> >> 
> >> No preference here, FWIW. Looks like this patch does a different thing
> >> than the kernel. But maybe a broader "automatic" helper is useful for
> >> user space code.
> >
> > Not sure. @Danielle: could you clarify your intention?
> 
> This follows the iproute2 helper, where I was asked to support >32-bit
> fields purely as a service to the users, so that one helper can be used
> for any integral field.

Which helper are your referring to? Is it modeled after NLA_UINT?

I don't think this patch is fine. This also returns -1ULL so there is
no way to know if size is not correct or payload length is 64 bits
using UINT64_MAX?

Thanks.
