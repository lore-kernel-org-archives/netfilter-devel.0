From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Tue, 07 Jun 2011 10:58:32 +0900
Message-ID: <1307411912.6576.8.camel@nexus.oss.ntt.co.jp>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
	 <1307320871-31770-2-git-send-email-pablo@netfilter.org>
	 <BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, stable@kernel.org,
	netfilter-devel@vger.kernel.org
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51079 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1FGB6d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:58:33 -0400
In-Reply-To: <BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2011-06-06 at 06:44 -0700, Maciej =C5=BBenczykowski wrote:
> > The mask indicates the bits one wants to zero out, so it needs to b=
e
> > inverted before applying to the original TOS field.
>=20
> Uhm, does it?

Yes.

> (mind you I haven't looked at the documentation of the feature, but
> I'm still pretty sure the right fix here is to change the docs, not
> the functionality)

You should read the documentation. What is more if you check the IPv4
implementation you will see that it is doing the right thing and
inverting the mask before applying the logical and to it. This bug went
unnoticed for so long (in fact it has been broken since day one) becaus=
e
IPv6 packets being mangled tend to have their DSCP field zeroed out (it
used to be random before 4319cc0cf5bb894b7368008cdf6dd20eb8868018 -
netfilter: IPv6: initialize TOS field in REJECT target module).

- Fernando

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
