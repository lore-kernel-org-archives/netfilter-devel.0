From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/9] ct helper set support
Date: Wed, 15 Mar 2017 11:35:45 +0100
Message-ID: <20170315103545.GA10205@salvia>
References: <20170314195816.1721-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751842AbdCOKfv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 06:35:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A07842460A
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 11:35:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EE7CDA3FD
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 11:35:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F947DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 11:35:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314195816.1721-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 08:58:07PM +0100, Florian Westphal wrote:
> This series adds the frontend/nft support to define and
> assign connection tracking helpers.
> 
> Example:
> 
> table inet myhelpers {
>   ct helper ftp-standard {
>      type "ftp"
>      protocol tcp
>   }
>   chain prerouting {
>       type filter hook prerouting priority 0;
>       tcp dport 21 ct helper set "ftp-standard"
>   }
> }
> 
> A future extension could also allow to define/set knobs
> that can only be set via module parameters at this time,
> for instance the ftp 'loose mode' or the number of allowed expectations.

LGTM.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
