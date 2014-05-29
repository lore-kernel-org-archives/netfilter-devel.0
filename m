From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/2] Do not print unset value in xml file
Date: Thu, 29 May 2014 13:26:38 +0200
Message-ID: <1401362800-30749-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:43168 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaE2L0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 07:26:55 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so235568wes.13
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2014 04:26:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In this patchset I refector the nft_rule_expr_log_snprintf function and
after, I fix a problem with unset values in xml file.

Ana Rey (2):
  src: expr: log: Code refactoring in nft_rule_expr_log_snprintf
  src: expr: log: Do not print unset values in xml.

 src/expr/log.c | 102 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 35 deletions(-)

-- 
2.0.0.rc2

