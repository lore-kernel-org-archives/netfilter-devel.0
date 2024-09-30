Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BA61E87B
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 11:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727696720; cv=none; b=HChTh6RhU7i0Kp5/EgRYbXJNkmpkjFLQLICrNUeQqevDInEIx3Lm6vXcN0COAJwohs6AJj5hcP6VEqbk6OTksIo0Tx570CV63W7ncd8od3IADHTBdqAOFZ8SxixGLjmSrBrMSbBoWdn+HcXNMUtWYEaG5AGMqL7zfj0xObXWF9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727696720; c=relaxed/simple;
	bh=NJhkoRDBQUmLoRXG9Hce6RadZyf03jcF0nLDJkWGxbI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ilJoV9yfasdrUgn01C/OEegeETMho9iXIC4RxLQ1MpSht8uryBUPMXqC0Vv688ODMc9pyxqkpUZdvngpJThEoFsFnInhugO1kfmNYEvdadCxGo2vE6YLB1hG7/QeJ/Y+l6Eo9GfTsa52/rF7WVl2iksrYbkbN188kxu3e/sT+ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdHfR+f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdHfR+f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A3DC4CEC7;
	Mon, 30 Sep 2024 11:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727696719;
	bh=NJhkoRDBQUmLoRXG9Hce6RadZyf03jcF0nLDJkWGxbI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qdHfR+f95INkFXoZ7i0A3JU880t5KgH+z8b61CcJ2T94NH7bSzsFWhiOcn2JKunUM
	 EDljzKaiSJgnc4hURu4MiRa/pUrIVWnibcbSVg5/5L46XrPHVtxrJkjb2cCkh4OMKg
	 EF89Uxb0hWu5boJ55p+Da8bV5MgTUJ045csULQ+Ac07kePbutD47h/fprO65TqaGGj
	 9oawhSz9s7V2mhdepVEHbSdb6HIkKmbNrZa+cEvzBpiW1Dxo/Zefgsm6BYfr+Zzckv
	 DV69Ny+oALAU89tyWGlhec5avBI6mK6JAfN2NHi7v0zQu0wVKMUdF7oQikWqS7BUiD
	 X7nS8IesI8Djg==
Date: Mon, 30 Sep 2024 13:45:09 +0200
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Danielle Ratson <danieller@nvidia.com>, Phil Sutter <phil@nwl.cc>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 "fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <20240930134509.489b54df@kernel.org>
In-Reply-To: <ZvqD1CmbNg_UAGQY@calendula>
References: <20240731063551.1577681-1-danieller@nvidia.com>
	<ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
	<DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
	<Zvp9NShxCERRPDdi@calendula>
	<ZvqD1CmbNg_UAGQY@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
> On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
> > > Hi,
> > > 
> > > Is there a plan to build a new version soon? 
> > > I am asking since I am planning to use this function in ethtool.  
> > 
> > ASAP  
> 
> but one question before... Is this related to NLA_UINT in the kernel?
> 
> /**
>  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
>  * @skb: socket buffer to add attribute to
>  * @attrtype: attribute type
>  * @value: numeric value
>  */
> static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
> {
>         u64 tmp64 = value;
>         u32 tmp32 = value;
> 
>         if (tmp64 == tmp32)
>                 return nla_put_u32(skb, attrtype, tmp32);
>         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
> }
> 
> if I'm correct, it seems kernel always uses either u32 or u64.
> 
> Userspace assumes u8 and u16 are possible though:
> 
> +/**
> + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
> + * \param attr pointer to netlink attribute
> + *
> + * This function returns the 64-bit value of the attribute payload.
> + */
> +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
> +{
> +       switch (mnl_attr_get_payload_len(attr)) {
> +       case sizeof(uint8_t):
> +               return mnl_attr_get_u8(attr);
> +       case sizeof(uint16_t):
> +               return mnl_attr_get_u16(attr);
> +       case sizeof(uint32_t):
> +               return mnl_attr_get_u32(attr);
> +       case sizeof(uint64_t):
> +               return mnl_attr_get_u64(attr);
> +       }
> +
> +       return -1ULL;
> +}
> 
> Or this is an attempt to provide a helper that allows you fetch for
> payload value of 2^3..2^6 bytes?

No preference here, FWIW. Looks like this patch does a different thing
than the kernel. But maybe a broader "automatic" helper is useful for
user space code.
