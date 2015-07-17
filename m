From: Florian Westphal <fw@strlen.de>
Subject: Re: nf_conntrack: falling back to vmalloc.
Date: Fri, 17 Jul 2015 17:02:08 +0200
Message-ID: <20150717150208.GO25674@breakpoint.cc>
References: <55A8C428.1000005@gmx.de>
 <20150717101009.GN25674@breakpoint.cc>
 <55A9125E.2080807@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
	Marcelo Leitner <mleitner@redhat.com>
To: Toralf =?iso-8859-15?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58966 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbbGQPCM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2015 11:02:12 -0400
Content-Disposition: inline
In-Reply-To: <55A9125E.2080807@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
> On 07/17/2015 12:10 PM, Florian Westphal wrote:
> > Do you run containers?
>=20
> No, I just run 4 Gentoo chroot images in parallel - but I do that sin=
ce autumn last year.
>=20
> Unfortunately I cannot see any correlation to an os/sw upgrade or a c=
onfig change which could cause these messages nowadays to be appear.
> Therefore I do wonder if some network related "traffic" causes this, =
b/c that box acts as a Tor exit relay too.

No, I see no way how this would happen in response to network traffic.

A conntrack hash table is only allocated on network namespace creation,=
 or when
a resize happens (someone changing /sys/module/nf_conntrack/parameters/=
hashsize).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
