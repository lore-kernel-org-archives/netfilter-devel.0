From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3] netfilter: x_tables: perform more sanity tests on rule set
Date: Tue, 22 Mar 2016 18:02:48 +0100
Message-ID: <1458666173-24318-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38135 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673AbcCVRCh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 13:02:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

3rd iteration.

In addition to the problem reported by Ben Hawkes this also adds
a few checks to better validate ->next_offset and the target.

I checked that ip(6)tables-restore still works w. simple rulesets.

The reproducer doesn't work anymore w. patch #4 applied.

