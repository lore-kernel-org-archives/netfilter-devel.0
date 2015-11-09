From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 0/2] payload statement
Date: Mon,  9 Nov 2015 14:57:32 +0000
Message-ID: <1447081054-31046-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48707 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751693AbbKIO5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 09:57:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add support for payload mangling to nft.

Patrick McHardy (2):
  proto: add checksum key information to struct proto_desc
  payload: add payload statement

 include/linux/netfilter/nf_tables.h |  4 ++++
 include/proto.h                     |  2 ++
 include/statement.h                 | 11 +++++++++
 src/evaluate.c                      | 10 ++++++++
 src/netlink_delinearize.c           | 46 ++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c             | 37 +++++++++++++++++++++++++++++
 src/parser_bison.y                  |  9 ++++++++
 src/payload.c                       | 24 +++++++++++++++++++
 src/proto.c                         |  5 ++++
 9 files changed, 145 insertions(+), 3 deletions(-)

-- 
2.5.0

