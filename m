From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Patches: don't call modprobe, ipv4/ipv6 flag support,
 xtables-multi unification.
Date: Tue, 19 Apr 2011 18:44:06 -0700
Message-ID: <BANLkTimsGzmOnXR1otTvnKBYAS7m=91+uA@mail.gmail.com>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35850 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1DTBoI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:44:08 -0400
Received: by wya21 with SMTP id 21so219387wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 18:44:07 -0700 (PDT)
In-Reply-To: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here's version 2.

Since the first patch was already applied, and the last isn't wanted,
we're down to 3 patches.

The following changes are available in the git repository at:
  git://github.com/zenczykowski/iptables.git for-upstream

The first patch is standalone, the third builds on the second.
Only the first patch was changed, and then only by adding
'enter,tab,tab,tab,tab' in two spots to fixup formatting.

Maciej Zenczykowski (5):
  Add --ipv4/-4 and --ipv6/-6 support to ip6?tables{,-restore}.
  Move common parts of libext{4,6}.a into libext.a
  combine ip6?tables-multi into xtables-multi

Thanks,
Maciej
