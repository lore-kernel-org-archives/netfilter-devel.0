Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3614AD3A
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728036824; cv=none; b=F/eoOtwbAo5W5dTbBk8wGQ7cLjz/B7+KAfofjJN4+XRfoDMnP1LbPOg1s/knT2sMT6jaEnM1+FsQlMITfBDDapmZGC6L+CRTI6QbkP+FmQ2bpk81Y820hK4vfOBHqiQcU7apJ/goRUpOWty4s+YdLsRwB2TT0phhfvcNpeRUilc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728036824; c=relaxed/simple;
	bh=bUFKWpGhuHRDtfCZqSYM/ze1RxFi/q9nGlZp5xS3B50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTo6YkSHle+gj4RAtvpCDW34alwKhAYFQ9diTBSwNX/Jq6zEjeFylzXdtCPu2GWLZIVo2QZSvwJ8QdDaKfifqKOLpe0q28wuVYuu2p8gUBErRcWtltJsg3Kc14AJ9bYghVljvxW09ywYykBv2qYL8H6yIauZkVOcYyjqLLSS13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=bdKx133V; arc=none smtp.client-ip=45.157.188.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="bdKx133V"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XKks740lFzJkK;
	Fri,  4 Oct 2024 12:13:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1728036811;
	bh=cqBQ9GK30wBQ0mr0f5EWQqndSVgF06uTkPIX5PaNsLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bdKx133Vy6xqJ40PSAv+hx1dx30i9BPFY3RphqDoJPa4e9HYgxHHpc4GUz0cvXHKU
	 I2HFhO08WqOavyPqNVcvjGdk0PHvXLOiP16v6en3RrPbZy7gyjIJvWm7lPQUOtAdbO
	 Dt2n7HZx9XZ5weBPl0jKAm1LXV6+D7wZ6wZreG70=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4XKks66FGyzf58;
	Fri,  4 Oct 2024 12:13:30 +0200 (CEST)
Date: Fri, 4 Oct 2024 12:13:26 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
Message-ID: <20241004.rel9ja7IeDo4@digikod.net>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
 <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
 <20241003.wie1aiphaeCh@digikod.net>
 <8f023c51-bac1-251e-0f40-24dbe2bba729@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f023c51-bac1-251e-0f40-24dbe2bba729@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Fri, Oct 04, 2024 at 12:30:02AM +0300, Mikhail Ivanov wrote:
> On 10/3/2024 8:45 PM, Mickaël Salaün wrote:
> > Please also add Matthieu in Cc for the network patch series.
> > 
> > On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
> > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > (SCTP, MPTCP, SMC).
> > > 
> > > Closes: https://github.com/landlock-lsm/linux/issues/40
> > > Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > ---
> > >   security/landlock/net.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/security/landlock/net.c b/security/landlock/net.c
> > > index bc3d943a7118..6f59dd98bb13 100644
> > > --- a/security/landlock/net.c
> > > +++ b/security/landlock/net.c
> > > @@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *const sock,
> > >   		return -EACCES;
> > >   	/* Checks if it's a (potential) TCP socket. */
> > 
> > We can extend this comment to explain that we don't use sk_is_tcp()
> > because we need to handle the AF_UNSPEC case.
> 
> Indeed, I'll do this.
> 
> > 
> > > -	if (sock->type != SOCK_STREAM)
> > > +	if (sock->type != SOCK_STREAM || sock->sk->sk_protocol != IPPROTO_TCP)
> > 
> > I think we should check sock->sk->sk_type instead of sock->type (even if
> > it should be the same).  To make it simpler, we should only use sk in
> > current_check_access_socket():
> > struct sock *sk = sock->sk;
> 
> Agreed.
> 
> > 
> > Could you please also do s/__sk_common\.skc_/sk_/g ?
> 
> Ofc
> 
> Btw, there is probably incorrect read of skc_family in this function
> [1]. I'll add READ_ONCE for sk->sk_family.
> 
> [1] https://lore.kernel.org/all/20240202095404.183274-1-edumazet@google.com/

I think it should not be a bug with the current code (IPv6 -> IPV4, and
socket vs. sock) but we should indeed use READ_ONCE() (and add this link
to the commit message).

> 
> > 
> > >   		return 0;
> > >   	/* Checks for minimal header length to safely read sa_family. */
> > > -- 
> > > 2.34.1
> > > 
> > > 
> 
