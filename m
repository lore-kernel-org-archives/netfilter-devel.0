From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: expect: fix crash when putting uninited
 expectation
Date: Mon, 17 Jul 2017 17:08:22 +0200
Message-ID: <20170717150822.GD9791@salvia>
References: <20170710115353.17226-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55776 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdGQPI1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:08:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DF44249C8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:08:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1127D1B357D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:08:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3AF31B3358
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:08:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170710115353.17226-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 10, 2017 at 01:53:53PM +0200, Florian Westphal wrote:
> We crash in __nf_ct_expect_check, it calls nf_ct_remove_expect on the
> uninitialised expectation instead of existing one, so del_timer chokes
> on random memory address.

Applied, thanks.
