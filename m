Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AA5C43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 07:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 004A020873
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 07:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEBHpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 03:45:02 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44094 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbfEBHpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 03:45:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hM6Op-0002HO-9B; Thu, 02 May 2019 09:44:59 +0200
Date:   Thu, 2 May 2019 09:44:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?iso-8859-15?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: Port triggering
Message-ID: <20190502074459.pdpa52kpwnhag453@breakpoint.cc>
References: <CAFs+hh5aHv_Xy2H2g9Bgsa-BYNY-uvE442Ws37vYtF484nZanQ@mail.gmail.com>
 <20180309120324.GB19924@breakpoint.cc>
 <CAFs+hh42HuoQh4Js7yyopVqofD-6YXkOVvrx=XjYm43igaaRLg@mail.gmail.com>
 <20180312112547.GA8844@breakpoint.cc>
 <CAFs+hh61B0+qx3uyr2TwKWCNKqPn5YgN33RjmOMafTESYsmyjQ@mail.gmail.com>
 <20180312155357.GC8844@breakpoint.cc>
 <CAFs+hh79dGTpW8OvUuGZ==YqVFXKs1q=NLE7oMnLjqJW5ZUHww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh79dGTpW8OvUuGZ==YqVFXKs1q=NLE7oMnLjqJW5ZUHww@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stéphane Veyret <sveyret@gmail.com> wrote:
> Le lun. 12 mars 2018 à 16:53, Florian Westphal <fw@strlen.de> a écrit :
> > > > Something like:
> > > >
> > > > chain postrouting {
> > > >         type filter hook postrouting priority 0;
> > > >         # tell kernel to install an expectation
> > > >         # arriving on udp ports 6970-7170
> > > >         # expectation will follow whatever NAT transformation
> > > >         # is active on master connection
> > > >         # expectation is removed after 5 minutes
> > > >         # (we could of course also allow to install an expectation
> > > >         # for 'foreign' addresses as well but I don't think its needed
> > > >         # yet
> > > >         ip dport 554 ct expectation set udp dport 6970-7170 timeout 5m
> > > > }
> > >
> > > It may be what I'm looking for. But I couldn't find any documentation
> > > about this “ct expectation” command. Or do you mean I should create a
> > > conntrack helper module for that?
> >
> > Right, this doesn't exist yet.
> >
> > I think we (you) should consider to extend net/netfilter/nft_ct.c, to
> > support a new NFT_CT_EXPECT attribute in nft_ct_set_eval() function.
> >
> > This would then install a new expectation based on what userspace told
> > us.
> >
> > You can look at
> > net/netfilter/nf_conntrack_ftp.c
> > and search for nf_ct_expect_alloc() to see where the ftp helper installs
> > the expectation.
> >
> > The main difference would be that with nft_ct.c, most properties of
> > the new expectation would be determined by netlink attributes which were
> > set by the nftables ruleset.
> 
> Does this mean I should create a new structure containing expectation
> data, as required by the nf_ct_expect_init function, and that I should
> expect to find this structure at &regs->data[priv->sreg] in
> nft_ct_set_eval?

No, that would be too extreme.

I think all the information should be passed as individual netlink
attributes.

In mean time, we gained ability to set timeout policies and conntrack
helpers via nft_ct, I think you can look at how they are implemented
to get an idea of how to gather the data that gets passed to
nf_ct_expect_init().

1a64edf54f55d7956cf5a0d95898bc1f84f9b818
netfilter: nft_ct: add helper set support
and
7e0b2b57f01d183e1c84114f1f2287737358d748
netfilter: nft_ct: add ct timeout support

table ip filter {
       ct timeout customtimeout {
               protocol tcp;
               l3proto ip
               policy = { established: 120, close: 20 }
       }

       chain output {
               type filter hook output priority filter; policy accept;
               ct timeout set "customtimeout"
       }
}

table inet myhelpers {
  ct helper ftp-standard {
     type "ftp" protocol tcp
  }
  chain prerouting {
      type filter hook prerouting priority 0;
      tcp dport 21 ct helper set "ftp-standard"
  }
}

So for expectations this might look like this:
table inet foo {
 ct expectation myexp {
	protocol udp;
	dport 6970-7170;
	timeout 5m;
	dmask 255.255.255.255;
	smask 255.255.255.255;
 }

 ip dport 554 ct expectation set "myexp"
}

nft_ct object evaluation would call nf_ct_expect_alloc() based
on current pkt->skb->_nfct and it would pass all info that is configured in
'myexp' already to nf_ct_expect_init().

The tuples to expect would be taken from pkt->skb->_nfct one.
I think for initial implementation, smask/dmask isn't needed so we
could just use the full expectet address.
Later on, we could extend this to also allow sport, classes, and so on.

Using the obect infrastructure allows to assign the expectation via maps,
without extra code, for example:

ct helper set tcp dport map {21 : "cthelp1", 2121 : "cthelp1" }
ct expectation set ip protocol map { 6 : "tcpexpect" , ...

> When all this is done, I will have to also update the nftables
> command. Will I also need to update the nftables library?

You will need to touch both libnftables and nftables.
You can look at nft/libnftnl history for the helper and timeout support.
