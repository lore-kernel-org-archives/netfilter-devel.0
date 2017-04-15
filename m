From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2] iptables-restore/save: exit when given an
 unknown option
Date: Sat, 15 Apr 2017 10:50:26 +0200
Message-ID: <20170415085026.GA3073@salvia>
References: <20170413211627.GA2387@salvia>
 <20170414115621.13812-1-vincent@bernat.im>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Bernat <vincent@bernat.im>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751893AbdDOIuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 04:50:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9374E04A0
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 10:50:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97562DA729
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 10:50:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8902ADA729
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 10:50:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170414115621.13812-1-vincent@bernat.im>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 01:56:21PM +0200, Vincent Bernat wrote:
> When an unknown option is given, iptables-restore should exit instead of
> continue its operation. For example, if `--table` was misspelled, this
> could lead to an unwanted change. Moreover, exit with a status code of
> 1. Make the same change for iptables-save.
> 
> OTOH, exit with a status code of 0 when requesting help.

Hm, this doesn't apply cleanly to iptables.git for some reason.

$ git am /var/tmp/iptables-v2-iptables-restore-save-exit-when-given-an-unknown-option.patch
Applying: iptables-restore/save: exit when given an unknown option
error: patch failed: iptables/ip6tables-restore.c:46
error: iptables/ip6tables-restore.c: patch does not apply
error: patch failed: iptables/iptables-restore.c:43
error: iptables/iptables-restore.c: patch does not apply
Patch failed at 0001 iptables-restore/save: exit when given an unknown option
The copy of the patch that failed is found in:
   /home/devel/iptables/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Would you refresh your tree and resubmit? Thanks!
