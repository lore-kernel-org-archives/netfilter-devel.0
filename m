From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: py: Fail test forcefully when bug is not fixed
Date: Mon, 26 Jun 2017 19:24:59 +0200
Message-ID: <20170626172459.GA11859@salvia>
References: <1498034865-11321-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbdFZRZD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:25:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2866E7B81
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:24:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3A531B4042
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:24:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9A5D1B4044
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:24:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1498034865-11321-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 21, 2017 at 02:17:45PM +0530, Shyam Saini wrote:
> when we have "fail" in the test cases then py test doesn't complain
> anything, but the test should complain if the fix is not applied.
> 
> Before applying the [Test] commit, nft throws following error message
> and exits with error code 134.
> $ nft add rule x y tcp dport set { 0 , 1 }
>     BUG: unknown expression type set reference
>     nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
>     Aborted
> 
> This commit enforces nft-test.py to throw error message when the fix
> is not applied.

This also looks good, applied, thanks Shyam.
