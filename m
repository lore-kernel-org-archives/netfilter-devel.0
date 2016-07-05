From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] meta: add random and probability match
Date: Tue,  5 Jul 2016 09:35:32 +0200
Message-ID: <1467704135-9154-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55923 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbcGEHfW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 03:35:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

This is yet another attempt at the random/probability matching.

First patch adds a simple 'meta random' expression.

Second patch adds a 'probability' mode which internally maps to
the random one and takes care of scaling the '0.x' probability
to the needed integer.

Third patch is the reverse translation, so that users that
input

meta probability 0.001

will see the same on list instead of

meta random <= 4294967

Patch 2 and 3 use meta statement to add this probability mode.

Let me know, if needed I can also only push patch #1.

I also have a patch for meta.t to add tests for this.

