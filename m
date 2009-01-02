From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: checksum calculation for an OUTPUT DNATted packet
Date: Sat, 3 Jan 2009 00:15:36 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901030013150.27495@fbirervta.pbzchgretzou.qr>
References: <885896af0901021447g3cdcf81as283779cfeacfe9b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41774 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZABXPj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:15:39 -0500
In-Reply-To: <885896af0901021447g3cdcf81as283779cfeacfe9b2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-02 23:47, Giacomo wrote:

>Hi to everybody.
>
>Implementing a kernel module that changes an IP or port in a packet in
>OUTPUT (realizing the so
>called OUTPUT DNAT), I have to recalculate the checksum of the packet.
>
>It is not clear to me if I have to use tcp_v4_check or csum_tcpudp_magic.

See the RAWDNAT branch of Xtables-addons where this is already done
(at least I hope it's correct - have not done much with it lately):

http://dev.medozas.de/gitweb.cgi?p=xtables-addons;a=blob;f=extensions/xt_RAWNAT.c;hb=RAWNAT#l73
