From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: register callback for special packet types like udp and icmp?
Date: Fri, 11 Apr 2008 14:41:56 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804111440310.21182@fbirervta.pbzchgretzou.qr>
References: <47FF5B62.1040600@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Mader <thezema@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33520 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053AbYDKMl5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:41:57 -0400
In-Reply-To: <47FF5B62.1040600@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-04-11 14:36, Thomas Mader wrote:

> Hello,
>
> is there a way to define callback (match) functions for special packet types
> like udp and icmp? I would like to have a match function which only reacts on
> udp and icmp packets. Is this possible in a kernelspace module and/or in a
> libnetfilter_queue daemon and how?

Both would work. For kernel modules, it's as simple as
specifying .proto = IPPROTO_UDP or IPPROTO_ICMP, see
http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
