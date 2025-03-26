Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627EF23C8CD
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017225; cv=none; b=tFrL2+gWJzEaqgmYGZLKE125ThYkGrJ6ibUptEHXuZ8zB9WC+TCCYbjloSds8MuaT39qy7kRindbAbETAQeThZL6VALvtOsqtYE20+WWs/mGCzHSykGtilB9lii4QTeSwV6BqI5ICF+Q3FiXNEFPH47+hWxCq0Tc5KF+JsRHcsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017225; c=relaxed/simple;
	bh=t7jLT4m580iAgEhau5q4O1JCadEbpLLvplq50YMwkEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oE5sftW7te32lSHyTrKHN8FwA9ssKlNtkz8R3ETmGROwgWi986DRFV4Zm6H1dRcPap2N6wcrJnbIAQB9JcSVH2rllrP86b+70cPEzf2a5hH0iv+Po7i6Kj9Wm7ilKZhGfs5XVG/Y0ahN2MwrLZ4WzcLs7KPpkNpdnw2czoI6Vkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1txWOz-0000jN-Or; Wed, 26 Mar 2025 20:27:01 +0100
Date: Wed, 26 Mar 2025 20:27:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2,v2 3/4] nflog: add network namespace support
Message-ID: <20250326192701.GB2205@breakpoint.cc>
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
 <0e7e461d-a30a-42af-9427-96cd97eb108d@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e7e461d-a30a-42af-9427-96cd97eb108d@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> +	if ((strlen(target_netns_path) > 0) &&
> +	    (join_netns_fd(source_netns_fd, NULL) != ULOGD_IRET_OK)
> +	   ) {
> +		ulogd_log(ULOGD_FATAL, "error joining source network "
> +		                       "namespace\n");
> +		goto out_handle;
> +	}
> +	source_netns_fd = -1;
> +

This looks buggy, but I do realize that join_netns_fd() closes this
for us.

Maybe a comment would help?
