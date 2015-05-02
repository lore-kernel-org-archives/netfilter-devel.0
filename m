From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: Matching MLD with ip6tables
Date: Sat, 2 May 2015 10:58:13 +0200
Message-ID: <20150502085812.GA3156@odroid>
References: <20150501025612.GB2465@odroid>
 <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Matthias Schiffer <mschiffer@universe-factory.net>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.passe0815.de ([188.40.49.9]:55289 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbbEBI6Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 04:58:16 -0400
Received: from mail.passe0815.de (localhost [127.0.0.1])
	by mail.passe0815.de (Postfix) with ESMTP id B40BD5864F2
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2015 10:58:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 01, 2015 at 08:33:03AM +0200, Jan Engelhardt wrote:
>=20
> On Friday 2015-05-01 04:56, Linus L=C3=BCssing wrote:
> >
> >According to RFC4890 ("Recommendations for Filtering ICMPv6
> >Messages in Firewalls"), page 35, a rule like this should match
> >MLD packets:
> >
> >$ ip6tables -A icmpv6-filter -p icmpv6 --icmpv6-type {130,131,132,14=
3} ...
> >
> >However, this does not seem to work for me. My guess is that it
> >does not match because --protocol is not 'icmpv6' but actually
> >the hop-by-hop-option first.
> >Also, is there a way to somehow match IPv6 protocols with IPv6
> >options in between?
>=20
> -p matches the first non-extension header. For the
> exthdrs, there is e.g. -m hbh.

You're right, I had made a wrong assumption about ip6tables... It
wasn't ip6tables incapabilities but a bug in OpenWRT which set a
default ICMPv6 code of 255 instead of 0 when not specifying it
next to the ICMPv6 type in its config. Thanks for your help!

Awesome that ip6tables is that smart :).

Cheers, Linus
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
