From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: xtables-arp: Use getaddrinfo()
Date: Thu, 10 Nov 2016 01:35:10 +0100
Message-ID: <20161110003510.GA4924@salvia>
References: <20161107122846.GA11799@Novo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39352 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbcKJAfP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 19:35:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 888D19B7F4
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:35:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79668DA80B
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:35:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A895DA803
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:35:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161107122846.GA11799@Novo>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 07, 2016 at 05:58:46PM +0530, Shivani Bhardwaj wrote:
> Replace gethostbyname() with getaddrinfo() as getaddrinfo()
> deprecates the former and allows programs to eliminate
> IPv4-versus-IPv6 dependencies.

Applied, thanks Shivani.
