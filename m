Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515105;
	b=CbpnA+ugDSzyx7T+kDq2TrEDPCfMEg/ElU5OIB2MkR4hrfEK7aEWNGgh/53y2Q3JzD5f
	 NKo9S5jW6dPGpPPJC3p0dXWDueo9hxIEA/PeAX8viinCSThaRW3YoVxByiiGhFtIdb23R
	 qbQJ4yjugVaYv2FRcDa4WdVZWciooenjkwKOmA6mDJkYyrwN+QSvhyZSuyEbnaJZAwTPv
	 Q2+3N/wcmHDSdGZaOKfaGs3AlpDPwa5Yh80IHWFZqgRFxdAF0DVAhGlTM9SHB8WPrF0jP
	 HNkuZmoJe0KYGvaF866XwA/f1gHtW2EqsVXAjiukBFYFY8IXo2QqVc/w5eLJz9DlGXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515105;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=IAtcsgG1Ev+dcev/O8wTn/i2UjNJet0ChJkwktKbtBI=;
	b=JRIM2lvXUa34Ysa+OFlCERwd+R9uuFOAxpBc4b29X3yzrz7389lHAadTcUUam0EzA3Ut
	 EYI491Q24aa0l6UM5LwbNcpQXEKpPbYA91Wo7VhIT061HDLIoBVFpUI9CENpiB+bk4QfJ
	 4EEFgK+iTUucrM92Yamo3IC+vgEOlu/9TunFUqO8fFkSa+b6GdTbsSoj9qmU6ZW6fKowR
	 qkBKWJyXz/g0y51CGLTD2hyIvYnrLTCP5vdzzXXAhbgN4AcJMadGecoVnfP3jpZX5Q2j7
	 jxIPXYQJa5mRnD23x7XsqZW58cwuyDEjCTJ+jMZvEUoFSgZxf26xMIBsaHmJkM93c0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bYlnOwQp;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 62B48606A328
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 16:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62B48606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bYlnOwQp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792515102;
	bh=IAtcsgG1Ev+dcev/O8wTn/i2UjNJet0ChJkwktKbtBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bYlnOwQpMtYn0JmCsZlzo1ZCp5ctGWYKtMW3Uz8OCvCRRaw8ag0E0baajl54QHiMX
	 P1N2Wv6imDVq4K1WYWTYhm8aUAYEgzIt/kBcbTjh8ZypQM1rUgca5WZscoD98D7E7F
	 iUMzY/r3BRAAi/Krlu8T/qR5YdqgpBfgtf6Odv20spGm46UIld54K3qeCGq24wdV81
	 j2IeXhO0dXU8SpbWIxbQjeVg8qFfbU9Bb8SaHcXfN9n6USHdli1jxJFXc3ikfDE4rO
	 WnaqgcjhUlp5hJnOdpfaoo8UQ7iocRxqpX+lkbFZ2L+o4eipoc+VuEV1P7QMagaCMR
	 XhrTs/2fBohgA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 84D576005E;
	Tue, 20 Oct 2026 18:51:42 +0200 (CEST)
Date: Tue, 20 Oct 2026 18:51:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Trevor Cordes <netfilter@tecnopolis.ca>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: expose named set element count
Message-ID: <atecG6WNYa6Y2kLL@chamomile>
References: <atdp-FBVOOKgN0De@pog.tecnopolis.ca>
 <ateYUFIPFZshosqX@chamomile>
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
In-Reply-To: <ateYUFIPFZshosqX@chamomile>

On Tue, Oct 20, 2026 at 06:35:31PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 20, 2026 at 08:17:44AM -0500, Trevor Cordes wrote:
> > Hi!  I have an application that can create very large named sets
> > (dynamically) of IPs.  For monitoring and testing purposes it is useful to
> > get a count of elements currently in a set.
> > 
> > Currently I an running "nft list table inet mytable |wc".  But once the ip
> > set grows to much over 100k IPs, that command can take around 90 minutes
> > on my system!  During that time the nft command takes 98% CPU.  That makes
> > monitoring in this manner nearly impossible.
> > 
> > I think the in-kernel code tracks the current number of elements.  Can we
> > expose this through the Netlink interface so users can get an instant
> > count of elements with virtually 0 CPU usage?  (Note, I'm not talking the
> > "size" data point, I'm talking the actual IPs currently in the set.)
> > 
> > Less importantly, I'm wondering what is making nft take so long to list
> > these huge sets.  Maybe the IP numeric sorting and formatting?  If it's
> > all the sorting, maybe an nft option to disable sorting would help?  Or an
> > option to disable formatting and have nft just dump the whole wad of IPs
> > on one line per set?
> > 
> > Thanks so much.  Please CC: my on replies because I'm not sure my
> > subscribe request is working or going anywhere.  The listserv may not like
> > my mail smarthost.
> 
> There is a count field in more recent userspace nft and kernels, what
> nft and kernel versions are you running?

nft list ruleset
table ip t {
        set s {
                type ipv4_addr
                size 10 # count 1
                counter
                elements = { 1.1.1.1 counter packets 1 bytes 11 }
        }
}

Userspace supports is available since nftables 1.1.5:
$ git describe --contains 8ff87c8fd483eb3fdab5839cccaf100b593fe92e
v1.1.4~48

And Linux kernel needs to >= v6.17:
$ git describe --contains 0014af802193a
v6.16-rc1~132^2~190^2
