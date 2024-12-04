Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACAE2391AA;
	Wed,  4 Dec 2024 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733340488; cv=none; b=bKUMc39slCMMiNBboooVfT7By8UuOEW3eZM0F5RR96PhV6TAEpg+3Gn/yA6T0wMDMkH9P124o7PedbEP/xhdaCzGtEoFgrRy2BiXpYptHwbfYNiSxx01IfF8rtwhsZFQe5hizCfZakxOT6VmCTZVGGYl9Pq6FwvG2CP+BelMe/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733340488; c=relaxed/simple;
	bh=gVf/mBxTJvebnqEdIle6xkNZAvjDrLxAz+i2Ut8HxyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5C6Ifc5lu7+DpOoAPsc8aOJJ71s2PKmNdbNr4IXjDlDaAwUj+kdy6TBd+rqwf2TCPTao9sr10fKMWsCgkX2cGLe0Q3LkvB0zxmM88zU7tLheG6YwZoRtxk7pvR91toCw3TqGWeakZ3Ctv6ggQBB8Sue7pO4NzfOJhlhwXn35YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=yC1l2Qed; arc=none smtp.client-ip=45.157.188.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="yC1l2Qed"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y3SGl1wkfzXvV;
	Wed,  4 Dec 2024 20:27:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733340479;
	bh=K6b7RkVHa81TH/U1AVRf2JXY8+WHDWPpbx+OOiCCbFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yC1l2QedjWBXPi2WNHZJ/QvF/BU0TzsyXnWrh6KkpD5KMJ370QTmWCuHpHgCjCA+t
	 6jbtXLxbmKl6g+VO9dbqsCOTumZbVjS6+Alfdm6/NGXvrugGxMaQbm0hET1cD/dg/i
	 TPMli8FpzCIJA9s8n7hThfpW+R6Db/JZsVBEG1Sc=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y3SGk2Q7cz1h6;
	Wed,  4 Dec 2024 20:27:58 +0100 (CET)
Date: Wed, 4 Dec 2024 20:27:57 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>, 
	gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	MPTCP Linux <mptcp@lists.linux.dev>, David Laight <David.Laight@aculab.com>
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Message-ID: <20241204.fahVio7eicim@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241018.Kahdeik0aaCh@digikod.net>
X-Infomaniak-Routing: alpha

On Fri, Oct 18, 2024 at 08:08:12PM +0200, Mickaël Salaün wrote:
> On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
> > Hi Mikhail and Landlock maintainers,
> > 
> > +cc MPTCP list.
> 
> Thanks, we should include this list in the next series.
> 
> > 
> > On 17/10/2024 13:04, Mikhail Ivanov wrote:
> > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > (SCTP, MPTCP, SMC).
> > 
> > Thank you for the patch!
> > 
> > I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
> > treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
> > see TCP packets with extra TCP options. On Linux, there is indeed a
> > dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
> > because we needed such dedicated socket to talk to the userspace.
> > 
> > I don't know Landlock well, but I think it is important to know that an
> > MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
> > will do a fallback to "plain" TCP if MPTCP is not supported by the other
> > peer or by a middlebox. It means that with this patch, if TCP is blocked
> > by Landlock, someone can simply force an application to create an MPTCP
> > socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
> > certainly work, even when connecting to a peer not supporting MPTCP.
> > 
> > Please note that I'm not against this modification -- especially here
> > when we remove restrictions around MPTCP sockets :) -- I'm just saying
> > it might be less confusing for users if MPTCP is considered as being
> > part of TCP. A bit similar to what someone would do with a firewall: if
> > TCP is blocked, MPTCP is blocked as well.
> 
> Good point!  I don't know well MPTCP but I think you're right.  Given
> it's close relationship with TCP and the fallback mechanism, it would
> make sense for users to not make a difference and it would avoid bypass
> of misleading restrictions.  Moreover the Landlock rules are simple and
> only control TCP ports, not peer addresses, which seems to be the main
> evolution of MPTCP.

Thinking more about this, this makes sense from the point of view of the
network stack, but looking at external (potentially bogus) firewalls or
malware detection systems, it is something different.  If we don't
provide a way for users to differenciate the control of SCTP from TCP,
malicious use of SCTP could still bypass this kind of bogus security
appliances.  It would then be safer to stick to the protocol semantic by
clearly differenciating TCP from MPTCP (or any other protocol).

Mikhail, could you please send a new patch series containing one patch
to fix the kernel and another to extend tests?  We should also include
this rationale in the commit message.

> 
> > 
> > I understand that a future goal might probably be to have dedicated
> > restrictions for MPTCP and the other stream protocols (and/or for all
> > stream protocols like it was before this patch), but in the meantime, it
> > might be less confusing considering MPTCP as being part of TCP (I'm not
> > sure about the other stream protocols).
> 
> We need to take a closer look at the other stream protocols indeed.

It would be nice to add support for MPTCP too, but this will be treated
as a new Landlock feature (with a proper ABI bump).

> 
> > 
> > 
> > > sk_is_tcp() is used for this to check address family of the socket
> > > before doing INET-specific address length validation. This is required
> > > for error consistency.
> > > 
> > > Closes: https://github.com/landlock-lsm/linux/issues/40
> > > Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
