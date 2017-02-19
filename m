From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nfnetlink_log: fix the typo
Date: Sun, 19 Feb 2017 20:58:39 +0100
Message-ID: <20170219195839.GA6211@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Duan Jiong <jduan@fiberhome.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750978AbdBST6p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Feb 2017 14:58:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2EC23DA722
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Feb 2017 20:58:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 222E0DA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Feb 2017 20:58:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B80CDA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Feb 2017 20:58:40 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This doesn't apply, sorry :(

$ git am /tmp/nfnetlink_log-fix-the-typo.patch  -s
Applying: nfnetlink_log: fix the typo
error: patch failed: net/netfilter/nfnetlink_log.c:1
error: net/netfilter/nfnetlink_log.c: patch does not apply
Patch failed at 0001 nfnetlink_log: fix the typo
The copy of the patch that failed is found in:
   /.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
