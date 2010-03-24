From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: debugging kernel during packet drops
Date: Wed, 24 Mar 2010 17:28:35 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003241727080.29135@obet.zrqbmnf.qr>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>  <4BA8DAC5.6050002@infopact.nl> <1269364893.2983.296.camel@edumazet-laptop>  <4BAA2DC5.7000409@infopact.nl> <1269447674.3213.64.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jorrit Kronjee <j.kronjee@infopact.nl>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40663 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0CXQ2g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:28:36 -0400
In-Reply-To: <1269447674.3213.64.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-24 17:21, Eric Dumazet wrote:
>dsthash_find() takes a lot of cpu, its a sign your hash table params
>might be suboptimal.
>
>Please send us "iptables -nvL" 

Consider using "iptables-save" instead, because -nvL is just
an abridged tabular display.
