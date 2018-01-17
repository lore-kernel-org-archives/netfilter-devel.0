From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] libnftables: Implement JSON output support
Date: Wed, 17 Jan 2018 13:50:26 +0100
Message-ID: <20180117125026.dnxtfybrcgoio72i@salvia>
References: <20180117115140.10751-1-phil@nwl.cc>
 <20180117124406.lil7vr2ypmpkhp5d@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752749AbeAQMua (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 07:50:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 441EE3066A8
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 13:50:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 285CFDA382
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 13:50:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180117124406.lil7vr2ypmpkhp5d@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 17, 2018 at 01:44:06PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 17, 2018 at 12:51:40PM +0100, Phil Sutter wrote:
[...]
> 
> > * There is quite some code-duplication involved given that this
> >   introduces an alternative function for almost any function in the
> >   affected code path.
> 
> You mean, a new callback for each expr/datatype? We should not expose
> bitwise/byteorder and such, it's too low level.

I'd rather see you map the abstract syntax tree that is represented
through parser_bison.y to your json representation. I think this patch
is mapping the tree that we obtain after the evaluation phase, which
comes with low level expressions such as bitwise/byteorder.
