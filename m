From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 0/8] unsorted fixes
Date: Tue, 18 Aug 2015 19:28:31 +0200
Message-ID: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37582 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbbHRRW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset contains a set of fixes for conntrackd as reported by
Paul Wouters.

Let me know if you have any concern with it, thank you.

Pablo Neira Ayuso (8):
  conntrackd: fix sanitization of expection attribute in the wire format
  conntrackd: NTA_MAX is also an invalid attribute
  conntrackd: fix leak in fork_process_new()
  conntrackd: fix descriptor leak in do_local_request()
  conntrackd: fix error handling in nfq_queue_cb()
  conntrackd: simplify branch in tcp_accept()
  conntrackd: use strncpy to set up the cache name
  conntrackd: missing break in expectation message parser function

 src/cache.c    |    5 +++--
 src/cthelper.c |   29 +++++++++++++++--------------
 src/local.c    |    9 ++++++---
 src/parse.c    |    8 +++++---
 src/process.c  |    2 ++
 src/tcp.c      |   12 +++++-------
 6 files changed, 36 insertions(+), 29 deletions(-)

-- 
1.7.10.4

