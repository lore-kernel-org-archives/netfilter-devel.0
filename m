From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/4] A round of covscan indicated fixes
Date: Fri, 12 Aug 2016 18:00:06 +0200
Message-ID: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41997 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbcHLQAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 12:00:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As for libnftnl, this series aims at fixing a number of issues
identified by covscan. And again, due to my limited overview of the
code-base, some of them might as well be invalid although I tried to
verify the issues as best as I can.

Phil Sutter (4):
  evaluate: Fix datalen checks in expr_evaluate_string()
  netlink_delinearize: Avoid potential null pointer deref
  proto_find_num: Avoid potential null pointer dereference
  evaluate: Avoid undefined behaviour in concat_subtype_id()

 src/evaluate.c            | 8 +++++---
 src/netlink_delinearize.c | 2 ++
 src/proto.c               | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.8.2

