From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter/IPv6:  initialize TOS field in REJECT target
 module
Date: Fri, 22 Apr 2011 10:06:00 +0200
Message-ID: <1303459560.3134.14.camel@edumazet-laptop>
References: <1303455759.2023.39.camel@nausicaa>
	 <1303456743.2023.55.camel@nausicaa>
	 <1303457656.3134.12.camel@edumazet-laptop>
	 <1303458454.9791.13.camel@nausicaa>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	yoshfuji@linux-ipv6.org, jengelh@medozas.de, davem@davemloft.net
To: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47149 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1DVIGE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:06:04 -0400
In-Reply-To: <1303458454.9791.13.camel@nausicaa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 22 avril 2011 =C3=A0 16:47 +0900, Fernando Luis Vazquez Cao=
 a
=C3=A9crit :

> Hi Eric,
>=20
> Thank you for the review, I really appreciate it.
>=20
> payload_len is set in __ip6_local_out() which is called from
> ip6_local_out.
>=20

Thats right, thanks !

> Could I get your acked-by for the two patches I sent?
>=20

Sure

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
