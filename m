From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH v2 libnftnl] payload mangling support
Date: Tue, 24 Nov 2015 12:48:57 +0000
Message-ID: <1448369338-18517-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45587 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753335AbbKXMtH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 07:49:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch adds support for payload mangling to libnftnl.

Updated to support setting the checksum method.


Patrick McHardy (1):
  payload: add payload mangling support

 include/libnftnl/expr.h             |  6 ++++
 include/linux/netfilter/nf_tables.h | 17 +++++++++++
 src/expr/payload.c                  | 58 ++++++++++++++++++++++++++++++++++---
 3 files changed, 77 insertions(+), 4 deletions(-)

-- 
2.5.0

