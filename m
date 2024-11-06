Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A671D4169
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 08:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882083; cv=none; b=lcImgHw1JbXK1r9yvOgK+e1TBgnhT2luC8+VcVZrkuWubPi8mRf7jmVj68KMXakWDVCi8lgmWrzDTasaLUCmoF8+8RhshfVCMsg6xLZP8QXMHG7hCBWyF/YCRzDJTOyP6A0JvhnekDAbaZ7jUh5sM5xVg+3PKU5QYC256Ot2BsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882083; c=relaxed/simple;
	bh=kfWx9d+/1nWj7klntqTlaaJRzYpnPbaia+1UQLZZWxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aulXtVkgHFbuyznI+/TzSKw6HvRE+A6TSjcUmx58+XtrVlR/J+oSf4ub2bwuhF97nJ+K3CcyYIBTIl4qNurCVb0dXTb05x2gkj4OKhRcB5wq0KqNRJx11r9zFtD2XI1Z7SXtrNy/ijzeguIdtS3ozf0maQ6/V/AiolxCqDM9DZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8bUs-0000Vx-Oo; Wed, 06 Nov 2024 09:34:38 +0100
Date: Wed, 6 Nov 2024 09:34:38 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241106083438.GA1738@breakpoint.cc>
References: <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
 <ZypLmxmAb_Hp2HBS@calendula>
 <20241105173247.GA10152@breakpoint.cc>
 <ZyqoReoNkhz_fo3p@calendula>
 <20241106082644.GA474@breakpoint.cc>
 <Zyspid81oTuwYtcQ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zyspid81oTuwYtcQ@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Can you clarify?  Do you mean skb_tstamp() vs ktime_get_real_ns()
> > or tstamp sampling in general?
> 
> I am referring to ktime_get_real_ns(), I remember to have measured
> 25%-30% performance drop when this is used, but I have not refreshed
> those numbers for long time.
>
> As for skb_tstamp(), I have to dig in the cost of it.

Its not about the cost, its about the sampling method.
If skb has the rx timestamp, then the event will reflect the skb
creation/rx time, not the "event time".  Did that make sense?
