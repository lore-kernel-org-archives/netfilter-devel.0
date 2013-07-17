From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: Conntrack vs. TCP-stack timout differences: quickfix howto
Date: Wed, 17 Jul 2013 08:14:16 +0000
Message-ID: <2ECE9D9EEF1F524185270138AE2326591D3BD709@S0MSMAIL111.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.ait.ac.at ([62.218.164.132]:43287 "EHLO MX2.ait.ac.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab3GQIVw convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:21:52 -0400
Received: from pps.filterd (MX2 [127.0.0.1])
	by MX2.ait.ac.at (8.14.5/8.14.5) with SMTP id r6H83Cbg021023
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2013 10:14:17 +0200
Received: from mail.ait.ac.at ([172.30.249.112])
	by MX2.ait.ac.at with ESMTP id 1dnau686q2-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2013 10:14:17 +0200
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

=46rom time to time, iptables drops related packets of TCP-connections =
originating from the host running iptables.=20

Jul 17 06:02:37 [somehost] iptables:DROP-ERROR IN=3D OUT=3Deth0 MAC=3D =
SRC=3D[somehost-ip] DST=3D[otherhost] LEN=3D64 TOS=3D00 PREC=3D0x00 TTL=
=3D64 ID=3D48442 CE DF PROTO=3DTCP SPT=3D41902 DPT=3D80 SEQ=3D382478645=
 ACK=3D1990115033 WINDOW=3D916 ACK PSH FIN URGP=3D0

The conntrack tables are quite empty,  far away from loosing conntracks=
 due to overload. In my opinion, kernel is generating those packets sin=
ce it is still handling the TCP-connection shutdown phase, while conntr=
ack has sorted out the entry, believing that the connection was termina=
ted already.

Since I assume, that the cause for this are different state-timeouts in=
 iptables and TCP-stack, I would like to write a howto (or better a scr=
ipt for automatic check) to find out, which parameters should be adjust=
ed.

Am I on the right track? Is this possible or is e.g. the iptables-TCP-s=
tate-model simplified for speed-up, that it cannot follow all local TCP=
 state changes by design?

Thanks,
Roman

PS: Kernel 3.9.7

DI Roman Fiedler
Engineer
Safety & Security Department
Assistive Healthcare Information Technology

AIT Austrian Institute of Technology GmbH
Reininghausstrae 13/1=A0 |=A0 8020 Graz=A0 |=A0 Austria
T +43(0) 50550 2957=A0 |=A0 M +43(0) 664 8561599=A0 |=A0 F +43(0) 50550=
 2950
roman.fiedler@ait.ac.at | http://www.ait.ac.at/

=46N: 115980 i HG Wien=A0 |=A0 UID: ATU14703506
http://www.ait.ac.at/Email-Disclaimer

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
