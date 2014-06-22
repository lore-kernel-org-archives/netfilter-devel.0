From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/4] expr: payload: Do not print unset values in xml and json
Date: Sun, 22 Jun 2014 20:32:17 +0200
Message-ID: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37676 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaFVScc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:32:32 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so3028239wib.12
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2014 11:32:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset values in xml and json file
and about refactoring code:
* "expr: payload: Use nft_rule_expr_set_* in the xml parsing code"
* "expr: payload: get a nft_rule_expr type in
    nft_rule_expr_payload_snprintf_* functions"

Ana Rey (4):
  expr: payload: Use nft_rule_expr_set_* in the xml parsing code
  expr: payload: get a nft_rule_expr type in
    nft_rule_expr_payload_snprintf_* functions
  expr: payload: Do not print unset values in xml file
  expr: payload: Do not print unset values in json file

 src/expr/payload.c | 129 +++++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 63 deletions(-)

-- 
2.0.0

