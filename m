From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/7] Interpret OP_NEQ against a set as OP_LOOKUP
Date: Tue, 29 Nov 2016 22:17:59 +0100
Message-ID: <20161129211759.GA6362@salvia>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39276 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755270AbcK2VSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:18:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C346174D13
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:18:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E723DA38C
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:18:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E2BBDA388
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:18:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 24, 2016 at 03:16:20PM +0100, Anatole Denis wrote:
> Now that the support for inverted matching is in the kernel and in libnftnl, add
> it to nftables too.
> 
> This fixes bug #888

Applied, thanks!
