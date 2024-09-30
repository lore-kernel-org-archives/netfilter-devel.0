Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873BBB65C
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 12:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727700506; cv=none; b=T4yQd9AvbNHMgxkVAV+uWovrNqOSnZW1Kf6rFd31xrLh1zIjhvhcIV2gq1TEu/Npvo9pMs/CPCrw/GM72GtBL3Z/6AVF/+8VU4HTCIQkpVnb33hkLw1ALrwLIEzbHD2Sm3FG3lbdJv3xpgF2qrhPF6/14RoQYElK5IVhKWVLkcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727700506; c=relaxed/simple;
	bh=De/R5mC+hm7ok2CHgaTIx+h0iWwPJ+5eQOSV0Pe3+84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KA+BZDgn4yALN4QAXqb3aKoMws81M8xqIGUdGVn9WddqPauYIqt8D7iz1nc16+Ui/MCDvbXJ3S4n7CI52aATuDBbr6e8kQN4fnvFVu+L8tSYFnQQO3tIm06AnlqGMUhJ8kn79iiV+hTrA3gMf6H7uG7GWKyBx6IwnwvvxiGD/wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34140 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svFp4-0089kR-Hb; Mon, 30 Sep 2024 14:48:20 +0200
Date: Mon, 30 Sep 2024 14:48:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Danielle Ratson <danieller@nvidia.com>, Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <ZvqeEa_37KEmL8li@calendula>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula>
 <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240930134509.489b54df@kernel.org>
X-Spam-Score: -1.9 (-)

On Mon, Sep 30, 2024 at 01:45:09PM +0200, Jakub Kicinski wrote:
> On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
> > On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
> > > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
> > > > Hi,
> > > > 
> > > > Is there a plan to build a new version soon? 
> > > > I am asking since I am planning to use this function in ethtool.  
> > > 
> > > ASAP  
> > 
> > but one question before... Is this related to NLA_UINT in the kernel?
> > 
> > /**
> >  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
> >  * @skb: socket buffer to add attribute to
> >  * @attrtype: attribute type
> >  * @value: numeric value
> >  */
> > static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
> > {
> >         u64 tmp64 = value;
> >         u32 tmp32 = value;
> > 
> >         if (tmp64 == tmp32)
> >                 return nla_put_u32(skb, attrtype, tmp32);
> >         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
> > }
> > 
> > if I'm correct, it seems kernel always uses either u32 or u64.
> > 
> > Userspace assumes u8 and u16 are possible though:
> > 
> > +/**
> > + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
> > + * \param attr pointer to netlink attribute
> > + *
> > + * This function returns the 64-bit value of the attribute payload.
> > + */
> > +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
> > +{
> > +       switch (mnl_attr_get_payload_len(attr)) {
> > +       case sizeof(uint8_t):
> > +               return mnl_attr_get_u8(attr);
> > +       case sizeof(uint16_t):
> > +               return mnl_attr_get_u16(attr);
> > +       case sizeof(uint32_t):
> > +               return mnl_attr_get_u32(attr);
> > +       case sizeof(uint64_t):
> > +               return mnl_attr_get_u64(attr);
> > +       }
> > +
> > +       return -1ULL;
> > +}
> > 
> > Or this is an attempt to provide a helper that allows you fetch for
> > payload value of 2^3..2^6 bytes?
> 
> No preference here, FWIW. Looks like this patch does a different thing
> than the kernel. But maybe a broader "automatic" helper is useful for
> user space code.

Not sure. @Danielle: could you clarify your intention?

If this is to support NLA_UINT, I'd prefer to stick to NLA_UINT semantics.

@Jakub: is there any plan to augment NLA_UINT in the future? What
the assumption from userspace that this will always return 32-bits
else 64-bits value?

Thanks.
