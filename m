From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] iptables: libiptc: Use
 list_{next/prev}_entry instead of list_entry
Date: Fri, 7 Apr 2017 17:34:37 +0200
Message-ID: <20170407153437.GD1466@salvia>
References: <20170329061219.GA6036@singhal-Inspiron-5558>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: simran singhal <singhalsimran0@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54288 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932178AbdDGPen (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 11:34:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91A811324CC
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:34:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F1A3DA39B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:34:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AB58DA878
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:34:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170329061219.GA6036@singhal-Inspiron-5558>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 11:42:19AM +0530, simran singhal wrote:
> This patch replace list_entry with list_{next/prev}_entry as it makes
> the code more clear to read.

Applied, thanks.

I think you can send a similar patch for libnftnl.
