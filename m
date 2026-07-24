Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5153385A1
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2026 10:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890462; cv=none; b=seUfEp1uhvieDKgFj42Pix5a+mQc+UosUsw64TayoJ9wbJvOyqvexVk18yo/QcNLPxgRheICXZld6Cdwk5EzyToqThD8tLpAuDl56zLzRoap63jGduDZsBpbhvIcon8hDDa/jSNUkDU6xhOHWtTJmhCu5LaDU0hFWdNZhLjZxjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890462; c=relaxed/simple;
	bh=HLrOMvaA5XaCgDg7wgzO6BtJ3RLcFrHV1YQ+IzAVWsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DoUtXVoRPrQWXeBCX+cZv0u0RZcsRKBbTReVInfQ7BPyVV8F2NojsFUQGrJ+D+wwV1MGuzxfNcYmQQJ3PoyXOjjqL7xy9JjioGSpBmR4F8aBmbzBoIV97exoonh9k7vvaeFEigp6cuwDsfkVnSyDLW5o/CDlZz1vaqlNoMB1B/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sUa9qL6W; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sUa9qL6W"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2BABC601A7;
	Fri, 24 Jul 2026 12:54:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890456;
	bh=a/5wFqeyMW8ZEVce4sABRhjvJCyPFUHArHRYub+jsLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sUa9qL6WQtWoGm6PjYrTeCYxuMpIRfxhs+09zt1A/eR4+e0yR7elkrn9RVV6ZiwOc
	 UChAffaCyouGxiChX7BwLqk2Ayq7YGziaIhNFUXD4qVaxfXP7cDF0gy8TVWv0TLDfx
	 QD5RGmuqVeA6LW6BgKOsJoRcSGdM1zS+CfaM6Z80KLa+KDurvrOx6p3P6SL2AYw9Dy
	 NAYU9BZUlfd/Uu6Eah0/09830aJslvNJzDvavMy7dFodMK1ohLv19CTrA//3KIMhMt
	 MSAGSRPZWZyxtvaZ2hNV40Iwp1FiyDNh1FrF8tueelheR2yjlIMmZX2lMrgT87Ow0t
	 uBhSuxMFV5ddg==
Date: Fri, 24 Jul 2026 12:54:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 0/4] Address Sashiko review of NAT hook dump
 code
Message-ID: <amNEVYJiUL2dj00m@chamomile>
References: <20260710151411.2358773-1-phil@nwl.cc>
 <amM_LjFL83jCngtg@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <amM_LjFL83jCngtg@chamomile>

On Fri, Jul 24, 2026 at 12:32:17PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> I think we have to tackle this from a different angle the
> nfnl_hook_dump_nat() dump issues, see:

Another option is: I take this as is and I follow up myself on top,
this is already improving the situation.

Let me know, thanks!
