Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD1778C9C
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2026 07:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773559624; cv=none; b=Nw4Gj/mnvDa1cBhkKI/9RLNI6TC7ZH0i/7DCjQWghErkojO9fVd+hryuHzkPktU78ZACusibLENj4ZAYmsKzPgTfORIInIQpkhsQxgEa2IbEjy+yoqi/Oalxq7jsCgd/Ggo4s3rtUh6L0pS187KVGtm63mMMsZWZbJGyA/9Ea1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773559624; c=relaxed/simple;
	bh=9UoUYeCa7EyN1Gw2XyYclPrYJZsdHIByOuWlu3zeyXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ju4m8jfRU999bL+qiTDj5TWSjbbUK7pLI+L8VMHofWia6+9HayjLlEbkd3FWQgTczf31hzqMJF2DnAYNVWf7krys9rAWE92kw5Vz84ozjMI9yWovP7LAo6vAPRaybXaDnZy6QVB35W/SQs0TRBWDq72qFGQMb8a84shQ92I7I/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 50BEB6080C; Sun, 15 Mar 2026 08:26:54 +0100 (CET)
Date: Sun, 15 Mar 2026 08:26:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Guanni Qu <qguanni@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_nat_sip: validate exp->dir in
 nf_nat_sip_expected()
Message-ID: <abZfPZvV1lpmLW89@strlen.de>
References: <20260313201346.562476-1-qguanni@gmail.com>
 <abSelah2hPOUbEng@strlen.de>
 <abVLg641YYZ6TlvM@chamomile>
 <CAFzOa17xzzjC6U7rC647kA-mT9FTMvX+V1Tc7isxeaP4+P5oww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFzOa17xzzjC6U7rC647kA-mT9FTMvX+V1Tc7isxeaP4+P5oww@mail.gmail.com>

Guanni Qu <qguanni@gmail.com> wrote:
> Hi Florian, Pablo,
> 
> You're right, the root cause is the missing ctnetlink validation
> that Florian's patch fixes. I hit this crash while testing SIP NAT
> with crafted expectations via ctnetlink, which is how exp->dir
> ended up out of range.

Thanks for confirming, I'll drop it from pachwork.
