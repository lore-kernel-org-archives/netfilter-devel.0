Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94448987E;
	Fri, 31 Jul 2026 23:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541271; cv=none; b=E6HD73QKB53eeAU1lPJPsAZK3hwa+yA0T1ciHiGhHMypPqh2h6u4ss0hN61jVo4gxlEG1/lyYiw8oHoaCy3pH9UYchUZ+K8gd5rkSY4n07KP3Er0CBUHBvhvVrThG2/nxmPinOKv+DUpgPBQn8/owqEO9/wJNk4SxrfPsz9w7MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541271; c=relaxed/simple;
	bh=eoq7u4/BUxBuwMlUCDBYXBtoCDWFxQINr60fZ4Ypy04=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKsbYC3p36Yi1Cy8/A651iyEv76jKX4vrBRGQoq48dtWVTFo+2aZzhWQ3GQ610sP0KCU++S6OkR18Dnu7CiZR/5exgr2KVRmg/BPuOCmY310ajVlGhyUhTM6jrhNzFTzRM3zPSzyCa4N8OxbEmcu3gPXpGIm6rwC75AMpOoUWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAqwJrq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAqwJrq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E741F00AC4;
	Fri, 31 Jul 2026 23:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785541270;
	bh=4Z9Ujll1w6KYKX0+vYOft86QtJRzLkq/a2RSvR2WYSk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KAqwJrq60zZl3xbCNYpy/x4Czm9wbuUenlYw6XVmv2WkW2Jx6tF6Hx+Sz+bpCsfyR
	 rdN29i/vmvP3j4i7mt7qoKzXmFJakmggbdXHvJnO9GXyojX/u+e1WLOzYHKS7rtm9v
	 lT2mGEEVBBKVd6olBOI2Hsh9gZlP6sWfVb8Vq4xvl8xABonMK1eRFX9TkXZ2bYqoRV
	 cen4sJl9k4Q3hOLdIRIyLBZhgGr6S42ZaLw2Y1rXMtD8boj3op4ucd24YgksphhTuI
	 /DNX2SV4zG55xfyyAVLoUiVRNBJhiKFkVkEWYBLja6x3vJu2TCJMA2NoSFN5+emU8T
	 y1sBDKd2p5yxw==
Date: Fri, 31 Jul 2026 16:41:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zhiling Zou <zhilinz@nebusec.ai>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
 razor@blackwall.org, idosch@nvidia.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org, vega@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: bridge: release template ct on non-IP
 path
Message-ID: <20260731164109.3a342ef1@kernel.org>
In-Reply-To: <amzDnLMB9bZDP4rw@chamomile>
References: <cover.1785479514.git.zhilinz@nebusec.ai>
	<3cf187b612fd78f8835fa9dad870326ce380f82f.1785479514.git.zhilinz@nebusec.ai>
	<20260731080233.1956d41c@kernel.org>
	<amzDnLMB9bZDP4rw@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 17:47:40 +0200 Pablo Neira Ayuso wrote:
> On Fri, Jul 31, 2026 at 08:02:33AM -0700, Jakub Kicinski wrote:
> > On Fri, 31 Jul 2026 14:36:53 +0800 Zhiling Zou wrote:  
> > > A bridge nftables ct zone set rule can attach a conntrack template to
> > > an skb before nf_ct_bridge_pre() sees it. For non-IPv4 and non-IPv6
> > > EtherTypes, nf_ct_bridge_pre() currently overwrites skb->_nfct with
> > > IP_CT_UNTRACKED without releasing the existing template reference.  
> > 
> > could be a coincidence but around the time this landed in our test tree
> > the nft_queue.sh test became more flaky.  
> 
> Maybe this patch could be causing it?
> 
> [nf,v3,1/1] netfilter: validate L4 headers after userspace packet writes
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/587830a57a593c4b621f7e8e94b2ddc73e6becb0.1785468829.git.zhilinz@nebusec.ai/
> 
> This is related to nfqueue specifically and it also was posted a few
> hours before the same day?

Yes, that makes more sense. There were some passes after that one go
applied but it's a flake so probably just luck
