Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B01F4C9B
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 10:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742552770; cv=none; b=j+sOAt3H1ZOPeCKrbOie8zXFYpE4QPTUF3oPsbgszmbVDCI1JqM+W+o6LWRZBYcvKcaQ5yuwHQh6W28eOWAPevg7TMJRs2EMZjR6h2CzbEqKMcGbEuGRT7C7RBM+U5zqUR2eq3tr9k4zSFpbxn+QY7+ANaBXRTYxw+c3TnFH4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742552770; c=relaxed/simple;
	bh=/U4/4npL+Qq6f+4Z/aJv8vj7H5DhPJFgirUnvnadPlM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPV9G8lS3H79ugz85fCQ6D0K7ykTXHW6cxokej8MADZ/FJ26ORGxGG76xq73OfzUTDYT3nAQxHpbiRhOJCmBhbVPBNTHr0YwZkdHuowyH0NGWR9WqWA00JeFDqdct0k1Bojwb+f6cKaCrXjPyV2uIs76+ngcg7Q3pdhqAyMJD2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AmH9P+x6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AmH9P+x6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AmH9P+x6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AmH9P+x6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5C45B605A4; Fri, 21 Mar 2025 11:26:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742552765;
	bh=QNZfW+kn4WssSrUwkRdFS1xMYLgslw8BIdUHO6KaxMQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=AmH9P+x6cSYaMg5i1Ajitn9kMjT5xv5p22geIC515QVeJ5O4cEvfZGAEsu1Ypy92W
	 dV2tEFVNcnaOlW6svwjMyof3WSY+2/elJpyDnYJH1QQnrkdt5/zs5dklo9ZQykll9O
	 q0F+l5XlotOoyW10v2M7BiR+FipOfp2CsCJ1224q22QiHV5deke1nLGRUpGtrUPyVn
	 V83Km5I0UVSrv+CiO8xaYO2YgoqCs5tj8PUy2xRoSqoHohZfEoW3D7JZNy/Oja4jQO
	 9Iyea1SQt284OB40xcaSq3aTlU5R9xVPpSkwcH0r0ON56YgkzzCguT7O/yV0OLtb7P
	 GxtrnbEHRZA4g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EB38D60594
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 11:26:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742552765;
	bh=QNZfW+kn4WssSrUwkRdFS1xMYLgslw8BIdUHO6KaxMQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=AmH9P+x6cSYaMg5i1Ajitn9kMjT5xv5p22geIC515QVeJ5O4cEvfZGAEsu1Ypy92W
	 dV2tEFVNcnaOlW6svwjMyof3WSY+2/elJpyDnYJH1QQnrkdt5/zs5dklo9ZQykll9O
	 q0F+l5XlotOoyW10v2M7BiR+FipOfp2CsCJ1224q22QiHV5deke1nLGRUpGtrUPyVn
	 V83Km5I0UVSrv+CiO8xaYO2YgoqCs5tj8PUy2xRoSqoHohZfEoW3D7JZNy/Oja4jQO
	 9Iyea1SQt284OB40xcaSq3aTlU5R9xVPpSkwcH0r0ON56YgkzzCguT7O/yV0OLtb7P
	 GxtrnbEHRZA4g==
Date: Fri, 21 Mar 2025 11:26:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: doc: Re-order gcc args so
 nf-queue.c compiles on Debian systems
Message-ID: <Z90-ujnsHlFRH4P3@calendula>
References: <20250319005605.18379-1-duncan_roe@optusnet.com.au>
 <Z9qOVEObhFzmVKx6@calendula>
 <Z9ssJMKDJDetdYV2@slk15.local.net>
 <Z9zHjBkgCDyPiBoN@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9zHjBkgCDyPiBoN@slk15.local.net>

On Fri, Mar 21, 2025 at 12:57:32PM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Thu, Mar 20, 2025 at 07:42:12AM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > On Wed, Mar 19, 2025 at 10:28:52AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 19, 2025 at 11:56:05AM +1100, Duncan Roe wrote:
> > > >   * Simple compile line:
> > > >   * \verbatim
> > > > -gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> > > > +gcc -g3 -gdwarf-4 -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl
> > >
> > > I am going t remove -g3 and -gdwarf-4, so it ends up with:
> > >
> > > gcc -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl
> >
> > That makes nonsense of the previous line:
> >
> > | you should start by reading (or, if feasible, compiling and stepping through with gdb) nf-queue.c
> >
> > You can only step through nf-queue.c if you compile with the debug options.
> >
> > Please leave them there.
>   ^^^^^^ ^^^^^ ^^^^ ^^^^^^
> You chose to ignore this or maybe you just missed it?

none of them, just disagreement.

> I can send a patch to remove the reference to gdb in the previous paragraph or I
> can send a patch to reinstate the gcc debug options. Which would you prefer?

developers are familiar with debugging tools, there are more choices
that gdb, -g is a "popular" flag, there is no need to document that
many gcc options in the documentation, just a "Simple compile line" is
fine.

I very much apologize for the discomfort this rises on you.

Thanks.
