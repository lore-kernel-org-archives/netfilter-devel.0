From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 02/22] netfilter: ipset: Headers file cleanup
Date: Tue, 1 Nov 2016 20:14:19 +0100
Message-ID: <20161101191419.GB18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbcKATOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:14:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 164F4168383
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:14:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0780ABAC25
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:14:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE187BAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:14:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:35PM +0200, Jozsef Kadlecsik wrote:
> Remove extra whitespace, group counter helper together. Mark some of
> the helpers arguments as const.

It would be better to split this in two patches, one to remove extra
whitespace.

And another to group counter helper together.

Given that these two changes are not related each other, I would
prefer you follow this patch.

Thanks.
