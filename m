From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] tests: py: Use stateless option on tests
Date: Wed, 18 Jan 2017 19:03:48 +0100
Message-ID: <20170118180348.GA1846@salvia>
References: <20170117154454.GA31287@lennorien.com>
 <20170118180253.GB24632@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752422AbdARSEG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 13:04:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58BE113C0C3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 19:03:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49E74A7DB1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 19:03:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22CE6A7E7D
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 19:03:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170118180253.GB24632@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 18, 2017 at 07:02:53PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 17, 2017 at 01:44:54PM -0200, Elise Lennion wrote:
> > To don't trigger false errors because of unrelated traffic on the
> > tested machine.
> > 
> > Tests, which have rules with counter and 'ok' result, are updated to
> > avoid new Warnings.
> 
> Also applied, thanks.
> 
> > diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
> > index aea57c3..41d5d3b 100644
> > --- a/tests/py/ip/flowtable.t
> > +++ b/tests/py/ip/flowtable.t
> > @@ -2,4 +2,4 @@
> >  
> >  *ip;test-ip;input
> >  
> > -flow table xyz { ip saddr timeout 30s counter packets 0 bytes 0};ok
> > +flow table xyz { ip saddr timeout 30s counter};ok
> 
> This reminds something: From flow tables, counter, quota, and limit
> must always be printed in their stateless version.
> 
> A simple way to fix this is to turn stateless_output into unsigned
> int, so you can stateless_output++ before printing the statement from
> flow_stmt_print().

As well stateless_output-- after printing it, to restore the counter
to its previous state.
