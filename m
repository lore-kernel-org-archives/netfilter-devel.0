From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] expr: ct: Do not print unset values in xml and json
Date: Tue, 24 Jun 2014 08:46:36 +0200
Message-ID: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58819 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaFXGrD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:47:03 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so5315784wib.5
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 23:47:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:
 * expr: ct: Use nft_rule_expr_set_* in the xml parsing code
 * expr: ct: Delete the last comma character in json text.

Ana Rey (4):
  expr: ct: Use nft_rule_expr_set_* in the xml parsing code
  expr: ct: Do not print unset values in xml file
  expr: ct: Delete the last comma character in json text.
  expr: ct: Do not print unset values in json

 src/expr/ct.c | 92 ++++++++++++++++++++++++-----------------------------------
 1 file changed, 37 insertions(+), 55 deletions(-)

-- 
2.0.0

