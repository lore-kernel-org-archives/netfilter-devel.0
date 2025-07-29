Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A90157E6B;
	Tue, 29 Jul 2025 00:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753750517; cv=none; b=GYhtTXBiOxbC2hC9/bLUnESeMv04FxLv/QP9oobcySetpg8AyBABbDzwxnxUkiYD4cTnk5mYiEFqnnIzrWc8R4t5ZJCrBGFngoQTZz7rJTqYn4wMuryGds77t3w1NY/jO3SEvE+PerCJcCTsKOR9+YvfyhDMn+gujrDejuxIVIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753750517; c=relaxed/simple;
	bh=7Ol6ZyCjDnTvs26fv2/mBsBfNm9On0BklX3ylJ4aZoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4b7I2XPU7k1/Y9fdN5NMTzrT9upbI+WG1+TJLz7zT3VxYnRLvtKsSCd3/F+trHVwnpWdax4xGmHap4g8ub2WEfNzNpBpwk0UZ3sPek6xmEbPTn8YX3aaKazobomV9SdG/dLF/1374q9RqGvVy8m3YYrPOfi5TCzqdkxJYovyPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lN/1cgfl; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tLNdWyZc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lN/1cgfl";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tLNdWyZc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3046660312; Tue, 29 Jul 2025 02:55:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753750513;
	bh=nftY6rJWBi7rKWeXskDE9/uuXO4KtsrlBwKkamWpcNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lN/1cgflqA/7mrJMm18D3Yi9OEnl8chOPUwMdUx49N904vhnIBqB0P2SBSMXsGLkC
	 8twDbJ5tY2g7NuMCtoP+cDADAao00+fO2mLqCxIxNSKZDaLIxtFedoUUZuHKjzE6Z9
	 RG0m7AEIk5GsrQmDi5ZgUbTp8J5AOrhwRFyh2B0G1hKJJf2Xm07NjzqQd3mYj56Qmn
	 Vyi9xjFo77XqaS0di/V8rU6zOn1At+wGlzq7ctoEBzlDeQSEJ/t35GyUblwgCff3f8
	 PEJ7hGvzyI1vTn7nTcArr1T11a7YVFijxBTJ0/CtSUSLATjqXWD7DUtPg23bXs0GIh
	 IVR7DFIQiBx+A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05F4160310;
	Tue, 29 Jul 2025 02:55:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753750511;
	bh=nftY6rJWBi7rKWeXskDE9/uuXO4KtsrlBwKkamWpcNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tLNdWyZcaJ7JkxckUSWnAeEEXwhuCT22oU1T8TssKZLvBVtgVOjJoqWsYekGpr0V/
	 nEnxyM/j0BTdfs9bUIsfQIo3T+bo5uActA76/Og9OqzBBXgDDFOFPTc1ZC8ZrVLGSl
	 +mW1tfQ6Cwhc88AxLuDgvL5raOWTGmRkDw3aStJ9W8VbpIsh/5Zch1BaPxGy4hpM1k
	 V+ltqC3B8RZxGO3/yEkVZ50fqsPOzLu28teEE1SCcz7KbQYmiH+h7Bj2pczVDy1sS5
	 wNPY+GCvCiXCQQz41+FMilT5bJzxqjZNsLzoBKbp7pti9m0veuonBV7XcFP92EQMZZ
	 /QPQDMD8AM89w==
Date: Tue, 29 Jul 2025 02:55:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev
Subject: Re: [PATCH v3 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aIgb64Riu6FBcC28@calendula>
References: <20250728102514.6558-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250728102514.6558-1-lance.yang@linux.dev>

On Mon, Jul 28, 2025 at 06:25:14PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When no logger is registered, nf_conntrack_log_invalid fails to log invalid
> packets, leaving users unaware of actual invalid traffic. Improve this by
> loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m conntrack
> --ctstate INVALID -j LOG' triggers it.

JFYI: I ended up taking v2 into nf-next, let me know if there is any
issue with your previous version, thanks.
