From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 11/22] netfilter: ipset: Simplify mtype_expire() for hash
 types
Date: Tue, 1 Nov 2016 20:25:46 +0100
Message-ID: <20161101192546.GI18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-12-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53898 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbcKATZu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:25:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F17B168380
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:25:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 104E4BAC24
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:25:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0055DBAC23
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:25:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-12-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:44PM +0200, Jozsef Kadlecsik wrote:
> Remove redundant parameters nets_length and dsize:
> they could be get from other parameters.
> 
> Remove one leve of intendation by using continue while
> iterating over elements in bucket.

Please, split this in two patches, otherwise this is hard to review.
