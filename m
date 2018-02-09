From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 0/9] netfilter: x_tables: use printk ratelimiting
Date: Fri,  9 Feb 2018 15:51:58 +0100
Message-ID: <20180209145207.2097-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46618 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751090AbeBIOzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aeons ago, before namespaces, there was no need to ratelimit this:
all of these error messages got triggered in response to iptables
commands, which need CAP_NET_ADMIN.

Nowadays we have namespaces, so its better to ratelimit these.
This should also help fuzzing (syzkaller), as it can generate a large
volume of error messages (which are useless there).

First patch get rid of printks that should never be triggered, as userland
doesn't generate such malformed rules.

The other patches convert all matches/targets.

In some cases, modules used pr_err() for errors that are just a
hint to and user as to why the rule was rejected, so this uses
pr_info_ratelimited everywhere.

Only exceptions are when the error appears to be due to a bug, i.e.
ABI breakage and other incompatible changes that should not happen.

Note that most patches introduce overly long lines, but splitting these
would make it necessary to split the error messages which is worse.

 46 files changed, 264 insertions(+), 262 deletions(-)
