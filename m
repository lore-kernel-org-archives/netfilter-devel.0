From: Jason Stubbs <j.stubbs@linkthink.co.jp>
Subject: conntrack bug?
Date: Fri, 18 Apr 2008 13:43:25 +0900
Message-ID: <200804181343.25640.j.stubbs@linkthink.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.blogtoy.net ([202.177.195.2]:61288 "EHLO smtp.blogtoy.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYDRFFP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2008 01:05:15 -0400
Received: from mail.linkthink.co.jp (unknown [221.186.146.128])
	by smtp.blogtoy.net (Postfix) with ESMTP id 0914E6A4ADC
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2008 13:43:27 +0900 (JST)
Received: from localhost (localhost [127.0.0.1])
	by mail.linkthink.co.jp (Postfix) with ESMTP id D6372A7053D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2008 13:43:26 +0900 (JST)
Received: from mail.linkthink.co.jp ([127.0.0.1])
	by localhost (mail.linkthink.co.jp [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zqCrkpyDAUY9 for <netfilter-devel@vger.kernel.org>;
	Fri, 18 Apr 2008 13:43:26 +0900 (JST)
Received: from [192.168.0.104] (unknown [192.168.0.104])
	by mail.linkthink.co.jp (Postfix) with ESMTP id 392F4A70538
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2008 13:43:26 +0900 (JST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

While testing patches for IPVS, I found a strange behaviour of conntrac=
k that=20
happens on an unpatched kernel too (2.6.24.4). Given the following rule=
s:

iptables -A FORWARD -p tcp -d 192.168.1.3 --dport 80 \
                    -m state --state NEW -j ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -P FORWARD DROP

And a network setup where replies from 192.168.1.3 don't go via the sam=
e=20
machine - ie, they appear to be being dropped - the following conntrack=
 entry=20
appears when sending only an ACK packet to 192.168.1.3:

ipv4     2 tcp      6 431684 ESTABLISHED src=3D192.168.0.104 dst=3D192.=
168.1.3=20
sport=3D12345 dport=3D80 packets=3D2 bytes=3D95 [UNREPLIED] src=3D192.1=
68.1.3=20
dst=3D192.168.0.104 sport=3D80 dport=3D12345 packets=3D0 bytes=3D0 mark=
=3D0 use=3D1

If a SYN has been sent the following state appears and no traffic (incl=
uding=20
an ACK) is allowed to pass:

ipv4     2 tcp      6 119 SYN_SENT src=3D192.168.0.104 dst=3D192.168.1.=
3=20
sport=3D23456 dport=3D80 packets=3D1 bytes=3D50 [UNREPLIED] src=3D192.1=
68.1.3=20
dst=3D192.168.0.104 sport=3D80 dport=3D23456 packets=3D0 bytes=3D0 mark=
=3D0 use=3D1

I would think that behaviour to be correct, but an entry appearing when=
 only=20
an ACK packet has been sent seems wrong. Is it a bug or intentional?

--=20
Jason Stubbs <j.stubbs@linkthink.co.jp>
LINKTHINK INC.
=E6=9D=B1=E4=BA=AC=E9=83=BD=E6=B8=8B=E8=B0=B7=E5=8C=BA=E6=A1=9C=E3=83=B6=
=E4=B8=98=E7=94=BA22-14 N.E.S S=E6=A3=9F 3F
TEL 03-5728-4772  FAX 03-5728-4773
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
