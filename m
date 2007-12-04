From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 4 Dec 2007 09:51:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
 <4753B957.2000207@trash.net> <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>
 <47550D5C.8090004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Salatiel Filho <salatiel.filho@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36973 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbXLDIvb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:51:31 -0500
In-Reply-To: <47550D5C.8090004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 4 2007 09:18, Patrick McHardy wrote:
> Salatiel Filho wrote:
>> On Dec 3, 2007 5:07 AM, Patrick McHardy <kaber@trash.net> wrote:
>> > Salatiel Filho wrote:
>>
>> > > # iptables -L
>> > > iptables v1.3.6: can't initialize iptables table `filter': Bad file
>> > > descriptor
>> > > Perhaps iptables or your kernel needs to be upgraded.
>> > >
>> > > My machine is a ARM machine with debian 4.0.
>> > > I also have already tried 1.3.8 and got the same error.
>> >
>> > Which kernel version (please also send .config)? Did you compile
>> > iptables yourself or used a version from Debian?
>> >

This looks more like an userspace issue. The strace log shows that the
netlink socket was obtained, but calls setsockopt with fd=-1.
Just a guess, though.
