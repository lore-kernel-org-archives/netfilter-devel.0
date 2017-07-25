From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: netlink: Subscribe nft monitor and nft monitor
 trace to respective groups.
Date: Tue, 25 Jul 2017 18:06:42 +0200
Message-ID: <20170725160642.GA3466@salvia>
References: <5976d630.c553650a.2e876.31e8@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdGYQGy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 12:06:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5DEE17D423
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:06:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA1B8DA7F4
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:06:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CED1DD1CAB
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:06:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5976d630.c553650a.2e876.31e8@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Varsha,

On Tue, Jul 25, 2017 at 10:55:00AM +0530, Varsha Rao wrote:
> Subscribe nft monitor only to NFNLGRP_NFTABLES and nft monitor trace
> only to NFNLGRP_NFTRACE. In netlink_monitor() depending on the command
> call setsockopt() once.

Could you enhance this patch in a way that things work like the
following:

#1 nft monitor

This prints all events, both nftrace and nftables.

#2 nft monitor trace

This prints only trace events.

#3 nft monitor ruleset

This prints only ruleset events.

for #3, you have to extend the bison parser I think, it should be not
too complicated.

>+       if (monhandler->monitor_flags == (unsigned int)-1)

I think there must be a way to make this more readable, as well as
make it work in the way I propose above.

Thanks!
