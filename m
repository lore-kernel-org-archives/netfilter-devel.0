From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack event missing TCP protoinfo
Date: Tue, 05 Jan 2010 21:39:42 +0100
Message-ID: <4B43A38E.4010104@netfilter.org>
References: <200912311403.21983.rui.p.m.sousa@gmail.com> <4B3CE8DE.4020701@netfilter.org> <201001041903.21755.rui.p.m.sousa@gmail.com> <4B4390B0.7090009@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Rui Sousa <rui.p.m.sousa@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39613 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab0AEUjY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:39:24 -0500
In-Reply-To: <4B4390B0.7090009@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Rui Sousa wrote:
>> I believe so, but I having a hard time understanding what I'm seeing.
>> AFAICT, I'm exercising the state transition sNo->sES->sES, my 
>> procedure is:
>>
>> PC1 -> linux router -> PC2
>>
>> 1. establish TCP connection between two PC's (using iperf). PC1 is the 
>> client, PC2 is the server.
>> 2. On the router, ifdown of output interface (the interface on PC2 side)
>> 3. On the router, manual destroy of connection in kernel
>> 4. On the router, ifup of output interface
>> 5. wait for iperf to start sending packets again. The connection 
>> between the endpoints is always established.
>>
>> Between 3 and 4 I receive a NFCT_DESTROY event (from 
>> libnetfilter_conntrack).
>> During 5. I get two events, both NFCT_UPDATEs, the first with 
>> conntrack status CONFIRMED/SEEN_REPLY, the second with conntrack 
>> status ASSURED. Both are missing the TCP protoinfo. In this is my 
>> problem, the kernel correctly picked up the on going TCP connection 
>> but never sends enough information to userspace about it.
> 
> Good analysis. Since Linux kernel 2.6.30, you should see a NFCT_NEW 
> event (for conntracks that have been created via ctnetlink) before you 
> get the two NFCT_UPDATE events. The NFCT_NEW contains the TCP protocol 
> state.

Oh, I read your email badly, sorry. Your using the pickup facility of 
the TCP tracking.

I cannot reproduce the problem following your steps, I'm using conntrack 
-F, the loopback device and some netcat commands:

[DESTROY] tcp      6 src=127.0.0.1 dst=127.0.0.1 sport=58383 dport=8000 
packets=2 bytes=112 src=127.0.0.1 dst=127.0.0.1 sport=8000 dport=58383 
packets=1 bytes=60 [ASSURED]
  [NEW] tcp      6 432000 ESTABLISHED src=127.0.0.1 dst=127.0.0.1 
sport=58383 dport=8000 [UNREPLIED] src=127.0.0.1 dst=127.0.0.1 
sport=8000 dport=58383
  [UPDATE] tcp      6 432000 src=127.0.0.1 dst=127.0.0.1 sport=58383 
dport=8000 src=127.0.0.1 dst=127.0.0.1 sport=8000 dport=58383
  [UPDATE] tcp      6 300 src=127.0.0.1 dst=127.0.0.1 sport=58383 
dport=8000 src=127.0.0.1 dst=127.0.0.1 sport=8000 dport=58383 [ASSURED]

I'm using a git snapshot from the current Linux kernel development version.
