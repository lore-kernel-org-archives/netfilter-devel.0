From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] mnl: Remove dead code
Date: Thu, 27 Jul 2017 10:46:46 +0200
Message-ID: <20170727084646.GB5576@salvia>
References: <20170726161630.12919-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbdG0Iq6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 04:46:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB774E1232
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 10:46:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC19CA7F28
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 10:46:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2C18D1CA3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 10:46:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170726161630.12919-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Pablo Bermudo.

On Wed, Jul 26, 2017 at 06:16:30PM +0200, Phil Sutter wrote:
> Remove the functions mnl_nft_rule_add() and *_delete() since they are
> not used throughout the code. Commit a72315d2bad47 ("src: add rule
> batching support") changed their only caller to use the batch variant
> introduced at the same time.

I think there are more useless functions. Pablo Bermudo mentioned this
to me a while ago. At least I remember some of them in netlink.c?

If not much asking, it would be good if we can kill them all in one go.
