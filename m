From: Florian Westphal <fw@strlen.de>
Subject: [stable, xtables] fix validation of jumps
Date: Mon,  1 Aug 2016 20:38:19 +0200
Message-ID: <1470076704-13325-1-git-send-email-fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, stable@kernel.org,
	alexander.levin@verizon.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46586 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788AbcHATqu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 15:46:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The various stable kernels suffer from one of the following
problems:

- They don't have 36472341017529e ("netfilter: x_tables: validate targets of jumps").
  In that case there is no validation which is problematic with unpriv netns support
  or when using unprivileged containers.

- They have a faulty backport of this commit and xtables is completely
  broken (kernel freeze since we iterate over random memory contents).
  This affects current 3.18.y and 4.1.y kernels for example.

- They have a correct backport of this commit, which causes problems
  with large rulesets (depending on machine, 1k or more; but even on
  fast machines rulesets with more than 10k rules cause softlockup during
  iptables-restore and friends).


These patches all contain the same backport but amended so it applies
to the indicated stable branch.

For 3.12:
- adjust for extra debug printks and lack of 36472341017529e.
  (The 36472341017529e commit is superseded by this).

For 3.14:
- adjust for extra debug printks and lack of kvfree.
  This backport is only needed to speed up rule validation.

For 3.18:
- adjust for extra debug printks and broken 36472341017529e backport.
  This backport is needed to make xtables work, we currently walk
  over random memory content so any iptables -A ... command will either
  fail or lock up.

For 4.1.y: same as 3.18.

For 4.4: Same as 3.14 -- backport is only needed to speed up ruleset
validtion.

The 4.4 backport will also apply to the 4.6.y tree.

I briefly tested all the kernels with these patches applied and
the large dummy ruleset from the commit message.

