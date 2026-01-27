Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61F155757
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 19:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769543423; cv=none; b=eEQfpd3YmHsdVdxyQQh7cXlj+CabEWZ/dvrSD4QHDt/BaBmqqYVVPPzY9KQSQtnegO/SpfX/lkWNt3fcXI5AQIxd655vToOVoEv/sY2Fu9S/NG/vensIlpTnw1gpuC7G0ItH1WA/NkRak9cNG3yrExbUKPLBl3Os2cAaTTq+Syg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769543423; c=relaxed/simple;
	bh=E9zQXlI7kH0Zogt0Kxq4KilMoewti/C/vrcgDwzsDPA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gn2ZZe/hTDsStAq/Uq+CE+UBdBM65MVdOkRrOGG8bWFit9zYpGgo23GtrTu7voUnVAL6HgrZElXK20XPEMi5w6vMWErkIpjY9USPDsOlv+uPgiATmsNGIfeqWXjdDK6pTHH+B2thaZ3aSkEvuWPuPJfhonbwpZzcbckvQkEYaZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iIJO9QMJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iIJO9QMJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5HW/icgO7gHUScNFqzC+rY+yQeqdHUeUYCcPZJExprs=; b=iIJO9QMJCSgS27WMA4kNi9Xq31
	ICL2UP/paGHV1+b3enw6gPmfky8r8pAB2kZBeBqDgKcqefCM8i611Dd3tBQlKfaVI/d4wYqVzhcyA
	BgCXbCejfMIIfn319RNET+t1sBQMKcrrQKuCQx9yCtvJDI/2staJEYBPQZQ/0HZW5CVLzKAVrM5sp
	IgaBX+E3uzIle93PEGAxPGMtsywrj4nvGPOUWFROvoOujL3AijDk/8/930CU1okvYCMYWFm/rPG88
	eztvORA2+P95e9FfXPRHehmzm8/3n9V6FAgN81Q1BV5awW9ugXt2SVoWltIigH3AZyxls4HTm+KQx
	SvDvNH6A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkp4n-000000008Q9-1cp2
	for netfilter-devel@vger.kernel.org;
	Tue, 27 Jan 2026 20:50:13 +0100
Date: Tue, 27 Jan 2026 20:50:13 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libxtables: Store all requested target types
Message-ID: <aXkW9V0my7urtb2e@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20260123115837.11177-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123115837.11177-1-phil@nwl.cc>

On Fri, Jan 23, 2026 at 12:58:37PM +0100, Phil Sutter wrote:
> Repeat the change in commit 1a696c99d278c ("libxtables: store all
> requested match types") for target registration. An obvious use-case
> affected as described in that commit is an 'nft list ruleset' process
> translating different families' extensions in one go. If the same
> extension is used in multiple families, only the first one is being
> found.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
