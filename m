Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8845910A0A;
	Thu, 23 May 2024 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716477169; cv=none; b=unc1sHxDsFLGsKDZngub5k0ZWa7I3TwmvzbWjBGB5TYR3TNZNTGdlVG2irnrODbLH62Z8ByFZOIh/zI+DzRLL3I8j507BOtljZvS2hjjJ8zU/xIpKNiAAKHP4fXSy4Md1qbwTRyaItOjdaBlxetEpirMfNi/Pdlnvgjwke1xz4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716477169; c=relaxed/simple;
	bh=/2JZJ+NgwBkFkdxGrZRWxcDRkjnMuIpIfZagfrfb048=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fmh4HwxY2sZ218WXT0cCYUjEdS33a+taGzGOVqRWaMihN2rkfamu2J4x9s3ZnkPEUk0epEdeXG2bwumyCFSZltxc0ANaX0cd21UWNWHa8YjTWNjpaShs4ioAJ7JVTUsYPaIfiO7okinqPg+hN6YNirE623BRCCPHZf9L+aMLRI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 23 May 2024 17:12:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 4/6] netfilter: nft_payload: skbuff vlan metadata
 mangle support
Message-ID: <Zk9c6TfO6_BRvbkN@calendula>
References: <20240522231355.9802-1-pablo@netfilter.org>
 <20240522231355.9802-5-pablo@netfilter.org>
 <e20cde161e014616d0b4969f2bec22cd80ca2c5a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e20cde161e014616d0b4969f2bec22cd80ca2c5a.camel@redhat.com>

On Thu, May 23, 2024 at 11:26:45AM +0200, Paolo Abeni wrote:
> On Thu, 2024-05-23 at 01:13 +0200, Pablo Neira Ayuso wrote:
> > @@ -801,21 +801,79 @@ struct nft_payload_set {
> >  	u8			csum_flags;
> >  };
> >  
> > +/* This is not struct vlan_hdr. */
> > +struct nft_payload_vlan_hdr {
> > +        __be16          h_vlan_proto;
> > +        __be16          h_vlan_TCI;
> > +};
> > +
> > +static bool
> > +nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
> > +		     int *vlan_hlen)
> > +{
> > +	struct nft_payload_vlan_hdr *vlanh;
> > +	__be16 vlan_proto;
> > +	__be16 vlan_tci;
> > +
> > +	if (offset >= offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto)) {
> > +		*vlan_hlen = VLAN_HLEN;
> > +		return true;
> > +	}
> > +
> > +	switch (offset) {
> > +	case offsetof(struct vlan_ethhdr, h_vlan_proto):
> > +		if (len == 2) {
> > +			vlan_proto = nft_reg_load16(src);
> 
> I'm sorry but the above introduces build warning due to endianess
> mismatch (host -> be)
> 
> > +			skb->vlan_proto = vlan_proto;
> > +		} else if (len == 4) {
> > +			vlanh = (struct nft_payload_vlan_hdr *)src;
> > +			__vlan_hwaccel_put_tag(skb, vlanh->h_vlan_proto,
> > +					       ntohs(vlanh->h_vlan_TCI));
> > +		} else {
> > +			return false;
> > +		}
> > +		break;
> > +	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
> > +		if (len != 2)
> > +			return false;
> > +
> > +		vlan_tci = ntohs(nft_reg_load16(src));
> 
> Similar things here htons() expect a be short int and is receiving a
> u16, vlan_tci is 'be' and the assigned data uses host endianess.
> 
> 
> Could you please address the above?

Sure, I will post v2.
