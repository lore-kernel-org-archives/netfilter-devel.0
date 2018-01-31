From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] Fix wraparound bug introduced in commit 48596a8ddc46
Date: Wed, 31 Jan 2018 14:54:14 +0100
Message-ID: <20180131135414.byqyilpca3zccyr6@salvia>
References: <1515752210-22053-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1515752210-22053-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752265AbeAaNyT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jan 2018 08:54:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A89071176A5
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2018 14:54:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98A53BAC29
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2018 14:54:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515752210-22053-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 12, 2018 at 11:16:50AM +0100, Jozsef Kadlecsik wrote:
> The patch "netfilter: ipset: Fix adding an IPv4 range containing
> more than 2^31 addresses" introduced a wraparound bug, which could
> lead to memory exhaustion when adding an x.x.x.x-255.255.255.255
> range to any hash:*net* types.
> 
> Fixes Netfilter's bugzilla id #1212, reported by Thomas Schwark.

For the record, I have renamed this to:

"netfilter: ipset: Fix wraparound in hash:*net* types"

And I have added the Fixes: tag.

Applied, thanks Jozsef!
