From: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Tue, 1 Jul 2014 16:18:50 -0400
Message-ID: <20140701201850.GE6358@tuxdriver.com>
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
 <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com>
 <20140701144149.GB6358@tuxdriver.com>
 <20140701171713.GO27687@wotan.suse.de>
 <CAB=NE6W4yg2_290aKacM0ar63yoVt_G8h59iWGxfCanV+AM=vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felix Fietkau <nbd@openwrt.org>, John Walker <john@x109.net>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Richard Fontana <fontana@sharpeleven.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42378 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaGAUaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:30:14 -0400
Content-Disposition: inline
In-Reply-To: <CAB=NE6W4yg2_290aKacM0ar63yoVt_G8h59iWGxfCanV+AM=vA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 01, 2014 at 11:54:43AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jul 1, 2014 at 10:17 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >> How is this any different from any other kernel support issue?
> >
> > This is a build issue that does not cause any errors, users go through with the install
> > just fine and only at run time do they discover the issue. We never documented
> > the expecations nor do I think we expected this before. This is also caused by an
> > input file from userspace, I do consider the issue unexpected.
> 
> This is a bit more broken given that DFS CAC patches are upstream but
> we haven't yet even provided the removal of antenna gain on the awk
> script but for some reason it did add the DFS CAC parsing to the awk
> script, so upstream has the awk DFS CAC parser options, we don't yet
> even use it, and the antenna gain wasn't removed. I'll work on that
> patch but parsing things in awk is getting a bit hairy for the
> conditionals. We can use the C parser now that we have on but the DFS
> CAC stuf was not yet ironed out for CRDA and wireless-regdb...

I wrote that awk script years ago so that we could get rid of the
old hard-coded rulesets and so I could have something working in RHEL5.

I never merged the DFS CAC stuff in wireless-regdb, because of the
unresolved issue of supporting multiple formats.  It looks to me like
the dfs_cac stuff in genregdb.awk is broken, since it doesn't seem
to account for flags.

I sent a patch that should account for the antenna gain issue.
Please give it a review.

Obviously, we need to talk more about this in Chicago if not before...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
