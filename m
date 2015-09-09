From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft] segfault bug in simple ruleset, regression?
Date: Wed, 9 Sep 2015 17:29:24 +0200
Message-ID: <20150909152924.GB24810@breakpoint.cc>
References: <CAOkSjBhk00k9H98Nx0hdxvrf5b8vAP5ad=iiKrdB2v4rHimoMw@mail.gmail.com>
 <20150909142903.GA3447@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52757 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbbIIP31 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 11:29:27 -0400
Content-Disposition: inline
In-Reply-To: <20150909142903.GA3447@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > flush ruleset
> > table inet filter {
> >         chain test0 {
> >         }
> > 
> >         chain test1 {
> >         }
> > 
> >         chain test2 {
> >         }
> > 
> >         chain test {
> >                 oif vmap {
> >                         eth0 : jump test0,
> >                         eth1 : jump test1,
> >                         eth2 : jump test2
> >                 }
> >         }
> > }
> > ========== 8< ==========
> > 
> > loaded with:
> >  % nft -f file
> 
> I cannot reproduce this here using this:

I can reproduce it, but with slight tweak.

flush ruleset
table inet filter {
        chain test0 {
        }
        chain test {
                oif vmap {
                        eth0 : jump test0,
                }
        }
}

(load it with nft -f )

Then edit file to add 2nd chain:
flush ruleset
table inet filter {
        chain test0 {
        }
        chain test1 {
        }
        chain test {
                oif vmap {
                        eth0 : jump test0,
                        lo: jump test1,
                }
        }
}

load it. poof..
