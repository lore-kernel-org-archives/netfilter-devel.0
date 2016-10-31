From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: destroy the set if fail to add
 transaction
Date: Mon, 31 Oct 2016 15:21:26 +0100
Message-ID: <20161031142126.GA21797@salvia>
References: <1477749785-14092-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943415AbcJaOVb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 10:21:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF25BE8394
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:21:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2DEBDA849
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:21:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE3CADA819
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:21:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477749785-14092-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 29, 2016 at 10:03:05PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When the memory is exhausted, then we will fail to add the NFT_MSG_NEWSET
> transaction. In such case, we should destroy the set before we free it.

Applied, thanks Liping.
