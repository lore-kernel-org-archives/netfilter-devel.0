Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A1141C89
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 10:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710239703; cv=none; b=jtlaoMDm4IiAz7/HuwDJR/69ZkzYNLTSHXv+8i8nzZOeRcAy54hipefl9xkOrIrEhc9WeQSVbUeDjlZtReP4lU41VWzH6FNoFvlMyMNDzTy9iXeB/KJl5dav7NSWX5HCDWSExgC5ebh+ilhJ72czKZ60JYEiJr7ZJdF4w5eJmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710239703; c=relaxed/simple;
	bh=L5IAh4vt5zr+BsYIhNhVUUvW/F6tWFa1ctG4AO71zog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxH4fl28KRIqi8UWLfy2z9WtWbCToqIcOrDOpUFpxpU/Iv2Y/pLlGwX0j6+Pvtjnmk7q7w1aFio5gRleHYHJ9tli3DNsupD97SR5EvSZBCUeYt2Oi0gJ0y6DtogXD3OZCyzomkI7gN35cydUYn5vuTmHcSQ+iz71HB4IECtuxo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rjzT9-0008Rq-KC; Tue, 12 Mar 2024 11:34:51 +0100
Date: Tue, 12 Mar 2024 11:34:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Sriram Rajagopalan <bglsriram@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft: Wrong payload merge of rule filter - "! --sport xx
 ! --dport xx"
Message-ID: <20240312103451.GA15190@breakpoint.cc>
References: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
 <20240308133718.GC22451@breakpoint.cc>
 <CAPtndGCRdMbE6t8psfdkK=rGyqtYW_t0Q3BPdmSCL_08SQzmmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtndGCRdMbE6t8psfdkK=rGyqtYW_t0Q3BPdmSCL_08SQzmmg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sriram Rajagopalan <bglsriram@gmail.com> wrote:
> Sure, it makes sense to prevent this at the caller of
> payload_do_merge(), i.e within stmt_reduce() itself.

Will you submit a patch?

Thanks,
Florian
