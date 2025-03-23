Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1531EE014
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 10:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742725506; cv=none; b=cTu2kW4uoa5A6ckh/89u3Sfa8aAPnok4WSXJVzkTL+VeNIWBNy5yHfiwM43X+ZLfczcFxmlxxB3iUeSmTNJsixYQjtKHDxTqJAWUqaEdwzIoVuVT3014YUPto+i1MQemfBChBFAHz3+QrAmwceQA7peZqMlDlCB2Q+ZPv+gJnBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742725506; c=relaxed/simple;
	bh=ShIEouvCpaJ04L9uRNzGdMvW+9pmA9myUV0nSdgOF4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjJagJ23HcFybgojsyko6pRP9/l+8OWIQzkHi3zZGThws+huU39o4dklPNrgAKOERs6htlWlW/qK3OrdrSdF98CO78DjdnoTg9BmJiaxZG1mQxKW3mws6vk2tR0Te8wMy5asC96YY5Ylcr082W0aYaRjagBdna/+bhQfSF8Dnko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TDVu63cm; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qReP9WQT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TDVu63cm";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qReP9WQT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1354B60390; Sun, 23 Mar 2025 11:25:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742725503;
	bh=5S0s16N9sXi2bWwepzW5tdeZIVf0Duit6gQxW7ly5h0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TDVu63cm7otKAUvt1dqDfPola9DoOnR99i77MT9eFI+Vw4aBgYP1z4m8+A7ay/5O2
	 rbBNxfvMz4vagHrRy7NV3bwbevA67e3E46sx5etI4lunsvjYsltmfYJLZkFillXzHq
	 NTA+mJZnd3Q4BNXZSRdXzZuC0LXHU9tHkZcmxlVG8+qqusfL4XSLSAJ8ldf2Svyyzk
	 CYRkhGzx2UcrjCY/RJNBV9NGApjbkNB8ixZezPVjGRA85EFSyJKtpQxRFqNgV8WbEG
	 GxEOV4sdNEeXOJnb+jgRGkjsYYu7GSZhfkveQLUqdzCfyE9nzwzZ+7HMCTHT7MoDuR
	 JFuvNIbKF6teg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E568D6037D;
	Sun, 23 Mar 2025 11:24:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742725500;
	bh=5S0s16N9sXi2bWwepzW5tdeZIVf0Duit6gQxW7ly5h0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qReP9WQTVDZF2L2LVZ2ikUu3WCd4TRTnEB9IkQzzuRjUINr09j92D630n/o+E0YWf
	 mzngh5VxoGDLTIg5Fp3HhkxW46bYOc0Jz1avZfDuW+uvjHyUdLYrmgpRmxf8zoBhdt
	 WVTjEYkAsCI7hby2CxYhmh9//d7cP4jkc6M/Q3SkhZ3qtk0ZZ8sj9SGWHbtTz63VNx
	 pRZCHwTyGM7h8yNzctQW3rckrF6w+45xBdm28GgLt8l13aYfKhUybBoQT5dI3SVyoS
	 tpmWlBZ001ySOsY5H+FcOFfDFywQU0NK+C4TWFM/hHGmH3UG+A8lZa2UF2giujpunU
	 xk1syv2ulHNJA==
Date: Sun, 23 Mar 2025 11:24:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, matthias.gerstner@suse.com, phil@nwl.cc,
	eric@garver.life
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z9_heeaa17G7egnE@calendula>
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8jDjlJcehMB_Z9F@calendula>
 <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>

On Fri, Mar 21, 2025 at 02:29:46PM +0100, Arturo Borrero Gonzalez wrote:
> 
> On 3/5/25 22:35, Pablo Neira Ayuso wrote:
> > Hi Jan,
> > 
> > I added a few more people to Cc.
> > 
> > On Fri, Feb 28, 2025 at 09:59:35PM +0100, Jan Engelhardt wrote:
> > > There is a customer request (bugreport) for wanting to trivially load a ruleset
> > > from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
> > > service unit is hereby added to provide that functionality. This is based on
> > > various distributions attempting to do same, cf.
> > > 
> > > https://src.fedoraproject.org/rpms/nftables/tree/rawhide
> > > https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/
> > > nftables.initd
> > > https://gitlab.archlinux.org/archlinux/packaging/packages/nftables
> > Any chance to Cc these maintainers too? Given this is closer to
> > downstream than upstream, I would like to understand if this could
> > cause any hypothetical interference with distro packagers.
> > 
> > Only subtle nitpick I see with this patch is that INSTALL file is not
> > updated to provide information on how to use --with-unitdir=.
> > 
> 
> I have mixed feelings about having this systemd service file in this repository.
> Will this file be maintained wrt. systemd ecosystem updates? Or will it be
> outdated and neglected after a few years?

From your words, I guess you don't find this useful for the Debian
case?

I understand your concerns of having a file in the tree that gets no
attention, for me, it is one less file to maintain TBH.

But maybe common ground on this helps reinvent the wheel if there is
consensus on this.

Having said this, I am a not so close downstream packager
requirements.
