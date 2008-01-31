From: Patrick McHardy <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 31 Jan 2008 19:53:57 +0100
Message-ID: <47A21945.2050005@trash.net>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>  <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>  <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>  <47A07FEA.3000702@trash.net>  <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>  <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>  <47A13573.7090804@trash.net>  <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>  <47A13FBD.8050803@trash.net> <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com> <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56444 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767AbYAaSyD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:54:03 -0500
In-Reply-To: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Jeff,
> 
> On Thu, 31 Jan 2008, Jeff Chua wrote:
> 
>> On the bad run, I got the following message ...
>>
>> boston kernel: nf_ct_tcp: invalid packed ignored IN= OUT=
>> SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=8162
>> DF PROTO=TCP SPT=1016 DPT=515 SEQ=3834958843 ACK=0 WINDOW=32792
>> RES=0x00 SYN URGP=0 OPT (0204400C0402080A0000CC190000000001030307)
>> UID=0 GID=65534
> 
> I can't find this packet in the last lo.bad pcap file. Could you dump the 
> bad traffic and send it together with the generated log record?
> 
> Strange, but there are a lot of incorrect checksum packets. How does it 
> come on the loopback interface?


Loopback doesn't perform full checksumming, so thats expected.
Current kernel versions can tell userspace that its only a
partial checksum, but I'm not sure whether tcpdump already
supports this.
