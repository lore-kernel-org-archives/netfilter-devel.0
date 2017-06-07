From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] scanner: add files in include dirs in alphabetical
 order.
Date: Wed, 7 Jun 2017 12:09:07 +0200
Message-ID: <20170607100907.GA4875@salvia>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbdFGKJQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:09:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D701617D42C
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:09:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3C5D102189
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:09:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC0F7FF6CC
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:09:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170607083559.10051-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 11:35:57AM +0300, Ismo Puustinen wrote:
> This means that if you have a directory structure like this
> 
>     /foo
>     /foo/02_rules.nft
>     /foo/01_rules.nft
> 
> where *.nft files in directory /foo are nft scripts, then an include
> statement in another nft script like this
> 
>     include "/foo/"
> 
> guarantees that "01_rules.nft" is loaded before "02_rules.nft".

OK, that was fast.

Applied with comestic coding style changes, thanks Ismo!

Do not hesitate to follow up in case of any fallout from this update.
