Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4762FD69E;
	Tue, 27 Jan 2026 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769513571; cv=none; b=Fq+YKQonXmkuQzrTQXYLYpm3OQfvNhTZr5T6SmSjFFpVtShhPNAWJQE6UrQn4DMwTCYQYTnJOXIrUJ0Dv1R0s4UXB4fSBw4WpbVl/jR+aTE6gjyyB3T8OItRRoEiypjRmB9OZub/QovtQcEKzg/tfum71+f3TLaRX6jCQWEIWFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769513571; c=relaxed/simple;
	bh=EzTP5A8ooaGyTzHA16EJy/+rAQMTN6Cofp/r/Zlkoqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWA9Xj2hty0dmvwYoogmNwVrC3D5vxstukeatGJmWfdPQqKCP494YLIBKaMpW69onk3TKA00lBYs5FdMgJMFcC0EIHT6yk88BtUx8gZ6ZWcEY9b4vqGJ8rPygtz0Ioc4lUUevuFTeuenNYs4fGqhPGrUq2iJ7Dux//6pNvoqXUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9C4266033F; Tue, 27 Jan 2026 12:32:48 +0100 (CET)
Date: Tue, 27 Jan 2026 12:32:48 +0100
From: Florian Westphal <fw@strlen.de>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <aXiiYOxuXVn5YhXG@strlen.de>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
 <20260121184621.198537-6-one-d-wide@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121184621.198537-6-one-d-wide@protonmail.com>

Remy D. Farley <one-d-wide@protonmail.com> wrote:
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
> ---
>  Documentation/netlink/specs/nftables.yaml | 25 +++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
> index 4b1f5b107..ce11312b9 100644
> --- a/Documentation/netlink/specs/nftables.yaml
> +++ b/Documentation/netlink/specs/nftables.yaml
> @@ -1509,6 +1509,31 @@ sub-messages:
>  operations:
>    enum-model: directional
>    list:
> +    -
> +      # Defined as nfnl_compat_subsys in net/netfilter/nft_compat.c
> +      name: getcompat
> +      attribute-set: compat-attrs
> +      fixed-header: nfgenmsg
> +      doc: Get / dump nft_compat info

Whats the intent here?  nft_compat isn't used by nftables, this
is iptables-nft compatibility glue.
