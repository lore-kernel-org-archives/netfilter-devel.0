Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E831D1F5A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728308152; cv=none; b=Mvzg8eEdsCp7nBj8Rn68rJdY3QAPUXOcT78FJPnITfiOYk7TeN+SAdnqe6mYVKFIrCh9fTPs3a4TybWCVQsNcHpgXIlnXPce+2g6dY0tgV+RJiBmDO+chRmymYMWJTWnx66q5PtozqwxhsrfvIanrlXrX1ji9CMIW0F4kiEVfOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728308152; c=relaxed/simple;
	bh=B54sR9Sa5K3R6L1LR5YH1nqW0mmfeA8i4OjJElbWIy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uz3FpW/Fr4VSZr8GfI33756lVei6SUfZfqLWnU7VcE0+u6FiZya5hlzIn0uRKg7XRRB9yoJN306fR7+D/fDEF+l4HmAEHY8BnZi3sxP9g17r7pW24g/J81QhhebLJcsbB9iI78uOBnqnEtmP3+JsNQe3eMdtNCoCiiVKVACBtqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=piYlzThc; arc=none smtp.client-ip=45.157.188.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="piYlzThc"
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XMgC00Cw4zL7G;
	Mon,  7 Oct 2024 15:35:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1728308139;
	bh=1pTlD7O6TYz2oK0/5j7oFAP/ARJGsmWMAioMZqPOTsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=piYlzThcqAPquoljy4drj7lOQeVN22gnZ5AOOZ3i4jiKsYjzFTto/4YoIQy81P7Hn
	 KbWVo9UuLbQAfZ9qjuA+9CFQ9OJXGEKyryzvL8KLBNGyJTGXrYTeqKEOkjJaXZbM8/
	 fuW8QYVPkArl299EcyjXp3pdEOPSzO0hDK28BJAI=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4XMgBz0Pd2zZGc;
	Mon,  7 Oct 2024 15:35:38 +0200 (CEST)
Date: Mon, 7 Oct 2024 15:35:35 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: Paul Moore <paul@paul-moore.com>, gnoack@google.com, 
	willemdebruijn.kernel@gmail.com, linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, artem.kuzin@huawei.com, 
	konstantin.meskhidze@huawei.com, Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
Message-ID: <20241007.ahuughaeF8ph@digikod.net>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
 <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
 <20241003.wie1aiphaeCh@digikod.net>
 <8f023c51-bac1-251e-0f40-24dbe2bba729@huawei-partners.com>
 <20241004.rel9ja7IeDo4@digikod.net>
 <0774e9f1-994f-1131-17f9-7dd8eb96738f@huawei-partners.com>
 <20241005.eeKoiweiwe8a@digikod.net>
 <9ae80f8c-1fb4-715f-87e1-b605ea4af59c@huawei-partners.com>
 <06f1d60a-91b6-7fa4-8839-e1752dbc2ec8@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06f1d60a-91b6-7fa4-8839-e1752dbc2ec8@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Mon, Oct 07, 2024 at 02:58:43PM +0300, Mikhail Ivanov wrote:
> On 10/7/2024 2:06 PM, Mikhail Ivanov wrote:
> > On 10/5/2024 6:49 PM, Mickaël Salaün wrote:
> > > On Fri, Oct 04, 2024 at 09:16:56PM +0300, Mikhail Ivanov wrote:
> > > > On 10/4/2024 1:13 PM, Mickaël Salaün wrote:
> > > > > On Fri, Oct 04, 2024 at 12:30:02AM +0300, Mikhail Ivanov wrote:
> > > > > > On 10/3/2024 8:45 PM, Mickaël Salaün wrote:
> > > > > > > Please also add Matthieu in Cc for the network patch series.
> > > > > > > 
> > > > > > > On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
> > > > > > > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > > > > > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > > > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > > > > > > (SCTP, MPTCP, SMC).
> > > > > > > > 
> > > > > > > > Closes: https://github.com/landlock-lsm/linux/issues/40
> > > > > > > > Fixes: fff69fb03dde ("landlock: Support network
> > > > > > > > rules with TCP bind and connect")
> > > > > > > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > > > > > > ---
> > > > > > > >     security/landlock/net.c | 2 +-
> > > > > > > >     1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > > 
> > > > > > > > diff --git a/security/landlock/net.c b/security/landlock/net.c
> > > > > > > > index bc3d943a7118..6f59dd98bb13 100644
> > > > > > > > --- a/security/landlock/net.c
> > > > > > > > +++ b/security/landlock/net.c
> > > > > > > > @@ -68,7 +68,7 @@ static int
> > > > > > > > current_check_access_socket(struct socket *const
> > > > > > > > sock,
> > > > > > > >             return -EACCES;
> > > > > > > >         /* Checks if it's a (potential) TCP socket. */
> > > > > > > 
> > > > > > > We can extend this comment to explain that we don't use sk_is_tcp()
> > > > > > > because we need to handle the AF_UNSPEC case.
> > > > > > 
> > > > > > Indeed, I'll do this.
> > > > 
> > > > I've noticed that we still should check sk->sk_family = AF_INET{,6}
> > > > here (so sk_is_tcp() is suitable). AF_UNSPEC can be only related to
> > > > addresses and we should not provide any checks (for address) if socket
> > > > is unrestrictable (i.e. it's not TCP). It's not useful and might lead to
> > > > error incosistency for non-TCP sockets.
> > > 
> > > Good catch, let's use sk_is_tcp().
> > > 
> > > > 
> > > > Btw, I suppose we can improve error consistency by bringing more checks
> > > > from INET/TCP stack. For example it may be useful to return EISCONN
> > > > instead of EACCES while connect(2) is called on a connected socket.
> > > 
> > > Yes, that would be nice (with the related tests).
> > > 
> > > > 
> > > > This should be done really carefully and only for some useful cases.
> > > > Anyway it's not related to the current patch (since it's not a bug).
> > > 
> > > Sure.
> > 
> > I have a little question to clarify before sending a next version. Are
> > we condisering order of network checks for error consistency?
> > 
> > For example, in the current_check_access_socket() we have following
> > order of checks for ipv4 connect(2) action:
> > (1) addrlen < sizeof(struct sockaddr_in) -> return -EINVAL
> > (2) sa_family != sk_family -> return -EINVAL
> > 
> > The ipv4 stack has a check for sock->state before (1) and (2), which can
> > return -EISCONN if the socket is already connected.
> > 
> > This results in the possiblity of two following scenarios:
> > 
> > Landlock enabled:
> > 1. socket(ipv4) -> OK
> > 2. connect(ipv4 address) -> OK
> > 3. connect(ipv6 address) -> -EINVAL (sa_family != sk_family)
> > 
> > Landlock disabled:
> > 1. socket(ipv4) -> OK
> > 2. connect(ipv4 address) -> OK
> > 3. connect(ipv6 address) -> -EISCONN (socket is already connected)
> > 
> > I have always considered the order of network checks as part of error
> > consistency, and I'd like to make sure that we're on the same page
> > before extending current patch with error inconsistency fixes.

Yes, we should try to stick to the same error ordering, and this should
be covered by tests.

> 
> BTW, a similar inconsistency in the error order was also found in
> selinux hooks. Accounting [1], I wonder if validating socket state
> in security hooks for bind/connect actions has been considered before.
> 
> [1] https://lore.kernel.org/all/20231228113917.62089-1-mic@digikod.net/

I think Landlock has a better test coverage than any other
(access-control) LSM, which is why we find these inconsistencies.
The LSM hooks should be better integrated into the network stack to
benefit from all the inconsistency checks.  On the other end, one
benefit of being call earlier is that an LSM can stop invalid requests
(I don't think it's worth it though).

However, before trying to change the hook call sites, we should first
make sure the side effects are OK for every LSMs:
https://lore.kernel.org/all/20240327120036.233641-1-mic@digikod.net/
...which also include testing (which is what we do for Landlock).

Any though from the network folks?
