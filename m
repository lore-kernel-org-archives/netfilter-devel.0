From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: debug: nt_conntrack and KVM crash
Date: Mon, 01 Feb 2010 15:57:07 +0100
Message-ID: <1265036227.2848.53.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <b6fcc0a1002010648k5a27c2dey12c1cdcb0790a33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jon Masters <jonathan@jonmasters.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:47171 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0BAO5N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:57:13 -0500
In-Reply-To: <b6fcc0a1002010648k5a27c2dey12c1cdcb0790a33@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 01 f=C3=A9vrier 2010 =C3=A0 16:48 +0200, Alexey Dobriyan a =C3=
=A9crit :

> conntracks also have netns pointer (->ct_net). This should be enough,=
 yes?
>=20

Not checked in __nf_conntrack_find() and other lookup routines/helpers
(nf_ct_tuple_equal(), ...)




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
