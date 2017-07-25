From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/6] tests/monitor: Simplify testcases
Date: Tue, 25 Jul 2017 18:12:58 +0200
Message-ID: <20170725161258.GA3630@salvia>
References: <20170725145629.20974-1-phil@nwl.cc>
 <20170725145629.20974-4-phil@nwl.cc>
 <20170725160228.GD591@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdGYQNP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 12:13:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C453F17D421
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:13:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8AC7A0AD4
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:13:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9026CE17F
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:12:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725160228.GD591@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 06:02:28PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 25, 2017 at 04:56:26PM +0200, Phil Sutter wrote:
> > By introducing 'O -' indicating that output should be identical as
> > input, testcases can be simplified quite a bit.
> 
> I like this update.

But I can't take it, git am complains. Please, rebase and resubmit,
thanks!
