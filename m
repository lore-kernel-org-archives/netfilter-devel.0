Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794787022;
	b=jR6EoVfYeGZy6zLvLcg+8LjJoZ+jUAwM4c+ZUeZSVY7Qm7I9lNOSHbjerSusR27Sy2qL
	 4wf0qQdSOaq0aVjgEOkKR7faERXTweRcP484qtvKChUIu8cHndKcrV6jgpnsLsRvThW8f
	 9vSFJw+6UfT3JJrcnVXrFCb08jonVcDTphY25N54RCNDPyXyiQCt1CY/S/RRtmkwBpTuG
	 +13AiYVMRz31IFKvoHQ8xLQdC00GR3SyMOxX9hGNuaGxSk/nd65rWaYKCEhEH3XxKippw
	 hEX1nWj0veESwGGhiA1HuVg2f1/4+Z/mUKw6L1QbOy6Bu32W2hQk24f4Uv92td3I0ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794787022;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=cZOqBnhuBD9n2KCnrt/LIAqIRAnxQbhC5EgqZFH30bk=;
	b=4M9Ho2INavg0fGLuE7paspJC6voibxuMP6dNmhHFXAbu4l9eCZ7knimjuLYdw+WL6Snw
	 hYbcGI075nZrzhVAuTP35SbWFuErm+iilG4MBW+SaaStnh2ON8ph3R6FncLiZVZnjnisR
	 bfM4Xxw8waKphlD+xqRXBndw6LVi9gfI88MtVucZrSxJMqEJHCNRZIJZH0CW9iUYhIy0/
	 nDCwjBAj+2e7rD7uJTX3DW2XieBVd56zIPAvjeGCGlKU+fUr1CNTmQ/3W8H6SOLAbL1HN
	 gU/20ORjSVJ92el7UkkLeywr1wpaM3P2diRCOialzxitj560oLQpY75BM9a7DB4+kpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="i/BJPgoK";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CEC95606A323;
	Sun, 15 Nov 2026 23:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEC95606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=i/BJPgoK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794787019;
	bh=cZOqBnhuBD9n2KCnrt/LIAqIRAnxQbhC5EgqZFH30bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i/BJPgoKHkdVaW9IWi92ylC2j/Kzuxy/+pwQQUgMGAy3hTZYaDcod0oJN1qSVsJ1K
	 UECBgrlQJ3phiLrc2V/Lkp/5tsRym+ybwOtFltBL6pbfgrDf6tZEwOnKZvs6jd4BVu
	 lIF2Xids27PF6K3UDgXRI3b0gF3Qr1hyDHGD0rdSgRJYHdiDCzg9n8pOYQcV79re/l
	 JHZmqGq1Sp9CASP80Y05BNTnagvg6XAa4euYCo3A+jMKovTC8WC0S8ISGw/+gJvrQu
	 khV0+/B8vViAvl7BiyDplUCzV+WC9AG4GRqyoqoqubPhWWFRBMeFA+TXXhUoi1YrB3
	 t9dUIbvyKjVLA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 91C3B6005A;
	Mon, 16 Nov 2026 00:56:59 +0100 (CET)
Date: Mon, 16 Nov 2026 00:56:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julian Anastasov <ja@ssi.bg>
Cc: netdev-bot+sashiko@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org,
	fw@strlen.de
Subject: Re: [PATCH net 01/15] ipvs: avoid out-of-bounds write in
 ip_vs_nat_icmp_v6
Message-ID: <avpGyYbSJnhlZE0I@chamomile>
References: <20261113011447.2357709-2-pablo@netfilter.org>
 <179462253904.2199510.6723175642724870986@kernel.org>
 <19ba5516-0938-495a-5e7f-57f5fd9a2b45@ssi.bg>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19ba5516-0938-495a-5e7f-57f5fd9a2b45@ssi.bg>

Hi Julian,

On Sat, Nov 14, 2026 at 10:06:38PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sat, 14 Nov 2026, netdev-bot+sashiko@kernel.org wrote:
> 
> > Thank you for your contribution! Sashiko AI review found more severe
> > issue(s) in other patches of this series. This mail is only an FYI, in case
> > you want to address the nit picks below when you respin.
> 
> 	In summary: we can drop current patches 1, 2, 15 and
> should address problems in 7.

OK; then I'll drop 1, 2, 7 and 15. Regarding 7, see below.

> 	We plan to update patch 2 to check for present data.
> Both patches 1 and 2 go together, so they can be dropped for
> now and improved in next version.
> 
> Patches 4, 8, 10 and 14 are ok, even if wording can be improved.
> 
> Patch 5: we prefer to drop the traffic when port 0 is involved
> 
> Patch 7 should be checked by the Netfilter guys.

It seems it is possible to create an expectation on unconfirmed
conntrack entries from the IPVS ftp helper.

For a TCP connection, the conntrack entry should not be already in
confirmed state when the FTP helper runs in most cases.

So I think easiest way is to make a patch to prevent unconfirmed
conntracks from expectations in the IPVS FTP helper.

> Patch 11: NO_CPORT is before connection is established and
> we do not sync conns in master before establishment. So,
> nothing bad can happen in practice.
> 
> Patch 12: races are possible but nothing fatal
> 
> Patch 15: The patch was meant for ip_vs_bind_xmit_v6. daddr can
> be further limited in next version, so this patch can be dropped.
> 
> > -- 
> > Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>

