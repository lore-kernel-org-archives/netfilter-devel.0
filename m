From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] monitor: Print NEWGEN events
Date: Mon, 24 Jul 2017 20:21:50 +0200
Message-ID: <20170724182150.GA18847@salvia>
References: <20170724172911.1611-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55390 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754377AbdGXSWH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 14:22:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57739172EA2
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 20:21:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4865EDA46B
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 20:21:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D2F4DA7F4
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 20:21:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170724172911.1611-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 24, 2017 at 07:29:11PM +0200, Phil Sutter wrote:
> Now that they contain process information, they're actually interesting.
> For backwards compatibility, print process information only if it was
> present in the message.

Applied, thanks Phil.
