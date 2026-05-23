Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017F525B080
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 08:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779524930; cv=none; b=RHEVTAifoJALhsViDceddENwzhjHbRDuqzlPywtWRz5ZtBNdM+N/ADeNLM9SvapGdBPnCXeMz6F/jVMtoTBpmVLuAWAnvBEIz7RrO6678tdVbrMe0FHjl3DJ8X+s7OGMq8Odb62QY7rW0qodLp1nM1LdyL5/lZ2lWaGWqSADJ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779524930; c=relaxed/simple;
	bh=jB9FDhrNwOL64ty/eoFc2tYfqdHa1Dk3JDsG8h92c4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTlxWaTK/8oBTLMUGlLMR4rvza0utREy14tOgH2zknDQHLk/5xIPiN+TolwHoMdd6zxhFfyM6WOBZnc8JoPdYCpUe6COEQA5XkMVl2vK5NKeQYflR8VWsN270wc4l3FatOodxm6Jj+NfbWVNq0M1aYMjeedoJGmjT5qWargZfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MXnPHn5a; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MXnPHn5a"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CD95A60181;
	Sat, 23 May 2026 10:28:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779524925;
	bh=Il+Zh+N7xGCUsk3cWs4cpxAeLU/kwEKT13OdDSWA6yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MXnPHn5aKhrkRlb/24KvctA+IbormNGb6bE7Bs7QA7Hf8RvvCNMwJRg/aDKAiaBxO
	 +6rtafrZaiaESuhRQ8KUHzsep3GiW3argQh+zEDDLTgSsCEb0U5Jgq8beisgeYbRml
	 kA9xQg9ey0V8d2hRG4H/FbMY32uoB+EGKKCiBBL5GIrDuTjEUH94eEpdP3lsu4IBUu
	 CiiZtKgz6QVjbC0GB+iPECfHfNJzp5JI0hyCxpKRRk99HOSBeIQQPJz1XSTwMmK53z
	 y0MMRD6XmIoK5RvbqgUx2JZLs7lvstlSmZQfCj42m139h2aaxq/u7dGgwbMuCP7s1T
	 Zoz3l1tgT+YDQ==
Date: Sat, 23 May 2026 10:28:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] netfilter: conntrack: remove some code
Message-ID: <ahFlOnRe6HxXDLJ3@chamomile>
References: <20260522050140.4838-1-fw@strlen.de>
 <ahFJGSir1oJ5i7Fb@chamomile>
 <ahFWpR_boNDHZUmO@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahFWpR_boNDHZUmO@strlen.de>

On Sat, May 23, 2026 at 09:26:29AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I have been working this week on fixing the helper infrastructure as I
> > told you, my series is directly clashing with this.
> > It's is taking me a bit of time to make sure to validate this is
> > correct but I can hopefully post it asap.
> 
> No need to rush, this one needs a new revision anyway.  I will wait
> until your series is applied before doing a v2.

I am finishing the review and testing, it is a change in the direction
of the previous series to tackle the issues, by dynamically allocating
the timeout and helper and refcnt to track packet path/ct extension
users. I can post this series later today / early morning tomorrow.

> If you like you can integrate the last patch of this series (irc/pptp
> deprecation) into yours, that patch isn' strictly related to the
> others.

Thanks, if my fixes are deemed correct, I'd appreciate that rebase on
top.
