Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07218C31
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727718730; cv=none; b=dimTJ3DkxwObdpUoL71S0wPXe6boL+TKBPf8jE61Ecayf5rw3yZPL9SnhCRITHSWGtPZnAQyDZqsbI97urDGVD0pTYn38C852WY+Ubj/1HCDn/NWZ7BOs/pWa5gzeF0/WdeCfZ7OzXWBNK5Emc84f1k0KU/UNaUO0JdxMTKU2f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727718730; c=relaxed/simple;
	bh=CaYAVFjaGBJYacXKTR0dj6s7Ft0StWUUPKoG+XcTQc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFlG/enn1ASbx3e4bSr16qzfFixKpC9rA7yYcPdKO0RPYNaN1mjcwWozXhLkquGGiJhAg2afXa4RUY39xql2AcP9OQA7gZKRAHOiM5dqrSMIhUTwJJoa0rZy4NUCcSYex1RFQMsL+TGHqtfljklENvh19qzEh6OSU35vhwhn33c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58448 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svKZ1-008WSa-Qi; Mon, 30 Sep 2024 19:52:05 +0200
Date: Mon, 30 Sep 2024 19:52:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Petr Machata <petrm@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Danielle Ratson <danieller@nvidia.com>, Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <ZvrlQjuqS0XY2CW6@calendula>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula>
 <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org>
 <ZvqeEa_37KEmL8li@calendula>
 <87cyklm7i2.fsf@nvidia.com>
 <ZvrZciPsfppMf9dl@calendula>
 <ZvrbgAHBWknkk2fe@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZvrbgAHBWknkk2fe@calendula>
X-Spam-Score: -1.9 (-)

On Mon, Sep 30, 2024 at 07:10:27PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 30, 2024 at 07:01:42PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 30, 2024 at 06:25:17PM +0200, Petr Machata wrote:
> > > 
> > > Pablo Neira Ayuso <pablo@netfilter.org> writes:
> > > 
> > > > On Mon, Sep 30, 2024 at 01:45:09PM +0200, Jakub Kicinski wrote:
> > > >> On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
> > > >> > On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
> > > >> > > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
> > > >> > > > Hi,
> > > >> > > > 
> > > >> > > > Is there a plan to build a new version soon? 
> > > >> > > > I am asking since I am planning to use this function in ethtool.  
> > > >> > > 
> > > >> > > ASAP  
> > > >> > 
> > > >> > but one question before... Is this related to NLA_UINT in the kernel?
> > > >> > 
> > > >> > /**
> > > >> >  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
> > > >> >  * @skb: socket buffer to add attribute to
> > > >> >  * @attrtype: attribute type
> > > >> >  * @value: numeric value
> > > >> >  */
> > > >> > static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
> > > >> > {
> > > >> >         u64 tmp64 = value;
> > > >> >         u32 tmp32 = value;
> > > >> > 
> > > >> >         if (tmp64 == tmp32)
> > > >> >                 return nla_put_u32(skb, attrtype, tmp32);
> > > >> >         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
> > > >> > }
> > > >> > 
> > > >> > if I'm correct, it seems kernel always uses either u32 or u64.
> > > >> > 
> > > >> > Userspace assumes u8 and u16 are possible though:
> > > >> > 
> > > >> > +/**
> > > >> > + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
> > > >> > + * \param attr pointer to netlink attribute
> > > >> > + *
> > > >> > + * This function returns the 64-bit value of the attribute payload.
> > > >> > + */
> > > >> > +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
> > > >> > +{
> > > >> > +       switch (mnl_attr_get_payload_len(attr)) {
> > > >> > +       case sizeof(uint8_t):
> > > >> > +               return mnl_attr_get_u8(attr);
> > > >> > +       case sizeof(uint16_t):
> > > >> > +               return mnl_attr_get_u16(attr);
> > > >> > +       case sizeof(uint32_t):
> > > >> > +               return mnl_attr_get_u32(attr);
> > > >> > +       case sizeof(uint64_t):
> > > >> > +               return mnl_attr_get_u64(attr);
> > > >> > +       }
> > > >> > +
> > > >> > +       return -1ULL;
> > > >> > +}
> > > >> > 
> > > >> > Or this is an attempt to provide a helper that allows you fetch for
> > > >> > payload value of 2^3..2^6 bytes?
> > > >> 
> > > >> No preference here, FWIW. Looks like this patch does a different thing
> > > >> than the kernel. But maybe a broader "automatic" helper is useful for
> > > >> user space code.
> > > >
> > > > Not sure. @Danielle: could you clarify your intention?
> > > 
> > > This follows the iproute2 helper, where I was asked to support >32-bit
> > > fields purely as a service to the users, so that one helper can be used
> > > for any integral field.
> > 
> > Which helper are your referring to? Is it modeled after NLA_UINT?
> > 
> > I don't think this patch is fine. This also returns -1ULL so there is
> > no way to know if size is not correct or payload length is 64 bits
> > using UINT64_MAX?
> 
> I found it:
> 
> static inline __u64 rta_getattr_uint(const struct rtattr *rta)
> 
> This only has one user in the tree so far, right?

Well, this is a matter of documenting behaviour.

> include/libnetlink.h:static inline __u64 rta_getattr_uint(const struct rtattr *rta)
> ip/ipnexthop.c:                 nh_grp_stats->packets = rta_getattr_uint(rta);
> ip/ipnexthop.c:                 nh_grp_stats->packets_hw = rta_getattr_uint(rta);
> 
> is this attribute for ipnexthop of NLA_UINT type?

But it seems intention is to support NLA_UINT according to iproute's
commit.

commit 95836fbf35d352f7c031ddac2e6093a935308cc9
Author: Petr Machata <petrm@nvidia.com>
Date:   Thu Mar 14 15:52:12 2024 +0100

    libnetlink: Add rta_getattr_uint()
    
    NLA_UINT attributes have a 4-byte payload if possible, and an 8-byte one if
    necessary. Add a function to extract these. Since we need to dispatch on
    length anyway, make the getter truly universal by supporting also u8 and
    u16.

so it went further to make it universal for 2^3..2^6 values.

I am going to submit a patch to provide more info on this helper function.
