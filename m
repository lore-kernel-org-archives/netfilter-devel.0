From: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Subject: connection tracker - ipv6 extension headers
Date: Mon, 17 Nov 2008 12:24:33 +0100
Message-ID: <200811171224.33582.christoph.paasch@student.uclouvain.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout.sgsi.ucl.ac.be ([130.104.5.77]:51179 "EHLO
	smtp4.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYKQLcj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:32:39 -0500
Received: from christoph-dell.localnet (unknown [78.110.193.201])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: cpaasch@smtp4.sgsi.ucl.ac.be)
	by smtp4.sgsi.ucl.ac.be (Postfix) with ESMTPSA
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 12:24:41 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everybody,

I'm quite new to netfilter, so be kind with me... :-)

In the case of my Master Thesis I have to develop shim6-support in netf=
ilter.

I found that there is no real support in the netfilter connection track=
er to=20
handle IPv6 extension headers. (e.g.: when I receive a shim6-payload ex=
tension=20
header, I would like to check if the context-tag is a valid one for the=
=20
locators used. - shim6-control messages will be handled like a layer-4=20
protocol as in icmp6)

I thought, that I could do that job in nf_ct_ipv6_skip_exthdr(...) to c=
heck if=20
the context-tag is valid. But it's not the job of that function to chec=
k the=20
"validness" of an extension header.

So, are there any plans to implement some kind of extension-header-hand=
ler in=20
the connection tracker? Or does there exists somewhere a patch who does=
 that=20
job?

I hope, that I was clear in my explanations.

Thanks for helping me,

--
Christoph Paasch

=C9cole Polytechnique de Louvain-la-Neuve
D=E9partement d'ing=E9nierie informatique

www.rollerbulls.be
--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
