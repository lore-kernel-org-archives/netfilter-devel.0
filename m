From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 22:23:52 +0000
Message-ID: <4D0D3478.30509@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.LNX.2.01.1012182304360.30262@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1012182304360.30262@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



Jan Engelhardt wrote:
> On Saturday 2010-12-18 22:51, Mr Dash Four wrote:
>   
>>> Members:
>>> 192.168.0.0,tcp:80
>>> 192.168.0.1,tcp:53
>>> 192.168.0.1,tcp:80
>>> 192.168.0.2,tcp:80
>>> 192.168.0.1,udp:53
>>> 192.168.0.3,tcp:80
>>>       
>> By 'something' I mean either omission of the protocol, or 'all' to
>> be specified instead of the protocol to mean no matching on protocol
>> would be made (in other words the protocol to be disregarded).
>>     
>
> If you don't check the protocol, you cannot know if there even is
> a port number. Not all L4 protocols have ports.
>   
OK, let me rephrase that: I do not wish to add 2x times as many members 
in a particular set when I am not interested in the protocol match - 
whether it is tcp or udp for me is irrelevant, all I am interested in is 
the ip subnet and the port number.
