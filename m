From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 1/2] scanner: add support for include directories
Date: Tue, 6 Jun 2017 17:58:24 +0200
Message-ID: <20170606155824.GA12447@salvia>
References: <20170606115010.26437-1-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdFFP62 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 11:58:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 416CA1F4B77
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:58:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FB6BA5B9
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:58:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24842FF6FE
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:58:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170606115010.26437-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 02:50:09PM +0300, Ismo Puustinen wrote:
> If a string after "include" keyword points to a directory instead of a
> file, consider the directory to contain only nft rule files and try to
> load them all. This helps with a use case where services drop their own
> firewall configuration files into a directory and nft needs to include
> those without knowing the exact file names.
> 
> File loading order from the include directory is not specified, so the
> files inside an include directory should not depend on each other.
> 
> Fixes(Bug 1154 - Allow include statement to operate on directories and/or wildcards).

Applied, thanks Ismo.

BTW, it would be great if you can send us a patch for the nft(8)
manpage too to document this new feature.

I can also create an account for your at wiki.nftables.org, in case
you want to add there more examples. There are people even slightly
describing their usecase and the way they are solving it. These
patterns will be good for people that are looking into reusing good
ideas when using nftables.
