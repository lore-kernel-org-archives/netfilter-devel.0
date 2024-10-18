Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [84.16.66.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF4204025
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729274904; cv=none; b=a2RWFKXqP5LnFFwphBHQTZE+6dwA/eFT1T3Ze9ojUT0apbe9udSphslJp70Aj57mKEEX12kay7G9hcuWUNXfSFV2K/jHtBLxZqvJKmtTxGEsqyN9uRRIOQuLl68IitO0iV96s1rvyWPnvclPtg5DUc0pNje0VNV3BYakVfbjI0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729274904; c=relaxed/simple;
	bh=b8RDOb0eqMg8kr7/h2Rvqmv6d6GX6jwaOxyJBbHi39I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG+ufM2snF6unXOP+tStjM83XO71WkWFlQqR3jawHM+9lqnWIKVpw/IlbJzow08b7IYQUY5TJok+YRx7RBEkRKt+CCnUjv3cAMjCbqr31KJajmmmKSBpG+8yan4VzDjHz17g5AsALbnu0p84Vq4DN8MNMZq29DHOwrbm9GPzTlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=LQd7RQqY; arc=none smtp.client-ip=84.16.66.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="LQd7RQqY"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XVXkN3lLNzgmj;
	Fri, 18 Oct 2024 20:08:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1729274892;
	bh=KEYQT5PqdF1JYcj4P2uuZFLVTpuMdKZe8EXn59nZbKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LQd7RQqYMPUrGzcA8/jm7IUkseYIIA4NA3fGRyC88MUo4RLMBFuOy9CF+h9Qo28BY
	 YXzwwHFm83C5dE6Apmzy8vTi9G2x973pxxtpoBYKF3UoyjpqhZL8xZfMx7VQ3TpOKO
	 DNyZgWtvPR7IKd5ONkSyZYCd/9tb+XO7BmARcaeI=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4XVXkL6rspzLv4;
	Fri, 18 Oct 2024 20:08:10 +0200 (CEST)
Date: Fri, 18 Oct 2024 20:08:10 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>, 
	gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	MPTCP Linux <mptcp@lists.linux.dev>
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Message-ID: <20241018.Kahdeik0aaCh@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
X-Infomaniak-Routing: alpha

On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
> Hi Mikhail and Landlock maintainers,
> 
> +cc MPTCP list.

Thanks, we should include this list in the next series.

> 
> On 17/10/2024 13:04, Mikhail Ivanov wrote:
> > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > should not restrict bind(2) and connect(2) for non-TCP protocols
> > (SCTP, MPTCP, SMC).
> 
> Thank you for the patch!
> 
> I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
> treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
> see TCP packets with extra TCP options. On Linux, there is indeed a
> dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
> because we needed such dedicated socket to talk to the userspace.
> 
> I don't know Landlock well, but I think it is important to know that an
> MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
> will do a fallback to "plain" TCP if MPTCP is not supported by the other
> peer or by a middlebox. It means that with this patch, if TCP is blocked
> by Landlock, someone can simply force an application to create an MPTCP
> socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
> certainly work, even when connecting to a peer not supporting MPTCP.
> 
> Please note that I'm not against this modification -- especially here
> when we remove restrictions around MPTCP sockets :) -- I'm just saying
> it might be less confusing for users if MPTCP is considered as being
> part of TCP. A bit similar to what someone would do with a firewall: if
> TCP is blocked, MPTCP is blocked as well.

Good point!  I don't know well MPTCP but I think you're right.  Given
it's close relationship with TCP and the fallback mechanism, it would
make sense for users to not make a difference and it would avoid bypass
of misleading restrictions.  Moreover the Landlock rules are simple and
only control TCP ports, not peer addresses, which seems to be the main
evolution of MPTCP.

> 
> I understand that a future goal might probably be to have dedicated
> restrictions for MPTCP and the other stream protocols (and/or for all
> stream protocols like it was before this patch), but in the meantime, it
> might be less confusing considering MPTCP as being part of TCP (I'm not
> sure about the other stream protocols).

We need to take a closer look at the other stream protocols indeed.

> 
> 
> > sk_is_tcp() is used for this to check address family of the socket
> > before doing INET-specific address length validation. This is required
> > for error consistency.
> > 
> > Closes: https://github.com/landlock-lsm/linux/issues/40
> > Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> 
> I don't know how fixes are considered in Landlock, but should this patch
> be considered as a fix? It might be surprising for someone who thought
> all "stream" connections were blocked to have them unblocked when
> updating to a minor kernel version, no?

Indeed.  The main issue was with the semantic/definition of
LANDLOCK_ACCESS_FS_NET_{CONNECT,BIND}_TCP.  We need to synchronize the
code with the documentation, one way or the other, preferably following
the principle of least astonishment.

> 
> (Personally, I would understand such behaviour change when upgrading to
> a major version, and still, maybe only if there were alternatives to

This "fix" needs to be backported, but we're not clear yet on what it
should be. :)

> continue having the same behaviour, e.g. a way to restrict all stream
> sockets the same way, or something per stream socket. But that's just me
> :) )

The documentation and the initial idea was to control TCP bind and
connect.  The kernel implementation does more than that, so we need to
synthronize somehow.

> 
> Cheers,
> Matt
> -- 
> Sponsored by the NGI0 Core fund.
> 
> 
