From: =?ISO-8859-1?Q?Terry_Mo=EBs?= <T.Moes@student.ulg.ac.be>
Subject: NAT66 : A first implementation
Date: Thu, 14 Jul 2011 17:47:20 +0200
Message-ID: <4E1F0F88.3090704@student.ulg.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:44265 "EHLO
	serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1GNPyD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:54:03 -0400
Received: from unknown (HELO [192.168.1.6]) (s061420@[91.179.116.231])
          (envelope-sender <T.Moes@student.ulg.ac.be>)
          by serv108.segi.ulg.ac.be (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 14 Jul 2011 17:47:21 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all !

Since the Draft of NPT66 (Stateless Mapping) has gone RFC=20
(http://tools.ietf.org/html/rfc6296), it's the good time for me to=20
publish my master thesis : an implementation, for Netfilter, of NAT in=20
IPv6, with both Stateless and Stateful approaches.

It's published on Sourceforge : https://sourceforge.net/projects/nfnat6=
6/

You will find 5 items in here :
- The PDF of my thesis, which explains some choices, if wanted;
- The slides shown on the presentation of my thesis, which contain some=
=20
extra-information with respect to the report;
- Two extensions for ip6tables (SNAT and DNAT);
- Three kernel files that have been edited for the purpose of the=20
implementation;
- The two modules that have been created.

Moreover, my thesis gives a deep explanation of NAT44 implementation,=20
and can thus be referenced anywhere needed.

The whole development of NAT66 is inspired from what was done for NAT44=
=2E

There is still a lot of work to do, and there is probably some bugs in=20
the modules (despite many tests in lab), thus any help is welcome!

A first step would be to patch the next version of the kernel with the=20
three modified files, so that any further development is greatly=20
facilitated! And since it's a thing I've never done, any advise is not=20
unnecessary :)

Don't hesitate if you have any question.

Greetings,
Terry

--
Terry Mo=EBs (20061420)
Universit=E9 de Li=E8ge - Facult=E9 des Sciences Appliqu=E9es
2=E8me ann=E9e Master Ing=E9nieur Civil en Informatique - D=E9l=E9gu=E9
Repr=E9sentant Etudiant - Conseil de Facult=E9
=46FSA Administrateur - http://www.ffsa.be
T.Moes@student.ulg.ac.be

--=20

N-HiTec - Nova High Technology Engineering and Consulting

Responsable des Infrastructures - Vice-Pr=E9sident

Web :   http://www.nhitec.com
T=E9l :   04/366.20.01

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
