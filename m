From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xtables-translate: Support setting standard chain policy
Date: Tue, 29 Nov 2016 23:00:59 +0100
Message-ID: <20161129220059.GB29033@salvia>
References: <20161125170646.8620-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756789AbcK2WBE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 17:01:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3D34174D1E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1CE6DA385
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF50DDA385
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161125170646.8620-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 25, 2016 at 06:06:46PM +0100, Phil Sutter wrote:
> Looks like this bit was simply forgotten when implementing
> xlate_chain_set() as everything needed was there to just print the
> desired policy along with the chain definition.

Also applied, thanks.
