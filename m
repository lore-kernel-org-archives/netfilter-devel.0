From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: nf_tables: Refine the codes to
 eliminate useless condition checks in nf_tables_api.c
Date: Wed, 18 Jan 2017 21:11:59 +0100
Message-ID: <20170118201159.GA20220@salvia>
References: <1484575377-32755-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47276 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753448AbdARUh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 15:37:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 94B5213C0CA
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 21:12:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8160EFEFB3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 21:12:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 542F5A7EE5
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 21:12:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484575377-32755-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2017 at 10:02:57PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The return value of nf_tables_table_lookup is valid pointer or one
> pointer error. There are two cases totally.
> case1: IS_ERR(table) is true, it would return the error or reset the
> table as NULL, it is unnecessary to perform the latter check
> "table != NULL".
> case2: IS_ERR(obj) is false, the table is one valid pointer. It is also
> unnecessary to perform that check.
> The nf_tables_newset and nf_tables_newobj have same logic codes.
> 
> In summary, we could move the block of condition check "table != NULL"
> in the else block to eliminate the original condition checks.

Applied, thanks feng.
