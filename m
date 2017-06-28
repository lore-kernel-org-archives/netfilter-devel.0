From: Florian Westphal <fw@strlen.de>
Subject: Re: crash on >= 4.9.0 kernel seems nf related
Date: Wed, 28 Jun 2017 12:23:23 +0200
Message-ID: <20170628102323.GO29636@breakpoint.cc>
References: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
 <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com>
 <20170516082128.GB16290@breakpoint.cc>
 <CAJO99T=4LQgUngzoSvpVED_+hxYT1bOtHzUXjBu-Jq4d4+7SuA@mail.gmail.com>
 <CAJO99T=5RPz691h9kAnSsC4fy_54o3qWU_2o-4FhHrxp5af7MQ@mail.gmail.com>
 <20170626131632.GI29636@breakpoint.cc>
 <CAJO99TnXE_5d4+1cEhRK570n6jOKntYn85c9rcMP8T0KuWdDHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33518 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751500AbdF1KY0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:24:26 -0400
Content-Disposition: inline
In-Reply-To: <CAJO99TnXE_5d4+1cEhRK570n6jOKntYn85c9rcMP8T0KuWdDHQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bjørnar Ness <bjornar.ness@gmail.com> wrote:
> 2017-06-26 15:16 GMT+02:00 Florian Westphal <fw@strlen.de>:
> > perf top might help pinpoint the source.

Leaving this here, this info would help.

> > What kernel is this, exactly?
> >
> > 4.10 (and 4.9.14 and later) has a change to make gc worker use less
> > cycles.
> 
> We see the behavior in 4.11.0 and 4.12.0-rc6 as well
> 
> > But I don't see the NAT connection.
> 
> Not sure what you mean here. We do not eed to have rules in the
> postrouting chain for it
> to tear down the server.

I mean that presence of NAT postrouting hook has, to the best of my
knowledge, no effect on the ct gc worker.

But perhaps this isn't the gc worker after all, perf top would help.

The only effect that the postrouting hook has is bringing rhashtables
'rhlist' interface into the mix, as we use that for the nat bysource
table.

> Monitoring conntrack entries also shows me
> this is stable around 120k

What does that mean?
Do you mean you run into problems after 120k entries?
