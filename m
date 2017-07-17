From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v4] include: Remove __init and __exit macro
 definitions.
Date: Mon, 17 Jul 2017 14:26:07 +0200
Message-ID: <20170717122607.GA7416@salvia>
References: <59601b38.05c2620a.1b29f.4776@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37364 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751304AbdGQM0L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 08:26:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A31BB25D32
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 14:25:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93520DA80E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 14:25:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C69ED1CAA
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 14:25:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <59601b38.05c2620a.1b29f.4776@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 08, 2017 at 05:07:23AM +0530, Varsha Rao wrote:
> Add nft_init and nft_exit functions, which calls _init and _exit
> functions in main.c file. Remove __init and __exit macro definitions as
> libnftables library will be created soon. Rename realm_table_init() and
> realm_table_exit() functions to avoid ambiguity as
> realm_table_rt_init(), realm_table_meta_init, realm_table_rt_exit() and
> realm_table_meta_exit() in rt.c and meta.c files.

Applied with changes.

Please, next time, split your patches into logical changes. In this
patch that are two logical changes that are not related:

1) Pass nf_sock to functions as parameter.
2) Remove __init and __exit functions.

So I have split this patch in two before pushing out.

Just note for the next time, no problem.

Thanks Varsha.
