From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Sat, 22 Dec 2007 08:56:53 +0100
Message-ID: <476CC345.7050108@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>	 <47696AE9.6090201@trash.net>	 <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>	 <476A3E93.3010400@trash.net>	 <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>	 <476A4CE7.4070607@trash.net>	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>	 <476A5130.6050800@trash.net> <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Damien Th=E9bault wrote:
> On Dec 20, 2007 12:25 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Thanks. Could you also post a tcpdump and enable conntrack logging
>> by doing "echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid=
"
>> and post the output of that, if any (you also need to load ipt_LOG
>> in case you're not using some other logging backend).
>>
>=20
> I captured three times. The first time ("bad1" files), the reply is
> coming back, but the ftp client doesn't seem to handle it. The second
> time ("bad2" files), there is a problem with sequence numbers. And
> then the last time ("good" files), it's ok.
>=20
> I had sequence number errors without the previous bridge patch which
> get merged in net-2.6. So I'll try again with the net-2.6 kernel.


Yes, the captures show the effects from the double POSTROUTING
invocation. Could you send me captures from the current net-2.6
tree?


