From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Tue, 1 Jul 2014 11:54:43 -0700
Message-ID: <CAB=NE6W4yg2_290aKacM0ar63yoVt_G8h59iWGxfCanV+AM=vA@mail.gmail.com>
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
 <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com>
 <20140701144149.GB6358@tuxdriver.com> <20140701171713.GO27687@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felix Fietkau <nbd@openwrt.org>, John Walker <john@x109.net>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Richard Fontana <fontana@sharpeleven.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63662 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaGASzG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:55:06 -0400
In-Reply-To: <20140701171713.GO27687@wotan.suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 1, 2014 at 10:17 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> How is this any different from any other kernel support issue?
>
> This is a build issue that does not cause any errors, users go through with the install
> just fine and only at run time do they discover the issue. We never documented
> the expecations nor do I think we expected this before. This is also caused by an
> input file from userspace, I do consider the issue unexpected.

This is a bit more broken given that DFS CAC patches are upstream but
we haven't yet even provided the removal of antenna gain on the awk
script but for some reason it did add the DFS CAC parsing to the awk
script, so upstream has the awk DFS CAC parser options, we don't yet
even use it, and the antenna gain wasn't removed. I'll work on that
patch but parsing things in awk is getting a bit hairy for the
conditionals. We can use the C parser now that we have on but the DFS
CAC stuf was not yet ironed out for CRDA and wireless-regdb...

  Luis
