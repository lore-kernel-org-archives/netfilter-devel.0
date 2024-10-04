Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D0A13DDD3;
	Fri,  4 Oct 2024 11:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040502; cv=none; b=DeoXB1rNkjYKYFF/I2ChepplcCJ9/Jw8Nf5Niy1Evg+s+BnP4QhBwd2ZbjJ70UMJVNtqlv/qfrOLPQzpd/cg2fZGVkFb7Sd1lXBO/tHIAT1Emb1Hnxm2M++86Z+lut8VwFZiFBaV3EBL5PfuBnAhtOMSl/g0ZRmkit8/jaEam0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040502; c=relaxed/simple;
	bh=LW23ndT1CxeC4h6uYTBagZ3oCm4WR+VrDPZOUEWaIBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mwd6jSgXxOqPglwuUugYZ1MLBm6f+U+Oa3QTDbRUVA+/FfOSk+wZzZLCUb4XvFVJXGQVNA6DMacJf/aINee/rte6nuWf9v0vaibdNyDxbL+BF4dTH9qDTKCvAn0YlBFegZe2oIIgUyJa6QOe6t+fFYC2tLOgYVI/jowKXFKXdH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=54078 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1swgGt-00FAWP-Bk; Fri, 04 Oct 2024 13:14:57 +0200
Date: Fri, 4 Oct 2024 13:14:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] netfilter: nf_tables: replace deprecated strncpy with
 strscpy_pad
Message-ID: <Zv_OLpeDYCPiPH19@calendula>
References: <20240909-strncpy-net-bridge-netfilter-nft_meta_bridge-c-v1-1-946180aa7909@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240909-strncpy-net-bridge-netfilter-nft_meta_bridge-c-v1-1-946180aa7909@google.com>
X-Spam-Score: -1.8 (-)

On Mon, Sep 09, 2024 at 03:48:39PM -0700, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings [1] and
> as such we should prefer more robust and less ambiguous string interfaces.
> 
> In this particular instance, the usage of strncpy() is fine and works as
> expected. However, towards the goal of [2], we should consider replacing
> it with an alternative as many instances of strncpy() are bug-prone. Its
> removal from the kernel promotes better long term health for the
> codebase.
> 
> The current usage of strncpy() likely just wants the NUL-padding
> behavior offered by strncpy() and doesn't care about the
> NUL-termination. Since the compiler doesn't know the size of @dest, we
> can't use strtomem_pad(). Instead, use strscpy_pad() which behaves
> functionally the same as strncpy() in this context -- as we expect
> br_dev->name to be NUL-terminated itself.

Applied to nf-next
