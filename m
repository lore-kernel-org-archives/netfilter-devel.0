Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A778EEEAB
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 13:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904069; cv=none; b=hc9Q7qnD0AL5shEWz5MRsJwRiSwmhrWlylRMbA1TTaM2i+1YKdEDwvVWyKwR+vcbUHZCJZq42ZJdAHNS7lObsPjve8JYrs2Y0Cbso+e0aeM3M2oz7pgcH5OG1EL57Ut8bgKlaWtlQ8FqkH/JBfjuo2CSDZd26uCdZBMDFt0Qfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904069; c=relaxed/simple;
	bh=OyVxibp55HiKfJhQcO6ez2Ph+Mi1sICgSrLd8QQ4M6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLCOy7JXQ8saa9QhgQmt/4aiqbsLX0zns3ZqmLGqsnOFllaxm/I3xwJ+GpY/cvCuQnqsmQ7Wyp87HMNN+1yeXGTOMusPWSrdezB91VM0c1aUeuDf/xvgDCCzxFk751T8y00Gk4syUj0uIqE1KZyn6x8/9NOfBTPeILfINyPS6Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 02CA76063D; Thu, 12 Feb 2026 14:47:44 +0100 (CET)
Date: Thu, 12 Feb 2026 14:47:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Ross <alan@sleuthco.ai>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] libxtables: refuse to run under file capabilities
Message-ID: <aY3aAChfNI3LWvfO@strlen.de>
References: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>

Alan Ross <alan@sleuthco.ai> wrote:
>  Extend the existing setuid guard in xtables_init() to also detect
>   file capabilities via getauxval(AT_SECURE).

I'll apply this tomorrow unless anyone else has any objections.
