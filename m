From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: make the daemon run in
 RT mode by default
Date: Tue, 6 Jun 2017 13:10:40 +0200
Message-ID: <20170606111040.GA1839@salvia>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
 <149674671245.18546.17167682826049346258.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58402 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdFFLLK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 07:11:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2007E210590
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:11:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E284A114D82
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:10:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 562131150D3
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:10:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149674671245.18546.17167682826049346258.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Tue, Jun 06, 2017 at 12:58:32PM +0200, Arturo Borrero Gonzalez wrote:
> In order to prevent netlink buffer overrun, conntrackd is recommended to run
> at max priority.
> Make conntrackd to use a RT (SHED_RR) scheduler by default at max priority.
> This is common among other HA daemons. For example corosync uses SCHED_RR
> by default.
> This change should help ease the configuration of conntrackd.
> 
> Note that a sched priority that high makes the nice value useless, so deprecate
> both options now.
> 
> The code is moved to the init() routine. In case of error setting the
> scheduler, the system default will be used. Report a message to the user
> and continue working.

I think we should provide a good default if someone doesn't specify
anything. So defaulting to RT is fine to me so we converge to what
other HA software is doing.

But I think we should keep the Nice and Scheduler clauses. Just in
case anyone wants to do this fine grain tunning.

So my proposal is:

1) Remove them from the examples configuration files.
2) Keep these toggles documented in manpage.
3) Provide this default if someone doesn't specify anything.

So the idea is that we provide good defaults.

BTW, an option I would really deprecate is the Checksum, a lot of
experimentation was going on at the time I added this (more than 10
years ago), this should really go away since I don't see a usecase for
this.

Thanks!
