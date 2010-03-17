From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RAWDNAT and disappearing packets
Date: Wed, 17 Mar 2010 15:12:34 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171509250.6297@obet.zrqbmnf.qr>
References: <2a3692de1003170240k1b5b4e88k6f447d8fd3cb213@mail.gmail.com>  <alpine.LSU.2.01.1003171323240.2731@obet.zrqbmnf.qr> <2a3692de1003170708y1d4603beh895d85f82e94ecc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dominik Kaspar <dokaspar.ietf@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55755 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab0CQOMf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:12:35 -0400
In-Reply-To: <2a3692de1003170708y1d4603beh895d85f82e94ecc2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-03-17 15:08, Dominik Kaspar wrote:

>>>I have a question about why packets are disappearing in my setup. My
>>>machine has two L2TP tunnels (10.6.1.2 and 10.6.1.3) to a Web server
>>>(10.6.1.1). The local machine uses a command such as "wget
>>>http://10.6.1.1/file --bind-address 10.6.1.2" to request a file from
>>>the server. On the server, outgoing packets are rewritten to 10.6.1.3,
>>>so that they travel back through the other tunnel. That works fine.
>>
>> For asymmetric routing, you should not be using NAT, but proper
>> policy routing.
>
>But what exactly did
>you mean by "proper policy routing" when saying that NAT should not be
>used for asymmetric routing?

It means that the webserver does something along the lines of

	ip route add 10.6.1.2/32 [via GW as needed] dev ltptun2

and not modifying the src/dst addresses at all.
