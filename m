From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] payload: only merge if adjacent and combined size
 fits into a register
Date: Mon, 18 Apr 2016 20:20:00 +0200
Message-ID: <20160418182000.GA2580@salvia>
References: <1460725779-12066-1-git-send-email-fw@strlen.de>
 <CAOkSjBhw32VvJewnQitmVxKzrBSG3yp=38g5cCzgsDvhmiVRZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36365 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbcDRSUT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:20:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 79D9DC1089
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:20:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0EDF4A737
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:20:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF109A737
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:20:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBhw32VvJewnQitmVxKzrBSG3yp=38g5cCzgsDvhmiVRZA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 16, 2016 at 03:17:56PM +0200, Arturo Borrero Gonzalez wrote:
> On 15 April 2016 at 15:09, Florian Westphal <fw@strlen.de> wrote:
> > add rule ip6 filter input ip6 saddr ::1/128 ip6 daddr ::1/128 fails,
> > we ask to compare a 32byte immediate which is not supported:
> >
> >   [ payload load 32b @ network header + 8 => reg 1 ]
> >   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 0x00000000 0x00000000 0x00000000 0x02000000 ]
> >
> > We would need to use two cmps in this case, i.e.:
> >
> >   [ payload load 32b @ network header + 8 => reg 1 ]
> >   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
> >   [ cmp eq reg 2 0x00000000 0x00000000 0x00000000 0x02000000 ]
> >
> > Seems however that this requires a bit more changes to how nft
> > handles register allocations, we'd also need to undo the constant merge.
> >
> > Lets disable merging for now so that we generate
> >
> >   [ payload load 16b @ network header + 8 => reg 1 ]
> >   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
> >   [ payload load 16b @ network header + 24 => reg 1 ]
> >   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
> >
> > ... if merge would bring us over the 128 bit register size.
> >
> > Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=1032
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  include/payload.h               |  2 +-
> >  src/payload.c                   | 27 ++++++++++++++++++++-------
> >  src/rule.c                      |  2 +-
> >  tests/py/ip6/ip6.t              |  1 +
> >  tests/py/ip6/ip6.t.payload.inet |  9 +++++++++
> >  tests/py/ip6/ip6.t.payload.ip6  |  7 +++++++
> >  6 files changed, 39 insertions(+), 9 deletions(-)
> >
> 
> Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
