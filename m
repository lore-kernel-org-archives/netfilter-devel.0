Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617A7F513;
	Wed,  4 Mar 2026 01:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772589438; cv=none; b=NGvHmwqmDC3rxhECO2erENMqBkjFgi7JCg0OPI8jdvMVlvMbwK1Wr9OsRt2p29Y6sQUk9JG380oCKSKZCLMmNx7WjpDrImQLZjW5U2TQfjcKFKc6A210iZyJR3ME/mwlx/6Pl5Vu21jcFut3rC8m7PswSQgEoZd8sp0/+BfDocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772589438; c=relaxed/simple;
	bh=wG/8yw2tgW69ZzgkCBpAej1VR/aauIn0W29cD7SEG/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hT+6/hldE1h3Kqkc+2M210Zg0uH2gG5DcIayZkrirQ+rJDeTOwfXH48Wl/3yRQPHpR4LX7TbSCpWv1Zkz6J9A9jOEfhIR7yJCgyJfw5KoS8gglCG7xCfvlxfQk1O0CP+8xNQKqeIuXxURwvZ3M9wjoGg7+Z/NaZTkcuVjT92wNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Vgmo35pK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Vgmo35pK"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 606706034A;
	Wed,  4 Mar 2026 02:57:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772589435;
	bh=tVulclVVxqqAKJbiQ1XlJd4gMy6R5scGZ56TPe1ad6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vgmo35pKFrhGCtQIzcU1O5W0f7i7aifLML9nnQh51BzHZTL6o2Ty2O823fR8QxcTg
	 EXWT6Ik+NsiZ0RwiXq6HF8LMARF9yO/1LdPyW1smY3qZRtKtaRAjp2Lc023z7BnESP
	 +bnizWR597rDfT3U03oMTQboRM3I+jMxGr7m77yGBTQJkWJhN3B7jsUVPlv5UNOmCE
	 OfWATjQmVzh4Nb1MyKi6uv8AWt97YWeCnILVHtzA/b0Jvn3v0krgdSuTWBRPHeaKtO
	 5MVPWaeRIXF/iZHeJFTMM1KZKX0Uxj1LWGQjhSU12iVFmA82LLLXw3RJfhFcbdo4Cv
	 J6Mn0icgyEuYw==
Date: Wed, 4 Mar 2026 02:57:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sam James <sam@gentoo.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] iptables 1.8.13 release
Message-ID: <aaeReM6MC2uBbT_6@chamomile>
References: <aaeMFWURL-6YWIkz@chamomile>
 <87h5qwgy18.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87h5qwgy18.fsf@gentoo.org>

On Wed, Mar 04, 2026 at 01:53:55AM +0000, Sam James wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > Hi!
> >
> > The Netfilter project proudly presents:
> >
> >         iptables 1.8.13
> 
> Thanks! BTW, tag seems to be missing?

Pushed out, thanks for telling me.
