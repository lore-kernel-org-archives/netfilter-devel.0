From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] iptables: libiptc: Use
 list_{next/prev}_entry instead of list_entry
Date: Fri, 7 Apr 2017 17:55:16 +0200
Message-ID: <20170407155516.GA6062@salvia>
References: <20170329061219.GA6036@singhal-Inspiron-5558>
 <20170407153437.GD1466@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: simran singhal <singhalsimran0@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754860AbdDGPzW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 11:55:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35ADF1373A0
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:55:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2734FDA862
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:55:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C138DA86B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:55:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170407153437.GD1466@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 07, 2017 at 05:34:37PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Mar 29, 2017 at 11:42:19AM +0530, simran singhal wrote:
> > This patch replace list_entry with list_{next/prev}_entry as it makes
> > the code more clear to read.
> 
> Applied, thanks.
> 
> I think you can send a similar patch for libnftnl.

Actually I had to keep it back. This doesn't even compile, please test
your patches.
