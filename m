Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415F2158A3C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931270; cv=none; b=t0GL+FwyKg/0R7d4SiBC4aOh8BD7ocRJmp9sQ0KpxwVhB2/X140HuL15PTStahejnLdbODgX7L6/5ZEcnZLUc7zh5ZvENDOHXiNTxnKxiD6uBo7yk4w8XHhawS9QHA3Fj8bP+DyCDJ7lOIIRk7QI83GQSKeAohaoxVyTHgeFIRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931270; c=relaxed/simple;
	bh=tuhYNMrJVvj/jyzQxtLsktpmoM6Z/1vHuYRnX1ZkRfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSkA1CfcnaSf+TbJNrcc7FX08BjFEfVmkAdIupL4ShpWokGPhdd1dH8sdnnB7/yi5dtPRGfvFZKHQYz5G9xI8IQ49mRR/daGBBuYzkD6tVCGsVjmj35nKstmhSRjuthIrSC2wxqHh2zxkB28HoeLlgZmoa5hxKuJej3HZp31chk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B+Uz8wcG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B+Uz8wcG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mUU5z69MXUaSde/LEMrB5ZFnzEo1Ct8TIMJ2DRCWDaI=; b=B+Uz8wcGYL66lDt6L7eB9cFgCK
	JjLKNEIi1NrTHUPBcpori9rtoRAY4Qp1GA2n5co/KDkn4j4rNHGhXszibPDuCQgJxgQPLhRwM7l9p
	ID1/DzqycfEF0ufL2AEiNhjIkGnKZStGC9Gy4aEAfJ9iAJVEv0e8XMa3Wsf/UQHSeZ/MROS/iQScQ
	gngS2xl9r30mIy1EXaYBGvRtfDO8ZECTNmm3SNrznn+PLLGtXVWckneZdYyUOgS1gCzm8xE+G3HDr
	TeP3QwpfnieES75H7W6Gsp8nzfHvNCq4ZMH1Du2+R3CwIjTcpJy8gTqk/K5EKquZcmSDJpSpuApcF
	1G+CWwng==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sjd0i-000000007mE-2s3l;
	Thu, 29 Aug 2024 13:08:16 +0200
Date: Thu, 29 Aug 2024 13:08:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@gmail.com>
Subject: Re: [PATCH iptables 1/1] configure: Determine if musl is used for
 build
Message-ID: <ZtBWoImxzGRBFLs2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Joshua Lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@gmail.com>
References: <20240828124731.553911-1-joshualant@gmail.com>
 <20240828124731.553911-2-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828124731.553911-2-joshualant@gmail.com>

Hi Joshua,

On Wed, Aug 28, 2024 at 01:47:31PM +0100, Joshua Lant wrote:
> Error compiling with musl-libc:
> The commit hash 810f8568f44f5863c2350a39f4f5c8d60f762958
> introduces the netinet/ether.h header into xtables.h, which causes an error due
> to the redefinition of the ethhdr struct, defined in linux/if_ether.h and
> netinet/ether.h. This is fixed by the inclusion of -D__UAPI_DEF_ETHHDR=0 in
> CFLAGS for musl. Automatically check for this macro, since it is defined
> in musl but not in glibc.

Thanks for the patch! I tested and it may be simplified a bit:

[...]
> +	#if defined(__UAPI_DEF_ETHHDR) && __UAPI_DEF_ETHHDR == 0
> +		return 0;
> +	#else
> +		#error error trying musl...
> +	#endif
[...]

Since the non-failure case is the default, this is sufficient:

|       #if ! defined(__UAPI_DEF_ETHHDR) || __UAPI_DEF_ETHHDR != 0
|               #error error trying musl...
|       #endif

Fine with you? If so, I'll push the modified patch out.

Thanks, Phil
