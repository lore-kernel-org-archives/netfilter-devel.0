Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17045039;
	Mon,  8 Jun 2026 22:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780957832; cv=none; b=GWKhtoo/QsPL6NvtihN65X9uD7yO0L28FCSOfDv0zcPRt9W2cxpeUOUmWw7kZIUUOT5TSePFBRZCApe5ETMG9dA9hVFWvNDJd0MLccfirZYicT7WJVqKzhyMbsUFyM6pya8e4w1nEnmCpHya7x7ulVbE1rnFIY0JqmmiwxtFkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780957832; c=relaxed/simple;
	bh=+U/ad3F/SwbcI0smRQz6Zy4vts/dRkjKbEiBAsj7WGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jt7DavhFC6kpnk4TpOxP+H7/8HLW3bIsCPsvhN1A04sZIjvS1WTxmlbpmXlLWWt/5zVZARv76vAh7WXQuYK436biXd6YW2cXHRQcOHTF/V4fLbfEqkGLtw1fzlCKhk7yEQBTxPOCVBGk6/0MN/vS/QGqSd9QkPFXuj8Ivtjb668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pd3a6/Eb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pd3a6/Eb"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EA79560177;
	Tue,  9 Jun 2026 00:30:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780957829;
	bh=8HixyEbDqEKu4zD6QtLGD2nk6dGuDyLSJANkkz2fXTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pd3a6/EbEJpesnW/g9D1igU6YZgKBQH/UGVEmTSsQb7n1ivfOogx9pua03ELL6mtt
	 H8eQ3vQ5dXVofNo+OhYpYll8Vd/YbhThM6JkJ5TUvzu0qR+i7Lzo4KVIe3D1Vb9b7u
	 IaEQ3Za2Y1uD1EPnLhQWWWpzxOR9+xe3EJtfhelnx/0w0B78Q1IX5ZDGXoz4vR41bn
	 cZqKKsnSqyEbAEr+60Hqpv4vEB8qdZHJmH1TTghT7+4We+5vH4QHYlM5ZvXqRjmKkn
	 YiH2gEEtzQF04OS9yh4tZLUJujFP4F9ryt9vEdb9TMKHqGPppqFmL5JtLo5/UIhNs5
	 Y0r8Z1aPom/tQ==
Date: Tue, 9 Jun 2026 00:30:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org, Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH net-next 08/15] netfilter: cttimeout: detach dataplane
 timeout policy and repurpose refcount
Message-ID: <aidCgrrmFJGNF-Th@chamomile>
References: <20260607094954.48892-1-pablo@netfilter.org>
 <20260607094954.48892-9-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260607094954.48892-9-pablo@netfilter.org>

Hi,

On Sun, Jun 07, 2026 at 11:49:47AM +0200, Pablo Neira Ayuso wrote:
> @@ -56,8 +73,14 @@ struct nf_conn_timeout *nf_ct_timeout_ext_add(struct nf_conn *ct,
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
>  	struct nf_conn_timeout *timeout_ext;
>  
> +	if (!timeout)
> +		return NULL;
> +
>  	timeout_ext = nf_ct_ext_add(ct, NF_CT_EXT_TIMEOUT, gfp);
> -	if (timeout_ext == NULL)
> +	if (!timeout_ext || timeout_ext->timeout)
                         ^^^^^^^^^^^^^^^^^^^^^^^
This check is useless, it is always going to be null.


There is also Julian Anastasov issue with documentation.

>> Documentation/networking/ipvs-sysctl.rst:76: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/networking/ipvs-sysctl.rst:76: ERROR: Unexpected section title or transition.

And regarding:

  netfilter: synproxy: fix unaligned memory access in timestamp adjustment

it is fixing the unaligned access, but inet_proto_csum_replace4()
wants 16-bit words starting from an even offset, sashiko reports that
this still would not work in uneven. I don't think this is worth, but
at least it is possible to add a note in the patch description.

I can post a v2 for this PR.
