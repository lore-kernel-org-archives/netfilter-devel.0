From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/3] expr: lookup: Do not print unset values in xml and json
Date: Tue, 24 Jun 2014 19:14:14 +0200
Message-ID: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62095 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFXROa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:14:30 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so1015687wiv.14
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:14:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset values in xml and json file
and about refactoring code:
* "expr: lookup: Use nft_rule_expr_set_* in the xml parsing code"

Ana Rey (3):
  expr: lookup: Use nft_rule_expr_set_* in the xml parsing code
  expr: lookup: Do not print unset values in xml file
  expr: lookup: Do not print unset values in json file

 src/expr/lookup.c | 80 +++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

-- 
2.0.0

