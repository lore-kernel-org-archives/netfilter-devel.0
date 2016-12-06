From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: silence gcc warning with stateful object maps
Date: Tue,  6 Dec 2016 13:29:41 +0100
Message-ID: <1481027381-3934-1-git-send-email-pablo@netfilter.org>
Cc: kbuild test robot <fengguang.wu@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752979AbcLFM3x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 07:29:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D7B28CD66
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:29:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3761DA849
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:29:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB980DA861
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:29:44 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not a problem in practise since objtype is ignored if the NFT_SET_OBJECT
flag is not set.

But call down gcc warnings:

   net/netfilter/nf_tables_api.c: In function 'nf_tables_newset':
>> net/netfilter/nf_tables_api.c:3003:15: warning: 'objtype' may be used
+uninitialized in this function

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 799eaa6808b9..789229663028 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2920,6 +2920,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return -EINVAL;
 	} else if (flags & NFT_SET_OBJECT)
 		return -EINVAL;
+	else
+		objtype = NFT_OBJ_UNSPEC;
 
 	timeout = 0;
 	if (nla[NFTA_SET_TIMEOUT] != NULL) {
-- 
2.1.4

