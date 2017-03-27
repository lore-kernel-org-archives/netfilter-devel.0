From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v5 1/1] netfilter: snmp: Fix one possible panic when
 snmp_trap_helper fail to register
Date: Mon, 27 Mar 2017 13:55:48 +0200
Message-ID: <20170327115548.GD5270@salvia>
References: <1490437476-12476-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39494 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751751AbdC0Lzz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 07:55:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 70540E8E97
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:55:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6344BDA86B
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:55:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB822DA873
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:55:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490437476-12476-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 25, 2017 at 06:24:36PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> In the commit 93557f53e1fb ("netfilter: nf_conntrack: nf_conntrack snmp
> helper"), the snmp_helper is replaced by nf_nat_snmp_hook. So the
> snmp_helper is never registered. But it still tries to unregister the
> snmp_helper, it could cause the panic.
> 
> Now remove the useless snmp_helper and the unregister call in the
> error handler.

Applied to nf, thanks.
