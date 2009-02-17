From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 19:25:13 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902171924340.23002@fbirervta.pbzchgretzou.qr>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Joe Pruett <joey@clean.q7.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52174 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZBQSZP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:25:15 -0500
In-Reply-To: <499B0097.4000505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-17 19:23, Patrick McHardy wrote:
> Joe Pruett wrote:
>> trying this again on the -devel list.  the basic question i'm trying to answer
>> is if there really isn't a way to filter esp/ah packets after
>> decryption/decapsulation in host2host mode.  i've looked at what i think is
>> the current linus kernel and don't see any changes to esp/ah handling to
>> address this.  is tunnel mode the only way i can do filtering on the packets
>> after ah/esp have done their work?
>
> Packets in both tunnel and transport mode traverse the netfilter hooks
> after decapsulation and before encapsulation. From a users POV there
> should be nothing special about it.

Precisely, see http://jengelh.medozas.de/images/nf-packet-flow.png .
