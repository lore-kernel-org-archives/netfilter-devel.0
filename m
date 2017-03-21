From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [RESENT]netfilter: nfnetlink_cthelper: Fix memory leak
Date: Tue, 21 Mar 2017 12:31:41 +0100
Message-ID: <20170321113141.GA6649@salvia>
References: <1490080030-6799-1-git-send-email-jeffy.chen@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        netfilter-devel@vger.kernel.org
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756896AbdCULbu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 07:31:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 093F6114810
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 12:31:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0D86FC38F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 12:31:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA734FC5A6
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 12:31:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490080030-6799-1-git-send-email-jeffy.chen@rock-chips.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 03:07:10PM +0800, Jeffy Chen wrote:
> We have memory leaks of nf_conntrack_helper & expect_policy.

Applied, thanks.
