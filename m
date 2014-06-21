From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] expr: meta: Do not print unset values in xml and json
Date: Sat, 21 Jun 2014 18:29:56 +0200
Message-ID: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33908 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaFUQaM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 12:30:12 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so2162991wiv.10
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 09:30:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:
* "expr: meta: Delete the last comma character in json text."
* "expr: meta: Use nft_rule_expr_set_* in the xml parsing code"

Ana Rey (4):
  expr: meta: Use nft_rule_expr_set_* in the xml parsing code
  expr: meta: Do not print unset values in xml file
  expr: meta: Delete the last comma character in json text.
  expr: meta: Do not print unset values in json file

 src/expr/meta.c | 80 +++++++++++++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 48 deletions(-)

-- 
2.0.0

