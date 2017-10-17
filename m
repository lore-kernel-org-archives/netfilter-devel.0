From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] netlink: Use nftnl_expr_fprintf() in
 netlink_dump_expr()
Date: Tue, 17 Oct 2017 15:20:32 +0200
Message-ID: <20171017132032.GA22545@salvia>
References: <20171004214111.2755-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43472 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752566AbdJQNUg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:20:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 85FB952306
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:20:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7802FBAC39
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:20:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171004214111.2755-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 04, 2017 at 11:41:11PM +0200, Phil Sutter wrote:
> This gets rid of the temporary buffer.

Applied, thanks.
