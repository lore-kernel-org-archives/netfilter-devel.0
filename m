From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: nft removes required payload protocol
 expressions
Date: Thu, 6 Apr 2017 18:41:00 +0200
Message-ID: <20170406164100.GA7143@salvia>
References: <20170323081156.17727-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40584 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753446AbdDFQlP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 12:41:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D24811ADC5
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:41:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DD10DA38F
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:41:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EB29DA38C
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:41:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170323081156.17727-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 23, 2017 at 09:11:56AM +0100, Florian Westphal wrote:
> This test fails with
> 'ip protocol tcp tcp dport 22' mismatches 'tcp dport 22'
> 
> ip protocol tcp tcp dport 22 is *ONLY* identical to
> 'tcp dport 22' in the ip family.
> 
> For netdev/inet/bridge, the dependency is required because
> we only want to match ipv4 packets.

This needs the C chunk to fix this, right? so I let you decide if you
want to push out this test now or make it together with the fix.

Thanks!
