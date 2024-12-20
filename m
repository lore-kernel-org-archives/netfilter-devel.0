Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352FC182B4
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2024 11:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734695454; cv=none; b=m+BBbVyWLjWveLSBZ7oOkfGNEd6uQP3GCrJJQeJzgb8E7E2YlJl+W74o+y47QESsSR0tmmf6HuWh8eMAO0e1/XjrE51sj30XT3sq8nx1vVqsyhGyEnSGqK2cnmOpqzwE3l0xwcPgrMjfRnfVXupu5eFnAZuADTcXumAXzTi1Inc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734695454; c=relaxed/simple;
	bh=qbgM0xHwIC7yTMP9DuDp4u+8aT3rYzY9vn7EGdvHL8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGsKkTO1kwkL9qadf4qGLI5ivrxzdmdWM3jVjEpBycnw8lA/HQASuCUCaMmY4qFQbJCEG9PZkYZVF3HGpSzqDAULQs1SGZScb2Lutrs61EH+OSzib1ujlJE/nIRapUdWPgF1mRH2SHm62FMgrxhXocjvyRpa7Q+f0Apvum0XwxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gzym0FK7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gzym0FK7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CEp5VvGKaCWz0/FRCUiFNoHQhyvjnzlBPJ17DoEOYBU=; b=gzym0FK7bt3J86+kAvLxXnUzcn
	rpxgNErE9AzMx6klrNOtty1UAEukiuRa3Oo34TLjqBIF2uIxaKFkWHjolffetQTW2W0DsgPnMrVmR
	/Aif1BUnknU7yu1hyb31lrz+C8gpGreY+/gKX4MvshzRGyUr6HzmU4gEv7amNs9HNjYowKUvldghF
	aeHtfhsMuQPRR8qKKKEKipiBqB7MPmWKZ5PyItJkXyZ+9PhjNcra1EbggKqNNvBZEoshw/Mswum1p
	Yrz2aqFt3SjNLZJaOK8QcTgLTQ7YlT0ck2w+XgKUVTTeSyZSZvi9/9xnXUzggzDP20ogbSkk6kyn5
	cZhPZ1kg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tObWk-000000003VV-2Us4;
	Fri, 20 Dec 2024 12:50:42 +0100
Date: Fri, 20 Dec 2024 12:50:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alyssa Ross <hi@alyssa.is>
Cc: netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
References: <20241219231001.1166085-2-hi@alyssa.is>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241219231001.1166085-2-hi@alyssa.is>

Hi Alyssa,

On Fri, Dec 20, 2024 at 12:10:02AM +0100, Alyssa Ross wrote:
> Since iptables commit 810f8568 (libxtables: xtoptions: Implement
> XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:
> 
> 	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/et…
> 	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-iptables-1.8.10-de…
> 	                 from src/xt.c:30:
> 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
> 	  115 | struct ethhdr {
> 	      |        ^~~~~~
> 	In file included from ./include/linux/netfilter_bridge.h:8,
> 	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
> 	                 from src/xt.c:27:
> 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/linux/if_ether.h:173:8: note: originally defined here
> 	  173 | struct ethhdr {
> 	      |        ^~~~~~
> 
> The fix is to use libc's version of if_ether.h before any kernel
> headers, which takes care of conflicts with the kernel's struct ethhdr
> definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel's
> header not to define its own version.

What I don't like about this is how musl tries to force projects to not
include linux/if_ether.h directly. From the project's view, this is a
workaround not a fix.

> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> ---
> A similar fix would solve the problem properly in iptables, which was 
> worked around with 76fce228 ("configure: Determine if musl is used for build").
> The __UAPI_DEF_ETHHDR is supposed to be set by netinet/if_ether.h, 
> rather than manually by users.

Why does 76fce228 not work for you?

Cheers, Phil
