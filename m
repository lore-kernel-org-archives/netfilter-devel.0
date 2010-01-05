From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack event missing TCP protoinfo
Date: Tue, 05 Jan 2010 20:19:12 +0100
Message-ID: <4B4390B0.7090009@netfilter.org>
References: <200912311403.21983.rui.p.m.sousa@gmail.com> <4B3CE8DE.4020701@netfilter.org> <201001041903.21755.rui.p.m.sousa@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Rui Sousa <rui.p.m.sousa@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0AETSw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:18:52 -0500
In-Reply-To: <201001041903.21755.rui.p.m.sousa@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Rui,

Rui Sousa wrote:
> I believe so, but I having a hard time understanding what I'm seeing.
> AFAICT, I'm exercising the state transition sNo->sES->sES, my procedure is:
> 
> PC1 -> linux router -> PC2
> 
> 1. establish TCP connection between two PC's (using iperf). PC1 is the client, 
> PC2 is the server.
> 2. On the router, ifdown of output interface (the interface on PC2 side)
> 3. On the router, manual destroy of connection in kernel
> 4. On the router, ifup of output interface
> 5. wait for iperf to start sending packets again. The connection between the 
> endpoints is always established.
> 
> Between 3 and 4 I receive a NFCT_DESTROY event (from libnetfilter_conntrack).
> During 5. I get two events, both NFCT_UPDATEs, the first with conntrack status 
> CONFIRMED/SEEN_REPLY, the second with conntrack status ASSURED. Both are 
> missing the TCP protoinfo. In this is my problem, the kernel correctly picked 
> up the on going TCP connection but never sends enough information to 
> userspace about it.

Good analysis. Since Linux kernel 2.6.30, you should see a NFCT_NEW 
event (for conntracks that have been created via ctnetlink) before you 
get the two NFCT_UPDATE events. The NFCT_NEW contains the TCP protocol 
state.

I guess that you're using an older Linux kernel.
