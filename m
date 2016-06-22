From: Greg KH <greg@kroah.com>
Subject: Re: [stable] netfilter fixes for CVE-2016-3134
Date: Tue, 21 Jun 2016 22:07:02 -0700
Message-ID: <20160622050702.GA21897@kroah.com>
References: <1466552471.27155.238.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable <stable@vger.kernel.org>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57832 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbcFVFes (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 01:34:48 -0400
Content-Disposition: inline
In-Reply-To: <1466552471.27155.238.camel@decadent.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 12:41:11AM +0100, Ben Hutchings wrote:
> Please cherry-pick these for all branches older than 4.6:
>=20
> commit bdf533de6968e9686df777dc178486f600c6e617
> Author: Florian Westphal
> <fw@strlen.de>
> Date:=A0=A0=A0Tue Mar 22 18:02:49 2016 +0100
>=20
> =A0=A0=A0=A0netfilter: x_tables: validate e->target_offset early
>=20
> commit 6e94e0cfb0887e4013b3b930fa6ab1fe6bb6ba91
> Author: Florian Westphal <fw@strlen.de>
> Date:=A0=A0=A0Tue Mar 22 18:02:50 2016 +0100
>=20
> =A0=A0=A0=A0netfilter: x_tables: make sure e->next_offset covers rema=
ining blob size
>=20
> commit 54d83fc74aa9ec72794373cb47432c5f7fb1a309
> Author: Florian Westphal <fw@strlen.de>
> Date:=A0=A0=A0Tue Mar 22 18:02:52 2016 +0100
>=20
> =A0=A0=A0=A0netfilter: x_tables: fix unconditional helper
>=20
> Ben.

Thanks, now applied where relevant.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
