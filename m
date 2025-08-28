Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF401B0F1E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385616; cv=none; b=GX5r+yy5xSPXAoVH+u5hdV8xe4HVq3TaeL3MYij6/fDBGr4V0vemBp8KqsLFiN5cgxMinN4UyoTFPaGk3xiV/nbjLkEbkk/aA7TxYyHMN32IQpzJqUUs8GHi0kWen3SkMqHKgmYIJAAH6uyOlbgBXdzFSF4Yg9/6P8M8wndNRe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385616; c=relaxed/simple;
	bh=hwjArDS80VzqUnD8LehjHhv/XHgkGuSI/FGZ1CmyuPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R7VXpb8LwIbyfcGQgMSqWoZvYvsBzj1ZtwzGmMOYAPoNcn+sjYDjD6IPVORKr2e7k3KucVPvsuumYPwFq/wjUTpyPFS383k0yL67ilqJ7NCVF06CyNWb5m7KSlq7eYcIftIceguu/JsNdLKd45SDkNPekJtlSJCROGrrkOgLxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CCKf7IeN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GbVO56sU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CCKf7IeN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GbVO56sU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 81E1760703; Thu, 28 Aug 2025 14:53:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756385613;
	bh=QtnKkGBiQj8sti3fgX0JwfDLnXqBzaDkPZzkdzgua2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CCKf7IeNOkBWVEd+gEanAwWYLaB2VvjhxQ7tZgG0bxMnYZEqNNqeM9udAJzrOaYbl
	 73oEFF2DD4iuaeOzQg4L41j0L9W4v2WutXB2yLysewFuMyreplDMgRwthLiyAqCn3Z
	 aA9bTG38rEYrnw3dtgcctdUpMlz8OtH4fbtVX8sFCjT8W3pbV1Do+lsIZum4vI3s/W
	 BdeTq8xYODR3CVn9xqTMxYghaVtO7Hf09TJruNmRO0Xpn87k5bAX0gwKduTZkmFtQR
	 itsAInvKhKpV62/i5iG8ktEuKTBg9Y++LdxAF/Xncwg/uX7gHTKssXuheMzk0YSH6x
	 RVTl6hRlcQj8Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 704B360703;
	Thu, 28 Aug 2025 14:53:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756385612;
	bh=QtnKkGBiQj8sti3fgX0JwfDLnXqBzaDkPZzkdzgua2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GbVO56sUHo/RPwIJ0Wu2ACGIErcTtSZhPN5SPGD3FQvNj7ZHjV3iomUa/ZuN7Bhix
	 sDNj4baRX6Wg3nuMlXqWnNwsjDVyQGs5wS+rKxNskbOr6MmQ/j4U7ABXwH5vEtr5qV
	 TQ1cj7WlU+4S6qZrTQ35K+iMNls4KShxHrMrkrk1+C4xUmQIHxLZqT8h9wUQQb2Ggx
	 r9WBPZcqDHhgTmzh9z8/sW2DCI/P/QR2JVTt6GdzdPOiOaKX/CsdMRI10UIg2p9W3l
	 Jm9CcE27JIP6t6wxoIk2vpnI2Ew02SwUQ36QVF1pcCe5/kf6W2HgKfYSmmhDgc+P5e
	 9R0L43VS37m4g==
Date: Thu, 28 Aug 2025 14:53:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aLBRSR5AXpt5M_7x@calendula>
References: <20250813170833.28585-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813170833.28585-1-phil@nwl.cc>

Hi Phil,

I know this is applied, but one late question.

On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> @@ -806,6 +815,29 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
>  	return 0;
>  }
>  
> +static int version_cmp(const struct nftnl_udata **ud)
> +{
> +	const char *udbuf;
> +	size_t i;
> +
> +	/* netlink attribute lengths checked by table_parse_udata_cb() */
> +	if (ud[NFTNL_UDATA_TABLE_NFTVER]) {
> +		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTVER]);
> +		for (i = 0; i < sizeof(nftversion); i++) {
> +			if (nftversion[i] != udbuf[i])
> +				return nftversion[i] - udbuf[i];
> +		}
> +	}
> +	if (ud[NFTNL_UDATA_TABLE_NFTBLD]) {
> +		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTBLD]);
> +		for (i = 0; i < sizeof(nftbuildstamp); i++) {
> +			if (nftbuildstamp[i] != udbuf[i])
> +				return nftbuildstamp[i] - udbuf[i];
> +		}
> +	}

One situation I was considering:

1.0.6.y (build today) in the host
1.1.5 (build n days ago) in the container

This will display the warning.

I suggested to use build time only when version is the same?

If the scenario is nftables in the host injects tables into container,
then host binary will likely be updated more often.

IIUC, the build time here will actually determine when the warning is
emitted, regardless the version.
