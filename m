From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/5] queue: Do not print unset value
Date: Fri, 13 Jun 2014 11:31:48 +0200
Message-ID: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51011 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaFMJcF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:32:05 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so2377543wgg.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 02:32:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code: "Add nft_rule_expr_queue_snprinf_* functions"
and "Use nft_rule_expr_* in the xml".

Also, It fixes some data type of variables.

Ana Rey (5):
  expr: queue: Add nft_rule_expr_queue_snprinf_* functions
  expr: queue: Use nft_rule_expr_* in the xml
  expr: queue: Do not print unset values in xml
  expr: queue: Do not print unset values in json
  expr: queue: Use the correct data type.

 src/expr/queue.c | 161 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 101 insertions(+), 60 deletions(-)

-- 
2.0.0

