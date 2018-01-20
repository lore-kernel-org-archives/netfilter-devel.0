From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Sat, 20 Jan 2018 10:21:44 +0100
Message-ID: <20180120092144.hmw3lufspn25lgc2@salvia>
References: <20180115014532.GA13839@dimstar.local.net>
 <20180116011537.b4xm2mxlabn5tsfl@salvia>
 <20180116124143.5s6exg3467ozmobb@salvia>
 <20180116204554.GA27044@dimstar.local.net>
 <20180116215217.GA27232@dimstar.local.net>
 <20180116223930.ftuagn4vtkvd2nka@salvia>
 <20180119014815.GA4882@dimstar.local.net>
 <20180119022722.duu5l3esazkox43z@salvia>
 <20180119022757.z5ir6zcytaabqntc@salvia>
 <20180120061118.GB4210@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbeATJVs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jan 2018 04:21:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16D75DA72B
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 10:21:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 069ECDA80C
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 10:21:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A4FDDA80C
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 10:21:45 +0100 (CET)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E98604265A2F
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 10:21:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180120061118.GB4210@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 20, 2018 at 05:11:18PM +1100, Duncan Roe wrote:
> On Fri, Jan 19, 2018 at 03:27:57AM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Jan 19, 2018 at 12:48:15PM +1100, Duncan Roe wrote:
> > > On Tue, Jan 16, 2018 at 11:39:30PM +0100, Pablo Neira Ayuso wrote:
> > > > On Wed, Jan 17, 2018 at 08:52:17AM +1100, Duncan Roe wrote:
> > > > > On Wed, Jan 17, 2018 at 07:45:54AM +1100, Duncan Roe wrote:
> > > > > > On Tue, Jan 16, 2018 at 01:41:43PM +0100, Pablo Neira Ayuso wrote:
> > > > > > > On Tue, Jan 16, 2018 at 02:15:37AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > On Mon, Jan 15, 2018 at 12:45:32PM +1100, Duncan Roe WROTE:
> > > > > > > > [...]
> >
> > Another alternative is:
> >
> > # iptables-restore-translate -f your_iptables_ruleset
> >
> > Hm, this is not documented in the wiki for some reason.
> 
> Yes it is - section "Moving from iptables to nftables" under "Basic operation".
> >
> Although I now use nft (script attached), I just realised that since libvirt
> sets up iptables rules, I could demo iptables-restore-translate working on them.
> 
> > iptables-save > save.txt
> > iptables-restore-translate -f save.txt
> all looked good *except*
> > # -t mangle -A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
> Just for fun, I thought I'd see what iptables-compat did with that:
> > iptables-compat -t mangle -A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
> There was no error message and iptables-compat returned 0. But now:
> > iptables-compat -t mangle -L
> > ERROR: You're using nft features that cannot be mapped to iptables, please keep using nft.
> and:
> > nft list ruleset
> > Segmentation fault (core dumped)

This patch broke nft list ruleset:

commit bce55916b51ec1a4c23322781e3b0c698ecc9561                                  
Author: Varsha Rao <rvarsha016@gmail.com>                                        
Date:   Wed Aug 16 19:48:13 2017 +0530                                           
                                                                                 
    src: Remove xt_stmt_() functions.    

Investigating.
