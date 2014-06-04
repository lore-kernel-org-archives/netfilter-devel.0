From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/5] reject: Do not print unset value
Date: Wed,  4 Jun 2014 13:38:06 +0200
Message-ID: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49451 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaFDLiW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:38:22 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so1229152wiw.16
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:38:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patchset It does not print unset value in xml and json file.

Also, I do some tasks about refactoring code: Use of
nft_rule_expr_reject_snprinf_* functions, add nft_rule_expr_reject_snprinf_*
function and convert incorrect type of a variable.

Ana Rey (5):
  expr: reject: Add nft_rule_expr_reject_snprinf_* functions
  expr: reject: Use nft_rule_expr_set_* in the xml and default parsing
    code
  expr: reject: Do not print unset values in xml
  expr: reject: Convert the type of a variable
  expr: reject: Do not print unset values in json

 src/expr/reject.c | 108 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 35 deletions(-)

-- 
2.0.0.rc2

