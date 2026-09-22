Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F65559C92
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095880; cv=none; b=Le8rudFXte0K4cTQFs164KTr7hZzCfE4GdVE+nsA8tqpNxybqQmuD7H8uQDGcefur9jBonN+m6C+m6IciK0vHzNCqrRYJQg/LvrC8/Jyr3gqOeeAwjxpezgIbwNhleXPUUVfpTAXyWepEderMYuyjaTicP02YUshXAW9uVV1yxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095880; c=relaxed/simple;
	bh=rDPogS4fDOnruuiO+iDSgmHiTCdcoPI0YcAqs4LAiTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsNz02MxO1JxbGpd6jp7T2egk7M0j+I8xNLxwET2Gv+1O8s/X7NUKWJhgY9YjELWROFHMYBi+aiKVpY5wScNx8MHPNbjOdLBRkdGqPv9APp3WH4cnYJatCt94czVjrze9eSDQ2PhIA38cUjC04rh6lDRTnLPAQnpllaU2EAsLBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=H5uPJeMb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="H5uPJeMb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H9oOPZrhMQq2ojwplvOMP7RZpNXjVOzlZ4nKfxOSLIM=; b=H5uPJeMbP4y7mp5855kVYK4/TQ
	4B36oAKet24yFKE4hpjkC9SySKukrMsWEbcin8amua8mrXaVPwHGLrMRRiw65Fp50socwXb4hAwjh
	SljMdJbPHy+XEdkgIYQ6Zy1ugyMh0IcFnl+U2aGOvzyBl/CO4CqubysVXnf8uTs7dTwqPNiiopiq1
	vspM2HxtvAvozRBiGYxTrP2/0MGqwzves2Ap8nupkekRz4YV2uDGnI3dlZP/IKqWtvHwcAWbCkHak
	9pmeacUEeKKP4TW/RypJHlNX3ZfvT5F+5paiTQ2TTt2JnWLSJHrcHPzS3N/83GdLgE6IwI+YJNShC
	yxJ0xyeg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x93i2-000000007pc-0Qfu;
	Tue, 22 Sep 2026 18:51:10 +0200
Date: Tue, 22 Sep 2026 18:51:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH nf-next] netfilter: nft_nat: use the right enum members
 for nat type switch
Message-ID: <arKx_sYz5ExzhPwi@orbyte.nwl.cc>
References: <20260922164059.4320-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922164059.4320-1-fmancera@suse.de>

On Tue, Sep 22, 2026 at 06:40:59PM +0200, Fernando Fernandez Mancera wrote:
> The member 'type' from struct 'nft_nat' is of type enum
> nf_nat_manip_type but at the switch statements for
> nft_nat_setup_netmap() and nft_nat_validate() functions the members from
> nft_nat_types enum were used instead.
> 
> This does not cause any problem but is worth fixing for correctness.
> 

> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Fixes: 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
Acked-by: Phil Sutter <phil@nwl.cc>
