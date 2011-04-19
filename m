From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Patches: don't call modprobe, ipv4/ipv6 flag support, xtables-multi unification.
Date: Mon, 18 Apr 2011 18:22:57 -0700
Message-ID: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ed W <lists@wildgooses.com>
To: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65341 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1DSBW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:22:59 -0400
Received: by wya21 with SMTP id 21so4417092wya.19
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2011 18:22:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following changes are available in the git repository at:
  git://github.com/zenczykowski/iptables.git for-upstream

The first two patches are standalone, the fifth builds on the fourth
which builds on the third.
It's not clear to me if you'll be willing to merge all of them.

Maciej Zenczykowski (5):
  Don't load ip6?_tables module when already loaded.
  Add --ipv4/-4 and --ipv6/-6 support to ip6?tables{,-restore}.
  Move common parts of libext{4,6}.a into libext.a
  combine ip6?tables-multi into xtables-multi
  add xtables-multi{32,64} recognition

Thanks,
Maciej
