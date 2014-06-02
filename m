From: Florian Westphal <fw@strlen.de>
Subject: Re: [nftables PATCH v2] src: Replace TOS support for using DSCP
 support
Date: Mon, 2 Jun 2014 10:58:26 +0200
Message-ID: <20140602085826.GA17858@breakpoint.cc>
References: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com>
 <1401200300-24583-1-git-send-email-alvaroneay@gmail.com>
 <20140601202707.GC19396@macbook.localnet>
 <538C307C.30405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56657 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbaFBI62 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:28 -0400
Content-Disposition: inline
In-Reply-To: <538C307C.30405@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=C1lvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
> >>Now, when we add a rule with DSCP, in the code generation step, nft=
ables
> >>compares 1 bytes but it should compare 6 bits. I think that the pro=
blem should
> >>be in the code generation.
> >
> >I don't really see how this patch changes this. The kernel operates =
in units
> >of bytes. For anything smaller nftables will have to generate approp=
riate
> >bitwise operations. Please explain in more detail how this patch cha=
nges this.
> >
>=20
> Now, nothing. For that it's stopped. I'm working for doing a patch
> for operating in the kernel not only with units of bytes like you
> say. In a couple of days, I'm going to send it to the list.

Are you sure this is the right approach?

It might be better to create appropriate masking instructions in
userspace, in most cases byte addressing is sufficient.

Something like this (warning: untested, misses 'reverse' mapping to
remove the implicit bitops when listing rules):

http://git.breakpoint.cc/cgit/fw/nftables.git/commit/?h=3Dpayload_offse=
t_04&id=3D76ac27643400111785a8abb21fdd9e4311d9876e
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
