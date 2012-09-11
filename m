From: Hassan <shamalizadeh@gmail.com>
Subject: Re: recommendations on implementing a custom Netfilter hook to QUEUE packets before their SEQ/ACK and size before fragmentation are known?
Date: Tue, 11 Sep 2012 12:31:26 +0000 (UTC)
Message-ID: <loom.20120911T131530-546@post.gmane.org>
References: <AANLkTi=x_khzkObaG4F7PrVzbStd5c1OZMCE_oKHa35b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57792 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2IKMfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Sep 2012 08:35:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TBPgG-0004oi-I7
	for netfilter-devel@vger.kernel.org; Tue, 11 Sep 2012 14:35:06 +0200
Received: from 193.137.168.40 ([193.137.168.40])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Sep 2012 14:35:04 +0200
Received: from shamalizadeh by 193.137.168.40 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Sep 2012 14:35:04 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Igor 'Lo' (=D0=98.L. <bombsiteunrested <at> gmail.com> writes:

>=20
> Hi all.
>=20
> What I look for is reimplementing a part of NFQUEUE functionality at
> the stage where TCP packet is formed before sending to network.
> It seems that NFQUEUE can't just handle expanded (> MTU) packet, and
> also want to have control over SEQ/ACK numbers assigned to
> both packets and connection structures.
>=20
> But errr.. where to look for? The sources are too complex and there's
> not enough guides.
> Actually I have this doc only:
> http://www.nsnam.org/wiki/index.php/GSOC2009Netfilter#Callback_Priori=
ty
>=20
> Can anyone point me to correct place in kernel sources to see/attach
> with SystemTap and track how SEQs are generated and how outgoing
> packets are planned to be fragmented or even dropped? Deliberately
> want a good tour.
>=20
> P.S. There's at least 2 projects that can benefit from such
> transparent packet size growing, one is mine and second is StegBox
> (steganography based covert channels in traffic)
>=20


Hi,
Have you ever got any solution for doing that?
I have been involved a project with this kind of problem.
In my project I need to put 32 byte more in IpOption. I did it and it w=
orks for
packet_length < (MTU-32). But for the packet_length > (MTU-32) each pac=
ket
should be fragmented with 2 packets. The problem is how can I use
nfq_set_verdict() for both of those packets?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
