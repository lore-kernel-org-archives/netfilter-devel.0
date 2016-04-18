From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: conntrack: prepare for hashtable merge, take 1
Date: Mon, 18 Apr 2016 16:16:58 +0200
Message-ID: <1460989021-10780-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48400 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbcDROQs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 10:16:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This small series prepares for upcoming merge of the per-namespace hash tables
into a single table (or rater, three tables
-- conntrack hash, expect hash and nat bysrc hash).

Arguments for merging it:
- We stop wasting (assuming default size) 250k backing store per namespace
- net namespace is just another part of the connection id, much like
  ip addresses or conntrack zones -- no need to treat it specially
- allows to get rid of the per-netns conntrack slab as well

These patches are first preparations.
We replace per-netns conntrack has generation seqcount by single one.

While at it, this replaces the method used to obtain the hash seed
by the (nowadays) more common get_random_once().

