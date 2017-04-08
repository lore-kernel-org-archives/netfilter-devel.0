From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink: Add API support for passing bound file
 descriptor
Date: Sun, 9 Apr 2017 00:21:13 +0200
Message-ID: <20170408222113.GA9190@salvia>
References: <1491259467-21230-1-git-send-email-chiaweic@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, npendhar@codeaurora.org
To: Skylar Chang <chiaweic@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbdDHWVT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 18:21:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00D292493A
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:21:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7119DA725
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:21:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6DA0DA729
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:21:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491259467-21230-1-git-send-email-chiaweic@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 03, 2017 at 03:44:27PM -0700, Skylar Chang wrote:
> Add API support to accept pre-bound file descriptor from a
> privileged process for creating a handle. Also clean-up
> the handle without close the passing file descriptor. This
> paves the path for privilege separation.

I can take this patch... But as things are going, I would very much
push for libnfnetlink deprecation, so this API may be soon deprecated
which would be weird as it would be just something new...

It would be much better if you use libmnl for this. There's a new API
in libnetfilter_conntrack that mixes well with it.

Let me know.
