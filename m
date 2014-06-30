From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Mon, 30 Jun 2014 12:19:08 -0700
Message-ID: <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com>
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: John Walker <john@x109.net>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Richard Fontana <fontana@sharpeleven.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felix Fietkau <nbd@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:64619 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaF3TTa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:19:30 -0400
In-Reply-To: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 30, 2014 at 11:55 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> For the current kernel we
> could intake the patch below, and I can port the change to no use
> dfs_cac, that would enable older kernels to use new and older versions
> of the ASCII database file.

Personally I actually rather avoid us accept a patch upstream for a
userspace change. The problem here is that we failed to realize the
impact of CFG80211_INTERNAL_REGDB at build time with a userspace tool,
in this case the db.txt file wireless-regdb provides and its format.

If we wanted to avoid a stable patch we could require a match between
wireless-regdb input file used for a kernel when
CFG80211_INTERNAL_REGDB is used at build time. That would require
different ASCII files on wireless-regdb or having the users of
CFG80211_INTERNAL_REGDB do the conversion themselves. Upstream would
just follow the wireless-regdb latest format. This then would just
require upstream a Kconfig update to clarify the requirements.

This seems like a rather lazy option but also one that would be rather
more fair and honest for upstream, we could deal with a proper fix by
reconsidering the implementation of CFG80211_INTERNAL_REGDB completely
for future kernels.

 Luis
