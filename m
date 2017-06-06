From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 1/4] conntrackd: evaluate configuration
 earlier
Date: Tue, 6 Jun 2017 18:11:03 +0200
Message-ID: <20170606161103.GA15654@salvia>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdFFQLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 12:11:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F848209911
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:11:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3363F102197
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:11:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40877102189
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:11:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:58:27PM +0200, Arturo Borrero Gonzalez wrote:
> Run the evaluation step sooner in the conntrackd startup routine.
> Don't close log or unlink lockfile at this stage.

Applied, thanks Arturo!
