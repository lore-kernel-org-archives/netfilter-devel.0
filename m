Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616293112DC
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756334821; cv=none; b=IzB+afKwyxk7mGA+Vy6QG4M5ADkFxanqFGsOa1ht1Tm6ykP+GF/mDTwXUU+3XgaLcvteY/j++jdjZRGaN/r9TdAr5VHPGD5V1u7dAvdQK39LRxSbmt798xqAcQVjxh8QMl9KLiKWUUGTjoQMhceIPS8UWcMVhSDDNknsM77w0CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756334821; c=relaxed/simple;
	bh=MLvG8AMH1i03UuDITBH4BwazKhE9Es2SfG2MZwviVM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiPwZLq42T4t2I7HbtC5cr38ESR5xe4MPsz+GyYhODiCnxt6mPePzTTkJTxiCyNMcanUBikFTp8ob6CAI2IWrA7el5pO+F5gxk98feVfhS1TZPZclUHiA2Qb2Do/yWsjwNu7p/XPlALDP/C5CnOjKMaJ65XQ/XDtXlGRbnBGvqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JoxjJvfw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JoxjJvfw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JoxjJvfw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JoxjJvfw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D908860602; Thu, 28 Aug 2025 00:46:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756334817;
	bh=Up035gXgOS6I3qdEJuNiV3TiJLRi4DhTwUkEuRXFJsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoxjJvfweocgNAgeYu+Or+5/I12dnO8mImQAo0yBpRvBeHGXXjDEdIH/DLM8+aqZr
	 cDLz+8BPTXz851zRJie3YjIDDlewwZSyiwIqjDyCtCTxf4l+dyz5Lt4YVm6lxxSiqE
	 TZ51wtEyFAlQxPVHaXRyYgIi/yDoNbHUkkhJ7vZJjYoZH+ypD/McPWbxAw6yLhUGrT
	 IUkx2v/qr8j6qg5WqJAcdbItWBaMHOQyeM9Tn5Y78vX5xsycBJDnehRCcmrBmJkkW5
	 6KKeElkIk37kgmTO7M4LVye/kCJ9xNntjIv5eGlHfF4a/N60MuIVOjMMobDpg6C9lr
	 +4bVfmDk+dhug==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ECBF360602;
	Thu, 28 Aug 2025 00:46:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756334817;
	bh=Up035gXgOS6I3qdEJuNiV3TiJLRi4DhTwUkEuRXFJsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoxjJvfweocgNAgeYu+Or+5/I12dnO8mImQAo0yBpRvBeHGXXjDEdIH/DLM8+aqZr
	 cDLz+8BPTXz851zRJie3YjIDDlewwZSyiwIqjDyCtCTxf4l+dyz5Lt4YVm6lxxSiqE
	 TZ51wtEyFAlQxPVHaXRyYgIi/yDoNbHUkkhJ7vZJjYoZH+ypD/McPWbxAw6yLhUGrT
	 IUkx2v/qr8j6qg5WqJAcdbItWBaMHOQyeM9Tn5Y78vX5xsycBJDnehRCcmrBmJkkW5
	 6KKeElkIk37kgmTO7M4LVye/kCJ9xNntjIv5eGlHfF4a/N60MuIVOjMMobDpg6C9lr
	 +4bVfmDk+dhug==
Date: Thu, 28 Aug 2025 00:46:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aK-K3qn6spM6O5eV@calendula>
References: <20250813170833.28585-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813170833.28585-1-phil@nwl.cc>

Hi Phil,

On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> Upon listing a table which was created by a newer version of nftables,
> warn about the potentially incomplete content.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Cc: Dan Winship <danwinship@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Just rebase this and apply, it clashes with my update for --unitdir.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
