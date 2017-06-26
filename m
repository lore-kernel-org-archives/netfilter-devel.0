From: Florian Westphal <fw@strlen.de>
Subject: Re: crash on >= 4.9.0 kernel seems nf related
Date: Mon, 26 Jun 2017 15:16:32 +0200
Message-ID: <20170626131632.GI29636@breakpoint.cc>
References: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
 <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com>
 <20170516082128.GB16290@breakpoint.cc>
 <CAJO99T=4LQgUngzoSvpVED_+hxYT1bOtHzUXjBu-Jq4d4+7SuA@mail.gmail.com>
 <CAJO99T=5RPz691h9kAnSsC4fy_54o3qWU_2o-4FhHrxp5af7MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49800 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751410AbdFZNRc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 09:17:32 -0400
Content-Disposition: inline
In-Reply-To: <CAJO99T=5RPz691h9kAnSsC4fy_54o3qWU_2o-4FhHrxp5af7MQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bjørnar Ness <bjornar.ness@gmail.com> wrote:
> When trying to narrow down the problem, I removed the NAT rules, and
> in particular
> the
>
> chain postrouting {
>   type nat hook postrouting priority 100
> }
>
> And the problem disappears. Commenting in the above block again,
> causes the following to happen:
>
> kworker/0:0 starts to use more and more cpu, and in less than a minute
> renders the
> machine useless. If network cable is unplugged, it takes aroung 30
> seconds for the machine to get into a useful state again.

The kworker is most likely the conntrack gc worker, but the gc worker is nat
agnostic, so I don't see how this makes a difference wrt. nat
postrouting hook presence.

perf top might help pinpoint the source.

What kernel is this, exactly?

4.10 (and 4.9.14 and later) has a change to make gc worker use less
cycles.

But I don't see the NAT connection.

