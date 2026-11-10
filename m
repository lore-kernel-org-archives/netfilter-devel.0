Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317950;
	b=y8aBv8hlDHh1+Jjy+TBhWMHMdhKYtf+avxVgQ/OgYcuDqhn2pwG3AEUPab5MJo6CgxYu
	 A28GV1RB18fPuSqmS61InnVBHSKKDr3E85aPJNFb/GvEKzqGnz6ABO1G5eJ68XYdOPh7R
	 1oGCNSZyGkv757MmpyMj3kmHz/h0kkeVhszqDtUQCriliqIZgta5uMJw8hIkqalZgFl2d
	 hP0ijoX8R+OpdfRdcFcUNCMaXR5ME5WJB35itcc+jPeJsWZQYkT9JI5QHi6bhNCRbUhWu
	 YTa0AFoTl0ICUF+kTys4tDFtbPNdc8bROqMVxNMGuUb6dUlI9ruFWqFRy0hP2PDJSBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317950;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wFNfiDrDQ62dob1raYQmpfkK1loXqPmROX0zVcY9fbA=;
	b=5DfikNzjnGZG+OmK9gVqdZUgfxgpDVS6SoBykO6D5eI+kkzaC/lwkO2zH5F2CQlDX1b8
	 /g8Jqz69qem0pZjBHEzqvU/UqpasGF6DFjGk5itrsYPTHHpkcFcTpDbbKuS7MweYGJjIy
	 EhYYLPwcOOy3jbo4HCubZlkwIk9tLIgEncLrTFzocQ2rS4lVnOe6VzIOnsrCjzKBJGO4I
	 9OjCjJSq3iRQNYk1wCtl4QPCUEoySC1TQbN39BskbF2b512OEKqHTbJijNpQVep1CkeWp
	 mpjs2P8k9PyGs2rGTvHcuCIMZF32Sz92UrauR2t9U9ebdhwpyT9O0UqqkFTCKLdhvkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FFF606A31C;
	Tue, 10 Nov 2026 13:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9FFF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AD46B60342; Tue, 10 Nov 2026 14:39:06 +0100 (CET)
Date: Tue, 10 Nov 2026 14:39:06 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: JiangJieHua <jiangjiehua1@huawei.com>, Paul Moore <paul@paul-moore.com>,
	audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	zhangchangzhong@huawei.com
Subject: Re: [PATCH] audit: fix incomplete NETFILTER_PKT records and return
 void
Message-ID: <avMeegglB__27xqp@strlen.de>
References: <20261110122939.45373-1-jiangjiehua1@huawei.com>
 <avMXzjF9hIcTVc9c@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avMXzjF9hIcTVc9c@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +			goto unknown_proto;
> > +		if (ih->version != 4 || ih->ihl < 5)
> > +			goto unknown_proto;
> > +
> > +		thoff = skb_network_offset(skb) + ih->ihl * 4;
> > +		frag = ntohs(ih->frag_off) & IP_OFFSET;
> 
> Are we going to add all these validations everywhere in the code?
> 
> So we will have to validate that the IPv4 header is well-formed over
> and over again?

Bridge doesn't check/validate ip headers.

I agree it would be best to have a central helper for this, this
copypastry has gotten out of hand.
