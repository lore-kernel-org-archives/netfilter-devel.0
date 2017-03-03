From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipv6: Preserve link scope traffic original oif
Date: Fri, 3 Mar 2017 12:39:18 +0100
Message-ID: <20170303113918.GA13435@salvia>
References: <1488376043-31976-1-git-send-email-alin.nastac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38200 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbdCCOoh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 09:44:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 152B91A2094
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 12:39:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 051C5DA86D
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 12:39:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF2BBDA80C
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 12:39:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1488376043-31976-1-git-send-email-alin.nastac@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 02:47:23PM +0100, Alin Nastac wrote:
> Link-local and multicast packets must keep their original oif after
> ip6_route_me_harder is called.

Out of curiosity, how does the setup you use look like to trigger this
problem?
