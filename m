From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH lnfct 2/2] conntrack: revert getobjopt_is_nat condition
Date: Tue, 28 Feb 2017 20:44:53 +0900
Message-ID: <20170228114453.GA22524@gmail.com>
References: <20170228045359.GA21582@gmail.com>
 <20170228050041.GC21582@gmail.com>
 <20170228104725.GB1517@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36572 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdB1LwS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:52:18 -0500
Received: by mail-pg0-f68.google.com with SMTP id 25so1298484pgy.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 03:52:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170228104725.GB1517@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi, Pablo

On Tue, Feb 28, 2017 at 11:47:25AM +0100, Pablo Neira Ayuso wrote:
> > diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
> > index fb43d6c..1581480 100644
> > --- a/src/conntrack/objopt.c
> > +++ b/src/conntrack/objopt.c
> > @@ -144,10 +144,8 @@ int __setobjopt(struct nf_conntrack *ct, unsigned int option)
> >  
> >  static int getobjopt_is_snat(const struct nf_conntrack *ct)
> >  {
> > -	if (!(test_bit(ATTR_STATUS, ct->head.set)))
> > -		return 0;
> > -
> > -	if (!(ct->status & IPS_SRC_NAT_DONE))
> > +	if (test_bit(ATTR_STATUS, ct->head.set) &&
> > +	    !(ct->status & IPS_SRC_NAT_DONE))
> 
> However, if ATTR_STATUS is not set, we keep checking ahead. What are
> you trying to fix?

It was:

-       return ((test_bit(ATTR_STATUS, ct->head.set) ?
-               ct->status & IPS_SRC_NAT_DONE : 1) &&
-               ct->repl.dst.v4 !=
-               ct->head.orig.src.v4);

I thought it keeps checking even ATTR_STATUS is not set.
But it's ok not to apply, returning false in case of
ATTR_STATUS is not set.

Thanks,
