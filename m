From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 0/2] netfilter: x_tables: speed up iptables-restore
Date: Wed, 11 Oct 2017 16:26:05 +0200
Message-ID: <20171011142607.15026-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40964 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751620AbdJKOZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 10:25:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables-restore can take quite a long time when sytem is busy, in order
of half a minute or more.

The main reason for this is the way ip(6)tables performs table swap:

When xt_replace_table assigns the new ruleset pointer, it does
not wait for other processors to finish with old ruleset.

Instead it relies on the counter sequence lock in get_counters().

This works but this is costly if system is busy as each counter read
operation can possibly be restarted indefinitely.

Instead, make xt_replace_table wait until all processors are known to not
use the old ruleset anymore.

This allows to read the old counters without any locking, no cpu is
using the ruleset anymore so counters can't change either.

