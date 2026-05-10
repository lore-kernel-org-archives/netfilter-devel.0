Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9A5346769
	for <netfilter-devel@vger.kernel.org>; Sun, 10 May 2026 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778449420; cv=none; b=LuVmhHDyW7WnSTJR9kX+6sAlnkhien+ql+0ApZSXP+o3tCjDXMlM8DUlJ0WDqnddsSGugYPE1iazRdT8jHs6FMX0uc6Q9oTPimKMaHPevc2jXs4/lY5LkCIm7SSW1g0u/X/bbiRQB+NlGdY7hx1uOa8GJVYw/A/QUMeQqJRaHTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778449420; c=relaxed/simple;
	bh=e6QLVY/ygljFB2CoCiKzN5NUU0E1YfCNJO6WTTpSblQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXaaM63/PjhUXNCsiDhLgdPDLQ3c3fBREeQJBsQnRDcRS4bv716OiX4WQtWP3E16spLionBJ7lTfRmc7MG8vRflXPf1zOmOHXeqOtqlDMiFJb6V182aQPY+phSwgXgQUJDSOZPU+Ka2YAe3RkoRIGg6Gp6zNw1wCP1QD3OR7nso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v6T8l9ou; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v6T8l9ou"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EF18760177;
	Sun, 10 May 2026 23:43:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778449410;
	bh=SC3z/yO2zohxkJUb8g+Hs2JV+obUQ79fYv5nyTHP0q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v6T8l9ou22Kn89pV0rCyFcANEJ4rxE0lNVExYWnIWNkx604Z1zOY7F5k3quFWGXZC
	 2nOFOc1Tb3Z3GVKcUkr7O03qGsIwp24hNb5ST+k7uH0gscwbfWJRml5Z+eIyGWwcgx
	 SJlAobTPhnpvcOJAFsV/74eZzg6dwviLOyFqHyiYozmLnlka78vb0Hg8DPYCbGFl4j
	 wzKJJPUzOpTUUTh5TkttVrra0FyTIzl42VdSEjd7fUPSiJixw1WFpfAZ0JeOUd4AxG
	 rBozZDovzZH9WWHaZ3wVIzWIBV2Dh862tHh+vBraVmNAaVphRFjUfOJidNCaJje4KA
	 eg4Fuf5Ro0k8g==
Date: Sun, 10 May 2026 23:43:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v6 0/8] netfilter: ipset fixes
Message-ID: <agD7_1W1G6aYuXPI@chamomile>
References: <20260508205903.10238-1-kadlec@netfilter.org>
 <af7rnaoD7TlglbhL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af7rnaoD7TlglbhL@strlen.de>

On Sat, May 09, 2026 at 10:09:01AM +0200, Florian Westphal wrote:
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > Hi Pablo,
> > 
> > Here follows the new revision of the fixes for the current list
> > of ipset related issues. If sashiko won't find any issues in 
> > the patches themselves, then please consider applying them.
> 
> I think it would make sense to start taking the first 4 patches so we
> make some progress here and Jozsef doesn't have to respin all patches.
> 
> What do you think?

Agreed.
