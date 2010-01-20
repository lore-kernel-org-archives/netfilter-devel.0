From: "Florian Fuessl" <flo@degnet.de>
Subject: RE: netfilter 00/07: SIP TCP & T.38 support
Date: Thu, 21 Jan 2010 00:57:31 +0100
Message-ID: <000001ca9a2c$54a44250$fdecc6f0$@de>
References: <20100120191824.25922.36663.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <madduck@debian.org>
To: "'Patrick McHardy'" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail04.viruscheckservice.de ([80.73.96.84]:54161 "EHLO
	mail04.viruscheckservice.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab0ATX5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:57:37 -0500
In-Reply-To: <20100120191824.25922.36663.sendpatchset@x2.localnet>
Content-Language: de
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you, Patrick :)

Patrick McHardy wrote:
> 
> The attached patches add TCP and T.38 FAX support to the SIP conntrack
> helper.
> 
> The patches are still work-in-progress, but they already work fine in
> all my tests and I know some people have been waiting for these
> features, so here's a snapshot of my current tree for anyone
> interested in testing.
> 
Leave me a note when heading to Munich next time; the beer will be on my
bill ;)

> They're based on the nf-next-2.6.git tree, but they also apply to the
> 2.6.32 release (might not compile though :).
> 
I'll give it a try within the next days ...

> Please report any test results.
> 
... and leave you a message with my results.

> 
>  include/linux/netfilter/nf_conntrack_sip.h  |   19 ++-
>  include/net/netfilter/nf_conntrack.h        |    2 +-
>  include/net/netfilter/nf_conntrack_expect.h |    1 +
>  include/net/netfilter/nf_nat_helper.h       |   32 ++-
>  net/ipv4/netfilter/nf_nat_helper.c          |   39 ++--
>  net/ipv4/netfilter/nf_nat_sip.c             |  158 ++++++++-----
>  net/netfilter/nf_conntrack_expect.c         |    9 +
>  net/netfilter/nf_conntrack_sip.c            |  333
> +++++++++++++++++++++------
>  8 files changed, 435 insertions(+), 158 deletions(-)
> 
> Patrick McHardy (7):
>       netfilter: nf_conntrack: show helper and class in
> /proc/net/nf_conntrack_expect
>       netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER
> request parsing
>       netfilter: nf_conntrack_sip: pass data offset to NAT functions
>       netfilter: nf_conntrack_sip: add TCP support
>       netfilter: nf_nat: support mangling a single TCP packet multiple
> times
>       netfilter: nf_nat_sip: add TCP support
>       netfilter: nf_conntrack_sip: add T.38 FAX support

