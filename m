From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add a configure flag to link libc statically
Date: Mon, 16 Jan 2017 13:57:59 +0100
Message-ID: <20170116125759.GA25857@salvia>
References: <20161230054426.GA9694@juliacomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Keno Fischer <keno@juliacomputing.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751043AbdAPM6K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 07:58:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 472DA1EC2C0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 13:58:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 385D5A7BEA
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 13:58:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC5FF470
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 13:58:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161230054426.GA9694@juliacomputing.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2016 at 12:44:26AM -0500, Keno Fischer wrote:
> The primary concern here is probably that iptables uses functions
> that in glibc still require the dynamic library at runtime.

I think that explains this:

libxt_owner.c:416: warning: Using 'getgrgid' in statically linked
applications requires at runtime the shared libraries from the glibc
version used for linking

> However, for my usage of iptables, I have never actually run into
> this situation, and even if I did, I'd rather switch libcs (though I
> may be in the minority there). Nevertheless, I think it would be
> useful to have this option available for those wanting a statically
> linked iptables.

I'm trying to understand why you need this. Thanks.
