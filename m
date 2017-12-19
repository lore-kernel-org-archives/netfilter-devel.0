From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix chain filter in
 nf_tables_dump_rules()
Date: Tue, 19 Dec 2017 13:09:39 +0100
Message-ID: <20171219120939.rszacmxndxeroy3y@salvia>
References: <20171219110443.3286-1-pablo@netfilter.org>
 <20171219112151.GR32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48166 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751583AbdLSMJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 07:09:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EBAD2B6FD3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 13:09:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5355DA863
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 13:09:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171219112151.GR32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:21:51PM +0100, Phil Sutter wrote:
> On Tue, Dec 19, 2017 at 12:04:43PM +0100, Pablo Neira Ayuso wrote:
> > ctx->chain may be null now that we have very large object names,
> > so we cannot check for ctx->chain[0] here.
> > 
> > Fixes: e46abbcc05aa ("netfilter: nf_tables: Allow table names of up to 255 chars")
> 
> This really fixes:
> 
> b7263e071aba7 ("netfilter: nf_tables: Allow chain name of up to 255 chars")

Will fix it here.

> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Apart from that:
> 
> Acked-by: Phil Sutter <phil@nwl.cc>

Thanks for reviewing!
