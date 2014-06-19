From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] expr: cmp: Do not print unset values in xml and json
Date: Thu, 19 Jun 2014 19:34:20 +0200
Message-ID: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33736 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaFSRej (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:34:39 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so10461002wib.5
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 10:34:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:
 * expr: cmp: Get a nft_rule_expr type in nft_rule_expr_cmp_snprintf_* functions
 * expr: cmp: Use nft_rule_expr_set_* in the xml parsing code


Ana Rey (4):
  expr: cmp: Get a nft_rule_expr type in nft_rule_expr_cmp_snprintf_*
    functions
  expr: cmp: Use nft_rule_expr_set_* in the xml parsing code
  expr: cmp: Do not print unset values in xml file
  expr: cmp: Do not print unset values in json file

 src/expr/cmp.c | 112 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 55 insertions(+), 57 deletions(-)

-- 
2.0.0

