From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables hashlimit ipmask support
Date: Thu, 28 Feb 2008 21:44:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802282141420.4324@fbirervta.pbzchgretzou.qr>
References: <2e77fc10802281140i59eee398t794a429db006b22a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Niki Denev <ndenev@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52888 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763502AbYB1Uok (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:44:40 -0500
In-Reply-To: <2e77fc10802281140i59eee398t794a429db006b22a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 28 2008 21:40, Niki Denev wrote:
>
>Recently i needed to be able to do exactly what iptables with hashlimit does,
>but instead of hashing by IP i wanted it to hash on arbitrary network mask.
>So, i've hacked up this, and i hope that you could find it useful.

Such has already been merged by me for 2.6.25.

>P.S. : There is no ipv6 support, and the manpage is not updated to
>reflect the new hashlimit option --hashlimit-ipmask

I also had added that.

>P.S.2: I know that this probably can be done with connlimit, but
>hashlimit can also do limiting on the destination ip (dstip mode)
>which i think is not possible with connlimit.

Connlimit works on connection tuples, so would be equal to
 --hashlimit-mode srcip,dstip,srcport,dstport
