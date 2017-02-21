From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] ipset patches for nf
Date: Tue, 21 Feb 2017 14:05:52 +0100
Message-ID: <20170221130552.GA21403@salvia>
References: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752744AbdBUNF7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2017 08:05:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 539881A09B1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 14:05:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43BA0DA845
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 14:05:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCA6CDA845
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 14:05:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 19, 2017 at 07:24:14PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next patches for ipset in your nf branch.
> Both patches should go into the stable kernel branches as well,
> because these are important bugfixes:
> 
> * Sometimes valid entries in hash:* types of sets were evicted
>   due to a typo in an index. The wrong evictions happen when
>   entries are deleted from the set and the bucket is shrinked.
>   Bug was reported by Eric Ewanco and the patch fixes
>   netfilter bugzilla id #1119.
> * Fixing of a null pointer exception when someone wants to add an
>   entry to an empty list type of set and specifies an add before/after
>   option. The fix is from Vishwanath Pai.
> 
> Best regards,
> Jozsef
> 
> The following changes since commit f95d7a46bc5722767c30ee223c8b67dd0f2e8793:
> 
>   netfilter: ctnetlink: Fix regression in CTA_HELP processing (2017-02-06 12:49:05 +0100)
> 
> are available in the git repository at:
> 
>   git://blackhole.kfki.hu/nf master

Pulled, thanks Jozsef.
