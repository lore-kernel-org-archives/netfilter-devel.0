From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED
 in reverse SNATv6 path
Date: Tue, 25 Apr 2017 11:15:01 +0200
Message-ID: <20170425091501.GA3557@salvia>
References: <22774.51265.265373.257836@gargle.gargle.HOWL>
 <22776.44325.616928.335465@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Dave Johnson <dave-kernel@centerclick.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1176083AbdDYJPK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:15:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7AB036B187
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:15:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68098FF2C8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:15:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE36CFF2DA
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:15:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <22776.44325.616928.335465@gargle.gargle.HOWL>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 08:44:21AM -0400, Dave Johnson wrote:
> 
> When recalculating the outer ICMPv6 checksum for a reverse path NATv6
> such as ICMPV6_TIME_EXCEED nf_nat_icmpv6_reply_translation() was
> accessing data beyond the headlen of the skb for non-linear skb.  This
> resulted in incorrect ICMPv6 checksum as garbage data was used.

Applied to nf, thanks.
