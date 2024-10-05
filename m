Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [84.16.66.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F998C2C9
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Oct 2024 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728143411; cv=none; b=Mu22v9aAf5fs7ZnwEWi+crS2IO3wkoqXG+cZeJk999UwOdp+LIVG89yj6VchxG5qJuFN4mwJrDwCWGwyUr7/6FJXhjQLLPLw5StauAYcXDlx4LSGwhiU7UsRkqlfQ607MmyhcwcZ+DCdLI+LyCg6kYiUdHHO7N7Tq+8AqSpXLO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728143411; c=relaxed/simple;
	bh=pFKcRB9zxsPWbtFDjflB/H+lmvRDsZY8/fzMq5a8meA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNBF9EqkKWqIYwzuOqAmUovpr1866hUTu6C1+iW5BMfj8uJF2js7povSjCDhPSiONGlmLQyWPyWP5X4YhZRNB1x5rrzdE5CSPuBoUrPL3NvD9wnQOF5oQGnobZcER7jeCwXPWUDqc0v4zdcuQAYeDYlIFznb433NqBAWkPyuvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=ZGY3aoZ2; arc=none smtp.client-ip=84.16.66.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="ZGY3aoZ2"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XLVGw54vlzKgG;
	Sat,  5 Oct 2024 17:50:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1728143400;
	bh=fEvnRaFE9+q3pKxb6HraPtzHUWsyP46VVEjoPYI/r24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZGY3aoZ2si2zzo9W8u0Cwl2O1H/GLlW2K9JsKmKtijHygTUvRUVzZyfMHzQsRVZX4
	 oc64L0BvDHAY7gT0uNWhsHDRPSKan/EM3b/aXkqlM4J9CdCDvoO7UkTGhJKo7u5Gfn
	 ESMghYiRTVo/4+dYZEyMYlayL8lM8C0XC9EdvnvM=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4XLVGv6xb5znb9;
	Sat,  5 Oct 2024 17:49:59 +0200 (CEST)
Date: Sat, 5 Oct 2024 17:49:57 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>, 
	Paul Moore <paul@paul-moore.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
Message-ID: <20241005.eeKoiweiwe8a@digikod.net>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
 <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
 <20241003.wie1aiphaeCh@digikod.net>
 <8f023c51-bac1-251e-0f40-24dbe2bba729@huawei-partners.com>
 <20241004.rel9ja7IeDo4@digikod.net>
 <0774e9f1-994f-1131-17f9-7dd8eb96738f@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0774e9f1-994f-1131-17f9-7dd8eb96738f@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Fri, Oct 04, 2024 at 09:16:56PM +0300, Mikhail Ivanov wrote:
> On 10/4/2024 1:13 PM, Mickaël Salaün wrote:
> > On Fri, Oct 04, 2024 at 12:30:02AM +0300, Mikhail Ivanov wrote:
> > > On 10/3/2024 8:45 PM, Mickaël Salaün wrote:
> > > > Please also add Matthieu in Cc for the network patch series.
> > > > 
> > > > On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
> > > > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > > > (SCTP, MPTCP, SMC).
> > > > > 
> > > > > Closes: https://github.com/landlock-lsm/linux/issues/40
> > > > > Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> > > > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > > > ---
> > > > >    security/landlock/net.c | 2 +-
> > > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/security/landlock/net.c b/security/landlock/net.c
> > > > > index bc3d943a7118..6f59dd98bb13 100644
> > > > > --- a/security/landlock/net.c
> > > > > +++ b/security/landlock/net.c
> > > > > @@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *const sock,
> > > > >    		return -EACCES;
> > > > >    	/* Checks if it's a (potential) TCP socket. */
> > > > 
> > > > We can extend this comment to explain that we don't use sk_is_tcp()
> > > > because we need to handle the AF_UNSPEC case.
> > > 
> > > Indeed, I'll do this.
> 
> I've noticed that we still should check sk->sk_family = AF_INET{,6}
> here (so sk_is_tcp() is suitable). AF_UNSPEC can be only related to
> addresses and we should not provide any checks (for address) if socket
> is unrestrictable (i.e. it's not TCP). It's not useful and might lead to
> error incosistency for non-TCP sockets.

Good catch, let's use sk_is_tcp().

> 
> Btw, I suppose we can improve error consistency by bringing more checks
> from INET/TCP stack. For example it may be useful to return EISCONN
> instead of EACCES while connect(2) is called on a connected socket.

Yes, that would be nice (with the related tests).

> 
> This should be done really carefully and only for some useful cases.
> Anyway it's not related to the current patch (since it's not a bug).

Sure.

The following patch series could probably be extended for all LSM to
benefit from these fixes:
https://lore.kernel.org/all/20240327120036.233641-1-mic@digikod.net/

Mikhail, according to your SCTP tests with SELinux, it looks like this
patch series should be updated, but that should be simple.

Paul, what is the status of this LSM patch series?  Could Mikhail
integrate this LSM patch (with the SCTP fix) as part of the current
Landlock patch series?  This would help fixing the Landlock tests (which
check SCTP error consistency) when run with SELinux.

> 
> > > 
> > > > 
> > > > > -	if (sock->type != SOCK_STREAM)
> > > > > +	if (sock->type != SOCK_STREAM || sock->sk->sk_protocol != IPPROTO_TCP)
> > > > 
> > > > I think we should check sock->sk->sk_type instead of sock->type (even if
> > > > it should be the same).  To make it simpler, we should only use sk in
> > > > current_check_access_socket():
> > > > struct sock *sk = sock->sk;
> > > 
> > > Agreed.
> > > 
> > > > 
> > > > Could you please also do s/__sk_common\.skc_/sk_/g ?
> > > 
> > > Ofc
> > > 
> > > Btw, there is probably incorrect read of skc_family in this function
> > > [1]. I'll add READ_ONCE for sk->sk_family.
> > > 
> > > [1] https://lore.kernel.org/all/20240202095404.183274-1-edumazet@google.com/
> > 
> > I think it should not be a bug with the current code (IPv6 -> IPV4, and
> > socket vs. sock) but we should indeed use READ_ONCE() (and add this link
> > to the commit message).
> 
> ok
> 
> > 
> > > 
> > > > 
> > > > >    		return 0;
> > > > >    	/* Checks for minimal header length to safely read sa_family. */
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > > 
> > > 
> 
