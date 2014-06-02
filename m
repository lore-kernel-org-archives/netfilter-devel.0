From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v3 0/2] Do not print unset value in xml file
Date: Mon,  2 Jun 2014 14:06:08 +0200
Message-ID: <1401710770-23662-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:59787 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBMGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:06:33 -0400
Received: by mail-we0-f175.google.com with SMTP id p10so5063766wes.34
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 05:06:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In this version, I rename some variables, I fix writing errors in the patch
description and I fix wrong indentation.

[Change in v2:]

Hi,
After some advises of Arturo Borrero, I send a previous patch to
'Code refactoring to use nft_rule_expr_set_* functions' patch and v2 of
"Do not print unset values in xml" patch.


Ana Rey (2):
  expr: log: Code refactoring to use nft_rule_expr_set_* functions
  src: expr: log: Do not print unset values in xml.

 src/expr/log.c | 93 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 39 deletions(-)

-- 
2.0.0.rc2

