Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9B18DF76
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 10:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727693788; cv=none; b=Z9bnMIzYkelKrG51goroxoWTMFBZHy/W4RSfO35UgklY0M9LzamvCmZLJ9kDmAgCNm4PdGVCciTJsLdTlUdtbTaopG0LSSgb7/EXn6wGdfMLuU+VHAOkIsg20BwojFA+ouAGuLsT5+L5L+eG6389nzoq74UFFi+a4dOdc00Hh8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727693788; c=relaxed/simple;
	bh=pqwIp3YZKhtCYMmBKK2tNECX5uwHiib4zorr0+8XdSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLXLGMB7iOlfb1nIynS+6rZDEWBJX/Cv7S6DyFyy/cOSyZrrQpmD6GZzrbquuRtLfO7cBzv94SnTc6n3sjyI3z6Xf0SEENqQP8dJ6Dp4540WIbqEPEfs3HOnbfyY5HiNImfd6ekofPL4ju81WOfXzvNsfv+hhe+1q6F91Brfj2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40614 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svE4j-008100-3I; Mon, 30 Sep 2024 12:56:23 +0200
Date: Mon, 30 Sep 2024 12:56:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Danielle Ratson <danieller@nvidia.com>
Cc: Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>,
	kuba@kernel.org
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Message-ID: <ZvqD1CmbNg_UAGQY@calendula>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zvp9NShxCERRPDdi@calendula>
X-Spam-Score: -1.9 (-)

Cc'ing Jakub.

On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:
> > Hi,
> > 
> > Is there a plan to build a new version soon? 
> > I am asking since I am planning to use this function in ethtool.
> 
> ASAP

but one question before... Is this related to NLA_UINT in the kernel?

/**
 * nla_put_uint - Add a variable-size unsigned int to a socket buffer
 * @skb: socket buffer to add attribute to
 * @attrtype: attribute type
 * @value: numeric value
 */
static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
{
        u64 tmp64 = value;
        u32 tmp32 = value;

        if (tmp64 == tmp32)
                return nla_put_u32(skb, attrtype, tmp32);
        return nla_put(skb, attrtype, sizeof(u64), &tmp64);
}

if I'm correct, it seems kernel always uses either u32 or u64.

Userspace assumes u8 and u16 are possible though:

+/**
+ * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
+ * \param attr pointer to netlink attribute
+ *
+ * This function returns the 64-bit value of the attribute payload.
+ */
+EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
+{
+       switch (mnl_attr_get_payload_len(attr)) {
+       case sizeof(uint8_t):
+               return mnl_attr_get_u8(attr);
+       case sizeof(uint16_t):
+               return mnl_attr_get_u16(attr);
+       case sizeof(uint32_t):
+               return mnl_attr_get_u32(attr);
+       case sizeof(uint64_t):
+               return mnl_attr_get_u64(attr);
+       }
+
+       return -1ULL;
+}

Or this is an attempt to provide a helper that allows you fetch for
payload value of 2^3..2^6 bytes?

Thanks.
