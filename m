Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454DB185B5F
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738922073; cv=none; b=NaK2au3nYvuUdaTgXQTEMcypRfweMXyfGe70WRGHCXKDaQGMxLwTxxokykJ0VrcZPy+JEKhqy8XHpt2Gp0l0Ajr5iXjnvpmzdXPdobsQ3PzohMllGLboLYD9z2JPE0G4gOfmzYf+uTN8feWYVBCugGkN/jwUiyd7k4LndC0ynl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738922073; c=relaxed/simple;
	bh=PMPOBQ2A+rbMFFP+cVTgDGnexDDDC8+yWvF8hilbBAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lamJzGJcOoeQOPshbuTtM0TsIAKXivIOC08j/fUbjORWDtNhubYijCuBSSiZEkc3TDVaCixI1SugZQg0RfKZBPYfReJ6m/1/a4nsAV4zAEzHURAcn/0j+io1ZX5iE9G/60Pyuhkq88stb+JqmHayG2CoDVQhCKkPFLSPGk4vLFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ryAFtCg1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rKqFMU3T; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ryAFtCg1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rKqFMU3T"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6808F60594; Fri,  7 Feb 2025 10:54:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738922068;
	bh=rORJNuOKp+qE4c/CHmNh/v5BSORPtVYaqlb88zdlRXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ryAFtCg1YK3j/qR3e42T3DrGyrUjELykdt+oTHUXvCBpaJOW1z/8s1XiXy7T9imu+
	 1vo+xouDm28NM3g+uLgZaGx3KwdwS9U8NL4st+fJbu/g9aw4CbDdqql363v5UYlR5S
	 76s9bslK3w6CceShBi26sHytgepzBLfjHVVpp37l4OLQ/IrWTk5E1aTWqFXbOI1ujW
	 LkYnvriy+r95Rf46S/bv6efJeu0FC/Fo14pHISmWGdXIEaQdd7QJh2TUW1gRMrmaU/
	 n6L3bVGXLpKtaUxHcevhlpxinoh16jvR3OfVu3J9FJLB35IeY6KPaT9h+5UNiNIEKi
	 VihD066/tMA5A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BFAFC60590;
	Fri,  7 Feb 2025 10:54:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738922067;
	bh=rORJNuOKp+qE4c/CHmNh/v5BSORPtVYaqlb88zdlRXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rKqFMU3T1s1mMQ72ccneFUpgei6ogd2C8Fm/qM3Zepwk9H5LsWSix8J5NgO5ArgPk
	 TCrE0E6rz8rDml29Acp1P5G/tzhOoXmsVRSHj52L9N+cpduHeMA2VZjHnY7SCHjRfL
	 8Q51MX1dwr7dKJyCvzzrO8E0qPNGnD6YijUnnwy6w751x/gJ7seRstVGiS7vhtLYaq
	 BkfIWOPrfB16j5YfsrhfiqWdOa+QBmY1mmtCqn3dLcagvZBomDXZDj9Fl9suWGjqhs
	 7Wd8H9VqDkJxpXO1AJtu/xVV25UC5lYDF7gOAZIWA2LuF98O1HnyjbBnk7vu1QSygM
	 hlbO/vqB6beiA==
Date: Fri, 7 Feb 2025 10:54:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/3] src: add and use payload_expr_trim_force
Message-ID: <Z6XYULCcpB0ZoFPO@calendula>
References: <20250130174718.6644-1-fw@strlen.de>
 <20250130174718.6644-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250130174718.6644-2-fw@strlen.de>

On Thu, Jan 30, 2025 at 06:47:13PM +0100, Florian Westphal wrote:
> Previous commit fixed erroneous handling of raw expressions when RHS sets
> a zero value.
> 
> Input: @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
> Output:@ih,48,16 set @ih,48,16 & 0xffc0 @ih,80,16 set \
> 	@ih,80,16 & 0xfc0f @ih,160,32 set @ih,160,32 & 0xffc00000
> 
> After this patch, this will instead display:
> 
> @ih,58,6 set 0x0 @ih,86,6 set 0x0 @ih,170,22 set 0x0
> 
> payload_expr_trim_force() only works when the payload has no known
> protocol (template) attached, i.e. will be printed as raw payload syntax.
> 
> It performs sanity checks on @mask and then adjusts the payload expression
> length and offset according to the mask.
> 
> Also add this check in __binop_postprocess() so we can also discard masks
> when matching, e.g.
> 
> '@ih,7,5 2' becomes '@ih,7,5 0x2', not '@ih,0,16 & 0xffc0 == 0x20'.
> 
> binop_postprocess now returns if it performed an action or not; if this
> returns true then arguments might have been freed so callers must no longer
> refer to any of the expressions attached to the binop.
> 
> Next patch adds test cases for this.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org> 
