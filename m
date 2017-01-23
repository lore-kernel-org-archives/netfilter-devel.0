From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V2] netfilter: nf_tables: validate the name size when
 possible
Date: Mon, 23 Jan 2017 14:20:21 +0100
Message-ID: <20170123132021.GA3607@salvia>
References: <1484917383-52757-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33460 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdAWNU2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 08:20:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64451168387
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:20:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 525791B32F2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:20:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84B1E1B32F2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:20:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484917383-52757-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 20, 2017 at 09:03:03PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, if the user add a stateful object with the name size exceed
> NFT_OBJ_MAXNAMELEN - 1 (i.e. 31), we truncate it down to 31 silently.
> This is not friendly, furthermore, this will cause duplicated stateful
> objects when the first 31 characters of the name is same. So limit the
> stateful object's name size to NFT_OBJ_MAXNAMELEN - 1.
> 
> After apply this patch, error message will be printed out like this:
>   # name_32=$(printf "%0.sQ" {1..32})
>   # nft add counter filter $name_32
>   <cmdline>:1:1-52: Error: Could not process rule: Numerical result out
>   of range
>   add counter filter QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Also this patch cleans up the codes which missing the name size limit
> validation in nftables.

Applied, thanks Liping.
