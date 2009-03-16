From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack_sip bug
Date: Mon, 16 Mar 2009 16:14:24 +0100
Message-ID: <49BE6CD0.1020803@trash.net>
References: <49B122A0.7080905@telegroup.com.ua> <49B76CD7.5030806@telegroup.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Andrew O. Zhukov" <andre@telegroup.com.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZCPPO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:14:28 -0400
In-Reply-To: <49B76CD7.5030806@telegroup.com.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andrew O. Zhukov wrote:
> No answers from netfilter list.
>=20
> I can exactly show the point where how this bug appeared include dump=
s=20
> from all points.
>=20
>=20
> Andrew O. Zhukov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> =D0=9Aernel 2.6.25.14-69.fc8
>> iptables-1.4.1.1-1.fc8.x86_64.rpm
>>
>> followed trouble:
>>
>> SIP gw                  Fedora               SipProxy      =D0=90ste=
risk
>> 192.168.2.24   192.168.2.1 666.666.34.46  555.555.184.13  555.555.18=
4.13
>>
>> Sip proxy without RTP proxy for not nat cusomers. It considetate SIP=
=20
>> GW as 666.666.34.46 and do not switch on RTP proxy.
>>
>> call from SIP GW to Asterisk. Dump from Fedor=D0=B0:
>>
>> U 2009/03/05 21:00:11.899191 555.555.184.13:5060 -> 192.168.2.24:506=
0
>>   SIP/2.0 183 Session Progress..Via: SIP/2.0/UDP=20
>> 555.555.184.13:5060;branch=3Dz9hG4bK878912355;rport=3D1025..From: "2=
12ua1"=20
>> <sip
>>   :101563@xxx.com>;tag=3D66346232..To:=20
>> <sip:2292694@xxx.com>;tag=3Das41f52f95..Call-ID:=20
>> 1295544592-5060-4@192.168.2.24..
>> .....
>> ..Contact: <sip:2292694@555.555.184.2>..Content-Type:=20
>> application/sdp..Content-Length: 263....v=3D0..o=3Droot 277
>>   97 27797 IN IP4 555.555.184.2..s=3Dsession..c=3DIN IP4 555.555.184=
=2E2..t=3D0
>>
>> ---
>> 180 Ringing without sdp
>> ---
>>
>> U 2009/03/05 21:00:20.753646 555.555.184.13:5060 -> 192.168.2.24:506=
0
>>   SIP/2.0 200 OK..Via: SIP/2.0/UDP=20
>> 555.555.184.13:5060;branch=3Dz9hG4bK878912355;rport=3D1025..Record-R=
oute:=20
>> <sip:555.555.184.13;
>>   lr=3Don;ftag=3D66346232>..From: "212ua1"=20
>> <sip:101563@xxx.com>;tag=3D66346232..To:=20
>> <sip:2292694@xxx.com>;tag=3Das41f52f95..C
>>   all-ID: 1295544592-5060-4@192.168.2.24..CSeq: 31 INVITE..User-Agen=
t:=20
>> Telegroup Ukraine..Allow: INVITE, ACK, CANCEL, OPTIO
>>   NS, BYE, REFER, SUBSCRIBE, NOTIFY..Supported: replaces..Contact:=20
>> <sip:2292694@555.555.184.2>..Content-Type: application/sd
>>   p..Content-Length: 265....v=3D0..o=3Droot 27797 27798 IN IP4=20
>> 555.555.184.13..s=3Dsession..c=3DIN IP4 555.555.184.13..t=3D0 0..m=3D=
audio
>>    29444 RTP/AVP 18 101..a=3Drtpmap:18 G729/8000..a=3Dfmtp:18=20
>> annexb=3Dno..a=3Drtpmap:101 telephone-event/8000..a=3Dfmtp:101 0-16.=
=2Ea=3D
>>   silenceSupp:off - - - -..a=3Dptime:20..a=3Dsendrecv..
>>
>> in the "OK" message =D0=90sterisk ip addresses in SDP changed to the=
 ip=20
>> addresses of SipProxy by sip_conntrack. I can provide DUMP from the=20
>> SipProxy and the complete set of dumps for developers.
>>
>> Thanks in advance.

There's a lot of addresses in there :) Could you please point to the
exact header which got rewritten incorrectly?

Also, please post the module parameters you're using when loading the
SIP conntrack/NAT modules.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
