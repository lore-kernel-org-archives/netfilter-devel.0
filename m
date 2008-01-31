From: Patrick McHardy <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 31 Jan 2008 03:41:55 +0100
Message-ID: <47A13573.7090804@trash.net>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>	 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>	 <47A07FEA.3000702@trash.net>	 <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com> <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	lkml <linux-kernel@vger.kernel.org>,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35438 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYAaCmd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:42:33 -0500
In-Reply-To: <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jeff Chua wrote:
> On Jan 31, 2008 10:23 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>   
>> Again, using latest linux, one with
>> 17311393f969090ab060540bd9dbe7dc885a76d5 reverted, and the other
>> without.
>>     
>
> Sorry, here's the attached output files.

Thanks. In the dump we can see that connections reusing ports
always have their first SYN dropped and retransmissted three
seconds later. I'm not sure whats causing this yet, do you have
any firewall rules that affect loopback traffic?

This filter (wireshark) shows one example of the problem in case
someone else wants to have a look:

(tcp.dstport == 1017 || tcp.srcport == 1017) && (tcp.flags == 0x02)

