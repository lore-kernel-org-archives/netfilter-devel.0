From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/3] expr: bitwise: Do not print unset values
Date: Thu, 19 Jun 2014 12:05:36 +0200
Message-ID: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46497 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaFSKFu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:05:50 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so2087443wgg.32
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 03:05:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code: "Get a nft_rule_expr type in
nft_rule_expr_bitwise_snprintf_* functions"

Ana Rey (3):
  expr: bitwise: Get a nft_rule_expr type in
    nft_rule_expr_bitwise_snprintf_* functions
  expr: bitwise: Do not print unset values in xml
  expr: bitwise: Do not print unset values in json

 src/expr/bitwise.c | 212 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 112 insertions(+), 100 deletions(-)

-- 
2.0.0

