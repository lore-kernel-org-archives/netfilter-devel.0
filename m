Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [45.157.188.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BAE223C7B
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734028999; cv=none; b=U+8H+d53I70u9BYYObTdOHSQjXlnD1dtX5pweZDdkIP9n4OSWWU4AYV+D4W4Nn57iGvd4gTHnnbwheIzftUFnLdtdE4qB4fmSneWaby4z/zapaEpyKlFj7VkjKE4w87OENPBOTG5w0bVJrNL4OW9itEEZJx/DwGZmfSrsBrhfPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734028999; c=relaxed/simple;
	bh=o2bVeZbhajJiWN0U8WTCLKosJC2kpjq4OkmKZ9+CpAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Irx0rObectLc4Fl9ji+/6CIYl30oTf8WeOR3Ex8fGkquBxyGVkCrm+ZoLqju2JLHYdb43poxsISfv3K5VDS/bFX3fuBuNEiYHWNBh96XEekhllcCZkjIhc+k1OuYDwqEwTXRaYMD7dud5186CYagOFNXmJehfRI/62B759Scvyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=0hnM4hc8; arc=none smtp.client-ip=45.157.188.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="0hnM4hc8"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y8LvJ3g1lzRfV;
	Thu, 12 Dec 2024 19:43:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1734028988;
	bh=Mmtm9fyTo5/r0MKZuqf9t/MEms75sx9RiuSVOLDMjIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0hnM4hc8hqjkyoqr9BFrIZOoT0mF0wylgwIGNE6Igbk3XV5TtYm5XJqDuONfX9XFf
	 VzdGhGE99QhQevM9+D6EoQsGHcArpLQ+dul8AJb7xCLaUMkmF39xvioQxaatZFj7DY
	 KFAL9We+7K5tDAg+3OyUOsh8AhM0pHEs1uA+egqQ=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y8LvH45x0zQ3r;
	Thu, 12 Dec 2024 19:43:07 +0100 (CET)
Date: Thu, 12 Dec 2024 19:43:04 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: Matthieu Baerts <matttbe@kernel.org>, gnoack@google.com, 
	willemdebruijn.kernel@gmail.com, matthieu@buffet.re, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	MPTCP Linux <mptcp@lists.linux.dev>, David Laight <David.Laight@aculab.com>
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Message-ID: <20241212.ief4eingaeVa@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net>
 <20241204.fahVio7eicim@digikod.net>
 <20241204.acho8AiGh6ai@digikod.net>
 <a24b33c1-57c8-11bb-f3aa-32352b289a5c@huawei-partners.com>
 <20241210.Eenohkipee9f@digikod.net>
 <20241210.ohC4die2hi8v@digikod.net>
 <b8726b37-8819-2289-40ec-81d875b13eba@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8726b37-8819-2289-40ec-81d875b13eba@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Wed, Dec 11, 2024 at 06:24:53PM +0300, Mikhail Ivanov wrote:
> On 12/10/2024 9:05 PM, Mickaël Salaün wrote:
> > On Tue, Dec 10, 2024 at 07:04:15PM +0100, Mickaël Salaün wrote:
> > > On Mon, Dec 09, 2024 at 01:19:19PM +0300, Mikhail Ivanov wrote:
> > > > On 12/4/2024 10:35 PM, Mickaël Salaün wrote:
> > > > > On Wed, Dec 04, 2024 at 08:27:58PM +0100, Mickaël Salaün wrote:
> > > > > > On Fri, Oct 18, 2024 at 08:08:12PM +0200, Mickaël Salaün wrote:
> > > > > > > On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
> > > > > > > > Hi Mikhail and Landlock maintainers,
> > > > > > > > 
> > > > > > > > +cc MPTCP list.
> > > > > > > 
> > > > > > > Thanks, we should include this list in the next series.
> > > > > > > 
> > > > > > > > 
> > > > > > > > On 17/10/2024 13:04, Mikhail Ivanov wrote:
> > > > > > > > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > > > > > > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > > > > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > > > > > > > (SCTP, MPTCP, SMC).
> > > > > > > > 
> > > > > > > > Thank you for the patch!
> > > > > > > > 
> > > > > > > > I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
> > > > > > > > treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
> > > > > > > > see TCP packets with extra TCP options. On Linux, there is indeed a
> > > > > > > > dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
> > > > > > > > because we needed such dedicated socket to talk to the userspace.
> > > > > > > > 
> > > > > > > > I don't know Landlock well, but I think it is important to know that an
> > > > > > > > MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
> > > > > > > > will do a fallback to "plain" TCP if MPTCP is not supported by the other
> > > > > > > > peer or by a middlebox. It means that with this patch, if TCP is blocked
> > > > > > > > by Landlock, someone can simply force an application to create an MPTCP
> > > > > > > > socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
> > > > > > > > certainly work, even when connecting to a peer not supporting MPTCP.
> > > > > > > > 
> > > > > > > > Please note that I'm not against this modification -- especially here
> > > > > > > > when we remove restrictions around MPTCP sockets :) -- I'm just saying
> > > > > > > > it might be less confusing for users if MPTCP is considered as being
> > > > > > > > part of TCP. A bit similar to what someone would do with a firewall: if
> > > > > > > > TCP is blocked, MPTCP is blocked as well.
> > > > > > > 
> > > > > > > Good point!  I don't know well MPTCP but I think you're right.  Given
> > > > > > > it's close relationship with TCP and the fallback mechanism, it would
> > > > > > > make sense for users to not make a difference and it would avoid bypass
> > > > > > > of misleading restrictions.  Moreover the Landlock rules are simple and
> > > > > > > only control TCP ports, not peer addresses, which seems to be the main
> > > > > > > evolution of MPTCP.
> > > > > > 
> > > > > > Thinking more about this, this makes sense from the point of view of the
> > > > > > network stack, but looking at external (potentially bogus) firewalls or
> > > > > > malware detection systems, it is something different.  If we don't
> > > > > > provide a way for users to differenciate the control of SCTP from TCP,
> > > > > > malicious use of SCTP could still bypass this kind of bogus security
> > > > > > appliances.  It would then be safer to stick to the protocol semantic by
> > > > > > clearly differenciating TCP from MPTCP (or any other protocol).
> > > > 
> > > > You mean that these firewals have protocol granularity (e.g. different
> > > > restrictions for MPTCP and TCP sockets)?
> > > 
> > > Yes, and more importantly they can miss the MTCP semantic and then not
> > > properly filter such packet, which can be use to escape the network
> > > policy.  See some issues here:
> > > https://en.wikipedia.org/wiki/Multipath_TCP
> > > 
> > > The point is that we cannot assume anything about other networking
> > > stacks, and if Landlock can properly differentiate between TCP and MTCP
> > > (e.g. with new LANDLOCK_ACCESS_NET_CONNECT_MTCP) users of such firewalls
> > > could still limit the impact of their firewall's bugs.  However, if
> > > Landlock treats TCP and MTCP the same way, we'll not be able to only
> > > deny MTCP.  In most use cases, the network policy should treat both TCP
> > > and MTCP the same way though, but we should let users decide according
> > > to their context.
> > > 
> > >  From an implementation point of view, adding MTCP support should be
> > > simple, mainly tests will grow.
> > 
> > s/MTCP/MPTCP/g of course.
> 
> That's reasonable, thanks for explanation!
> 
> We should also consider control of other protocols that use TCP
> internally [1], since it should be easy to bypass TCP restriction by
> using them (e.g. provoking a fallback of MPTCP or SMC connection to
> TCP).
> 
> The simplest solution is to implement separate access rights for SMC and
> RDS, as well as for MPTCP. I think we should stick to it.
> 
> I was worried if there was a case where it would be useful to allow only
> SMC (and deny TCP). If there are any, it would be more correct to
> restrict only the fallback SMC -> TCP with TCP access rights. But such
> logic seems too complicated for the kernel and implicit for SMC
> applications that can rely on a TCP connection.
> 
> [1] https://lore.kernel.org/all/62336067-18c2-3493-d0ec-6dd6a6d3a1b5@huawei-partners.com/

Let's continue the discussion on this thread.

> 
> > 
> > > 
> > > > 
> > > > > > 
> > > > > > Mikhail, could you please send a new patch series containing one patch
> > > > > > to fix the kernel and another to extend tests?
> > > > > 
> > > > > No need to squash them in one, please keep the current split of the test
> > > > > patches.  However, it would be good to be able to easily backport them,
> > > > > or at least the most relevant for this fix, which means to avoid
> > > > > extended refactoring.
> > > > 
> > > > No problem, I'll remove the fix of error consistency from this patchset.
> > > > BTW, what do you think about second and third commits? Should I send the
> > > > new version of them as well (in separate patch)?
> > > 
> > > According to the description, patch 2 may be included in this series if
> > > it can be tested with any other LSM, but I cannot read these patches:
> > > https://lore.kernel.org/all/20241017110454.265818-3-ivanov.mikhail1@huawei-partners.com/
> 
> Ok I'll do this, since this patch doesn't make any functional changes.
> 
> About readability, a lot of code blocks were moved in this patch, and
> because of this, the regular diff file has become too unreadable.
> So, I decided to re-generate it with --break-rewrites option of git
> format- patch. Do you have any advice on how best to compose a diff for
> this patch?

The changes are not clear to me so I don't know.  If a lot of parts are
changed, maybe splitting this patch into a few patches would help.  I'm
a bit worried that too much parts are changed though.

When I try to apply this series I get:

  Patch failed at 0002 landlock: Make network stack layer checks explicit
  for each TCP action
  error: patch failed: security/landlock/net.c:1
  error: security/landlock/net.c: patch does not apply
