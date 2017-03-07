From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fix 'state'
 translation to nft
Date: Tue, 7 Mar 2017 20:31:58 +0100
Message-ID: <20170307193158.GA19663@salvia>
References: <20170307153507.14640-1-phil@nwl.cc>
 <20170307161729.GA2233@salvia>
 <20170307162055.GA4753@salvia>
 <20170307165409.GB19869@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbdCGUKk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 15:10:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 24CFB1C4FF3
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 20:32:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13498DA818
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 20:32:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6829DA846
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 20:31:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170307165409.GB19869@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 07, 2017 at 05:54:09PM +0100, Phil Sutter wrote:
> On Tue, Mar 07, 2017 at 05:20:55PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Mar 07, 2017 at 05:17:29PM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Mar 07, 2017 at 04:35:07PM +0100, Phil Sutter wrote:
> > > > While translating a conntrack state match in old syntax, matches are
> > > > looked up by name, only. This returned the revision 0 entry since
> > > > matches are registered in reverse order of appearance in the array
> > > > passed to xtables_register_matches(). The problem is that revision 0
> > > > doesn't define an xlate callback.
> > > > 
> > > > Fix this by reordering the matches in conntrack_mt_reg so that the
> > > > highest revision one is found first.
> > > 
> > > Applied, thanks Phil.
> > 
> > Wait.
> > 
> > Do you mean this case?
> > 
> > # iptables-translate -I INPUT -m state --state NEW
> > nft insert rule ip filter INPUT ct state new  counter
> > 
> > Hm, this works here.
> 
> Yes, that's it. And it working for you just emphasizes something's fishy
> here. I just reverted my patch, then it's like this:
> 
> | $ ./configure --prefix=$PWD/install && make && make install
> | [...]
> | $ ./install/sbin/iptables-translate -I INPUT -m state --state NEW
> | nft # -I INPUT -m state --state NEW
> 
> Using 'strace -eopen' I see that libxt_state.so from the install
> destination is used, not the system one.
> 
> Also, I did this change for debugging:
> 
> | --- a/iptables/xtables-translate.c
> | +++ b/iptables/xtables-translate.c
> | @@ -100,6 +100,10 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
> |                         .escape_quotes  = !cs->restore,
> |                 };
> |  
> | +               printf("found match %s, rev %u, xlate is %p\n",
> | +                               matchp->match->name,
> | +                               matchp->match->revision,
> | +                               matchp->match->xlate);
> |                 if (!matchp->match->xlate)
> |                         return 0;
> 
> The output is then:
> 
> | $ ./install/sbin/iptables-translate -I INPUT -m state --state NEW
> | nft found match state, rev 0, xlate is (nil)
> | # -I INPUT -m state --state NEW
> 
> Am I missing something??

Via nft_compatible_revision() I'm getting revision 3. Are you using
latest kernel from git?
