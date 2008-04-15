From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: AW: Add new target in mangle table
Date: Tue, 15 Apr 2008 11:52:06 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804151149070.9651@fbirervta.pbzchgretzou.qr>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de> <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr> <20080414163449.293250@gmx.net> <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr> <20080415083543.20880@gmx.net>
 <alpine.LNX.1.10.0804151046120.9651@fbirervta.pbzchgretzou.qr> <20080415092052.107670@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: manuel scheub <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40535 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbYDOJwI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:52:08 -0400
In-Reply-To: <20080415092052.107670@gmx.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-04-15 11:20, manuel scheub wrote:
>> >
>> >I modified the udhcpd from the busybox  - have a look in the attached
>> >file.
>> >To handle the different cases i wrote a shell script - also attached.
>> 
>> But if the client uses DHCP, why don't you hand out 10.0.x.x directly?
>
>If the client uses DHCP, i do hand out 10.0.x.x directly! The
>modified dhcpd listens on all requests, it doesn't matter if it is
>not a dhcp-request.

But there is only DHCPINFORM which might carry a non 10.0.x.x
address.
I think it's simpler if you just add 192.168.0.0/16 as an
address to eth0.

