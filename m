From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_queue: get rid of dependency on
 IP6_NF_IPTABLES
Date: Tue, 13 Sep 2016 11:10:41 +0200
Message-ID: <20160913091041.GA4034@salvia>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <20160912175030.GA31089@salvia>
 <CAML_gOeP3zvNxptZP2vCvu2KsyOri7Okpapv7zKFg_gFPeWGWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756273AbcIMJKt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 05:10:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FDB71E0DC9
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:10:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DBCE1150D2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:10:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B77D5100A7C
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:10:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOeP3zvNxptZP2vCvu2KsyOri7Okpapv7zKFg_gFPeWGWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 13, 2016 at 01:45:38PM +0800, Liping Zhang wrote:
> 2016-09-13 1:50 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > We have nft_queue support for bridge now, but nfqueue_hash() takes a
> > pkt->pf parameter expecting NFPROTO_IPV4 or NFPROTO_IPV6.
> >
> > So nft_queue hashing with bridge is currently broken.
> 
> Yes, I will send another patch to do this :)

Sure, thanks.
