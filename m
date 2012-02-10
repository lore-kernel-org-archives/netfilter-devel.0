From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: BUG nf_conntrack_ffff880863c50000: Objects remaining on
 kmem_cache_close()
Date: Fri, 10 Feb 2012 08:54:59 +0100
Message-ID: <1328860499.4030.2.camel@edumazet-laptop>
References: <4F328A81.4050607@univ-nantes.fr> <20120209155753.GB5951@1984>
	 <4F33F03C.5030805@univ-nantes.fr> <20120209193917.GB6881@1984>
	 <4F34CAC0.7060800@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jean-philippe.menil@univ-nantes.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43219 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2BJHzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:55:03 -0500
Received: by wics10 with SMTP id s10so1799535wic.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Feb 2012 23:55:01 -0800 (PST)
In-Reply-To: <4F34CAC0.7060800@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 10 f=C3=A9vrier 2012 =C3=A0 08:44 +0100, Jean-Philippe Meni=
l a =C3=A9crit :

> No, the NetlinkEventsReliable is commented in the configuration file.
>=20
> However, on the same hosts, i see strange things:
> ths host boot with the following parameter:
> net.netfilter.nf_conntrack_max=3D262144
> net.netfilter.nf_conntrack_tcp_timeout_established=3D10800
>=20
> nf_conntrack is loaded with the following parameter:
> options nf_conntrack hashsize=3D262144
>=20
> But it seems that the nf_conntrack_max reset to his default value=20
> (65536) periodically.
> Three days ago, i manually increase the nf_conntrack_max to 262144,=20
> yesterday i see plenty of "nf_conntrack: table full, dropping packet"=
=2E
> checking the value, is fall down to 65536.
>=20
> It's maybe not related, but i can't understand how the value can chan=
ge?
>=20

65536 is the default value when module is loaded.

Something unloads it and loads it again, and sysctl is not run after
this module load.




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
