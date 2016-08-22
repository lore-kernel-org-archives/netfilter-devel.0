From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] ct: allow numeric conntrack labels
Date: Mon, 22 Aug 2016 18:08:56 +0200
Message-ID: <20160822160856.GA2570@salvia>
References: <1471861047-7254-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932717AbcHVQJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:09:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D36421F18DA
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:09:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C337AFC61E
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:09:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A89E89D6A4
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:09:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471861047-7254-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 12:17:26PM +0200, Florian Westphal wrote:
> When dumping labels in rule list we try to print a symbolic name.
> If we don't find one, we print the bit number instead.
> 
> This changes nft to also allow use of the number instead of a name
> when adding ct label rules so that such dumps can also be restored
> again.
> 
> This is similar to other cases, e.g. skuid root vs skuid 0 which
> are both valid.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
