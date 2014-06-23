From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] expr: target: Do not print unset values in xml and json files
Date: Mon, 23 Jun 2014 11:38:16 +0200
Message-ID: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39951 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaFWJic (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:32 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so3806890wiw.17
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:38:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset values in xml and json file
and about refactoring code:
* "expr: target: get a nft_rule_expr type in
    nft_rule_expr_target_snprintf_* functions"
* "expr: target: Use nft_rule_expr_set_* in the xml parsing code"

Ana Rey (4):
  expr: target: get a nft_rule_expr type in
    nft_rule_expr_target_snprintf_* functions
  expr: target: Use nft_rule_expr_set_* in the xml parsing code
  expr: target: Do not print unset values in xml file
  expr: target: Do not print unset values in json file

 src/expr/target.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

-- 
2.0.0

