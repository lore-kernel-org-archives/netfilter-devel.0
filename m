Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCDC446D5
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Apr 2024 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711983748; cv=none; b=ORcEaQ8N9e5+u1CbY5++v6OXtGGwMAqGDel9GPe5dRwkPWXcgAvNN2dMotbo50+Z6AekSX4csCWF5p7Bqm27vH7Pr9RdM5l2/YFGrGoPuxFHHKldO1OAQJvpKzSOPoRSrgr49j/ATRV+bEVPMNWlNXzNw9psUfDvlvYKoQimYcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711983748; c=relaxed/simple;
	bh=G8tk9SNv8PvSYd5Li8cXRlhF7Yi1mkFbDsp+4k8m5Ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXC3j70xe3GgOghbqp/Ry+ofUP27SkgRbnmwmoPSvpAEuyhfOhQCNWcOlQB1G2cKGLzWlzlszCIcGhYF8vduPYjJpJB7Ss4pJaj84TVLpXDsbZCeNlsSSJH6dMXeCr94Ah5A+nzyvyzbdwERa4hgvo+Mn3RDC1pFhKCNVrCx4Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 1 Apr 2024 17:02:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables] tests: shell: packetpath/flowtables: open all
 temporary files in /tmp
Message-ID: <ZgrMfVaZoyIHllxG@calendula>
References: <20240324145908.2643098-1-jeremy@azazel.net>
 <20240324145908.2643098-2-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240324145908.2643098-2-jeremy@azazel.net>

On Sun, Mar 24, 2024 at 02:59:08PM +0000, Jeremy Sowden wrote:
> The test used to do I/O over a named pipe in $PWD, until Phil changed it
> to create the pipe in /tmp.  However, he missed one `socat` command.
> Update that too.

Applied, thanks
