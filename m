Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0C03876C6;
	Thu, 23 Jul 2026 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815729; cv=none; b=LweA8g93yQWhDewBXVNU4mbW3s+p9AP7oD+Jkp1tjI4qEFRiopuhf550l9h1uBDF9QKhbs5ByumoHotpkp6iWy/uyI/+Yff/793HGy2tBE+jTEo5uhu3HikSL/zOkYNi2QmX+DmW+iLLHCQUMYug5gilb+Ho/AMEGt6l6yoHL70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815729; c=relaxed/simple;
	bh=dApdIxuCfeJX1T5nF326X1Ad4ICNMhPHvlm0l2q/B5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bq+b8R2x3is1P8qRlWuKQFRkOWjehr9xPr8vYZkbuewYljkYVzq+FIhnbcRjWLDcyCHrdBL2KjlSHMWEKGewLYjzehLWPUklKkentf8hqNVHsDFtXUjC4csv08k3IzokZi64zZvb7eudDxBeLGyuimnnMhoFWkfvEI2RFbP4ki8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iX3c9ao1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX3c9ao1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE131F000E9;
	Thu, 23 Jul 2026 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784815726;
	bh=HwUa/sJrhvgNZG7kxPqSdvij6oGFSeBAtAkF+4FCwNc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iX3c9ao1LQu810z/A4tyRRSeI9J+MeSPM/vClwpmFKe64VLHb3MkkOxFxW+9wcGbG
	 GFJWbxWngQFxZylXhH2pCSQKw/KcyBCz3uqHtmMOoo8Id/2tL4AVPwU7ecNpmgr9z1
	 M9N9K7f5r4icc/q6utnWN22ZGzWHddNrvTn135vq6TesAzjJ2vm1rRIbFvlqu5AdOc
	 +oCW+wPLqdEzy0joLRBkRF4a7kyVA8P00TE8Q62J2iy/l/TdLDeVzYiq4VspbXhtTv
	 oe4afnWFqDKXCYJonDmqO3HHaRo06SLfUa+PncsXqy/CggfXPLSi5E4s42tQrhLNAm
	 yDRC/aNk7d+YQ==
Date: Thu, 23 Jul 2026 07:08:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 09/13] ipvs: fix the checksum validations
Message-ID: <20260723070845.7855a0f1@kernel.org>
In-Reply-To: <20260722211420.153933-10-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
	<20260722211420.153933-10-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Jul 2026 23:14:16 +0200 Pablo Neira Ayuso wrote:
> +/**
> + * ip_vs_checksum_common_check - validate checksum for TCP/UDP/ICMP
> + */

this not-really-kdoc comment causes a bunch of new warnings,
and this file was previously warning free. Which in turn
makes our AI reviewer ignore the series. Could you respin?

> +static inline bool ip_vs_checksum_common_check(struct sk_buff *skb,
> +					       int offset, int proto, int af)
> +{
> +	if (!ip_vs_checksum_needed(skb, af))
> +		return true;
> +	return !nf_checksum(skb, NF_INET_LOCAL_IN, offset, proto, af);
> +}
