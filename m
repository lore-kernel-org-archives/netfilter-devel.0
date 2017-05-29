From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] evaluate: avoid reference to multiple src data in
 statements which set values
Date: Mon, 29 May 2017 13:03:01 +0200
Message-ID: <20170529110301.GA4822@salvia>
References: <149579635553.24003.5991119396424133127.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56792 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdE2LDH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 07:03:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 367F51EC2D7
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 13:02:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 253E9102195
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 13:02:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A9EC100A6A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 13:02:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149579635553.24003.5991119396424133127.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 26, 2017 at 01:00:21PM +0200, Arturo Borrero Gonzalez wrote:
> Prevent this assert:
> 
> % nft [..] tcp dport set { 0 , 1 }
> BUG: unknown expression type set reference
> nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
> Aborted
> 
> We can't use a set here because we will not known which value to use.
> 
> With this patch, a proper error message is reported to users:
> 
> % nft add rule t c tcp dport set {1, 2, 3, 4, 5}
> <cmdline>:1:28-42: Error: you cannot use a set here, unknown value to use
> add rule t c tcp dport set {1, 2, 3, 4, 5}
>              ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^
> 
> % nft add rule t c tcp dport set @s
> <cmdline>:1:28-29: Error: you cannot reference a set here, unknown value to use
> add rule t c tcp dport set @s
>              ~~~~~~~~~~~~~~^^
> 
> This error is reported to all statements which set values.

Applied, thanks Arturo.

Probably you can add a test for this? It would be good to know what
error nft reports in case of BUG: message, so we can distinguish
between command error and assertion/bug.
