From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] limit: Do not print unset value
Date: Mon, 16 Jun 2014 11:10:13 +0200
Message-ID: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43182 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJK3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:10:29 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so3628406wib.9
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:10:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:
"expr: limit: Add nft_rule_expr_limit_snprinf_* functions" and
"expr: limit: Use nft_rule_expr_set_* in the xml parsing code"

Ana Rey (4):
  expr: limit: Add nft_rule_expr_limit_snprinf_* functions
  expr: limit: Use nft_rule_expr_set_* in the xml parsing code
  expr: limit: Do not print unset values in json
  expr: limit: Do not print unset values in xml

 src/expr/limit.c | 90 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 28 deletions(-)

-- 
2.0.0

