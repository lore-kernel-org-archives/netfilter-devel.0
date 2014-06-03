From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v4 0/3] Do not print unset value in xml file
Date: Tue,  3 Jun 2014 12:41:53 +0200
Message-ID: <1401792116-17742-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48096 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaFCKmJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:42:09 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so6159021wiv.15
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:42:05 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

In this version, I add a new patch:
"expr: log: Rename variables in nft_rule_expr_log_json_parse functions"

It removes these changes out of "Use nft_rule_expr_set_* in the xml parsing code"
patch.

Also, I fix some errors with nft_rule_expr_set_* functions in
"Use nft_rule_expr_set_* in the xml parsing code" patch.

[Change in v3:]
In this version, I rename some variables, I fix writing errors in the patch
description and I fix wrong indentation.

[Change in v2:]

Hi,
After some advises of Arturo Borrero, I send a previous patch to
'Code refactoring to use nft_rule_expr_set_* functions' patch and v2 of
"Do not print unset values in xml" patch.


Ana Rey (3):
  expr: log: Rename variables in nft_rule_expr_log_json_parse functions
  expr: log: Use nft_rule_expr_set_* in the xml parsing code
  expr: log: Do not print unset values in xml

 src/expr/log.c | 95 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 41 deletions(-)

-- 
2.0.0.rc2

