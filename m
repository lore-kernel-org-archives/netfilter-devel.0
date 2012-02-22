From: Tony Zelenoff <antonz@parallels.com>
Subject: [PATCH 0/3] net/netfilter: minor refactoring of conntrack ecache
Date: Wed, 22 Feb 2012 10:47:58 +0400
Message-ID: <1329893281-508699-1-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <antonz@parallels.com>, <pablo@netfilter.org>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:54941 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2BVHAv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:00:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just saw some issues that better to refactor and save a bit of CPU cycles while
looking around conntracks. So, here they are.

Patches based on net-next tree.

Tony Zelenoff (3):
  net/netfilter: whitespace removed
  net/netfilter: refactor notifier registration
  net/netfilter: refactor nf_ct_deliver_cached_events

 net/netfilter/nf_conntrack_ecache.c |   81 +++++++++++++++++------------------
 1 files changed, 39 insertions(+), 42 deletions(-)

