Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146E1442B1D;
	Fri, 31 Jul 2026 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512233; cv=none; b=rZQ3aSmwKtIhe406ADMqp9puPwBIAY04iA/zrpX4bqpOMWDPEngG4H5LQOyHUbr0UJvYLcYCMgK7aQQlHG9WeRTEqtXC6vAWACb5EY2JO3bEwlmEdE6x4q1X+TMTX9Ko864GW/uFhKrQYhN3JJ1eneQ9mEyxszfzJcvWxuDmwLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512233; c=relaxed/simple;
	bh=0sBDKBsJe4Zi04fFTxmiDSJZIAhaXamUeVXLMj5Yq9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXrN74UqeD0bYFbztiwJAuIYXAYwpg1/0fApYNN+TCanbAUaAAMyWRisJ/T7L0l0G1qvgiyiQwPsptsa96Zh9Vk+sus6bjWTJ5DhJAHVXFz69/tCdAXsASYZCSpepUFhlXqS4A4RQgcU/kRg2/wOx/w0QnoXCozg/ptpjN9aCco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T1fIQY2c; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T1fIQY2c"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B6211601A8;
	Fri, 31 Jul 2026 17:37:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512229;
	bh=Gtyue+FDmTCXzQ883/mbAImlHf7blfYdPuwqN+XQOm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1fIQY2cO56VQhPcmVXQVtv8B2kPPyeMRrX+q441fNVvZsVw/eRzBs8iVOFk4rdDY
	 B9Fah8GIM/O34GYKfOTfV3eHjrjDlVval9Ru0nZvHuA7YOZmN19ALQ+FgTN2HWJsX4
	 xYze15jK8gi743JFdLYemNQGhfYfUmPR+sSLrkN03yuZ6xn7Imwubu3Iq+WSbkZqZQ
	 FkCvmM7jvDfaiknhz3mAXYHEoYJS5EKZecYLHTAhBJBj3DPXw/LbKYHI7Xec74rISG
	 lzJE/IPK0xDFRrRToaYO1/KTMuzv2GjSsxR/0kvDd5AZHmJehFRqRJ0o+DInJIBKeA
	 h3E9RR5LEFVMg==
Date: Fri, 31 Jul 2026 17:37:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Lee <david.lee@trailofbits.com>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	phil@nwl.cc, horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack: prevent helper extension
 relocation
Message-ID: <amzBI6YKhMX3Ezib@chamomile>
References: <20260731140811.566714-1-david.lee@trailofbits.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731140811.566714-1-david.lee@trailofbits.com>

On Fri, Jul 31, 2026 at 02:08:10PM +0000, David Lee wrote:
> struct nf_conn_help contains the head of the per-master expectation
> list. hlist_add_head_rcu() makes the first expectation node point back to
> that head, but nf_ct_ext_add() can later move the extension buffer with
> krealloc(). This leaves the node backpointer aimed at freed memory, so
> unlinking the expectation writes through a stale pointer.
> 
> Reserve the full u8-addressable extension space when adding the helper
> extension and reuse the existing buffer once the helper is present. This
> keeps the expectation list head stable while allowing later extensions
> to be added.
> 
> Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
> Bug found and triaged by OpenAI Security Research and 
> validated by Trail of Bits.

Thanks for your patch.

This is a duplicate of:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260715144755.00ea7dfcd9f@proton.me/

proposed fix tackles the problem from the ct expectation feature angle:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260730150305.617144-1-pablo@netfilter.org/
