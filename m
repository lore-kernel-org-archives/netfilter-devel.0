From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 23:10:47 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012182304360.30262@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D0D2CF4.5070201@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Saturday 2010-12-18 22:51, Mr Dash Four wrote:
>> Members:
>> 192.168.0.0,tcp:80
>> 192.168.0.1,tcp:53
>> 192.168.0.1,tcp:80
>> 192.168.0.2,tcp:80
>> 192.168.0.1,udp:53
>> 192.168.0.3,tcp:80
>
>By 'something' I mean either omission of the protocol, or 'all' to
>be specified instead of the protocol to mean no matching on protocol
>would be made (in other words the protocol to be disregarded).

If you don't check the protocol, you cannot know if there even is
a port number. Not all L4 protocols have ports.
