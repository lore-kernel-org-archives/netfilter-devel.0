Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C617131E53
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706127798; cv=none; b=qtfIrntuOaDqng95rH9GdnkVIB+tkHN5Y8SPKBdw85K7OxV39q1R9Uz41ZTDckLWP148+RYzdhga+1ZYdBpYCvvD570ZGT8201/i3VC6plau7MyKFwNG/5t5ElZLImxB4/F9R4dpjyB8TT0BnQlMN46kPsvS+n+49SHPpdCTiKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706127798; c=relaxed/simple;
	bh=eJpfMkVj2mJ/zcHyKR5paWNe77eqbTbtvrafMYeHf2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fy0ytMIVIPDHdG9favUybBrna6p0pxjuG7BEwmerg3IGOmYPX0z2OVjVpECG97lyv6IeksikbD7w3wZqSOc4/T8Zu3mbMinQMDVGriLYwp8QhrBypmtSg6WrlJ0oFcKL8X67eiRddz91QepyUeDBuKzSGsw3XHMeg60Bqi1Mn5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=52060 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rSjmA-006plB-M8; Wed, 24 Jan 2024 21:23:12 +0100
Date: Wed, 24 Jan 2024 21:23:09 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Felix Huettner <felix.huettner@mail.schwarz>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_conntrack 1/2] dump: support filtering by
 zone
Message-ID: <ZbFxrXUrCklFBOSP@calendula>
References: <cover.1701675975.git.felix.huettner@mail.schwarz>
 <f5abe59a5d9577db8a5e07317aab90cede94d90a.1701675975.git.felix.huettner@mail.schwarz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5abe59a5d9577db8a5e07317aab90cede94d90a.1701675975.git.felix.huettner@mail.schwarz>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 09:35:03AM +0000, Felix Huettner wrote:
> diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> index 76b5c27..2e9458a 100644
> --- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> +++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> @@ -547,6 +547,7 @@ enum nfct_filter_dump_attr {
>  	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
>  	NFCT_FILTER_DUMP_L3NUM,		/* uint8_t */
>  	NFCT_FILTER_DUMP_STATUS,	/* struct nfct_filter_dump_mark */
> +	NFCT_FILTER_DUMP_ZONE,		/* uint16_t */
>  	NFCT_FILTER_DUMP_TUPLE,
>  	NFCT_FILTER_DUMP_MAX
>  };

Applied with nit. I had to move NFCT_FILTER_DUMP_ZONE after
NFCT_FILTER_DUMP_TUPLE in enum nfct_filter_dump_attr, otherwise it
breaks ABI.
