Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5350222568
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 12:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333233; cv=none; b=rT8xhj6TTwi56x/m0U2BKf/SL9WoPRAUgzi0XI34lX+kcfDFCKJXVqHk8gh0Zd375fnCDVEx3JI1QzIt8GXllrfq+UBVwPPlq0XkbZ1hzulO1yYgH0F9UQ5ttgAIFKoJW0pLfNiOrJBPOTfZ55xoy2qXg5JSWq6t5473jtcpHNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333233; c=relaxed/simple;
	bh=j1KFSoMl/+eoDOn7jKFDU0xcNWchCeekqnkPXMVgGec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhF8M4xjUKSq/gT2/K/sfH8Oz1iWRXek47avDNiPcCys7IlY5MUhpirn2yYABjGR9m1hFLhgACjzfkuHlgpN5SyiCTi9rm4ICRSWeobTS8/NWI9k3L2MF+bi6bWSWbslSI2eE31mMU9ASnushmL/WJta2p0Hcqqem7bpEMpJLsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tXTuTd8D; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tXTuTd8D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tXTuTd8D";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tXTuTd8D"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E289260740; Mon,  8 Sep 2025 14:07:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757333228;
	bh=dlyDMoGLuhZva6GFVarEuoTMLqq/odKeBUDB7v6OW1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXTuTd8DKEWyEz6EJyKXqOfmcnYmxcJZQdn5edkA9m7m3iQvQL+r1wKWMDuFjdoeX
	 ho2PvX22Hor56XrmkECCtd5kh2Em4nB0BMYNtkzP2fWge0K8lOKAaMcFB7KWLIHdoB
	 W4nSC7HgOakmMAUJh5v8/+KscXLqjXPZZAxp+6eJDeBzwHHZRCh15YcA7Hfski3CC/
	 YPs4nvgrAW6DN3YHVtskPVX+x+fVaszr5tZoQ2E511I7nFeQuGsrjAG/Dd2NxPjPio
	 aVsCHzMzCLrc5k/3DfEBJwRIljE/P9Evv2/b670ySJkJVFmI81EoEBvX5XcF9gDD4a
	 2sTgzxDszWrrA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DCF8160740;
	Mon,  8 Sep 2025 14:07:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757333228;
	bh=dlyDMoGLuhZva6GFVarEuoTMLqq/odKeBUDB7v6OW1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXTuTd8DKEWyEz6EJyKXqOfmcnYmxcJZQdn5edkA9m7m3iQvQL+r1wKWMDuFjdoeX
	 ho2PvX22Hor56XrmkECCtd5kh2Em4nB0BMYNtkzP2fWge0K8lOKAaMcFB7KWLIHdoB
	 W4nSC7HgOakmMAUJh5v8/+KscXLqjXPZZAxp+6eJDeBzwHHZRCh15YcA7Hfski3CC/
	 YPs4nvgrAW6DN3YHVtskPVX+x+fVaszr5tZoQ2E511I7nFeQuGsrjAG/Dd2NxPjPio
	 aVsCHzMzCLrc5k/3DfEBJwRIljE/P9Evv2/b670ySJkJVFmI81EoEBvX5XcF9gDD4a
	 2sTgzxDszWrrA==
Date: Mon, 8 Sep 2025 14:07:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aL7G6aI4M74hgS8Z@calendula>
References: <20250813170833.28585-1-phil@nwl.cc>
 <aL7GEObOxcH1z4Rb@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aL7GEObOxcH1z4Rb@calendula>

On Mon, Sep 08, 2025 at 02:03:51PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> > Upon listing a table which was created by a newer version of nftables,
> > warn about the potentially incomplete content.
> 
> Compilation breaks for me here:
> 
> In file included from src/netlink.c:13:
> ./nftversion.h:6:20: error: 'MAKE_STAMP' undeclared here (not in a function)
>     6 |         ((uint64_t)MAKE_STAMP >> 56) & 0xff,
>       |                    ^~~~~~~~~~

It breaks when I compile with:

make V=1 CFLAGS+="-fsanitize=address -fsanitize=undefined" -j 16

which I usually do, including valgrind runs, to catch for memory
issues.

Could you look into restoring this? Thanks!
