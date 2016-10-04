From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix namespace handling in nf_log_proc_dostring
Date: Tue, 4 Oct 2016 08:46:53 +0200
Message-ID: <20161004064653.GA8692@salvia>
References: <1474227655-5022-1-git-send-email-jann@thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org
To: Jann Horn <jann@thejh.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752262AbcJDGrE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2016 02:47:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49FD91D94C2
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:47:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C952BAC23
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:47:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15EB0BAC34
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:46:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474227655-5022-1-git-send-email-jann@thejh.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 18, 2016 at 09:40:55PM +0200, Jann Horn wrote:
> nf_log_proc_dostring() used current's network namespace instead of the one
> corresponding to the sysctl file the write was performed on. Because the
> permission check happens at open time and the nf_log files in namespaces
> are accessible for the namespace owner, this can be abused by an
> unprivileged user to effectively write to the init namespace's nf_log
> sysctls.

Applied, thanks.
