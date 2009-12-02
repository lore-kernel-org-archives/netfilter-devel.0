From: dansirbu101@yahoo.ca
Subject: postrouting - it fails after change pkt via libipq
Date: Wed, 2 Dec 2009 14:06:16 -0800 (PST)
Message-ID: <577596.29550.qm@web51106.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web51106.mail.re2.yahoo.com ([206.190.38.148]:23043 "HELO
	web51106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751988AbZLBWGK convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:06:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

=A0=A0=A0 I have wrote a program to handle some IP packets using libipq=
 (linux 2.6.10 / iptables 1.3.3).
=A0=A0 =A0So I setup the NAT table with :

iptables -t nat -I PREROUTING -p sctp -j QUEUE
iptables -t nat -I POSTROUTING -p sctp -j QUEUE

=A0=A0=A0 The incoming packet go OK through my user space program and h=
ave the DST address changed to get forwarded to the server location. No=
w the server replies back, the rsp packet arrives within the POSTROUTIN=
G rule and gets sent by the kernel to my userspace program.
=A0=A0=A0=A0=A0Userspace program=A0applies the required changes - meani=
ng=A0it changes the SRC address and sends it back to the kernel. The ip=
_set_verdict response > 0 =3D> which means success.
=A0=A0=A0=A0 So far so good.

=A0=A0=A0=A0 The problem is that the mangled packet does not come out .=
=2E... (tcpdump does not capture it neither on the local machine neithe=
r on the receiver machine) !=20
=A0=A0=A0=A0 So to me is like the kernel is "dropping" the=A0packet ...=
=2E..

=A0=A0=A0=A0=A0 Any idea how can I debug this ?!?
=A0=A0=A0=A0 =A0I have no option to upgrade to a latest linux kernel - =
unfortunately.=A0

BR,
Dan S.



      _________________________________________________________________=
_
The new Internet Explorer=AE 8 - Faster, safer, easier.  Optimized for =
Yahoo!  Get it Now for Free! at http://downloads.yahoo.com/ca/internete=
xplorer/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
