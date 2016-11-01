From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 16/22] netfilter: ipset: Collapse same condition body to
 a single one
Date: Tue, 1 Nov 2016 20:27:30 +0100
Message-ID: <20161101192730.GJ18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-17-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54320 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753885AbcKAT1j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:27:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B3A8168381
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:27:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CC06BAC2D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:27:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AF06BAC26
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:27:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-17-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:49PM +0200, Jozsef Kadlecsik wrote:
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Please, document that net_ratelimit() and pr_warn is not useful
anymore, so you remove.
