From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] ipset patches for nf-next
Date: Mon, 8 Jan 2018 13:57:02 +0100
Message-ID: <20180108125702.6ajyx7zbswdqpfer@salvia>
References: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52826 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756815AbeAHM5H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 07:57:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A26724931
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 13:57:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A2818E791
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 13:57:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 06, 2018 at 04:36:06PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to apply the next patches:
> 
> - A patch to use the swap() macro instead of the manual coding
>   from Gustavo A. R. Silva
> - A fix to take into account the possible counter value matching
>   for the "don't update counters" mode. It required a reorganizing
>   in handling the extensions which resulted a simpler and cleaner code.
> - The patch "netfilter: ipset: use nfnl_mutex_is_locked" revealed
>   a missing mutex locking in ip_set_net_exit(), fixed.

Pulled, thanks Jozsef!
