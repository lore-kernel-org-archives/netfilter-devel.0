From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] nftables 0.8.1 release
Date: Tue, 16 Jan 2018 15:53:30 +0100
Message-ID: <20180116145330.mpidpmwk6j7xtnyc@salvia>
References: <alpine.LSU.2.20.1801161547001.14457@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbeAPOxe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 09:53:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6716D19D8CF
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 15:53:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58484DA84F
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 15:53:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1801161547001.14457@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 16, 2018 at 03:48:24PM +0100, Jan Engelhardt wrote:
> 
> >        nftables 0.8.1
> >
> >This release contains mostly incremental fixes and documentation 
> >updates, such as fixing up ./configure --with-mini-gmp for embedded 
> >setups that don't have libgmp.
> 
> Why is this now installing a libnftables.pc file when there is no 
> library or headers to go with it? (Remember that libnftables.la is 
> listed for "noinst_LTLIBRARIES".)

That sounds like a leftover when we were aiming to roll back/not to expose
libnftables yet in this release.
