From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_osf: Add missing permission checks
Date: Wed, 6 Dec 2017 09:01:34 +0100
Message-ID: <20171206080134.GA2844@salvia>
References: <1512517361-23689-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdLFICE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 03:02:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 169B9C514A
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:02:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9DCEDA873
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:01:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1512517361-23689-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 05, 2017 at 03:42:41PM -0800, Kevin Cernekee wrote:
> The capability check in nfnetlink_rcv() verifies that the caller
> has CAP_NET_ADMIN in the namespace that "owns" the netlink socket.
> However, xt_osf_fingers is shared by all net namespaces on the
> system.  An unprivileged user can create user and net namespaces
> in which he holds CAP_NET_ADMIN to bypass the netlink_net_capable()
> check:
> 
>     vpnns -- nfnl_osf -f /tmp/pf.os
> 
>     vpnns -- nfnl_osf -f /tmp/pf.os -d
> 
> These non-root operations successfully modify the systemwide OS
> fingerprint list.  Add new capable() checks so that they can't.

Applied, thanks Kevin.
