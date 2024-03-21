Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E7057876;
	Thu, 21 Mar 2024 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711019478; cv=none; b=KzZMA9vbQAopu5lGFvpffRje4hRib/OOXcvhYIEqx8zgw22ReC/ATZQ3h9p8fcYiEej8Y6VacCwrWcRAkrOIH6HQ1OdX3ZiDbaK2jocisesUOCkpV3RsD1i9J/zx1+kn4XIWLiCsctrJv3GE5AQKZ7M1bHAYPH8dLh3bV/t4a9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711019478; c=relaxed/simple;
	bh=AsSp33wfcQ6xtm/iImY5mOvO+b8R3QdhsH9rsrmM4gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyWd5HVD2+pX7Sk58u/DjiRXo2cxx6Edh3aWBqt26FBafJnnuKR3Jvpxb0apLQWwcCMoonyW8Moz1dgJ4g+L8l8CXROyZuwd9UX5htPDTDz3xW105vcbW2ZKNFp6PrCQaCJpRcx/rj1/ABJslWX1ejomn7VFJn9u6J52/ARasXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 21 Mar 2024 12:11:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com
Subject: Re: [PATCH net 3/3] netfilter: nf_tables: Fix a memory leak in
 nf_tables_updchain
Message-ID: <ZfwVzPeSh2RrA2hT@calendula>
References: <20240321000635.31865-1-pablo@netfilter.org>
 <20240321000635.31865-4-pablo@netfilter.org>
 <1c84b33599ba6d10680162a43ea729f7353327b3.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1c84b33599ba6d10680162a43ea729f7353327b3.camel@redhat.com>

On Thu, Mar 21, 2024 at 11:52:29AM +0100, Paolo Abeni wrote:
> On Thu, 2024-03-21 at 01:06 +0100, Pablo Neira Ayuso wrote:
> > From: Quan Tian <tianquan23@gmail.com>
> > 
> > If nft_netdev_register_hooks() fails, the memory associated with
> > nft_stats is not freed, causing a memory leak.
> > 
> > This patch fixes it by moving nft_stats_alloc() down after
> > nft_netdev_register_hooks() succeeds.
> > 
> > Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
> > Signed-off-by: Quan Tian <tianquan23@gmail.com>
> 
> I'm sorry for nit-picking, but our tag verification scripts are unhappy
> WRT this commit, it lacks your SoB. Would you mind sending an updated
> PR?

Sure, sorry about this.
