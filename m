From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] expr: exthdr: Do not print unset values in xml and json
Date: Tue, 24 Jun 2014 14:33:43 +0200
Message-ID: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48659 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaFXMeD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:34:03 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so286311wes.19
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 05:33:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset values in xml and json file
and about refactoring code:
* "expr: exthdr: Add nft_rule_expr_exthdr_snprinf_* functions"
* "expr: exthdr: Use nft_rule_expr_set_* in the xml parsing code"

Ana Rey (4):
  expr: exthdr: Add nft_rule_expr_exthdr_snprinf_* functions
  expr: exthdr: Use nft_rule_expr_set_* in the xml parsing code
  expr: exthdr: Do not print unset values in xml
  expr: exthdr: Do not print unset values in json

 src/expr/exthdr.c | 167 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 102 insertions(+), 65 deletions(-)

-- 
2.0.0

