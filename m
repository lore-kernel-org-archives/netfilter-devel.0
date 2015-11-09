From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 0/1] payload mangling support
Date: Mon,  9 Nov 2015 14:59:15 +0000
Message-ID: <1447081156-31427-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48728 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213AbbKIO7T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 09:59:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch adds support for payload mangling to libnftnl.

Patrick McHardy (1):
  payload: add payload mangling support

 include/libnftnl/expr.h             |  4 ++++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/payload.c                  | 42 +++++++++++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 4 deletions(-)

-- 
2.5.0

