Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C06835972;
	Sat,  7 Mar 2026 18:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772906472; cv=none; b=UYvUbmJ9bROLqMa6OTvT58iMWd93xGc/OXWiFMWjxZAYa+4JMwcT0iGnGdIMuiuC3OfA0obV6HfjTCOofWX97RUrHNc2SbkMdHPB/ITyLqlh0Nue0wV3v3b7eWTH1/yA7oIum4KlORmCR35yachh2tR8NK9EpBYifzXdifaTWJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772906472; c=relaxed/simple;
	bh=prN+9XDH2OpRHbxFXdupFODMI4tqRupebqPozZ7WqNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQnprbGYfrMzHSHZIiGLMalUjN7FJksCl/JfQLzstpZODQwcASRHtPC+Vk8/9HS9eGjhXMI5TWkYuJ3LcIGfj5etjb72jC0ojmOX4b7ne0aX2yToF4KKRJo1DEDjPTniGawKtB+JiVlco4BFYTYLaHMghaCgWV28gZYYXaP7NOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B259D602AB; Sat, 07 Mar 2026 19:01:07 +0100 (CET)
Date: Sat, 7 Mar 2026 19:01:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: ctnetlink: validate CTA_EXPECT_NAT_DIR to
 prevent OOB access
Message-ID: <aaxn41hrKcVo7e9M@strlen.de>
References: <aaxew8enOWT853XV@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaxew8enOWT853XV@v4bel>

Hyunwoo Kim <imv4bel@gmail.com> wrote:
> ctnetlink_parse_expect_nat() assigns the user-supplied
> CTA_EXPECT_NAT_DIR value directly to exp->dir without validating that it
> is within the valid range (0 to IP_CT_DIR_MAX-1).  When
> nf_nat_sip_expected() later uses exp->dir as an index into
> ct->master->tuplehash[], an out-of-bounds array access occurs.
> 
> For example, with exp->dir = 100, the access at
> ct->master->tuplehash[100] reads 5600 bytes past the start of a
> 320-byte nf_conn object, causing a slab-out-of-bounds read confirmed by
> UBSAN.
> 
> Validate exp->dir against IP_CT_DIR_MAX before accepting it.

I would prefer a fix for exp_nat_nla_policy so netlink policy validation
can handle this for us.

        [CTA_EXPECT_NAT_DIR] = NLA_POLICY_MAX(NLA_BE32, IPCT_DIR_MAX),

.. should do it.  Might make sense to check all other attrs while at it.
