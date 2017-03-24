From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v3 1/1] netfilter: snmp: Fix one possible panic when
 snmp_trap_helper fail to register
Date: Fri, 24 Mar 2017 13:21:30 +0100
Message-ID: <20170324122130.GA3080@salvia>
References: <1490055749-52357-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, jolsa@redhat.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933871AbdCXMVh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 08:21:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 798ED11E593
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:21:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A176DA87E
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:21:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A55FDA87D
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:21:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490055749-52357-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 08:22:29AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> In the commit 93557f53e1fb ("netfilter: nf_conntrack: nf_conntrack snmp
> helper"), the snmp_helper is replaced by nf_nat_snmp_hook. So the
> snmp_helper is never registered. But it still tries to unregister the
> snmp_helper, it could cause the panic.

This patch looks correct to me.

But probably for some reason I don't manage to trigger, how do you
reproduce this?
