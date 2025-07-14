Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB20131E2D
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2025 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501173; cv=none; b=FDKSWzVHUPRksAhrTW6mN5gPuPzKc9+2Qd/XsN3NvTLmhYgS/xmVdYuc8FR0Db5dvEbz1p3j4Rb4slzpz+1aabKPCJA2f/8e7dRCtap5k+Ene0OxRaQWCAtPa7k8hyEHSJKP/xyZtlSUaj206rr0oXBt0O+/CRoRVRxGMSP1WVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501173; c=relaxed/simple;
	bh=KQrQ/DsZS82qUfBWPW/nIIn8F9UpgcBbZ6rh+2/XByE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Un0AlI7ENacqzrNJzuIMPTrWsIeDhyYJtgL8EI9J5WglZN+bzmgPcjJ8GDXNAbpZnRTMm0tiyL2cPBz5j63LDgzkFg2LsvO92PqdtFfX9MIBEt9GY5xY5x6p/q3MCwIqVlN8vHod3mjcHQ0GPJj/8EXUG4a05jwGx0ieUGyigMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t31duhRS; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t31duhRS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t31duhRS";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t31duhRS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A2C2A60263; Mon, 14 Jul 2025 15:52:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501170;
	bh=Wg/lC7WP5qzUgGvjiFmlsdLLp0lbKuUihYyZGVSnPpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t31duhRS5l6CLzck6fcMBnfZJtLKxmy2JgeFtluxb5Yi2wGlLeKpAED4khlIojxNY
	 LF1q/QX6mbdC1r1R9Z5WUjhI/fBOvjkHx5x1y02m0yBh+2v1mo5E45Jywuwyjkae3c
	 +102GuZZTBfwMGX3yoON6MowyhWP7AlsYWcupAleBgT8fW1s1fzERDcwU9j0hIHg+4
	 5KhpXZd2j5vsjROGfn9E/f0dD0eVqFWccUpdW0ihk6SfzPGhLhrJe5/xQhlu16vdOy
	 JpcL4x6DHi8FTeasZBKfKW/Gjy5Sc/bv5gCD6ICQGNS0Ub5mhGT7tmC8Ha7WHFKPBL
	 CE5/2VwVnQw2g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 23A9260254;
	Mon, 14 Jul 2025 15:52:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501170;
	bh=Wg/lC7WP5qzUgGvjiFmlsdLLp0lbKuUihYyZGVSnPpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t31duhRS5l6CLzck6fcMBnfZJtLKxmy2JgeFtluxb5Yi2wGlLeKpAED4khlIojxNY
	 LF1q/QX6mbdC1r1R9Z5WUjhI/fBOvjkHx5x1y02m0yBh+2v1mo5E45Jywuwyjkae3c
	 +102GuZZTBfwMGX3yoON6MowyhWP7AlsYWcupAleBgT8fW1s1fzERDcwU9j0hIHg+4
	 5KhpXZd2j5vsjROGfn9E/f0dD0eVqFWccUpdW0ihk6SfzPGhLhrJe5/xQhlu16vdOy
	 JpcL4x6DHi8FTeasZBKfKW/Gjy5Sc/bv5gCD6ICQGNS0Ub5mhGT7tmC8Ha7WHFKPBL
	 CE5/2VwVnQw2g==
Date: Mon, 14 Jul 2025 15:52:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: hide clash bit from userspace
Message-ID: <aHULrxlyOK03bBtF@calendula>
References: <20250707203247.25155-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250707203247.25155-1-fw@strlen.de>

On Mon, Jul 07, 2025 at 10:32:44PM +0200, Florian Westphal wrote:
> Its a kernel implementation detail, at least at this time:
> 
> We can later decide to revert this patch if there is a compelling
> reason, but then we should also remove the ifdef that prevents exposure
> of ip_conntrack_status enum IPS_NAT_CLASH value in the uapi header.
> 
> Clash entries are not included in dumps (true for both old /proc
> and ctnetlink) either.  So for now exlude the clash bit when dumping.

Applied to nf.git, thanks
