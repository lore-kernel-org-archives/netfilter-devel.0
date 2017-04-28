From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/2] masquerade: Complain if no prerouting chain
 exists
Date: Fri, 28 Apr 2017 10:05:23 +0200
Message-ID: <20170428080523.GI20805@orbyte.nwl.cc>
References: <20170427132439.9443-1-phil@nwl.cc>
 <20170427132439.9443-2-phil@nwl.cc>
 <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42529 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163921AbdD1IF0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 04:05:26 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 28, 2017 at 09:01:44AM +0200, Arturo Borrero Gonzalez wrote:
> On 27 April 2017 at 15:24, Phil Sutter <phil@nwl.cc> wrote:
> > As reported in netfilter bz#1105, masquerading won't work if there isn't
> > at least an empty base chain hooked into prerouting. In order to raise
> > awareness of this problem at the user, complain if a masquerading
> > statement is added and the table does not contain an appropriate
> > prerouting chain already.
> >
> > To not break user scripts which add the required chain at a later point,
> > accept the command anyway.
> >
> > A better solution would be to create the required chain as a dependency
> > and drop it again on return path or if the user adds his own one later,
> > though I doubt the extra effort is feasible here.
> >
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/evaluate.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
> 
> This warning will be printed even in rulesets loaded with '-f'
> which first creates the masq rule an then the other chain.

Hmm. I tested it with the following config and it works fine:

| table ip nat {
| 	chain post {
| 		type nat hook postrouting priority 0; policy accept;
| 		oifname "veth2" masquerade
| 	}
| 
| 	chain pre {
| 		type nat hook prerouting priority 0; policy accept;
| 	}
| }

OK, with a config consisting of several 'add' commands, it indeed warns.

> I think is just a matter of documenting *everywhere* that this is the
> expected behaviour, not a bug.

Yeah, I should indeed have done that first, also because masquerade
statement is not documented at all yet.

Thanks, Phil
