From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Invalid SACK numbers in NAT'ed packets
Date: Fri, 25 Apr 2008 12:57:03 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804251256530.11644@fbirervta.pbzchgretzou.qr>
References: <funk78$srq$1@ger.gmane.org> <Pine.LNX.4.64.0804232126040.28881@blackhole.kfki.hu> <00c101c8a5ea$d83213f0$5101a8c0@csltd.intranet> <Pine.LNX.4.64.0804241130040.30382@blackhole.kfki.hu> <006b01c8a6b1$884da030$5101a8c0@csltd.intranet>
 <Pine.LNX.4.64.0804251059510.5340@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Leonid Zeitlin <lz@csltd.com.ua>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34636 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYDYK5F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:57:05 -0400
In-Reply-To: <Pine.LNX.4.64.0804251059510.5340@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-04-25 11:02, Jozsef Kadlecsik wrote:

>On Fri, 25 Apr 2008, Leonid Zeitlin wrote:
>
>> It appears that short of writing a custom netfilter extension, there's no way
>> to turn off SACKs on a particular connection. Is this right?
>
>Yes, exactly. Actually, writing a new extension to erase any TCP option 
>isn't that hard: just replace the option with noop and recalculate the 
>checksum.

There is already a TCPOPTSTRIP target.
