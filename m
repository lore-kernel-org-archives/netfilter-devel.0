From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 nf-next] netfilter: connlimit: split xt_connlimit into
 front/backend
Date: Fri, 8 Dec 2017 07:40:50 +0100
Message-ID: <20171208064050.GF24449@breakpoint.cc>
References: <20171206124112.21239-1-fw@strlen.de>
 <CAG1aQh+TyBTXsCO0Whtfs12=tpnc8n4kBkVDMGcu0wWbfnt31g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Yi-Hung Wei <yihung.wei@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49634 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751109AbdLHGmP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 01:42:15 -0500
Content-Disposition: inline
In-Reply-To: <CAG1aQh+TyBTXsCO0Whtfs12=tpnc8n4kBkVDMGcu0wWbfnt31g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yi-Hung Wei <yihung.wei@gmail.com> wrote:
> On Wed, Dec 6, 2017 at 4:41 AM, Florian Westphal <fw@strlen.de> wrote:
> > +static int __init nf_conncount_modinit(void)
> > +{
> > +       int ret, i;
> > +
> > +       BUILD_BUG_ON(CONNCOUNT_LOCK_SLOTS > CONNCOUNT_SLOTS);
> > +       BUILD_BUG_ON((CONNCOUNT_SLOTS % CONNCOUNT_LOCK_SLOTS) != 0);
> > +
> > +       return ret;
> I test it with iptables -m connlimit, and nf_conncount may fail to
> load sometimes.
> 
> It turns out that it is because ret is not used in this function.
> Shall we get rid of ret, and return 0 here?

Yes.
