From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net v2] xt_RATEEST: acquire xt_rateest_mutex for hash
 insert
Date: Tue, 6 Feb 2018 13:26:12 +0100
Message-ID: <20180206122612.y2ztqmtcu2wfpicm@salvia>
References: <20180205224145.9420-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752807AbeBFM0O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 07:26:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 86A251D94A9
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 13:26:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7636BBAC38
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 13:26:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180205224145.9420-1-xiyou.wangcong@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 05, 2018 at 02:41:45PM -0800, Cong Wang wrote:
> rateest_hash is supposed to be protected by xt_rateest_mutex,
> and, as suggested by Eric, lookup and insert should be atomic,
> so we should acquire the xt_rateest_mutex once for both.
> 
> So introduce a non-locking helper for internal use and keep the
> locking one for external.

Applied, thanks!
