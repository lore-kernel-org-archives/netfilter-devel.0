From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Wed, 2 Jul 2014 13:03:09 +0530
Message-ID: <CABPxzYL28zyu5D5iYDZy3wcJ-BMa8RfaFCe88HC5867NhpvPnQ@mail.gmail.com>
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
 <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com> <20140701144149.GB6358@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felix Fietkau <nbd@openwrt.org>, John Walker <john@x109.net>,
	netfilter-devel@vger.kernel.org,
	Richard Fontana <fontana@sharpeleven.org>
To: "John W. Linville" <linville@tuxdriver.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39904 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaGBHda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:33:30 -0400
In-Reply-To: <20140701144149.GB6358@tuxdriver.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 1, 2014 at 8:11 PM, John W. Linville <linville@tuxdriver.com> wrote:
>
> On Mon, Jun 30, 2014 at 12:19:08PM -0700, Luis R. Rodriguez wrote:
> > On Mon, Jun 30, 2014 at 11:55 AM, Luis R. Rodriguez
> > <mcgrof@do-not-panic.com> wrote:
> > > For the current kernel we
> > > could intake the patch below, and I can port the change to no use
> > > dfs_cac, that would enable older kernels to use new and older versions
> > > of the ASCII database file.
> >
> > Personally I actually rather avoid us accept a patch upstream for a
> > userspace change. The problem here is that we failed to realize the
> > impact of CFG80211_INTERNAL_REGDB at build time with a userspace tool,
> > in this case the db.txt file wireless-regdb provides and its format.
> >
> > If we wanted to avoid a stable patch we could require a match between
> > wireless-regdb input file used for a kernel when
> > CFG80211_INTERNAL_REGDB is used at build time. That would require
> > different ASCII files on wireless-regdb or having the users of
> > CFG80211_INTERNAL_REGDB do the conversion themselves. Upstream would
> > just follow the wireless-regdb latest format. This then would just
> > require upstream a Kconfig update to clarify the requirements.
> >
> > This seems like a rather lazy option but also one that would be rather
> > more fair and honest for upstream, we could deal with a proper fix by
> > reconsidering the implementation of CFG80211_INTERNAL_REGDB completely
> > for future kernels.
>
> I'm shocked that anyone actually uses CFG80211_INTERNAL_REGDB...
>

Lot of embedded devices like ours avoid the pain of cross compiling
crda, udev...
and resort to internal_regdb as a easy way to get things done.


> Anyway, I don't see the big deal.  We should keep
> CFG80211_INTERNAL_REGDB (whether implemented in awk or C) up-to-date
> with current kernels.  Anyone wanting to use an old kernel with an
> updated wireless-regdb file is responsible for ensuring compatibility.
> If they can't do that, then they should seek support from a vendor.
> How is this any different from any other kernel support issue?

Sounds good to me.
