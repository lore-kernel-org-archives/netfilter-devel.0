Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021C238C36;
	Wed,  5 Aug 2026 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785951613; cv=none; b=K7L/WWOnmxl4fMMbc4Iy3dkMe3cDHiGafnPV+DvlfWHOj3HAhNX3hESMRiZxEigVrcK7JbQIJvhB/n1eThhGdmuf74KAuYDAPtCvhfjxSQJIIJo3g0mynXO1KBMchghCYBwz/9x/hB1o+gC1OOlU+vI+iBYUIoYw2y7tjuboc7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785951613; c=relaxed/simple;
	bh=uIEhHr5Uq/se3lTE0pFbwYIWFkyW1YxeOf7ixtiTSok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+k4KFmWm+63PZO/8mm74KDvBgFYD3ouyNUiCwGA5IAAkvLay3l44FfBbZP+8dEPw7jS/C78BbCigTMN8Rk31gW/yOES0TXHI2DjikCadhD23b//l3H1uQYuXw+nNaLLjVPH3PymDkOGjmywJVLsves5U6YO/QYUcSw61in71e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GxasPuWZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GxasPuWZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 34B4C6019E;
	Wed,  5 Aug 2026 19:40:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785951610;
	bh=uIEhHr5Uq/se3lTE0pFbwYIWFkyW1YxeOf7ixtiTSok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GxasPuWZk/nWkhgnd3vlh/3sUSXsu+6kFVMdoLrsXPuX1mGHJhUMXLA4T8vrBq2DK
	 RyINTQzDhEubLyf7JYXbXx6FpSpi0Drq/tsulwaz/nHeBN7g7bBGmHEAAIZqUZUzML
	 8Th9v3sMYfSC898Ro/wZVCLG4+Z9BTDLyzhbIE+MaJ9cnHFMbVEBf3yT42EHlNRNKZ
	 G9xFhsAKNxVffd06gJLpzr2BXGk2lrClVV6+2LqyNB2vVyX+nfApYWmxF89QTnild3
	 gXY+Nr5GAQGnmrGqiSphM7uLxkL6w+bvA/HLk587t47JK00UTdfG0VVTqYeIE+GZ5B
	 amGWbNP4+zyzQ==
Date: Wed, 5 Aug 2026 19:40:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net-next 0/9] Netfilter updates for net-next
Message-ID: <anN1dx7XiePnme7g@chamomile>
References: <20260731153402.851224-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731153402.851224-1-pablo@netfilter.org>

Hi,

After reading sashiko's comment, I think this nf-next PR can be
included upstream and the only real issue can be addressed in a follow
up.

Thanks.
