From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next v2 0/2] fixes for recent nf_compact hooks
Date: Tue, 27 Sep 2016 09:38:33 -0400
Message-ID: <1474983515-4115-1-git-send-email-aconole@bytheb.org>
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34486 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752865AbcI0Nin (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2016 09:38:43 -0400
Received: by mail-qk0-f196.google.com with SMTP id b204so826323qkc.1
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2016 06:38:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Two possible error conditions were caught during an extended testing
session, and by a build robot.  These patches fix the two issues (a
missing handler when config is changed, and a potential NULL
dereference).

Aaron Conole (2):
  netfilter: Fix potential null pointer dereference
  nf_set_hooks_head: acommodate different kconfig

 net/netfilter/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.5.5

