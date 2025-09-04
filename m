Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF72459D4
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756998994; cv=none; b=VG/FqK2usvR1okxiht9KMM4Rv6P5RwLWXlnL1As71eVMcvP5J8JwuNwPsqODtm5R6TT5TGqXPMJj+bMCzvS/Vt3yO2MYObPD4r2lq1rSwOmEgx9k0SBu+nXD1CFoMjfosQF1vLy6i1seJZ1Abin9S1ncs1K1kALjNmcgz+6M/S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756998994; c=relaxed/simple;
	bh=m8X22b1oQjR0E1q/dBsbZnVHRrxP/bwHQColl9cJOj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPRCAyUxQWDp1mJ8BzSukLfu9vzD4UN6GjvjMBCvCcpnZ84GFdegVzvZ9c08deddonvjeJ6KXH6P3IrWuA3snA7nmsE50G62dTxI4J1a7lv1IsV3cGfnpQ08+VX5GBo/bxoXCOpl6s6pFnC006nQrIahFSSiBCvUPk6ECTEm6D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t3gTw66C; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tB7HcQJz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t3gTw66C";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tB7HcQJz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3705B6080E; Thu,  4 Sep 2025 17:16:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756998983;
	bh=MwmTjEPsgBfo5EjlVSgZwuV8ieElvfSYjmyF+t58EeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t3gTw66ChOuu9WfMd7ZtgnkzMxcJOeMsslbppymOUsRMlj/Qau/TGTOQ6ICrccrdc
	 8Wc0PLfOTSdo/KHS3knxQCzjhwsc2/ZSe3CBKEaVxpaSuGDbP1o8V38q6stLx+BO32
	 9B1qV56cwv5dc5I2ILDuOJ9E1D0Qg3gH+Td8GEh6Ya+rvRWPaJhtIXNk3+eyHKfUtM
	 +fqfI/sCdjODfxL2hBioYTPHj9CbTPF6AVebweW6SPIALf+8FRJF3b+LtbnwTCdWxn
	 dYq6Itdq+lVkmZ1doeAWHKD6/TbyxwHiEfGFqvX1EWck3TpeIdr44gCpsu0i2njFoj
	 FqPPRNgswizcQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4EF6D6080E;
	Thu,  4 Sep 2025 17:16:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756998982;
	bh=MwmTjEPsgBfo5EjlVSgZwuV8ieElvfSYjmyF+t58EeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tB7HcQJzqQeVK2L479J9fiO8qBekzPn2zsLcFqnpFoClbXZYxi77uMOPY2AyPMecJ
	 oZ1fnv9cKYfBxMR875LlrbnsU3r7Eo60FPa9paV8qPbfCTtMp/Ki1QBjAvE0dTJIB3
	 MVSwZRUVQBva6cNP5nlUmgwucwM3cgYcu5rWKXjhwX4jvZhYxyMlmF4HLcdIQ2luQ0
	 yb5Ml7jvA7PwFvdm9CPXWEY5CcyvzFI9a+jJWtDzVKnfWL0UZ3cwo3bYhH6vRvKPNQ
	 k0YluwehsJa0wOYFO1JOcQ9J0cq1ManPsPEutH/P654DNreq2A7BjPxhZg2KTv/9Uy
	 ecpU7KzrXxYVQ==
Date: Thu, 4 Sep 2025 17:16:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v5 1/3] mnl: Support simple wildcards in netdev hooks
Message-ID: <aLmtQ47BLcj5AC11@calendula>
References: <20250731222945.27611-1-phil@nwl.cc>
 <20250731222945.27611-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250731222945.27611-2-phil@nwl.cc>

Hi Phil,

NFTA_DEVICE_PREFIX is now available in net.git, let's pick up on this.

On Fri, Aug 01, 2025 at 12:29:43AM +0200, Phil Sutter wrote:
> When building NFTA_{FLOWTABLE_,}HOOK_DEVS attributes, detect trailing
> asterisks in interface names and transmit the leading part in a
> NFTA_DEVICE_PREFIX attribute.
> 
> Deserialization (i.e., appending asterisk to interface prefixes returned
> in NFTA_DEVICE_PREFIX atributes happens in libnftnl.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v4:
> - Introduce and use NFTA_DEVICE_PREFIX which contains a NUL-terminated
>   string as well but signals the kernel to interpret it as a prefix to
>   match interfaces on.
> - Do not send wildcards in NFTA_HOOK_DEV: On one hand, the kernel can't
>   detect them anymore since they are NUL-terminated as well. On the
>   other, it would defeat the purpose of having NFTA_DEVICE_PREFIX, which
>   is to not crash old user space.
> 
> Changes since v3:
> - Use uint16_t for 'attr' parameter and size_t for 'len' variable
> - Use mnl_nft_ prefix for the helper function
> 
> Changes since v2:
> - Introduce mnl_attr_put_ifname() to perform the conditional
>   mnl_attr_put() parameter adjustment
> - Sanity-check array index in above function to avoid out-of-bounds
>   access
> ---
>  include/linux/netfilter/nf_tables.h |  2 ++
>  src/mnl.c                           | 26 +++++++++++++++++++++++---
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index f57963e89fd16..b38d4780ae8c8 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -1774,10 +1774,12 @@ enum nft_synproxy_attributes {
>   * enum nft_device_attributes - nf_tables device netlink attributes
>   *
>   * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
> + * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
>   */
>  enum nft_devices_attributes {
>  	NFTA_DEVICE_UNSPEC,
>  	NFTA_DEVICE_NAME,
> +	NFTA_DEVICE_PREFIX,
>  	__NFTA_DEVICE_MAX
>  };
>  #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
> diff --git a/src/mnl.c b/src/mnl.c
> index 43229f2498e55..b532b8ff00c1e 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -795,6 +795,26 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
>  	free_const(dev_array);
>  }
>  
> +static bool is_wildcard_str(const char *str)
> +{
> +	size_t len = strlen(str);
> +
> +	if (len < 1 || str[len - 1] != '*')
> +		return false;
> +	if (len < 2 || str[len - 2] != '\\')
> +		return true;
> +	/* XXX: ignore backslash escaping for now */

Is this comment here still valid?

> +	return false;
> +}
> +
> +static void mnl_nft_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname)
> +{
> +	uint16_t attr = is_wildcard_str(ifname) ?
> +			NFTA_DEVICE_PREFIX : NFTA_DEVICE_NAME;
> +
> +	mnl_attr_put_strz(nlh, attr, ifname);
> +}
> +
>  static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
>  {
>  	const struct expr *dev_expr = cmd->chain->dev_expr;
> @@ -803,14 +823,14 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
>  	int i, num_devs = 0;
>  
>  	dev_array = nft_dev_array(dev_expr, &num_devs);
> -	if (num_devs == 1) {
> +	if (num_devs == 1 && !is_wildcard_str(dev_array[0].ifname)) {
>  		cmd_add_loc(cmd, nlh, dev_array[0].location);
>  		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
>  	} else {
>  		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
>  		for (i = 0; i < num_devs; i++) {
>  			cmd_add_loc(cmd, nlh, dev_array[i].location);
> -			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
> +			mnl_nft_attr_put_ifname(nlh, dev_array[i].ifname);
>  		}
>  		mnl_attr_nest_end(nlh, nest_dev);
>  	}
> @@ -2091,7 +2111,7 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
>  	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
>  	for (i = 0; i < num_devs; i++) {
>  		cmd_add_loc(cmd, nlh, dev_array[i].location);
> -		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
> +		mnl_nft_attr_put_ifname(nlh, dev_array[i].ifname);
>  	}
>  
>  	mnl_attr_nest_end(nlh, nest_dev);
> -- 
> 2.49.0
> 
