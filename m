Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55A62F30
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 23:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753399156; cv=none; b=E/iWbHoKj/NGCSnPVdqYgDqaEihP9nfOVjlQmurGTMEQuPj7JPzF3j/91NpUiJpcV3odWwie5fu/cfgCA5M6dYkOv6HSMovm0D14V4+fHG30FnxRQGgan0cZS6i73Ya48I18R+F+uG9du9zToNdjw971jO00oZJnSlHS9ixwM/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753399156; c=relaxed/simple;
	bh=JTU9owwbiZX19NZl8KRC/BRKY2WZeaCe3HEGGbjSpmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfUXfvuu1TZstcB2RF6kwBZa9f4le6Ck0XVs8qiOvHtFAqMwxGthB0//ztvE6BHCrNvGGRxwsgkNvPlQZlRkbJy2joctC7+H3b6CulARDQDvvezqAFYjZ132Ug5GoqaHtQn9Jv8ZBxGAXuUmUr2v4dSm6urhHbwwnde45SRhEjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oIKuzEgZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SMYPQXGF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oIKuzEgZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SMYPQXGF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 366DA60273; Fri, 25 Jul 2025 01:19:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753399149;
	bh=4/eQp4i9uy9pBO6y7jVgVMuWnT5nRbVUkLurb4M9TnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oIKuzEgZi29pfMvXFR0Hed8PCa4wh4zvSi1nzhFHznqxrcJ2W9s13oekZxxjchGK9
	 2m2vxK7DAEkVGUB8t36I5XCRpyOlZHRwNJQzUAvJxOCW9cIyRV85mxTZ+b3VU/NPPP
	 JnGYrFFFjUw1o8eLzxu0EhFy9Dm/24QMfF+ayTCtMTS37ubM5JMYVXYhLxd7jT6WQn
	 jsbMVr3yDgRPofGcWCJED1Tm3hXtCnNYTKg279X1hg3aVjFrVyaLPO+GSA6w9XyfEJ
	 9NL/lxyjL02/43lGCAfN9zw8ecy99R1dPaD7UFaVe8eNLw2l1SubRuvF0X1dsLo7Hi
	 Q6o0x59oXKcnA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 800106026E;
	Fri, 25 Jul 2025 01:19:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753399148;
	bh=4/eQp4i9uy9pBO6y7jVgVMuWnT5nRbVUkLurb4M9TnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SMYPQXGF0VPxDWCIPzRlbSv80rDT+i27cj/Z9RWdEPANIyGlDNnGCfYKvA9ZkhHy+
	 d5Y0XeyYhtGKD3qmvjVhH8FR5TF/K8B4v4AKPRoPBRFhCIuRhMFL/Fq/x6AKAMvCFZ
	 N7qJrwwBt9iRj+FkKn1S7O68YtJ+M68teAngdhTqaA8oqQ09uwvc9KNdInSzPyVQTJ
	 3ybd5j6Y1fv3EiguKF4PZ9e1QbO0315OZbEV3SJMIJAwMkJNgyeAVxhm6OED8MooSu
	 toz3TD0tCcT1Wc0dfCse5/Jlt7Vw5/t7caZyiD9ZuF3i0zRy8TaFMX+4PF5CryAfeG
	 6JjzKy80Tyr5g==
Date: Fri, 25 Jul 2025 01:19:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIK_aSCR67ge5q7s@calendula>
References: <20250704123024.59099-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250704123024.59099-1-fw@strlen.de>

Hi Florian,

On Fri, Jul 04, 2025 at 02:30:16PM +0200, Florian Westphal wrote:
> Removal of many set elements, e.g. during set flush or ruleset
> deletion, can sometimes fail due to memory pressure.
> Reduce likelyhood of this happening and enable sleeping allocations
> for this.

I am exploring to skip the allocation of the transaction objects for
this case. This needs a closer look to deal with batches like:

 delelem + flush set + abort
 flush set + del set + abort

Special care need to be taken to avoid restoring the state of the
element twice on abort.

This would allow to save the memory allocation entirely, as well as
speeding up the transaction handling.

From userspace, the idea would be to print this event:

        flush set inet x y

to skip a large burst of events when a set is flushed.

Is this worth to be pursued?
