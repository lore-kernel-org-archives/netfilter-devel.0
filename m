From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore/ip6tables-restore: add --version/-V
 argument
Date: Sun, 9 Apr 2017 00:04:18 +0200
Message-ID: <20170408220418.GA8524@salvia>
References: <1491255160.5423.16.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Dan Williams <dcbw@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37536 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdDHWEZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 18:04:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C7E924939
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:04:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3039DA807
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:04:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4330DDA729
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:04:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491255160.5423.16.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 03, 2017 at 04:32:40PM -0500, Dan Williams wrote:
> Prints program version just like iptables/ip6tables.

Applied, thanks.

You sent us a chunk for the manpage?
