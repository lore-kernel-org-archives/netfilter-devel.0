From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnfntl] set: free user data
Date: Thu, 6 Jul 2017 15:49:53 +0200
Message-ID: <20170706134953.GA7766@salvia>
References: <20170706130539.22515-1-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752068AbdGFNt6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2017 09:49:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E85D64D65B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2017 15:49:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB351DA87A
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2017 15:49:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 002D0DA80A
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2017 15:49:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170706130539.22515-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 06, 2017 at 02:05:39PM +0100, Eric Leblond wrote:
> This was causing a memory leak when using set.
> 
> Catched by an ASAN run:
> 
> ==21004==ERROR: LeakSanitizer: detected memory leaks
> 
> Direct leak of 12 byte(s) in 2 object(s) allocated from:
>     #0 0x4cde58 in malloc (/usr/local/sbin/nft+0x4cde58)
>     #1 0x7ffff79b8c19 in nftnl_set_set_data /home/eric/git/netfilter/libnftnl/src/set.c:179
> 
> Signed-off-by: Eric Leblond <eric@regit.org>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Please go push this, thanks!
