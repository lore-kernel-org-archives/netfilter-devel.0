From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/5] expr: bitwise: Do not print unset values
Date: Thu, 19 Jun 2014 17:07:05 +0200
Message-ID: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38113 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSPHW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:22 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so2450593wgh.14
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 08:07:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:

*"expr: byteorder: Get a nft_rule_expr type in
    nft_rule_expr_byteorder_snprintf_* functions"
* "expr: byteorder: Use nft_rule_expr_set_* in the xml parsing code"
* "expr: byteorder: Rename variables in
    nft_rule_expr_byteorder_json_parse functions"

*** BLURB HERE ***

Ana Rey (5):
  expr: byteorder: Get a nft_rule_expr type in
    nft_rule_expr_byteorder_snprintf_* functions
  expr: byteorder: Use nft_rule_expr_set_* in the xml parsing code
  expr: byteorder: Do not print unset values in xml file
  expr: byteorder: Rename variables in
    nft_rule_expr_byteorder_json_parse functions
  expr: byteorder: Do not print unset values in json

 src/expr/byteorder.c | 196 +++++++++++++++++++++++++++------------------------
 1 file changed, 102 insertions(+), 94 deletions(-)

-- 
2.0.0

