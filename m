From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: remove hook owner refcounting
Date: Tue, 13 Oct 2015 14:33:25 +0200
Message-ID: <1444739608-9327-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47406 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbbJMMde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2015 08:33:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of .owner = THIS_MODULE in all nf_hook_ops, its not needed
anymore.

The only facility that used this was nfqueue but nowadays we zap all
queued entries that make use of a to-be-removed nf hook.

Followup commit simplifies nfqeue a bit (nf_queue_entry_get_refs can't
fail anymore) and gets rid of a bunch of unneeded rcu readlocks.

diffstat:
21 files changed, 11 insertions(+), 99 deletions(-)
