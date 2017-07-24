From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Attach process info to
 NFT_MSG_NEWGEN notifications
Date: Mon, 24 Jul 2017 13:09:17 +0200
Message-ID: <20170724110917.GA6454@salvia>
References: <20170719143223.3618-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdGXLJh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 07:09:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C03E3CA4B5
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:09:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A524ADA81E
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:09:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0214DA241
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:09:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170719143223.3618-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 04:32:23PM +0200, Phil Sutter wrote:
> This is helpful for 'nft monitor' to track which process caused a given
> change to the ruleset.

Applied, thanks Phil.
