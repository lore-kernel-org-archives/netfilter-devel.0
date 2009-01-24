From: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Subject: nf_conntrack_proto_generic, assigned to 0
Date: Sat, 24 Jan 2009 16:22:36 +0100
Message-ID: <200901241622.36634.christoph.paasch@student.uclouvain.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout.sgsi.ucl.ac.be ([130.104.5.77]:58106 "EHLO
	smtp3.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZAXP3n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:29:43 -0500
Received: from christoph-dell.localnet (unknown [91.177.99.112])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: cpaasch@smtp3.sgsi.ucl.ac.be)
	by smtp3.sgsi.ucl.ac.be (Postfix) with ESMTPSA
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 16:22:39 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

while reading through the source-code I remarked, that for the generic =
l4=20
protocol handler (nf_conntrack_proto_generic.c)  the protocol number 0 =
is=20
used. While linux/in.h defines IPPROTO_IP =3D 0 (and says "a dummy prot=
ocol for=20
tcp", whatever that may mean), in net/ipv6.h, the protocol 0 is used fo=
r the=20
hop-by-hop header. And as IANA states, 0 is assigned to the IPv6 Hop-by=
-hop=20
option.

Even, if netfilter doesn't tracks the hop-by-hop protocol, it shouldn't=
 use=20
this number for the generic protocol handler, because this might be con=
fusing.
In my opinion, 255 should be used, which is assigned as "Reserved" by I=
ANA.

What do you think?

--
Christoph Paasch

=C9cole Polytechnique de Louvain
D=E9partement d'ing=E9nierie informatique

www.rollerbulls.be
--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
