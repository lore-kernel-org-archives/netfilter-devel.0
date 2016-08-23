From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 iptables] iptables-restore: add missing arguments to
 usage message
Date: Tue, 23 Aug 2016 17:54:53 +0200
Message-ID: <20160823155453.GA17182@salvia>
References: <6deca21e-1daf-269a-da51-4673f911d58a@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Brian Haley <brian.haley@hpe.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754250AbcHWPy6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 11:54:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D06028E4D8
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:54:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C12DD9663F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:54:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE9D89663F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:54:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <6deca21e-1daf-269a-da51-4673f911d58a@hpe.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 23, 2016 at 10:14:47AM -0400, Brian Haley wrote:
> 
> iptables-restore was missing -n, -T and -M from the
> usage message, added them to match the man page.
> Cleaned-up other *restore files as well.

Applied, thanks.
