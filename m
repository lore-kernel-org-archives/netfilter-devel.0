Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6203054C5
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 22:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642341; cv=none; b=Ru36UWh++NHWSaGHSYQ2bzcoYmQAnTqfbvttuQ/gxAoFFilii0PiAJo/IwBJWa9WICC1wriepiQMi9DOugcxvfWtLjLFmxCPJ7wwRZOikQlf9fTLk6Y+V4FBRTJ8YYVfkKzSYWN7NoRB0ed0mNa8mxz8MMh74Lshk7uERxWi9+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642341; c=relaxed/simple;
	bh=6rp71pwhnjXX37l30DhpaOsHylLtxgCJml8NF95wBmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pjkzw5L42UAZAvkePqAbQ7EX/JEiVh1wN1CgmydI2Nxv5Btx+K3GUBwShhCgoy2sXST5YPbYM+/oJGnno+D3yCFzl8kRQIkv4TrC6rKjSU1KghTRHEBfQBgffGoBXXqhHdi0UGrp6oEgIjoj9V1X8vop/uIaUZEhArTLmSczKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kITl7f0J; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CrFZwmSo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kITl7f0J";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CrFZwmSo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6EEE06028B; Wed, 20 Aug 2025 00:25:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755642336;
	bh=mFFeTXF9Kk3ql28XMq5nSSB+8FNY9C0TT7daDCXDjrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kITl7f0JGpjal35nxOqnt4tCChwA94VjDoeUw843C7L8lI+C85tiKZpSz6rAyhqgL
	 vOB+OkXAaOA+g5RRnP1Pwpl9y3SSmkSgEJoKueJD2ZGAYb6Vu1zjOqufQsYMdvSn3l
	 PYUO7zh57y33MB2et/8m7BY7x3FOaVfCM4pWBauvMYwNL+zBz97h/080HAX/wQrqIf
	 7siYN5BPmSMCulQvxqoLLUaeAGXkkgsYM1sMh/J2VPKNnnYDXy+HmhEsDCWTqOiU5W
	 m/MCIwud3ejUxgjG1rHqwYl/bOYo3duGu8+zoajsuNuEei5b0K3hmj1hypDm80R/sB
	 Q0T5Y65FXtlGQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2BC0660281;
	Wed, 20 Aug 2025 00:25:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755642335;
	bh=mFFeTXF9Kk3ql28XMq5nSSB+8FNY9C0TT7daDCXDjrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrFZwmSojJB3lhUrN2oy7/V0TXCZXP1ym20f6nHtZxIvUpO2c8rS+0Cytr7+fe2yk
	 9FdjIDWvUCT04XtxhCfHLUdmk3A8FmYpOsISy26ddyBEsiI0Zl+Z3PRvWI2rLVDG9K
	 kPhOtP/WmhX4oIa3mniwc74/lkMEKJ9GrTPo/6HVe0wsm7t2qj71JS6LVy2Rki1gRE
	 d96S/0izL2+QSmVUknGX8wsuhrK8Bzc+vzyiqH99g4HWP2doYvYraYZ0/37UqUzaSt
	 R6JGBKfzpKqp9yEz67BSTAR93ssSaqtjKb+tPWt8D9jJ93qmLNi6HiI4aBvMH+8zds
	 SYP+zbIXPOe4Q==
Date: Wed, 20 Aug 2025 00:25:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
Subject: Re: [PATCH 1/7 nft v2] src: add tunnel template support
Message-ID: <aKT53LQQPlWg_LJO@calendula>
References: <20250814110450.5434-1-fmancera@suse.de>
 <aKRybNzVyFOC7oCB@calendula>
 <bdddcdd0-e8d8-4c8c-96e0-c18878e348ca@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bdddcdd0-e8d8-4c8c-96e0-c18878e348ca@suse.de>

On Tue, Aug 19, 2025 at 05:57:55PM +0200, Fernando Fernandez Mancera wrote:
> 
> 
> On 8/19/25 2:47 PM, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > I made a changes to this series and push it out to the 'tunnel' branch
> > under the nftables tree.
> > 
> > I added IPv6 support to this 1/7 patch.
> > 
> > However:
> > 
> > [PATCH 6/7] tunnel: add tunnel object and statement json support
> > 
> > still needs to be adjusted to also support IPv6.
> > 
> > I can see JSON representation uses "src" and "dst" as keys.
> > 
> > It is better to have keys that uniquely identify the datatype, I would
> > suggest:
> > 
> > "ip saddr"
> > "ip6 saddr"
> > 
> > (similar to ct expression)
> > 
> > or
> > 
> > "src-ipv4"
> > "src-ipv6"
> > 
> 
> Hi Pablo,
> 
> I would prefer the latter options "src-ipv4" and "src-ipv6" mainly because
> adding spaces to keys in a JSON should be avoided.
> 
> I am sending a v3 with the requested changes, thank you!

OK, thanks.
