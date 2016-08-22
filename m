From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] netfilter: nft_numgen: add number generator expression
Date: Mon, 22 Aug 2016 11:32:19 +0200
Message-ID: <20160822093219.GA5516@salvia>
References: <20160818101310.GA27665@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbcHVJc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:32:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A03161373AF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:32:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91A81FB45D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:32:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DCD5FB45D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:32:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160818101310.GA27665@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 18, 2016 at 12:13:13PM +0200, Laura Garcia Liebana wrote:
> Add support for the number generator expression in netfilter.

Applied, thanks.

I have rewritten the description to something larger. Writing larger
description is good for the record, specifically it is good to
indicate their purpose.

I have fixed this minor glitch here too.

net/netfilter/nft_numgen.c:43:25: warning: symbol 'nft_ng_policy' was
not declared. Should it be static?

Thanks Laura!
