From: Patrick McHardy <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Date: Wed, 30 Jan 2008 14:47:22 +0100
Message-ID: <47A07FEA.3000702@trash.net>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu> <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
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
Received: from stinky.trash.net ([213.144.137.162]:51601 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYA3Nri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:47:38 -0500
In-Reply-To: <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jeff Chua wrote:
> On Jan 29, 2008 6:53 PM, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> 
>> As the problem can be reproduced so easily, could you capture a full TCP
>> session and send the pcap file? Thus it could be analyzed, replayed, etc.
>> and found the reason why the patch above slows down the printing.
>> By reverting back it we loose TCP reopening support.
> 
> Not an expert here. I use 'tcpdump -i lo' and don't see anything
> different between the good and bad.  Anyway, attached are the good and
> bad log files.
> 
> There's a slight pause of 27 seconds after 502 jobs (both good and bad
> runs), then the good one will resume and transmit in burst until
> completing all the 1000 times. The bad run will resume and transmit
> one-by-one every 3 seconds.
> 
> Please tell me what options to use with tcpdump to dump more useful output.


A binary dump would be more useful:

tcpdump -i lo -w <outfile>

and I guess Jozsef also wants "-s 0" so the full packets are included.
