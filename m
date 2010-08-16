From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 16 Aug 2010 17:32:42 +0300
Message-ID: <1281969162.27200.45.camel@chilepepper>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
	 <1279285829.1603.77.camel@powerslave>
	 <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
	 <1279517423.7097.2.camel@powerslave>
	 <1281966043.27200.30.camel@chilepepper>
	 <AANLkTikxcG8GpTTE5h28QSjD2uXpPXdNwFrshn2UKQRY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: ext Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:54025 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0HPOdI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:33:08 -0400
In-Reply-To: <AANLkTikxcG8GpTTE5h28QSjD2uXpPXdNwFrshn2UKQRY@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-16 at 16:26 +0200, ext Changli Gao wrote:
> On Mon, Aug 16, 2010 at 9:40 PM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> > Does anyone have an idea on how I could solve this problem?
> >
> > I have been considering using the IDLETIMER target and activate it when
> > the throughput goes to HIGH.  Then if this timer expires, it would
> > inform the userspace that now there's no data going through.  But this
> > sounds very artificial to me and will add one more dependency on the
> > userspace, since the IDLETIMER is using sysfs to inform userspace,
> > instead of netlink.
> >
> 
> Read the code of IDLETIMER again, and I notice that IDLETIMER will
> wake up all the sleepers on the corresponding sysfs files. So no
> polling is needed, what you need do is watching another files for
> read. You can use select/poll/epoll. It should be no very difficult.

Yes, I know.  I have reworked the IDLETIMER for upstream inclusion, so I
should know this after all. ;) It was just the idea of having the daemon
have one more interface with the kernel that seemed a bit ugly...


-- 
Cheers,
Luca.

