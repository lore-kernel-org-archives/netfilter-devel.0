Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [45.157.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729331802A0
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495946; cv=none; b=dkZC4k1qq5Abu/2+C/JF8/P++GveRiyYD3k060n6krWT7QIu6cwdD8J/ktF5mTGDN9D+TbXyrI1UHLtpXsAhQLWN61Cy0IspMLxSilrsve3gVx4+3vcwHw9kEbF4p8AOXInEkc7HkSM5RfCpAGx1/iWwKw8glF5gsK6wVM3+yks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495946; c=relaxed/simple;
	bh=JSh9G8B/hhE3cjcRgoAQVV5csCa5MBscKddNaCVOwYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ap2yWYZWIUQOgjBUJkeyw2Aw7JPCao7B4VT5F7nFJlm+J/OUpmVsG/Q9MCB5zNlG5eFL16zXAh0k2IF74jgwz5R4qsZphaekWSxz8RZF82EX+G/UQ/N2FZ+dmx248pkZAydmvwbEKW4P2RXsCLf9Edm8yTS0GEILnJ5n0H8+hVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=wu87VAyq; arc=none smtp.client-ip=45.157.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="wu87VAyq"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VTR7f6JW2zjL8;
	Tue, 30 Apr 2024 18:52:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714495934;
	bh=JSh9G8B/hhE3cjcRgoAQVV5csCa5MBscKddNaCVOwYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wu87VAyqG0g9pzocG398PQkwDaP655Xc+z/wpf4zOlnDGW0A0K2bm2AE8B0KLPoGP
	 sBQoBn33iKNf5j1X5p2x54+sYDzhyynFDJGwFTgdU7R1AS/HgyTxfk+jLObEqedf98
	 avJFepZnA9omeMZ2MTRFkm3hPRu1RLTQZQ15xybo=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4VTR7d44DkzNRV;
	Tue, 30 Apr 2024 18:52:13 +0200 (CEST)
Date: Tue, 30 Apr 2024 18:52:12 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
Message-ID: <20240430.beicheugee5T@digikod.net>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240425.Soot5eNeexol@digikod.net>
X-Infomaniak-Routing: alpha

On Tue, Apr 30, 2024 at 03:36:30PM +0200, Mickaël Salaün wrote:
> On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
> > Make hook for socket_listen(). It will check that the socket protocol is
> > TCP, and if the socket's local port number is 0 (which means,
> > that listen(2) was called without any previous bind(2) call),
> > then listen(2) call will be legitimate only if there is a rule for bind(2)
> > allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
> > supported by the sandbox).
> 
> Thanks for this patch and sorry for the late full review.  The code is
> good overall.
> 
> We should either consider this patch as a fix or add a new flag/access
> right to Landlock syscalls for compatibility reason.  I think this
> should be a fix.  Calling listen(2) without a previous call to bind(2)
> is a corner case that we should properly handle.  The commit message
> should make that explicit and highlight the goal of the patch: first
> explain why, and then how.
> 
> We also need to update the user documentation to explain that
> LANDLOCK_ACCESS_NET_BIND_TCP also handles this case.
> 
> > 
> > Create a new check_access_socket() function to prevent useless copy paste.
> > It should be called by hook handlers after they perform special checks and
> > calculate socket port value.
> 
> You can add this tag:
> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> 
> > 
> > Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
> > Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > ---
> >  security/landlock/net.c | 104 +++++++++++++++++++++++++++++++++-------
> >  1 file changed, 88 insertions(+), 16 deletions(-)


> > +		if (inet_sk(sock->sk)->inet_num != 0)
> 
> Why do we want to allow listen() on any socket that is binded?

Please ignore this comment. I was initially thinking about a new access
right, which would be good to have anyway, but with another series.
