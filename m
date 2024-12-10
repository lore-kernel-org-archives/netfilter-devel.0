Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [185.125.25.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A25A1C2DB0
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733853944; cv=none; b=nzpnRz8fpDPIJqnDRZBgtantOR7rBOYeQ6SxWJEDVjNspxYnqsKhxrKQ4Il8OhSs4XIwPhbStmS9/NVKNCE3CGsqfGPRrI/SoRCUlFqG180xt4xfhpO1XaIDYPCjraKLwxx5yc43mWac31OkK4ZNtWsOzc34Ov+j6FpmbkhG6Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733853944; c=relaxed/simple;
	bh=cV8P/IVlEaa2qjHfEzA3/kNDfQnVV4ToDFPS8xWX8oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3KoeiHAlXzcN7g+vSEOmuMVpUmgqsZVHg/+3KCpzJRPQy5Qyaqqdp1OLpyW4/ISIIz3af+ajIU8zAt3Qo7bpiSK9eYdEL9IjR7Sw1CI+vdK7xAXrJKssZxLyC9Yytilw/SnxgPHkbE8//AKyfr9FT81DEiG0wdetYTRavCOz2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=ujnokSil; arc=none smtp.client-ip=185.125.25.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="ujnokSil"
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10:40ca:feff:fe05:1])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y768y4Htszdvg;
	Tue, 10 Dec 2024 19:05:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733853938;
	bh=gza3l5oTypw+l8B1/vErZ/xUWzQy1RteLPzFdKO3PXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujnokSil3DWicZpARfJFhOjw3LTKRhgk8LoxV58ZhWmm2VkSaBsocq1S8tQhGzFDG
	 fkit6tOmAV93AuZteNk9ycajUVNlVv55mDnPT8Nduy9y69GfhbIr6z7Q+ufN08AHU+
	 Vr3k46ZrL1H/KpsW3nAKuMrUKspe6MauF79afktY=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y768y0L1RzkGY;
	Tue, 10 Dec 2024 19:05:38 +0100 (CET)
Date: Tue, 10 Dec 2024 19:05:35 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: Matthieu Baerts <matttbe@kernel.org>, gnoack@google.com, 
	willemdebruijn.kernel@gmail.com, matthieu@buffet.re, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	MPTCP Linux <mptcp@lists.linux.dev>, David Laight <David.Laight@aculab.com>
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Message-ID: <20241210.ohC4die2hi8v@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net>
 <20241204.fahVio7eicim@digikod.net>
 <20241204.acho8AiGh6ai@digikod.net>
 <a24b33c1-57c8-11bb-f3aa-32352b289a5c@huawei-partners.com>
 <20241210.Eenohkipee9f@digikod.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241210.Eenohkipee9f@digikod.net>
X-Infomaniak-Routing: alpha

On Tue, Dec 10, 2024 at 07:04:15PM +0100, Mickaël Salaün wrote:
> On Mon, Dec 09, 2024 at 01:19:19PM +0300, Mikhail Ivanov wrote:
> > On 12/4/2024 10:35 PM, Mickaël Salaün wrote:
> > > On Wed, Dec 04, 2024 at 08:27:58PM +0100, Mickaël Salaün wrote:
> > > > On Fri, Oct 18, 2024 at 08:08:12PM +0200, Mickaël Salaün wrote:
> > > > > On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
> > > > > > Hi Mikhail and Landlock maintainers,
> > > > > > 
> > > > > > +cc MPTCP list.
> > > > > 
> > > > > Thanks, we should include this list in the next series.
> > > > > 
> > > > > > 
> > > > > > On 17/10/2024 13:04, Mikhail Ivanov wrote:
> > > > > > > Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> > > > > > > LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > > > should not restrict bind(2) and connect(2) for non-TCP protocols
> > > > > > > (SCTP, MPTCP, SMC).
> > > > > > 
> > > > > > Thank you for the patch!
> > > > > > 
> > > > > > I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
> > > > > > treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
> > > > > > see TCP packets with extra TCP options. On Linux, there is indeed a
> > > > > > dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
> > > > > > because we needed such dedicated socket to talk to the userspace.
> > > > > > 
> > > > > > I don't know Landlock well, but I think it is important to know that an
> > > > > > MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
> > > > > > will do a fallback to "plain" TCP if MPTCP is not supported by the other
> > > > > > peer or by a middlebox. It means that with this patch, if TCP is blocked
> > > > > > by Landlock, someone can simply force an application to create an MPTCP
> > > > > > socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
> > > > > > certainly work, even when connecting to a peer not supporting MPTCP.
> > > > > > 
> > > > > > Please note that I'm not against this modification -- especially here
> > > > > > when we remove restrictions around MPTCP sockets :) -- I'm just saying
> > > > > > it might be less confusing for users if MPTCP is considered as being
> > > > > > part of TCP. A bit similar to what someone would do with a firewall: if
> > > > > > TCP is blocked, MPTCP is blocked as well.
> > > > > 
> > > > > Good point!  I don't know well MPTCP but I think you're right.  Given
> > > > > it's close relationship with TCP and the fallback mechanism, it would
> > > > > make sense for users to not make a difference and it would avoid bypass
> > > > > of misleading restrictions.  Moreover the Landlock rules are simple and
> > > > > only control TCP ports, not peer addresses, which seems to be the main
> > > > > evolution of MPTCP.
> > > > 
> > > > Thinking more about this, this makes sense from the point of view of the
> > > > network stack, but looking at external (potentially bogus) firewalls or
> > > > malware detection systems, it is something different.  If we don't
> > > > provide a way for users to differenciate the control of SCTP from TCP,
> > > > malicious use of SCTP could still bypass this kind of bogus security
> > > > appliances.  It would then be safer to stick to the protocol semantic by
> > > > clearly differenciating TCP from MPTCP (or any other protocol).
> > 
> > You mean that these firewals have protocol granularity (e.g. different
> > restrictions for MPTCP and TCP sockets)?
> 
> Yes, and more importantly they can miss the MTCP semantic and then not
> properly filter such packet, which can be use to escape the network
> policy.  See some issues here:
> https://en.wikipedia.org/wiki/Multipath_TCP
> 
> The point is that we cannot assume anything about other networking
> stacks, and if Landlock can properly differentiate between TCP and MTCP
> (e.g. with new LANDLOCK_ACCESS_NET_CONNECT_MTCP) users of such firewalls
> could still limit the impact of their firewall's bugs.  However, if
> Landlock treats TCP and MTCP the same way, we'll not be able to only
> deny MTCP.  In most use cases, the network policy should treat both TCP
> and MTCP the same way though, but we should let users decide according
> to their context.
> 
> From an implementation point of view, adding MTCP support should be
> simple, mainly tests will grow.

s/MTCP/MPTCP/g of course.

> 
> > 
> > > > 
> > > > Mikhail, could you please send a new patch series containing one patch
> > > > to fix the kernel and another to extend tests?
> > > 
> > > No need to squash them in one, please keep the current split of the test
> > > patches.  However, it would be good to be able to easily backport them,
> > > or at least the most relevant for this fix, which means to avoid
> > > extended refactoring.
> > 
> > No problem, I'll remove the fix of error consistency from this patchset.
> > BTW, what do you think about second and third commits? Should I send the
> > new version of them as well (in separate patch)?
> 
> According to the description, patch 2 may be included in this series if
> it can be tested with any other LSM, but I cannot read these patches:
> https://lore.kernel.org/all/20241017110454.265818-3-ivanov.mikhail1@huawei-partners.com/
