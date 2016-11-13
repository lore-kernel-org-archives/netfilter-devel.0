From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove unused netns_ct
 member
Date: Sun, 13 Nov 2016 22:22:22 +0100
Message-ID: <20161113212222.GA17212@salvia>
References: <1478783821-15979-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965086AbcKMVW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Nov 2016 16:22:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E387C9B7F4
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 22:22:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7A94DA807
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 22:22:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A32ADA803
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 22:22:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478783821-15979-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 10, 2016 at 02:17:01PM +0100, Florian Westphal wrote:
> since 23014011ba420 ('netfilter: conntrack: support a fixed size of 128 distinct labels')
> this isn't needed anymore.

Applied, thanks.
