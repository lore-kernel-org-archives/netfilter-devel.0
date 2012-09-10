From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: ulogd syslogemu output garbage after kernel update (32 to 64bit)
Date: Mon, 10 Sep 2012 08:36:56 +0200
Message-ID: <9F69795E29C890408AC2DAF646C89BB379DA486186@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mta1.ait.ac.at ([62.218.164.111]:46162 "EHLO mail.ait.ac.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372Ab2IJGmq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:42:46 -0400
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list,

In short: Could 32-bit ulogd run on 64-bit kernel without failing?

Longer story: One of our machines runs on 32bit linux because 32bit cod=
e is smaller. Also the kernel was a 32-bit one. Over the time during op=
eration, the larger amount of data processed increased RAM requirements=
=2E All processes stay below 4G but the system itself could use more th=
an 4G RAM, which is not possible with the 32-bit kernel used. So the ke=
rnel was upgraded  to 64 bit (kernel 3.3.2) WITHOUT upgrading the syste=
m to 64 bit.

Afterwards everything worked fine except that the ulogd (1.24-3ubuntu1)=
 messages written to syslogemu were complete garbage, e.g.

Jan  1 00:00:00 localhost  0 0 20 0 1 < IN=3D [unprintable bytes]
R OUT=3D [unprintable bytes] MAC=3D50:54:2d:49:4e:46:4f:00:00:00:00:00:=
00:00:00:00:00:00:00:0e:00:50:56:9c:3c:a6:00:50:56:9c:00:a2:08:00:34:35=
:37:36:36:31:32:20:34:32:38:37:38:35:39:38:34:30:20:34:32:38:37:38:35:3=
8:31:30:34:20:34:31:35:31:32  SRC=3D32.48.32.48 DST=3D32.49.55.32 LEN=3D=
13112 TOS=3D10 PREC=3D0x20 TTL=3D57 ID=3D12340 MF FRAG:5940 PROTO=3D53

All other iptables tools seem to work correctly, e.g. iptables-save sho=
ws correct interface names, rules and also the ruleset works as expecte=
d. From that I would expect, that the error should reside in the netlin=
k handover of captured packets to ulogd or the ulogd handling of those =
messages.

Is it possible to run a 32-bit ulogd on 64-bit system or is there some =
reason, this cannot work? If it won't work, it would be nice if ulogd f=
ails to start with some understandable error message.

Kind Regards,
Roman

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
