From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 18:46:27 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091844220.3866@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
 <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr>
 <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr> <47FCD954.5000308@trash.net> <alpine.LNX.1.10.0804091710070.3866@fbirervta.pbzchgretzou.qr>
 <47FCDD9D.7050905@trash.net> <alpine.LNX.1.10.0804091819380.3866@fbirervta.pbzchgretzou.qr> <47FCF047.3000202@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51038 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYDIQq2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:46:28 -0400
In-Reply-To: <47FCF047.3000202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 18:35, Patrick McHardy wrote:
>
>> A few concerns.
>> If so, how would you deal with the addition of a new, real,
>> protocol? Suppose someone added support for the
>> semifictional IPv5, say  AF_INET5=42 or so. How would
>> this affect the NFPROTO list?
>
> It wouldn't since those values simply have seperate
> meanings. AF_INET5 might be 42, NFPROTO_INET5 could
> be .. lets say 5.
>
Then the big question is: what do you store in
ct->tuplehash[0].src.l3num, AF_INET5 or NFPROTO_IPV5?
Probably NFPROTO_IPV5.
Ok, then the only issue - if there is such - is when
AF_ values from the networking code pass into netfilter territory,
then you would need a translation function.
