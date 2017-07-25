From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/6] tests/monitor: Ignore newgen messages in output
Date: Tue, 25 Jul 2017 17:57:58 +0200
Message-ID: <20170725155758.GB591@salvia>
References: <20170725145629.20974-1-phil@nwl.cc>
 <20170725145629.20974-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38334 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbdGYP6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 11:58:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DBB4517D420
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:57:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFDF7DA46D
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:57:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6EA2DA812
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:57:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725145629.20974-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:56:24PM +0200, Phil Sutter wrote:
> Predicting the new ID value is not feasible and neither is implementing
> support for regular expressions when matching monitor output, so simply
> ignore them.
> 
> Also use diff option '-w' instead of '-Z' to ignore all whitespace, not
> just at EOL.

Applied, thanks Phil.
