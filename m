From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Fri, 11 Jan 2008 13:24:51 +0100
Message-ID: <47876013.2040405@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>	 <476A4CE7.4070607@trash.net>	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>	 <476A5130.6050800@trash.net>	 <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>	 <476CC345.7050108@trash.net>	 <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>	 <4777DB2F.4010307@trash.net>	 <9a4a382a0801020118n4166e505l5eb84a9f07f620be@mail.gmail.com> <9a4a382a0801110010h3b4ed334sb53392ab564c00b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-1?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <9a4a382a0801110010h3b4ed334sb53392ab564c00b5@mail.gmail.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Damien Th=E9bault wrote:
> 2008/1/2 Damien Th=E9bault <damien.thebault@gmail.com>:
>  =20
>> On Dec 30, 2007 6:53 PM, Patrick McHardy <kaber@trash.net> wrote:
>>    =20
>>> Thanks. They still show the double POST_ROUTING effects (the retran=
smitted
>>> \0a), but I can't figure out why this would be happening. Please ad=
d TRACE
>>> rules in both directions for the FTP control traffic and post the o=
utput.
>>> This will allow to verify that we're indeed dealing with double hoo=
k
>>> invocations and not some other bug:
>>>
>>> modprobe ipt_LOG
>>> iptables -t raw -A OUTPUT -p tcp --dport 21 -j TRACE
>>> iptables -t raw -A OUTPUT -p tcp --sport 21 -j TRACE
>>> iptables -t raw -A PREROUTING -p tcp --dport 21 -j TRACE
>>> iptables -t raw -A PREROUTING -p tcp --sport 21 -j TRACE
>>>      =20
> I tried to use the patch I created earlier (the one adding the hooks
> again). I said it worked but it does not everytime.
>
> By the way, Patrick, what do you think about this bug? Maybe I
> shouldn't rely on bridges but it's a useful feature sometimes.
>  =20

No, this should work properly. I just tried to reproduce it,
but I only get a single POSTROUTING invocation. I tried with
real bridged traffic, traffic routed between two different
bridge devices and traffic routed between a bridge device
and a normal ethernet device, but everything seems to work
correctly.

Could you send me the commands you're using to configure
your setup and everything (routing, iptables, ...) that
could be related?




