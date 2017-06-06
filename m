From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/3] libip6t_icmp6: xlate: remove leftover space
Date: Tue, 6 Jun 2017 17:43:25 +0200
Message-ID: <20170606154324.GB11008@salvia>
References: <20170605220828.4738-1-pablombg@gmail.com>
 <20170605220828.4738-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdFFPn3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 11:43:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F304D1F4B79
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD199102182
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E632510218D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170605220828.4738-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:08:27AM +0200, Pablo M. Bermudo Garay wrote:
> This change should have been included in commit f035be35c749
> ("xtables-translate: fix multiple spaces issue"), but was forgotten.

Also applied, thanks.
