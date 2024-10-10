Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E91C6F67
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 12:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728564433; cv=none; b=NtATiNXRLi6AlxWM0FfZ9mbpukaNh0+mPL4vsr4nl+zDbpvEz+M2wORyMCFHXVQH3t2QuZBn4/Dx3yYVt35zA1nW+WAPFxOh6DmTWgI//xBTQdOEA0Y3XktfX9WfQnm9+fFbTvltANo4dmqlRFQqviFtA4O81zo+bjpGrfqjwFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728564433; c=relaxed/simple;
	bh=byKPRSdbCbqfPFsx4nv8oJaMRDo5VkIdMcx/SEc8k+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNs729bigCl/OUnrBI8/uFOwkdJVZxPE2OkHWZKz36xEv5fhsM0uUWg1pBC8V3noMH/5/9qwTjvp5PsR3PYHWePOVuKTPXM2WIA53wPzdq6Wf36bc4PflZ127Lku+Psf/mcgvXn/w4pmT/BXqBVsw4qoSwd+An0N6EOFGD5W2Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sysZQ-0000OO-VQ; Thu, 10 Oct 2024 14:47:08 +0200
Date: Thu, 10 Oct 2024 14:47:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Yadan Fan <ydfan@suse.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, Michal Kubecek <mkubecek@suse.de>,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH] nf_conntrack_proto_udp: Set ASSURED for NAT_CLASH
 entries to avoid packets dropped
Message-ID: <20241010124708.GB30424@breakpoint.cc>
References: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Yadan Fan <ydfan@suse.com> wrote:
> c46172147ebb brought the logic that never setting ASSURED to drop NAT_CLASH replies
> in case server is very busy and early_drop logic kicks in.
> 
> However, this will drop all subsequent UDP packets that sent through multiple threads
> of application, we already had a customer reported this issue that impacts their business,
> so deleting this logic to avoid this issue at the moment.
> 
> Fixes: c46172147ebb ("netfilter: conntrack: do not auto-delete clash entries on reply")
> 
> Signed-off-by: Yadan Fan <ydfan@suse.com>


Acked-by: Florian Westphal <fw@strlen.de>
