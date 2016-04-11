From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: conntrack: de-inline two helpers
Date: Mon, 11 Apr 2016 21:52:34 +0200
Message-ID: <1460404356-29893-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35551 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbcDKTwT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 15:52:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Noticed that we have two static inline functions that should be normal functions
instead.
First patch saves a bit text size as well.

include/net/netfilter/nf_conntrack_ecache.h |  108 +++-------------------------
net/netfilter/nf_conntrack_ecache.c         |   84 +++++++++++++++++++++
2 files changed, 99 insertions(+), 93 deletions(-)

