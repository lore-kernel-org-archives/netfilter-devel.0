From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: add chain validations tests
Date: Tue, 29 Mar 2016 13:16:57 +0200
Message-ID: <20160329111657.GA13065@salvia>
References: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es>
 <20160322192019.GA7551@salvia>
 <CAOkSjBimNsBCYTK3AnHc4iFUkkjGoDU+y7Hn1j+qEfjHLPSR4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40857 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbcC2LRK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:17:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AC12C83D23
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:17:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 56276DA3A4
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:17:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2975791DC
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:17:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBimNsBCYTK3AnHc4iFUkkjGoDU+y7Hn1j+qEfjHLPSR4A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 23, 2016 at 08:44:31AM +0100, Arturo Borrero Gonzalez wrote:
> On 22 March 2016 at 20:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Mar 22, 2016 at 02:06:09PM +0100, Arturo Borrero Gonzalez wrote:
> >> Some basic test regarding chains: jumps and validations.
> >>
> >> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> >> ---
> >> NOTE: the testcases/chains/0009masquerade_jump_1 file fails, seems like a bug
> >> in the kernel validation. Needs more investigation.
> >
> > I can see this there:
> >
> >> +$NFT add chain t output {type nat hook output priority 0 \; }
> >
> > We only support masquerade from postrouting.
> >
> > static struct xt_target masquerade_tg_reg __read_mostly = {
> >         .name           = "MASQUERADE",
> >         .family         = NFPROTO_IPV4,
> >         .target         = masquerade_tg,
> >         .targetsize     = sizeof(struct nf_nat_ipv4_multi_range_compat),
> >         .table          = "nat",
> >         .hooks          = 1 << NF_INET_POST_ROUTING,
> >
> > BTW, it would be good to add more tests to exercise the chain loop
> > detection code.
> >
> > Please, fix and resubmit, thanks.
> 
> Probably mi description of the problem was poor.
> 
> The offending testcase is testing, in fact, that we can add a rule
> with a jump to a chain with a masquerade rule, thus connecting
> masquerade to a output hook:
> 
> $NFT add table t
> $NFT add chain t output {type nat hook output priority 0 \; }
> $NFT add chain t c1
> $NFT add rule t c1 masquerade
> $NFT add rule t output tcp dport vmap {1 :jump c1 }
> 
> this don't fail, and that's the problem indeed.

Right, I'm applying this so we keep this in the radar, thanks.
