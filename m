From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Sun, 30 Dec 2007 18:53:51 +0100
Message-ID: <4777DB2F.4010307@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <47696AE9.6090201@trash.net>	 <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>	 <476A3E93.3010400@trash.net>	 <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>	 <476A4CE7.4070607@trash.net>	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>	 <476A5130.6050800@trash.net>	 <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>	 <476CC345.7050108@trash.net> <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Damien Th=E9bault wrote:
> On Dec 22, 2007 8:56 AM, Patrick McHardy <kaber@trash.net> wrote:
>> Yes, the captures show the effects from the double POSTROUTING
>> invocation. Could you send me captures from the current net-2.6
>> tree?
>>    =20
>
> Sure, here they are.
> (I used David Miller's net-2.6.25 at 75fa3253609430f28da005da494ce5ad=
3b5c78a1 )
>  =20

Thanks. They still show the double POST_ROUTING effects (the retransmit=
ted
\0a), but I can't figure out why this would be happening. Please add TR=
ACE
rules in both directions for the FTP control traffic and post the outpu=
t.
This will allow to verify that we're indeed dealing with double hook
invocations and not some other bug:

modprobe ipt_LOG
iptables -t raw -A OUTPUT -p tcp --dport 21 -j TRACE
iptables -t raw -A OUTPUT -p tcp --sport 21 -j TRACE
iptables -t raw -A PREROUTING -p tcp --dport 21 -j TRACE
iptables -t raw -A PREROUTING -p tcp --sport 21 -j TRACE

Thanks.


