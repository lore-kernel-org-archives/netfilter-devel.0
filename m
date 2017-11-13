From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: timeouts can be const
Date: Mon, 13 Nov 2017 13:46:57 +0100
Message-ID: <20171113124656.GA7846@salvia>
References: <20171112194201.3403-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41922 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752646AbdKMMrC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:47:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E26AE392E01
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:47:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D42B9BAC2A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:47:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171112194201.3403-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 12, 2017 at 08:42:01PM +0100, Florian Westphal wrote:
> Nowadays this is just the default template that is used when setting up
> the net namespace, so nothing writes to these locations.

Applied, thanks.
