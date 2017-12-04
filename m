From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_cthelper: Add missing permission
 checks
Date: Mon, 4 Dec 2017 11:32:00 +0100
Message-ID: <20171204103200.GA16022@salvia>
References: <1512331965-30830-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753127AbdLDKcF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Dec 2017 05:32:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D86772519A7
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:32:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6073DA807
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:32:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1512331965-30830-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 03, 2017 at 12:12:45PM -0800, Kevin Cernekee wrote:
> The capability check in nfnetlink_rcv() verifies that the caller
> has CAP_NET_ADMIN in the namespace that "owns" the netlink socket.
> However, nfnl_cthelper_list is shared by all net namespaces on the
> system.

Right, we need per-netns support for nfnetlink_cthelper.

> An unprivileged user can create user and net namespaces
> in which he holds CAP_NET_ADMIN to bypass the netlink_net_capable()
> check:

Applied to nf, thanks.
[...]
> I think xt_osf has the same issue with respect to xt_osf_fingers.
> Also, it looks like nlmon devices created in an unprivileged netns can
> see netlink activity from the init namespace.

A fix that one would be good too.
