From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nf_ct_helper: warn when not applying
 default helper assignment
Date: Thu, 2 Feb 2017 14:26:52 +0100
Message-ID: <20170202132652.GA10489@salvia>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
 <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com>
 <20170124012859.GA6375@salvia>
 <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm>
 <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
 <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com>
 <alpine.LSU.2.20.1701252136460.25515@cbobk.fhfr.pm>
 <20170201162704.GA3880@salvia>
 <alpine.LSU.2.20.1702012036110.4763@cbobk.fhfr.pm>
 <alpine.LSU.2.20.1702012057560.4763@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Jiri Kosina <jikos@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbdBBN1B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2017 08:27:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C7EB131CB4
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:26:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D5F9DA80C
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:26:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17410DA808
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:26:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1702012057560.4763@cbobk.fhfr.pm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 01, 2017 at 09:01:54PM +0100, Jiri Kosina wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> Commit 3bb398d925 ("netfilter: nf_ct_helper: disable automatic helper 
> assignment") is causing behavior regressions in firewalls, as traffic 
> handled by conntrack helpers is now by default not passed through even 
> though it was before due to missing CT targets (which were not necessary 
> before this commit).
> 
> The default had to be switched off due to security reasons [1] [2] and 
> therefore should stay the way it is, but let's be friendly to firewall 
> admins and issue a warning the first time we're in situation where packet 
> would be likely passed through with the old default but we're likely going 
> to drop it on the floor now.
> 
> Rewrite the code a little bit as suggested by Linus, so that we avoid 
> spaghettiing the code even more -- namely the whole decision making 
> process regarding helper selection (either automatic or not) is being 
> separated, so that the whole logic can be simplified and code (condition) 
> duplication reduced.
> 
> [1] https://cansecwest.com/csw12/conntrack-attack.pdf
> [2] https://home.regit.org/netfilter-en/secure-use-of-helpers/

Applied, thanks.
