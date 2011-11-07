From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: ipset: usage of unitialized variable ip_to in
 ip_set_hash_ipportnet.c
Date: Mon, 7 Nov 2011 23:18:23 +0100
Message-ID: <20111107221823.GH18221@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smp.if.uj.edu.pl ([149.156.82.206]:41827 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1KGWXb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:23:31 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,


in file et/netfilter/ipset/ip_set_hash_ipportnet.c
in functionhash_ipportnet4_uadt(...)
variable u32 ip_to, can be used uninitialized
in line 283
	for (; !before(ip_to, ip); ip++) {

because, if both tb[IPSET_ATTR_IP_TO] and tb[IPSET_ATTR_CIDR]
are false, then there is no initialization of ip_to.

  CC [M]  net/netfilter/ipset/ip_set_hash_ipportnet.o
net/netfilter/ipset/ip_set_hash_ipportnet.c: In function =E2=80=98hash_=
ipportnet4_uadt=E2=80=99:
include/net/tcp.h:266:28: warning: =E2=80=98ip_to=E2=80=99 may be used =
uninitialized in this function [-Wuninitialized]
net/netfilter/ipset/ip_set_hash_ipportnet.c:187:10: note: =E2=80=98ip_t=
o=E2=80=99 was declared here


I think this should be fixed be properly initializing / using ip_to,
or by telling compiler that some of paths will end in initialization.


Also why on earth a before(a,b) function is used
to compare IP addresses? Shouldn't before(seq1,seq2) function
be used only to compare TCP sequnce numbers?!

Regards,
Witek

--=20
Witold Baryluk
JID: witold.baryluk // jabster.pl
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
