From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Sun, 21 Jan 2018 00:42:54 +1100
Message-ID: <20180120134254.GA13310@smallstar.local.net>
References: <20180116124143.5s6exg3467ozmobb@salvia>
 <20180116204554.GA27044@dimstar.local.net>
 <20180116215217.GA27232@dimstar.local.net>
 <20180116223930.ftuagn4vtkvd2nka@salvia>
 <20180119014815.GA4882@dimstar.local.net>
 <20180119022722.duu5l3esazkox43z@salvia>
 <20180119022757.z5ir6zcytaabqntc@salvia>
 <20180120061118.GB4210@dimstar.local.net>
 <20180120092144.hmw3lufspn25lgc2@salvia>
 <20180120124733.p5lnv4jcqai3xehs@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [138.44.249.138] ([138.44.249.138]:56258 "HELO
        smallstar.local.net" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with SMTP id S1751125AbeAVEKF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jan 2018 23:10:05 -0500
Content-Disposition: inline
In-Reply-To: <20180120124733.p5lnv4jcqai3xehs@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 20, 2018 at 01:47:33PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Jan 20, 2018 at 10:21:44AM +0100, Pablo Neira Ayuso wrote:
> > On Sat, Jan 20, 2018 at 05:11:18PM +1100, Duncan Roe wrote:
> > > On Fri, Jan 19, 2018 at 03:27:57AM +0100, Pablo Neira Ayuso wrote:
> > > > On Fri, Jan 19, 2018 at 12:48:15PM +1100, Duncan Roe wrote:
> > > > > On Tue, Jan 16, 2018 at 11:39:30PM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Wed, Jan 17, 2018 at 08:52:17AM +1100, Duncan Roe wrote:
> > > > > > > On Wed, Jan 17, 2018 at 07:45:54AM +1100, Duncan Roe wrote:
> > > > > > > > On Tue, Jan 16, 2018 at 01:41:43PM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > On Tue, Jan 16, 2018 at 02:15:37AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > > On Mon, Jan 15, 2018 at 12:45:32PM +1100, Duncan Roe WROTE:
> > > > > > > > > > [...]
> > > >
> > > > Another alternative is:
> > > >
> > > > # iptables-restore-translate -f your_iptables_ruleset
> > > >
> > > > Hm, this is not documented in the wiki for some reason.
> > >
> > > Yes it is - section "Moving from iptables to nftables" under "Basic operation".
> > > >
> > > Although I now use nft (script attached), I just realised that since libvirt
> > > sets up iptables rules, I could demo iptables-restore-translate working on them.
> > >
> > > > iptables-save > save.txt
> > > > iptables-restore-translate -f save.txt
> > > all looked good *except*
> > > > # -t mangle -A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
> > > Just for fun, I thought I'd see what iptables-compat did with that:
> > > > iptables-compat -t mangle -A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
> > > There was no error message and iptables-compat returned 0. But now:
> > > > iptables-compat -t mangle -L
> > > > ERROR: You're using nft features that cannot be mapped to iptables, please keep using nft.
> > > and:
> > > > nft list ruleset
> > > > Segmentation fault (core dumped)
> >
> > This patch broke nft list ruleset:
> >
> > commit bce55916b51ec1a4c23322781e3b0c698ecc9561
> > Author: Varsha Rao <rvarsha016@gmail.com>
> > Date:   Wed Aug 16 19:48:13 2017 +0530
> >
> >     src: Remove xt_stmt_() functions.
>
> I have revert it and push it out.
>
> BTW, not related to this problem, the -j CHECKSUM --checksum-fill is
> something that libvirt generates or you using it there?
>
> During the last Netfilter workshop, we have had some discussions on
> this features, and people felt this is something actually not useful
> these days, so we kept it back in nftables.
>
> If there's a usecase for this, we can of course reconsider.
>
> Thanks!

-j CHECKSUM --checksum-fill is something that libvirt generates,

Cheers ... Duncan.
