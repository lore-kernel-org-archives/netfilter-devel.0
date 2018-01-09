From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 0/2] parser_bison: delete chains via chain handle
Date: Wed, 10 Jan 2018 00:28:24 +0530
Message-ID: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41492 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932310AbeAIS6t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 13:58:49 -0500
Received: by mail-pf0-f193.google.com with SMTP id j3so5373218pfh.8
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jan 2018 10:58:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print chain handles with option '-a' and delete chains via chain handle

Harsha Sharma (2):
  src: Print handle attribute in chains
  parser_bison: extend nft to delete chain via chain handle

 src/parser_bison.y | 16 ++++++++++++++--
 src/rule.c         |  5 ++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

-- 
2.11.0

