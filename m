From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH v2] src: Replace TOS support for using DSCP
 support
Date: Sun, 1 Jun 2014 21:27:07 +0100
Message-ID: <20140601202707.GC19396@macbook.localnet>
References: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com>
 <1401200300-24583-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55219 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaFAU1L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:27:11 -0400
Content-Disposition: inline
In-Reply-To: <1401200300-24583-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 27, 2014 at 04:18:20PM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [changes in v2]
> * Replace TOS support for using DSCP support
>=20
> Now, when we add a rule with DSCP, in the code generation step, nftab=
les
> compares 1 bytes but it should compare 6 bits. I think that the probl=
em should
> be in the code generation.

I don't really see how this patch changes this. The kernel operates in =
units
of bytes. For anything smaller nftables will have to generate appropria=
te
bitwise operations. Please explain in more detail how this patch change=
s this.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
