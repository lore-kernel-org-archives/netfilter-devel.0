From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/3] expr: immediate: Do not print unset values in xml and json
Date: Sat, 21 Jun 2014 17:53:40 +0200
Message-ID: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:61059 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaFUPyF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:54:05 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so5000545wes.39
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 08:54:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:
* "expr: immediate: Use nft_rule_expr_set_* in the xml parsing code"

Ana Rey (3):
  expr: immediate: Use nft_rule_expr_set_* in the xml parsing code
  expr: immediate: Do not print unset values in json file
  expr: immediate: Do not print unset values in xml file

 src/expr/immediate.c | 95 +++++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 49 deletions(-)

-- 
2.0.0

