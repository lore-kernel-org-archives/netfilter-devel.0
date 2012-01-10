From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: Ulog/filter device name does not match effective device name of
 data flow: expected?
Date: Tue, 10 Jan 2012 14:04:12 +0100
Message-ID: <9F69795E29C890408AC2DAF646C89BB379CF93964B@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arcss01.ait.ac.at ([62.218.164.126]:54327 "EHLO mail.ait.ac.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755673Ab2AJNJt convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jan 2012 08:09:49 -0500
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Just a question, if this is intended behavior in NAT/logging with ulog/=
filter, I know it should be some border case:


In test environment, all 10/8 IPs are routed via lo by default to avoid=
 test data from 10/8 net leaving the host.

10.0.0.0/8 dev lo  scope link  src 10.0.0.1

To allow some connections to reach machines outside, these connections =
are natted, e.g.

Iptables -t nat -A OUTPUT -o lo -d 10.0.0.5 -p tcp -m tcp --dport 80 -j=
 DNAT --to-destination xxx.172:80

This allows to create the connection, but with two side effects:

Although the package leaves via eth0, ulog will report OUT=3Dlo:

Jan 10 12:06:13 v3lsn1105 iptables:ACCEPT-INFO IN=3D OUT=3Dlo MAC=3D SR=
C=3D10.xx.xx.3 DST=3Dxxxx.172 LEN=3D60 TOS=3D00 PREC=3D0x00 TTL=3D64 ID=
=3D46425 CE DF PROTO=3DTCP SPT=3D48808 DPT=3D80 SEQ=3D1237479374 ACK=3D=
0 WINDOW=3D32792 SYN URGP=3D0

To accept the connection, OUTPUT on lo has to be accepted (using filter=
 rule with -o lo), although package leaves via eth0.

Is this expected behavior?

Kind regards,
Roman

DI Roman Fiedler
Engineer
Safety & Security Department
Information Management & eHealth

AIT Austrian Institute of Technology GmbH
Reininghausstrae 13/1=A0 |=A0 8020 Graz=A0 |=A0 Austria
T +43(0) 50550 2957=A0 |=A0 M +43(0) 664 8561599=A0 |=A0 F +43(0) 50550=
 2950
roman.fiedler@ait.ac.at | http://www.ait.ac.at/

=46N: 115980 i HG Wien=A0 |=A0 UID: ATU14703506
This email and any attachments thereto, is intended only for use by the=
 addressee(s) named herein and may contain legally privileged and/or co=
nfidential information. If you are not the intended recipient, please n=
otify the sender by return e-mail or by telephone and delete this messa=
ge from your system and any printout thereof. Any unauthorized use, rep=
roduction, or dissemination of this message is strictly prohibited. Ple=
ase note that e-mails are susceptible to change. AIT Austrian Institute=
 of Technology GmbH shall not be liable for the improper or incomplete =
transmission of the information contained in this communication, nor sh=
all it be liable for any delay in its receipt.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
