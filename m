Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [83.166.143.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59EE86320
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733853866; cv=none; b=motq3TuLvawOybXZLWvGMjflpxYsr2bYjeEkDXEUNyven4wS7Tk98v5E4vDK7TrjM5MMkE5URN9dWjWU9ZvalRYXrCw/d8AyFeqFGjEsIjmrw+fIKOH85PHDPY0Te3gt86kPEfWEz52wMFNwFbAIjkAQ5YW90Iofr7Q7peZb4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733853866; c=relaxed/simple;
	bh=77Qlx27wlKCeqVSBZaB7kO9QJE1s+ZW9CUlb/3SMJ5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtxnwIggDS3PocBIrmVV2lJrGfMTqW8N3lnjModItBwwOkpGE5ahnD3Aq/fxK6IfICO4JkAtxJwfq2/AMCCztD8y0P10MhKdDkez9haW3x4ZaN4F2VMhmLqpU9uUO7JDKQ7ooGroOc8tR5dd7eFv0E17zWOBHXeCy2/Ihw5kczE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=gVwJWa7N; arc=none smtp.client-ip=83.166.143.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="gVwJWa7N"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y767Q3NTtzX2X;
	Tue, 10 Dec 2024 19:04:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733853858;
	bh=EPOh+etsU+dSAyHlZze34E+Js4PynjzVIPhILt/44/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gVwJWa7NBoxDL8ckAdGmP++bVnwAiY1zsK5bJap6Fbf1Drbc14M/PN8/U9fTOEIlu
	 rSDeyq+TvL0FVyLS6wntoaU10rBXzrNjuGAokZ23cZqP7y/matiFuF6spZ6x02Ahhl
	 j+TGvxdswVQ8Vwzb3amwhs1rPPSwuvALieOMOK5Q=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y767P2ndgzhsx;
	Tue, 10 Dec 2024 19:04:17 +0100 (CET)
Date: Tue, 10 Dec 2024 19:04:06 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: Matthieu Baerts <matttbe@kernel.org>, gnoack@google.com, 
	willemdebruijn.kernel@gmail.com, matthieu@buffet.re, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	MPTCP Linux <mptcp@lists.linux.dev>, David Laight <David.Laight@aculab.com>
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Message-ID: <20241210.Eenohkipee9f@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net>
 <20241204.fahVio7eicim@digikod.net>
 <20241204.acho8AiGh6ai@digikod.net>
 <a24b33c1-57c8-11bb-f3aa-32352b289a5c@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a24b33c1-57c8-11bb-f3aa-32352b289a5c@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Mon, Dec 09, 2024 at 01:19:19PM +0300, Mikhail Ivanov wrote:
> On 12/4/2024 10:35 PM, Mickaël Salaün wrote:
> > On Wed, Dec 04, 2024 at 08:27:58PM +0100, Mickaël Salaün wrote:
> > > On Fri, Oct 18, 2024 at 08:08:12PM +0200, Mickaël Salaün wrote:
> > > > On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
> > > > > Hi Mikhail and Landlock maintainers,
> > > > > 
> > > > > +cc MPTCP list.
> > > > 
> > > > Thanks, we should include this list in the next series.
> > > > 
> > > > > 
> > > > > On 17/10/2024 13:04, Mikhail Ivanov wrote:
> > > > > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > > > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > > > > (SCTP, MPTCP, SMC).
> > > > > 
> > > > > Thank you for the patch!
> > > > > 
> > > > > I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
> > > > > treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
> > > > > see TCP packets with extra TCP options. On Linux, there is indeed a
> > > > > dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
> > > > > because we needed such dedicated socket to talk to the userspace.
> > > > > 
> > > > > I don't know Landlock well, but I think it is important to know that an
> > > > > MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
> > > > > will do a fallback to "plain" TCP if MPTCP is not supported by the other
> > > > > peer or by a middlebox. It means that with this patch, if TCP is blocked
> > > > > by Landlock, someone can simply force an application to create an MPTCP
> > > > > socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
> > > > > certainly work, even when connecting to a peer not supporting MPTCP.
> > > > > 
> > > > > Please note that I'm not against this modification -- especially here
> > > > > when we remove restrictions around MPTCP sockets :) -- I'm just saying
> > > > > it might be less confusing for users if MPTCP is considered as being
> > > > > part of TCP. A bit similar to what someone would do with a firewall: if
> > > > > TCP is blocked, MPTCP is blocked as well.
> > > > 
> > > > Good point!  I don't know well MPTCP but I think you're right.  Given
> > > > it's close relationship with TCP and the fallback mechanism, it would
> > > > make sense for users to not make a difference and it would avoid bypass
> > > > of misleading restrictions.  Moreover the Landlock rules are simple and
> > > > only control TCP ports, not peer addresses, which seems to be the main
> > > > evolution of MPTCP.
> > > 
> > > Thinking more about this, this makes sense from the point of view of the
> > > network stack, but looking at external (potentially bogus) firewalls or
> > > malware detection systems, it is something different.  If we don't
> > > provide a way for users to differenciate the control of SCTP from TCP,
> > > malicious use of SCTP could still bypass this kind of bogus security
> > > appliances.  It would then be safer to stick to the protocol semantic by
> > > clearly differenciating TCP from MPTCP (or any other protocol).
> 
> You mean that these firewals have protocol granularity (e.g. different
> restrictions for MPTCP and TCP sockets)?

Yes, and more importantly they can miss the MTCP semantic and then not
properly filter such packet, which can be use to escape the network
policy.  See some issues here:
https://en.wikipedia.org/wiki/Multipath_TCP

The point is that we cannot assume anything about other networking
stacks, and if Landlock can properly differentiate between TCP and MTCP
(e.g. with new LANDLOCK_ACCESS_NET_CONNECT_MTCP) users of such firewalls
could still limit the impact of their firewall's bugs.  However, if
Landlock treats TCP and MTCP the same way, we'll not be able to only
deny MTCP.  In most use cases, the network policy should treat both TCP
and MTCP the same way though, but we should let users decide according
to their context.

From an implementation point of view, adding MTCP support should be
simple, mainly tests will grow.

> 
> > > 
> > > Mikhail, could you please send a new patch series containing one patch
> > > to fix the kernel and another to extend tests?
> > 
> > No need to squash them in one, please keep the current split of the test
> > patches.  However, it would be good to be able to easily backport them,
> > or at least the most relevant for this fix, which means to avoid
> > extended refactoring.
> 
> No problem, I'll remove the fix of error consistency from this patchset.
> BTW, what do you think about second and third commits? Should I send the
> new version of them as well (in separate patch)?

According to the description, patch 2 may be included in this series if
it can be tested with any other LSM, but I cannot read these patches:
https://lore.kernel.org/all/20241017110454.265818-3-ivanov.mikhail1@huawei-partners.com/
