From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/3] expr: nat: Do not print unset value
Date: Fri, 13 Jun 2014 14:08:26 +0200
Message-ID: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:37745 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaFMMIr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:08:47 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so1997702wev.34
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 05:08:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code: "Use nft_rule_expr_set_* in the xml"

Ana Rey (3):
  expr: nat: Use nft_rule_expr_set_* in the xml
  expr: nat: Do not print unset values in xml file
  expr: nat: Do not print unset values in json file

 src/expr/nat.c | 74 ++++++++++++++++++++--------------------------------------
 1 file changed, 25 insertions(+), 49 deletions(-)

-- 
2.0.0

