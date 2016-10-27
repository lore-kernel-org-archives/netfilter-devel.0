From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: avoid excess memory allocation
Date: Thu, 27 Oct 2016 18:36:54 +0200
Message-ID: <20161027163654.GA11474@salvia>
References: <1477518377-26894-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934875AbcJ0QhD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:37:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC7076EAC2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBDC6DA84B
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4CC7DA81C
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:36:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477518377-26894-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 26, 2016 at 11:46:17PM +0200, Florian Westphal wrote:
> This is now a fixed-size extension, so we don't need to pass a variable
> alloc size.  This (harmless) error results in allocating 32 instead of
> the needed 16 bytes for this extension as the size gets passed twice.

Applied, thanks Florian.
