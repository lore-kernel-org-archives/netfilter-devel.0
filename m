From: "Andrew O. Zhukov" <andre@telegroup.com.ua>
Subject: conntrack_sip bug
Date: Wed, 11 Mar 2009 09:48:39 +0200
Message-ID: <49B76CD7.5030806@telegroup.com.ua>
References: <49B122A0.7080905@telegroup.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from red.telegroup.kiev.ua ([193.28.184.10]:45320 "EHLO
	red.telegroup.kiev.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZCKHsm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:48:42 -0400
Received: from andrew.telegroup.com.ua ([10.0.1.4]:46214)
	by red.telegroup.kiev.ua with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.62)
	(envelope-from <andre@telegroup.com.ua>)
	id 1LhJB8-0003qO-Vf
	for netfilter-devel@vger.kernel.org; Wed, 11 Mar 2009 09:48:39 +0200
In-Reply-To: <49B122A0.7080905@telegroup.com.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No answers from netfilter list.

I can exactly show the point where how this bug appeared include dumps=20
from all points.


Andrew O. Zhukov =D0=C9=DB=C5=D4:
> =EBernel 2.6.25.14-69.fc8
> iptables-1.4.1.1-1.fc8.x86_64.rpm
>=20
> followed trouble:
>=20
> SIP gw                  Fedora               SipProxy      =E1sterisk
> 192.168.2.24   192.168.2.1 666.666.34.46  555.555.184.13  555.555.184=
=2E13
>=20
> Sip proxy without RTP proxy for not nat cusomers. It considetate SIP =
GW=20
> as 666.666.34.46 and do not switch on RTP proxy.
>=20
> call from SIP GW to Asterisk. Dump from Fedor=C1:
>=20
> U 2009/03/05 21:00:11.899191 555.555.184.13:5060 -> 192.168.2.24:5060
>   SIP/2.0 183 Session Progress..Via: SIP/2.0/UDP=20
> 555.555.184.13:5060;branch=3Dz9hG4bK878912355;rport=3D1025..From: "21=
2ua1" <sip
>   :101563@xxx.com>;tag=3D66346232..To:=20
> <sip:2292694@xxx.com>;tag=3Das41f52f95..Call-ID:=20
> 1295544592-5060-4@192.168.2.24..
> .....
> ..Contact: <sip:2292694@555.555.184.2>..Content-Type:=20
> application/sdp..Content-Length: 263....v=3D0..o=3Droot 277
>   97 27797 IN IP4 555.555.184.2..s=3Dsession..c=3DIN IP4 555.555.184.=
2..t=3D0
>=20
> ---
> 180 Ringing without sdp
> ---
>=20
> U 2009/03/05 21:00:20.753646 555.555.184.13:5060 -> 192.168.2.24:5060
>   SIP/2.0 200 OK..Via: SIP/2.0/UDP=20
> 555.555.184.13:5060;branch=3Dz9hG4bK878912355;rport=3D1025..Record-Ro=
ute:=20
> <sip:555.555.184.13;
>   lr=3Don;ftag=3D66346232>..From: "212ua1"=20
> <sip:101563@xxx.com>;tag=3D66346232..To:=20
> <sip:2292694@xxx.com>;tag=3Das41f52f95..C
>   all-ID: 1295544592-5060-4@192.168.2.24..CSeq: 31 INVITE..User-Agent=
:=20
> Telegroup Ukraine..Allow: INVITE, ACK, CANCEL, OPTIO
>   NS, BYE, REFER, SUBSCRIBE, NOTIFY..Supported: replaces..Contact:=20
> <sip:2292694@555.555.184.2>..Content-Type: application/sd
>   p..Content-Length: 265....v=3D0..o=3Droot 27797 27798 IN IP4=20
> 555.555.184.13..s=3Dsession..c=3DIN IP4 555.555.184.13..t=3D0 0..m=3D=
audio
>    29444 RTP/AVP 18 101..a=3Drtpmap:18 G729/8000..a=3Dfmtp:18=20
> annexb=3Dno..a=3Drtpmap:101 telephone-event/8000..a=3Dfmtp:101 0-16..=
a=3D
>   silenceSupp:off - - - -..a=3Dptime:20..a=3Dsendrecv..
>=20
> in the "OK" message =E1sterisk ip addresses in SDP changed to the ip=20
> addresses of SipProxy by sip_conntrack. I can provide DUMP from the=20
> SipProxy and the complete set of dumps for developers.
>=20
> Thanks in advance.
>=20
>=20


--=20
Andrew O. Zhukov
Telegroup Ukraine
Technical director.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
