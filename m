From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v2 0/2] Do not print unset value in xml file
Date: Mon,  2 Jun 2014 12:11:31 +0200
Message-ID: <1401703893-17050-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65298 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaFBKLm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:11:42 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so4883562wgh.35
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 03:11:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

After some advises of Arturo Borrero, I send a previous patch to
'Code refactoring to use nft_rule_expr_set_* functions' patch and v2 of
"Do not print unset values in xml" patch.

Ana Rey (2):
  src: expr: log: Code refactoring to use nft_rule_expr_set_* functions
  src: expr: log: Do not print unset values in xml.

 src/expr/log.c | 81 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

-- 
2.0.0.rc2

