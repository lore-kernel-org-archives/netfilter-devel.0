From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH v2 nft 0/2] payload mangling support
Date: Tue, 24 Nov 2015 12:55:39 +0000
Message-ID: <1448369741-19622-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45657 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387AbbKXMzo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 07:55:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add support for payload mangling to nft.

Changes since v1:

* set checksum type
* generate protocol dependencies for payload expression in statement
  (f.i. ether saddr set 00:00:00:00:00:00 => meta iiftype ether)


Patrick McHardy (2):
  proto: add checksum key information to struct proto_desc
  payload: add payload statement

 include/linux/netfilter/nf_tables.h | 17 ++++++++++++++
 include/proto.h                     |  2 ++
 include/statement.h                 | 11 +++++++++
 src/evaluate.c                      | 25 ++++++++++++++++++--
 src/netlink_delinearize.c           | 46 ++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c             | 40 ++++++++++++++++++++++++++++++++
 src/parser_bison.y                  |  9 ++++++++
 src/payload.c                       | 24 +++++++++++++++++++
 src/proto.c                         |  5 ++++
 9 files changed, 174 insertions(+), 5 deletions(-)

-- 
2.5.0

