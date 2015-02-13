From: Marco Gaiarin <gaio@sv.lnf.it>
Subject: Some help to fix 'ipac-ng', a iptables-based accounting software...
Date: Fri, 13 Feb 2015 16:57:05 +0100
Message-ID: <20150213155705.GL3803@sv.lnf.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-222-c70.assomax.it ([185.20.70.222]:39994 "EHLO
	relay.posta.assomax.it" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbbBMQGZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2015 11:06:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by relay.posta.assomax.it (Postfix Assomax Secure Mailer) with ESMTP id 6CE5721E685
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2015 16:57:09 +0100 (CET)
Received: from relay.posta.assomax.it ([127.0.0.1])
	by localhost (relay.posta.assomax.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t1HS7zsCSvBj for <netfilter-devel@vger.kernel.org>;
	Fri, 13 Feb 2015 16:57:08 +0100 (CET)
Received: from tank.sv.lnf.it (unknown [46.19.234.132])
	(Authenticated sender: nostrafam@assomax.net)
	by relay.posta.assomax.it (Postfix Assomax Secure Mailer) with ESMTPSA id D30F921E684
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2015 16:57:08 +0100 (CET)
Received: from armitage.sv.lnf.it ([10.5.1.3])
	by tank.sv.lnf.it with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <gaio@sv.lnf.it>)
	id 1YMIc8-0007L4-7Q
	for netfilter-devel@vger.kernel.org; Fri, 13 Feb 2015 16:57:08 +0100
Received: from [10.5.1.14] (helo=albus)
	by armitage.sv.lnf.it with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <gaio@sv.lnf.it>)
	id 1YMIc5-000DLM-G9
	for netfilter-devel@vger.kernel.org; Fri, 13 Feb 2015 16:57:05 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I'm a very dumb programmer and i know little C, so i feel some fear to
write here, but... i hope that someone here can take this as an
exercise. ;-)


I use by some year an accounting software called 'ipac-ng':

	http://ipac-ng.sourceforge.net/

substantially, that software add some ''no target'' rule via
libiptables, and an helper program extract counter from them, building
graphs.
It is not realtime nor (i think) byte-accurate, but it is really
'lightweight'' compared to libpcap alternatives.
Also, it is, ahem, in ''low maintenance mode''. ;)


Recently i've upgraded from debian squeeze (so, iptables 1.4.8-3) to
debian wheezy (so, iptables 1.4.14-3.1).
After that upgrade, 'fetchipac' (the main binary that add the rules and
extract data) start complaining about some extended parameters i use
(MAC match):

	fetchipac: unrecognized option '--mac-source'

and then sigsev.
If i remove the ''extended parameters'', all work as expected. But
clearly i need that.


I've asked in ipac-ng lists[1], and a developer confirm me that seems a
libiptables incompatibilites.
Pointed me also against the guilty .c file:

	http://ipac-ng.cvs.sourceforge.net/viewvc/ipac-ng/ipac-ng/agents/iptab=
les/iptables.c?view=3Dmarkup

where the most of the code are taken from iptables itself.
The function prepare_entry() on line 834 roughly mimic the iptables
command line parse (but only for the '-m' parameter!).

So i've taken the relevant iptables code from 1.4.8 and 1.4.14, diff
them and port back ipac-ng code[2].

I've reached the (for me, impressive! ;) result that the code compile
and does not sigsev anymore.
But still reply 'unrecognized option'. ;-(


Someone can help me? Thanks.


[1]: https://sourceforge.net/p/ipac-ng/mailman/ipac-ng-common/thread/20=
150205165940.GR3690%40sv.lnf.it/#msg33353346

[2]: my code on https://sourceforge.net/p/ipac-ng/mailman/message/33379=
160/

--=20
dott. Marco Gaiarin				        GNUPG Key ID: 240A3D66
  Associazione ``La Nostra Famiglia''                    http://www.sv.=
lnf.it/
  Polo FVG   -   Via della Bont=E0, 7 - 33078   -   San Vito al Tagliam=
ento (PN)
  marco.gaiarin(at)lanostrafamiglia.it   t +39-0434-842711   f +39-0434=
-842797

		Dona il 5 PER MILLE a LA NOSTRA FAMIGLIA!
    http://www.lanostrafamiglia.it/25/index.php/component/k2/item/123
	(cf 00307430132, categoria ONLUS oppure RICERCA SANITARIA)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
