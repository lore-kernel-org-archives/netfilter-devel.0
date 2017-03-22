From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] netfilter: Clean up tests if NULL returned on failure
Date: Wed, 22 Mar 2017 14:38:21 +0100
Message-ID: <20170322133821.GA21278@salvia>
References: <1490085879-1827-1-git-send-email-singhalsimran0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, outreachy-kernel@googlegroups.com
To: simran singhal <singhalsimran0@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36870 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759719AbdCVNjC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 09:39:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6825C170D20
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 579FFDA38F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F638DA878
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:38:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490085879-1827-1-git-send-email-singhalsimran0@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 02:14:34PM +0530, simran singhal wrote:
> This patch series clean up tests if NULL returned on failure.

$ git grep "== NULL" net/netfilter/ | wc -l
461

This is cleaning up just some of them, we still seem to have quite a
bit of them.

Main problem with this changes is that it creates lots of work to
people backporting patches and stable maintainers, I remember that
they have complain about this.

Either way, I would prefer you fix this coding style issue in one go,
ie. one single patch, it will be a large one.
