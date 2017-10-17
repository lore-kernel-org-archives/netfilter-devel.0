From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 14:11:45 +0200
Message-ID: <20171017121145.GA18793@salvia>
References: <20171017110507.GA16060@salvia>
 <20171017112218.14539-1-phil@nwl.cc>
 <20171017113150.GA8818@salvia>
 <20171017120222.GW32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755766AbdJQMLt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:11:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75BFEDA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:11:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 666C6DA861
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:11:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171017120222.GW32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 02:02:22PM +0200, Phil Sutter wrote:
> Hi,
> 
> Actually, I don't quite get the suggested change:
> 
> On Tue, Oct 17, 2017 at 01:31:50PM +0200, Pablo Neira Ayuso wrote:
> > @@ -308,3 +307,7 @@ global:
> >  
> >  local: *;
> >  };
> > +
> > +LIBNFTNL_6 {
> > +  nftnl_expr_fprintf;
> > +} LIBMNL_5;
> 
> Why LIBMNL_5? Shouldn't this be LIBNFTNL_5?

Oh right :-)

Neurons rollerskating here, sorry.
