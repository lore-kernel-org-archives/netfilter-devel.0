From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 07/22] netfilter: ipset: Regroup ip_set_put_extensions
 and add extern
Date: Tue, 1 Nov 2016 20:24:22 +0100
Message-ID: <20161101192422.GH18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-8-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752964AbcKATY1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:24:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D53A0168386
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:24:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C79FCBAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:24:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B87CBAC28
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:24:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-8-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:40PM +0200, Jozsef Kadlecsik wrote:
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

A bit pendantic, but please, add description, oneline is fine
indicating why this belongs there is good. Thanks.
