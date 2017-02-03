From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 0/9] nftables: add zone support to ct statement
Date: Fri,  3 Feb 2017 13:35:47 +0100
Message-ID: <20170203123556.17357-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41954 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMfj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:35:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the ability to set the conntrack zone from nftables, i.e.
native replacement for -j CT --zone $number.

See individual patches for details.
This will need more documentation and exposure of the builtin
hook priorities (e.g. via defines?) so users can more easily
see whats happening.

Pablo suggested to allow something like

hook prerouting prio $raw;
or even
hook prerouting prio $conntrack - 1;

instead of the 'awkward' use of the actual numbers used by the kernel
('priority -300' to hook at same priority as raw table).

However, this series doesn't contain any of that, so users will
have to use priorities between -399 and -199 (i.e. after defrag and
before conntrack pickup) to assign zones.

