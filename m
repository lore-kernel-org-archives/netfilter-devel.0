From: Florian Westphal <fw@strlen.de>
Subject: Re: nf_conntrack: falling back to vmalloc.
Date: Fri, 17 Jul 2015 12:10:09 +0200
Message-ID: <20150717101009.GN25674@breakpoint.cc>
References: <55A8C428.1000005@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
	Marcelo Leitner <mleitner@redhat.com>
To: Toralf =?iso-8859-15?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58298 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757279AbbGQKKM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2015 06:10:12 -0400
Content-Disposition: inline
In-Reply-To: <55A8C428.1000005@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
> I do run a server with a 64 bit hardened Gentoo Linux (kernel current=
ly 4.0.8).
> Around 12th of July it started to spew those messages into kern.log :
>=20
> /var/log/kern.log:Jul 12 15:26:07 tor-relay kernel: [538360.650490] n=
f_conntrack: falling back to vmalloc.
> /var/log/kern.log:Jul 12 15:26:07 tor-relay kernel: [538360.650615] n=
f_conntrack: falling back to vmalloc.
> /var/log/kern.log:Jul 12 15:26:08 tor-relay kernel: [538361.673649] n=
f_conntrack: falling back to vmalloc.
> /var/log/kern.log:Jul 12 15:26:08 tor-relay kernel: [538361.673786] n=
f_conntrack: falling back to vmalloc.
>=20
> I read https://bugzilla.openvz.org/show_bug.cgi?id=3D3092 but a reboo=
t did not help.
> I got 1-2 thousends of those lines per day.

Most likely result of 88eab472ec21f01d3e36ff ("netfilter: conntrack:
adjust nf_conntrack_buckets default value".

Do you run containers?

This message can only be printed when a new network namespace is create=
d
(or something is rmmod/modprobing nf_conntrack module all the time).

I wonder if this is caused by some program creating netns for
sandboxing?

Pablo, Patrick -- any idea on how to stop conntrack from becoming activ=
e
in a newly created netns automatically without breaking anything?

With upcoming per netns hooks, we might be able to delay registering
conntrack, defrag etc.  until after a -m conntrack rule has been added.
Dou you think that could work?

=46or nft we could create an expression to configure conntrack explicit=
ly
(inverse NOTRACK).

[ obviously we can also add that for xtables but that would break
  setups if we suddently move to "you must ask for conntrack via
  ruleset" model. ]
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
