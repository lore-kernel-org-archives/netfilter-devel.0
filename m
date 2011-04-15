From: =?ISO-8859-1?Q?Terry_Mo=EBs?= <T.Moes@student.ulg.ac.be>
Subject: Defining and parsing SNAT and DNAT options
Date: Fri, 15 Apr 2011 17:34:05 +0200
Message-ID: <4DA8656D.90309@student.ulg.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:55199 "EHLO
	serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab1DOPks (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:40:48 -0400
Received: from unknown (HELO [192.168.1.10]) (s061420@[91.179.198.188])
          (envelope-sender <T.Moes@student.ulg.ac.be>)
          by serv108.segi.ulg.ac.be (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 15 Apr 2011 17:33:58 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to identify (to understand) where are located the definition=
=20
and parsing code of the options for SNAT and DNAT target.

Actually, I'm trying to understand how the data given in args finishes=20
in NLA structures, correctly formatted. Args given to iptables are of=20
form IP-IP:Port-Port, but I can't find where this arg is parsed.

I've been trying to find where the arg 'to-source' is defined, without=20
success (and this arg has to defined somewhere, because if it is=20
misspelled, iptables refuses the command).

Can somebody give me a little help ?

Thanks a lot,
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
