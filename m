From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: AW: Iptables ruleset modified somehow when performing
 "iptables-save" followed by "iptables-restore"
Date: Tue, 29 Nov 2011 17:19:09 +0100
Message-ID: <9F69795E29C890408AC2DAF646C89BB379CBC8D7B8@MAILBOX.arc.local>
References: <9F69795E29C890408AC2DAF646C89BB379CBDCB231@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arcss01.ait.ac.at ([62.218.164.126]:36316 "EHLO mail.ait.ac.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752619Ab1K2QT1 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Nov 2011 11:19:27 -0500
In-Reply-To: <9F69795E29C890408AC2DAF646C89BB379CBDCB231@MAILBOX.arc.local>
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

In the meantime I found the cause.=20

With kernel 2.6.32-35-generic and lucid iptables iptables-save does not=
 save the real iptables entries currently active. This should have only=
 mild security implications and might only be observed on machines on m=
achines with paranoid rulesets.

How to detect:

iptables -t nat -A POSTROUTING -p tcp -m conntrack --ctorigdst 192.168.=
0.0/24 -j SNAT --to-source 192.168.0.1
# iptables-save -t nat | grep POSTR
:POSTROUTING ACCEPT [87:5264]
-A POSTROUTING -p tcp -m conntrack --ctorigdst 192.168.0.0 -j SNAT --to=
-source 192.168.0.1

As you can see, the network prefix in the ctorigdst was lost during sav=
e, so rule is not the same after save, restore will restore broken rule=
=2E

On kernel version 2.6.38-12-generic and Ubuntu oneiric iptables, everyt=
hing works as expected.


Could someone point me to the revision of the fix of this problem, so t=
hat I can forward info to Ubuntu?

Thanks,

Roman


> -----Urspr=FCngliche Nachricht-----
> Von: Fiedler Roman
> Gesendet: Montag, 28. November 2011 12:47
> An: netfilter-devel@vger.kernel.org
> Betreff: Iptables ruleset modified somehow when performing "iptables-
> save" followed by "iptables-restore"
>=20
> Hello List,
>=20
> I've observed failure in POSTROUTING in a way so strange, that I did =
not find
> any suitable keywords to search the web for solution. But I guess, th=
at
> someone, who also observed that, will remember and perhaps could help
> me towards a solution.
>=20
> Setup and how to reproduce:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> X--->---
>           |--------- FW-----Net-Z
> Y----<---
>=20
> The firewall FW receives SYN from X for IP in Net-Z on eth0. Connecti=
on is
> DNATed to Y and forwarded via eth0. To avoid TCP-breakup by reply fro=
m Y-
> >X, connection is also SNATed to IP of firewall, so Y receives SYN fr=
om FW-IP.
>=20
> When building the iptables ruleset using various iptables [-t nat] -A=
 ...
> commands, the setup works. Conntrack shows
>=20
> # conntrack -L | grep YYYYYY.13
> tcp      6 431995 ESTABLISHED src=3DXXXXX.129 dst=3DNET-Z.252 sport=3D=
38231
> dport=3D8080 packets=3D2 bytes=3D112 src=3DYYYYYY.13 dst=3DFW-IP.250 =
sport=3D8080
> dport=3D38231 packets=3D1 bytes=3D60 [ASSURED] mark=3D0 secmark=3D0 u=
se=3D2
>=20
> After
>=20
> # iptables-save > iptables.x
> # iptables-restore < iptables.x
>=20
> and sending SYN from X again conntrack is
> # conntrack -L | grep YYYYYY.13
> tcp      6 115 SYN_SENT src=3DXXXXXX.129 dst=3DNET-Z.252 sport=3D3823=
4
> dport=3D8080 packets=3D2 bytes=3D120 [UNREPLIED] src=3DYYYYYY.13
> dst=3DXXXXXXXX.129 sport=3D8080 dport=3D38234 packets=3D0 bytes=3D0 m=
ark=3D0
> secmark=3D0 use=3D2
>=20
> It seems that the POSTROUTING rule is not active, tcpdump really show=
s the
> SYN leaving the firewall with source-IP unmodified (still X).
>=20
> Kernel version: 2.6.32-35-generic
> Iptables version: iptables-save v1.4.4 on Mon Nov 28 11:36:06 2011
>=20
>=20
> Questions:
> =3D=3D=3D=3D=3D=3D=3D
>=20
> * Should a save-restore-sequence lead to the exact same iptables-setu=
p
> before save or is the some other constraint to be met to guarantee sa=
ve-
> restore to restore exactly what was saved? (There were no concurrent
> iptables table-modify activities on that machine during test except b=
ut active
> network traffic).
> * Why does the order of iptables rules created influence outcome?
> * Does this behavior correspond to a known bug?
> * If really bug, what are the exact effects? Could this be a security=
 problem
> when affecting filter instead of nat?
>=20
> Thanks for your help,
>=20
> DI Roman Fiedler
> Safety & Security Department
> Information Management & eHealth
>=20
> AIT Austrian Institute of Technology GmbH
> Reininghausstrae 13/1  |  8020 Graz  |  Austria
> T +43(0) 316 586570-63  |  M +43(0) 664 8561599  |  F +43(0) 316 5865=
70-12
> roman.fiedler@ait.ac.at <mailto:roman.fiedler@ait.ac.at> |
> http://www.ait.ac.at <http://www.ait.ac.at/>
> http://www.ait.ac.at/eHealth/ <http://www.ait.ac.at/eHealth/>
>=20
> Kennen Sie die www.eHealth2011.at?
>=20
> FN: 115980 i HG Wien  |  UID: ATU14703506
> This email and any attachments thereto, is intended only for use by t=
he
> addressee(s) named herein and may contain legally privileged and/or
> confidential information. If you are not the intended recipient, plea=
se notify
> the sender by return e-mail or by telephone and delete this message f=
rom
> your system and any printout thereof. Any unauthorized use, reproduct=
ion,
> or dissemination of this message is strictly prohibited. Please note =
that e-
> mails are susceptible to change. AIT Austrian Institute of Technology=
 GmbH
> shall not be liable for the improper or incomplete transmission of th=
e
> information contained in this communication, nor shall it be liable f=
or any
> delay in its receipt.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
