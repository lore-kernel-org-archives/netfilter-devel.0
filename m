From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore/ip6tables-restore: add --version/-V
 argument
Date: Mon, 10 Apr 2017 13:53:56 +0200
Message-ID: <20170410115356.GC2155@salvia>
References: <1491255160.5423.16.camel@redhat.com>
 <20170408220418.GA8524@salvia>
 <1491707416.27302.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Dan Williams <dcbw@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbdDJLyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 07:54:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 034FB52308
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 13:54:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7188BAAA8
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 13:54:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2763CBAAA1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 13:54:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491707416.27302.1.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 08, 2017 at 10:10:16PM -0500, Dan Williams wrote:
> On Sun, 2017-04-09 at 00:04 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Apr 03, 2017 at 04:32:40PM -0500, Dan Williams wrote:
> > > Prints program version just like iptables/ip6tables.
> > 
> > Applied, thanks.
> > 
> > You sent us a chunk for the manpage?
> 
> I did not, but I will.  I noticed there wasn't one for the iptables-
> restore --wait changes either, was Lorenzo going to send one?  Mine
> would probably conflict with that.

Right. I forgot to ask for that chunk to Lorenzo.

If you can help us on adding these missing chunks to the manpage, I
would really appreciate this. Thanks!
