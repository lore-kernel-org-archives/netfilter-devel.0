From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Mon, 28 Feb 2011 18:04:46 +0100
Message-ID: <4D6BD5AE.4040801@trash.net>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence> <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu> <4D695E73.2090006@netfilter.org> <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu> <4D698FCB.6060205@netfilter.org> <4D699421.4070309@netfilter.org> <4D6A6C36.9050402@trash.net> <alpine.DEB.2.00.1102271827150.24122@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57696 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1B1REt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:04:49 -0500
In-Reply-To: <alpine.DEB.2.00.1102271827150.24122@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 27.02.2011 18:28, schrieb Jozsef Kadlecsik:
>>> > > Hm, I forgot to include the description. New patch attached.
>> > 
>> > Thanks. I'll apply this tommorrow, assuming Jozsef is fine with
>> > this version.
> Yes, of course
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks everyone.
