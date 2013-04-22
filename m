From: Eric Leblond <eric@regit.org>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 01:03:11 +0200
Message-ID: <1366671791.15660.36.camel@tiger2>
References: <516EA684.9040209@linux.intel.com>
	 <20130419100531.GA3481@localhost> <517129D8.8000006@linux.intel.com>
	 <20130419121127.GA29452@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Julien Vehent <julien@linuxwall.info>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59609 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3DVXDV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:03:21 -0400
In-Reply-To: <20130419121127.GA29452@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, 2013-04-19 at 14:11 +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 19, 2013 at 02:26:16PM +0300, Tomasz Bursztyka wrote:
> > Hi Pablo,
> > 
> > >>I am thinking of taking original nft tool's lexer/parser for the statements.
> > >>It's nice, it works, no need to reinvent the wheel. The change will be on
> > >>creating libnftables objects instead.
> >
> > >We can just export the abstract syntax tree functions to build the
> > >rules.
> > 
> > I am not sure about what you mean. To me, we let the user playing
> > with the same exact statement they will use through nft tool.
> 
> After the parsing, nft generates and abstract syntax tree (see list of
> statements and struct expr for instance). You can use that do build
> the rule-set. You can easily build rules using that tree structure.
> 
> > >I've also discussing with Patrick that some even higher level API,
> > >something simple for users, just like "match tcp port 22" would be
> > >good to have.
> > 
> > Wait, you want to introduce another statement format? How is it
> > going to be simpler than nft tool format? I don't get the point
> > here.
> >
> > >>Flags:
> > >>NFT_FLAG_NL_SYNC (default): using libmnl (already used by libnftables,
> > >>so no extra dependancy) event_driver and nl_driver are forgotten.
> > >>NFT_FLAG_NL_ASYNC: Same as previous but a event_driver is at least
> > >>mandatory.
> > >>And a nl_driver can be provided to support libnl, others...
> >
> > >Also commented this with Patrick and I don't think we need this driver
> > >infrastructure.  We get nothing from supporting two different
> > >libraries as drivers. All your efforts should focus on libnftables.
> > 
> > It's a requirement for me to be able to use another way to discuss
> > on netlink. Let's say it: something else than libmnl or libnl.
> > And it's not that complicated anyway to handle, as for the event
> > loop actually. I am definitely keeping that.
> 
> I don't get why you may need something different than libmnl or libnl.

I don't think Tomasz need it but future application developers will
really love to avoid to learn how netlink messages are build. The
application developers are often doing both the GUI work (with crazy
things like web framework, QT or GTK) and they will benefit in using a
simple and consistent API where details of kernel-userspace interaction
will be transparently handled by the library.

The current "let's fork an iptables" approach was heavily used because
it was really simple to implement. The main point was that only the
command line syntax has to be known. So I think using the nft grammar
can be a good idea. At least for the basic
insertion/modification/deletion operations.

...
> > I am fine with that, providing different levels of abstraction. But
> > I am pretty sure people will prefer using higher level one: see how
> > applications uses iptables tool for instance?
> 
> Don't be so sure about that. People making very simple applications
> will stick to the simple make-my-life-easy API, yes. But people
> willing to make more advanced stuff will end up requiring to access
> details at different levels of the abstraction.

We definitely need different level of abstractions. At least a high
level and a low level. The high level abstraction should be almost
nftables independent (and netlink independent for sure) and the lower
level can get into the details.

I think Jesper's mail has described some features that would be really
useful in the high level API. Maybe continuing the discussion on these
type of features will lead to the list of the thing that would be useful
for most people.

<idea type=stupid>Regarding the low level API, I did not yet look a
libnftables but maybe just keeping it could be ok ?</idea> 

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

