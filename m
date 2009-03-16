From: "Andrew O. Zhukov" <andre@telegroup.com.ua>
Subject: Re: conntrack_sip bug
Date: Mon, 16 Mar 2009 17:42:45 +0200
Message-ID: <49BE7375.8070503@telegroup.com.ua>
References: <49B122A0.7080905@telegroup.com.ua> <49B76CD7.5030806@telegroup.com.ua> <49BE6CD0.1020803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from red.telegroup.kiev.ua ([193.28.184.10]:35725 "EHLO
	red.telegroup.kiev.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZCPPmr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:42:47 -0400
In-Reply-To: <49BE6CD0.1020803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> Andrew O. Zhukov wrote:
>> No answers from netfilter list.
>>
>> I can exactly show the point where how this bug appeared include dum=
ps=20
>> from all points.
>>
>>
>> Andrew O. Zhukov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> =D0=9Aernel 2.6.25.14-69.fc8
>>> iptables-1.4.1.1-1.fc8.x86_64.rpm
>>>
>>> followed trouble:
>>>
>>> SIP gw                  Fedora               SipProxy      =D0=90st=
erisk
>>> 192.168.2.24   192.168.2.1 666.666.34.46  555.555.184.13  555.555.1=
84.13
>>>
>>> Sip proxy without RTP proxy for not nat cusomers. It considetate SI=
P=20
>>> GW as 666.666.34.46 and do not switch on RTP proxy.
>>>
>>> call from SIP GW to Asterisk. Dump from Fedor=D0=B0:
>>>
>>> U 2009/03/05 21:00:11.899191 555.555.184.13:5060 -> 192.168.2.24:50=
60
>>>   SIP/2.0 183 Session Progress..Via: SIP/2.0/UDP=20
>>> 555.555.184.13:5060;branch=3Dz9hG4bK878912355;rport=3D1025..From:=20
>>> "212ua1" <sip
>>>   :101563@xxx.com>;tag=3D66346232..To:=20
>>> <sip:2292694@xxx.com>;tag=3Das41f52f95..Call-ID:=20
>>> 1295544592-5060-4@192.168.2.24..
>>> .....
>>> ..Contact: <sip:2292694@555.555.184.2>..Content-Type:=20
>>> application/sdp..Content-Length: 263....v=3D0..o=3Droot 277
>>>   97 27797 IN IP4 ___555.555.184.2_____..s=3Dsession..c=3DIN IP4 __=
_555.555.184.2_____..t=3D0

It's the real address of rtp stream

>>>
>>> ---
>>> 180 Ringing without sdp
>>> ---
>>>
>>> U 2009/03/05 21:00:20.753646 555.555.184.13:5060 -> 192.168.2.24:50=
60
>>>   SIP/2.0 200 OK..Via: SIP/2.0/UDP=20
>>> 555.555.184.13:5060;branch=3Dz9hG4bK878912355;rport=3D1025..Record-=
Route:=20
>>> <sip:555.555.184.13;
>>>   lr=3Don;ftag=3D66346232>..From: "212ua1"=20
>>> <sip:101563@xxx.com>;tag=3D66346232..To:=20
>>> <sip:2292694@xxx.com>;tag=3Das41f52f95..C
>>>   all-ID: 1295544592-5060-4@192.168.2.24..CSeq: 31=20
>>> INVITE..User-Agent: Telegroup Ukraine..Allow: INVITE, ACK, CANCEL, =
OPTIO
>>>   NS, BYE, REFER, SUBSCRIBE, NOTIFY..Supported: replaces..Contact:=20
>>> <sip:2292694@555.555.184.2>..Content-Type: application/sd
>>>   p..Content-Length: 265....v=3D0..o=3Droot 27797 27798 IN IP4=20
>>> ______555.555.184.13___________..s=3Dsession..c=3DIN IP4 __________=
_555.555.184.13_________..t=3D0 0..m=3Daudio

Here !!! You try to fix this packet. As the result inside GW send RTP t=
o
555.555.184.13 instead  555.555.184.2

>>>    29444 RTP/AVP 18 101..a=3Drtpmap:18 G729/8000..a=3Dfmtp:18=20
>>> annexb=3Dno..a=3Drtpmap:101 telephone-event/8000..a=3Dfmtp:101 0-16=
=2E.a=3D
>>>   silenceSupp:off - - - -..a=3Dptime:20..a=3Dsendrecv..
>>>
>>> in the "OK" message =D0=90sterisk ip addresses in SDP changed to th=
e ip=20
>>> addresses of SipProxy by sip_conntrack. I can provide DUMP from the=
=20
>>> SipProxy and the complete set of dumps for developers.
>>>
>>> Thanks in advance.
>=20
> There's a lot of addresses in there :) Could you please point to the
> exact header which got rewritten incorrectly?

I even find it in sources several minutes before send this post.

Look at nf_conntrack_sip.c
after comments
/* RTP info only in some SDP pkts */

You change SDP in outgoing and incoming packets. However, you have to d=
o=20
it only for outgoing. Otherwise, like in this example You'll have a=20
trouble with RTP in connecttion over SIP Proxy without RTP Proxy.


>=20
> Also, please post the module parameters you're using when loading the
> SIP conntrack/NAT modules.

Actually I do not load this module. It's default Fedora 8 package.
Even if I unload module using rmod , modprobe -r etc.. it continue
break packets... :(

> --=20
> To unsubscribe from this list: send the line "unsubscribe=20
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Andrew O. Zhukov
Telegroup Ukraine
Technical director.
Phone 380-44-2308228
Cell 380-67-4017256
=46ax 380-44-2386027
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
