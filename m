From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] monitor: add debug messages
Date: Mon, 17 Jul 2017 17:26:05 +0200
Message-ID: <20170717152605.GA27373@salvia>
References: <149985898964.3446.4650892786570168840.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdGQP0N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:26:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78564249C2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:26:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C3811B357E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:26:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86F401B32C6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:25:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149985898964.3446.4650892786570168840.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 01:29:49PM +0200, Arturo Borrero Gonzalez wrote:
> Add some debug messages in the monitor/trace code paths to ease development
> and debugging in case of errors.
> 
> After this patch, running 'nft monitor --debug=mnl,netlink' is more verbose.

Applied, thanks Arturo.
