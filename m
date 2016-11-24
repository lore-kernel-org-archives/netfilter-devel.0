From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft V2] src: add log flags syntax support
Date: Thu, 24 Nov 2016 13:33:38 +0100
Message-ID: <20161124123338.GA18726@salvia>
References: <1479555075-41756-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47898 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938647AbcKXMek (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:34:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CFA41F4B78
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:33:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B088A7D4E
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:33:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFDFCA7D49
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:33:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479555075-41756-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 19, 2016 at 07:31:15PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Now NF_LOG_XXX is exposed to the userspace, we can set it explicitly.
> Like iptables LOG target, we can log TCP sequence numbers, TCP options,
> IP options, UID owning local socket and decode MAC header. Note the
> log flags are mutually exclusive with group.
> 
> Some examples are listed below:
>  # nft add rule t c log flags tcp sequence,options
>  # nft add rule t c log flags ip options
>  # nft add rule t c log flags skuid
>  # nft add rule t c log flags ether
>  # nft add rule t c log flags all
>  # nft add rule t c log flags all group 1
>  <cmdline>:1:14-16: Error: flags and group are mutually exclusive
>  add rule t c log flags all group 1
>               ^^^

Applied, thanks Liping.
