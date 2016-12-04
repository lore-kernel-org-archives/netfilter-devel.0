From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] config: drop old/obsolete/deprecated
 conntrackd.conf config options
Date: Sun, 4 Dec 2016 21:34:37 +0100
Message-ID: <20161204203437.GB12811@salvia>
References: <148067787905.31366.6882929818938291343.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDUeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:34:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4A03A7E22
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:34:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6B0BDA729
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:34:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8038DA729
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:34:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148067787905.31366.6882929818938291343.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 02, 2016 at 12:24:39PM +0100, Arturo Borrero Gonzalez wrote:
> There has been a long adaptation time already, with several conntrack-tools
> releases in the meantime.
> 
> Users migrating from an old conntrackd to a current one are required
> to update their config file.

Also applied, thanks for sorting out this Arturo.
