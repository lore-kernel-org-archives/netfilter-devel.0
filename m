From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: deprecate unix backlog
 configuration
Date: Tue, 6 Jun 2017 13:11:53 +0200
Message-ID: <20170606111153.GB1839@salvia>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
 <149674672410.18546.18108815853544215114.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59084 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdFFLMC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 07:12:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18A8A2E7844
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:11:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0604D10218B
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:11:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E79910218F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:11:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149674672410.18546.18108815853544215114.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:58:44PM +0200, Arturo Borrero Gonzalez wrote:
> This configuration option doesn't add any value to users.
> Use the magic value of 100 (i.e, the socket will keep 100 pending connections),
> which I think is fair enough for what conntrackd can do in the unix socket.

I don't think conntrackd will ever get more than 100 connection that
are pending to be accepted.

So I'm fine with this 4/4 patch.
