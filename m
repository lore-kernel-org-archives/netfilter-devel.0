From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Sat, 10 Nov 2012 20:13:43 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Wilson <chris@aptivate.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:44676 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2KJTNo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Nov 2012 14:13:44 -0500
In-Reply-To: <20121110140720.GA9610@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-11-10 15:07, Pablo Neira Ayuso wrote:

>On Thu, Nov 08, 2012 at 06:37:24PM +0000, Chris Wilson wrote:
>[...]
>> >>Another option which doesn't violate layering might be to update
>> >>the NAT rule when the outgoing address is known (after routing),
>> >
>> >That is what MASQUERADE is usually for.
>> 
>> Unfortunately I am using MASQUERADE and this still happens. If it
>> could just be fixed in the MASQUERADE target that would be a big
>> win.
>
>MASQUERADE already cleans up the entries in the conntrack table once
>you get your device down, that code is still there in 2.6.18:
>
>http://lxr.linux.no/#linux+v2.6.18/net/ipv4/netfilter/ipt_MASQUERADE.c#L111

It looks like it only catches the case of a changing ifindex.

That may work for PPP links, but if you access the 'net over an
Ethernet-looking link as is (thankfully) done by cable ISPs,
the interface will never go away.

The DHCP client will simply change one or more addresses on it -- and
at the same time I wonder if that makes it a "you should run
conntrack -F or something from your dhclient.script" case.
