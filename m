Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCCF31B13C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755596973; cv=none; b=EmdptMlC9ZH7Ye5ZKiaBDXi1SJhNiyV47lgWd6mnpDS5bpgb1/t1iUTS9/y/NyF5/BlksrsxWV+kjHC5SC34lGYWnu5Po25iIFi2sOp1ZO62fwVy8WSp7w4Uqe9CGWgawqtZKUsXSY7vMNk3qiNty+AD7VBMWn+Q0Gmooi/VcmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755596973; c=relaxed/simple;
	bh=iGhkyRZ8hxdt1A1uTmt0i7YvooZsn5Z4s818Po6sXWE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAzfyqfq0DE/BENuE8uSxOihykBE7wfI/cSyZTJAEJsAomDZjyL6l4QzZTu6VKjRlv3GxiIeJ1yEFD7tQkcYBdAkkWBCCXy4XNlTv8TWIh1KEYYFtmmP/BMbDW74vLyfVEs/IUpNGzrMs8jz0Fz8XNzWmxeiF19okt1iRhq2Za0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CvpM5f+/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ri76BVcg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CvpM5f+/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ri76BVcg"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 456D260281; Tue, 19 Aug 2025 11:49:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755596969;
	bh=t7iNGE5fi2SJ0IiRkYjTTQqcAGsGkDyH9zB0gNtTWJw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=CvpM5f+/vHP9rjHFKZG3V+uDfMdNti5dhjqxa0703MaqVbbKYK3lPUsVryVgIxKum
	 XlqJ7cWlqY5q4cipHRCQqRSiX6SAjIxIsS03AGke4TTt1RepngZqjs4IyPL733XInv
	 H00I6AxluT4NL5QcvyNkVKiCcuWrk5UyKiY/FGtuxp94U0y85dkfCv0KH7atPFLZ50
	 Mx2SKGPUW6+poDpffo6cnwEC155hGaKCgN8KMSd2I+ckaS/R7JbuzjOsaoOFcY6nR2
	 C5TJEINBHsbRBfci2RFleuVMqcFu+0o5CJgz/tiaBiT4omltPzYIX1NmyellAFtoWQ
	 YSr7EAblG353w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8AB946027C;
	Tue, 19 Aug 2025 11:49:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755596968;
	bh=t7iNGE5fi2SJ0IiRkYjTTQqcAGsGkDyH9zB0gNtTWJw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ri76BVcgxT4VpCE9/UM49lcSUg2YFV6L0deTmg0Nfy0N5p+90CcQ199YKvhJ01Pbg
	 v6VIVpIjJ7f1JvQ12n2OWV4H0CX34aOwXJ2/rBeeuHJ3Hd5DlwY79lRw5+6zkiilM2
	 KlieMIOBQcl+jeBWXq0PeGtMSYcLOFHrh637t1qlGZKBKZxPAfpKIoe7TTYtGDnYcA
	 MSLcWZAIkeCcCTqwi2Q77V0LsC9CE2e8nw+Sp+SFBCC8twvFYixRJpH6CBZq5tAqOz
	 TgU5z4hcj1uxQVyyx37Qg11he0xMdq33o0A7yyTuLoaIWt42xBIXRaatf4sqdi8cCW
	 McibIyBGLs6ug==
Date: Tue, 19 Aug 2025 11:49:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/14] json: Do not reduce single-item arrays on
 output
Message-ID: <aKRIpVbN32L7B2b5@calendula>
References: <20250813170549.27880-1-phil@nwl.cc>
 <aKM1tbmVvbzoDUqx@calendula>
 <aKOWFj5sjJNySsde@orbyte.nwl.cc>
 <aKO2RJbE_3GdtwNH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKO2RJbE_3GdtwNH@calendula>

On Tue, Aug 19, 2025 at 01:24:52AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 18, 2025 at 11:07:34PM +0200, Phil Sutter wrote:
> > On Mon, Aug 18, 2025 at 04:16:21PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Aug 13, 2025 at 07:05:35PM +0200, Phil Sutter wrote:
> > > > This series consists of noise (patches 1-13 and most of patch 14) with a
> > > > bit of signal in patch 14. This is because the relatively simple
> > > > adjustment to JSON output requires minor adjustments to many stored JSON
> > > > dumps in shell test suite and stored JSON output in py test suite. While
> > > > doing this, I noticed some dups and stale entries in py test suite. To
> > > > clean things up first, I ran tests/py/tools/test-sanitizer.sh, fixed the
> > > > warnings and sorted the changes into fixes for the respective commits.
> > > 
> > > Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Series applied, thanks!
> > 
> > > I will follow up with a patch to partially revert the fib check change
> > > for JSON too.
> > 
> > Hmm. That one seems like a sensible change and not just a simplification
> > of output.
> 
> Actually, I don't find an easy way to retain backward compatibility in
> the JSON output for fib without reverting:
> 
> commit 525b58568dca5ab9998595fc45313eac2764b6b1
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue Jun 24 18:11:10 2025 +0200
> 
>     fib: allow to use it in set statements
> 
> commit f4b646032acff4d743ad4f734aaca68e9264bdbb
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue Jun 24 18:11:06 2025 +0200
> 
>     fib: allow to check if route exists in maps
> 
> I am not sure I want to do that, because then the fib expression
> cannot be used with sets/maps.

I found a way, it is not "nice" but it helps to address the current
issue:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250819092342.721798-1-pablo@netfilter.org/
