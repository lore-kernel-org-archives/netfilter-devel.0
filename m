From: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Subject: Another issue with ipset on sparc64
Date: Thu, 5 Nov 2009 17:57:07 +0000
Message-ID: <4513233BE7DF454BB62D30017EEE55436CFB992FEF@GVW1115EXC.americas.hpqcorp.net>
References: <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23795 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529AbZKER5U convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:57:20 -0500
In-Reply-To: <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I found another issue with ipset on sparc64 (Ultra2, 2 CPU, 2.6.31.5,
Debian5).
When I flush an iptreemap, one (of two) ksoftirqd goes up to 25% CPU
load and remains there until I delete the set. I don't have to place
anything in the map, just doing "ipset -N abc iptreemap; ipset -F abc" is
enough. Doing that again with another map will add 25% load to the
second ksoftirqd. Adding more maps will not change things further.

Regards
       Georg Chini
