From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 05/22] netfilter: ipset: Split extensions into separate
 files
Date: Tue, 1 Nov 2016 20:21:03 +0100
Message-ID: <20161101192103.GF18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-6-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbcKATVI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:21:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2222168385
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:21:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B809BDA84C
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:21:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83E1CDA841
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:21:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-6-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:38PM +0200, Jozsef Kadlecsik wrote:
> Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

And please, provide a better description for this. Probably oneline
indicating that this is a cleanup should be fine.
