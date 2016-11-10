From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_mangle: Use getaddrinfo()
Date: Thu, 10 Nov 2016 01:35:19 +0100
Message-ID: <20161110003519.GB4924@salvia>
References: <20161107124517.GA15462@Novo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbcKJAf2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 19:35:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B25A39B7F3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:35:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A412CDA808
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:35:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6F25DA7F6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:35:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161107124517.GA15462@Novo>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 07, 2016 at 06:15:17PM +0530, Shivani Bhardwaj wrote:
> Replace gethostbyname() with getaddrinfo() as getaddrinfo()
> deprecates the former and allows programs to eliminate
> IPv4-versus-IPv6 dependencies.

Also applied.
