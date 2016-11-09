From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: simplify the basic
 expressions' init routine
Date: Thu, 10 Nov 2016 00:07:23 +0100
Message-ID: <20161109230723.GA11511@salvia>
References: <1478438151-30598-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752621AbcKIXH2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 18:07:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37EB4A7CB4
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 00:07:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29926A7E96
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 00:07:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E82AA7E92
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 00:07:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478438151-30598-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 06, 2016 at 09:15:51PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Some basic expressions are built into nf_tables.ko, such as nft_cmp,
> nft_lookup, nft_range and so on. But these basic expressions' init
> routine is a little ugly, too many goto errX labels, and we forget
> to call nft_range_module_exit in the exit routine, although it is
> harmless.
> 
> Acctually, the init and exit routines of these basic expressions
> are same, i.e. do nft_register_expr in the init routine and do
> nft_unregister_expr in the exit routine.
> 
> So it's better to arrange them into an array and deal with them
> together.

Applied, thanks.
